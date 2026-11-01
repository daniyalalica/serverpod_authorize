import 'package:serverpod/serverpod.dart';
import 'package:serverpod_rbac_server/serverpod_rbac_server.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given RBAC & ABAC Endpoints', (sessionBuilder, endpoints) {
    late Session session;
    final rbac = RbacService.instance;
    final abac = AbacService.instance;

    setUp(() {
      session = sessionBuilder.build();
    });

    group('RbacEndpoint (Self-inspection)', () {
      test(
        'when user queries getMyPermissions then returns their assigned roles and permissions',
        () async {
          const userId = 'client-user-1';
          await rbac.createPermission(
            session,
            resource: 'profile',
            codename: 'edit',
            name: 'Edit Profile',
          );
          await rbac.createRole(session, name: 'member');
          await rbac.assignPermissionsToRole(
            session,
            roleName: 'member',
            permissions: ['profile.edit'],
          );
          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'member',
          );

          // Add domain rule to the role
          const domainExpr = '[["owner_id", "=", 101]]';
          await abac.addDomainRule(
            session,
            roleName: 'member',
            resource: 'profile',
            filterExpression: domainExpr,
          );

          final authedSessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              userId,
              {},
            ),
          );

          final info = await endpoints.rbac.getMyPermissions(
            authedSessionBuilder,
          );
          expect(info.userIdentifier, userId);
          expect(info.roles, contains('member'));
          expect(info.permissions, contains('profile.edit'));

          final hasPerm = await endpoints.rbac.hasPermission(
            authedSessionBuilder,
            'profile.edit',
          );
          expect(hasPerm, isTrue);

          final hasRole = await endpoints.rbac.hasRole(
            authedSessionBuilder,
            'member',
          );
          expect(hasRole, isTrue);

          // ABAC domain checks on endpoint
          final hasDomains = await endpoints.rbac.hasDomains(
            authedSessionBuilder,
            'profile.edit',
            resource: 'profile',
          );
          expect(hasDomains, isTrue);

          final filters = await endpoints.rbac.getMyDomainFilters(
            authedSessionBuilder,
            'profile.edit',
            resource: 'profile',
          );
          expect(filters, contains(domainExpr));

          final domainAccess = await endpoints.rbac.getMyDomainAccess(
            authedSessionBuilder,
            'profile.edit',
            resource: 'profile',
          );
          expect(domainAccess.isAllowed, isTrue);
          expect(domainAccess.hasDomains, isTrue);
          expect(domainAccess.filterExpressions, contains(domainExpr));
        },
      );
    });

    group('RbacAdminEndpoint (Administrative Control & Bulk Operations)', () {
      test(
        'when unprivileged user calls admin endpoint then throws RbacException',
        () async {
          const regularUserId = 'regular-user';
          final regularSessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              regularUserId,
              {},
            ),
          );

          expect(
            () => endpoints.rbacAdmin.createRole(
              regularSessionBuilder,
              name: 'hacker_role',
            ),
            throwsA(
              isA<RbacException>().having(
                (e) => e.reason,
                'reason',
                RbacExceptionReason.permissionDenied,
              ),
            ),
          );
        },
      );

      test(
        'admin can perform single and bulk creation and domain rule management',
        () async {
          const adminUserId = 'superadmin-user';
          final adminSessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              adminUserId,
              {Scope.admin},
            ),
          );

          // Single permission creation
          final p1 = await endpoints.rbacAdmin.createPermission(
            adminSessionBuilder,
            resource: 'video',
            codename: 'upload',
            name: 'Upload Video',
          );
          expect(p1.codename, 'upload');

          // Bulk permission creation
          final bulkPerms = [
            RbacPermission(
              resource: 'video',
              codename: 'edit',
              name: 'Edit Video',
            ),
            RbacPermission(
              resource: 'video',
              codename: 'delete',
              name: 'Delete Video',
            ),
          ];
          final insertedPerms = await endpoints.rbacAdmin.createPermissions(
            adminSessionBuilder,
            bulkPerms,
          );
          expect(insertedPerms.length, 2);

          // Single role creation
          final r1 = await endpoints.rbacAdmin.createRole(
            adminSessionBuilder,
            name: 'video_producer',
            description: 'Producer of video content',
          );
          expect(r1.name, 'video_producer');

          // Bulk role creation
          final bulkRoles = [
            RbacRole(name: 'video_reviewer', description: 'Reviewer'),
            RbacRole(name: 'video_archivist', description: 'Archivist'),
          ];
          final insertedRoles = await endpoints.rbacAdmin.createRoles(
            adminSessionBuilder,
            bulkRoles,
          );
          expect(insertedRoles.length, 2);

          // Bulk assign permissions to role
          await endpoints.rbacAdmin.assignPermissionsToRole(
            adminSessionBuilder,
            roleName: 'video_producer',
            permissions: ['video.upload', 'video.edit'],
          );

          // Assign role to user
          await endpoints.rbacAdmin.assignRoleToUser(
            adminSessionBuilder,
            userIdentifier: 'creator-1',
            roleName: 'video_producer',
          );

          // Admin adds domain rule to role
          const filterExpr =
              '[["state", "=", "published"], ["channel_id", "=", 5]]';
          final rule = await endpoints.rbacAdmin.addDomainRule(
            adminSessionBuilder,
            roleName: 'video_producer',
            resource: 'video',
            permission: 'video.upload',
            filterExpression: filterExpr,
            description: 'Only published videos in channel 5',
          );
          expect(rule.id, isNotNull);
          expect(rule.permission, 'video.upload');
          expect(rule.filterExpression, filterExpr);

          // List domain rules
          final rules = await endpoints.rbacAdmin.listDomainRules(
            adminSessionBuilder,
            roleName: 'video_producer',
            resource: 'video',
            permission: 'video.upload',
          );
          expect(rules.length, 1);
          expect(rules.first.filterExpression, filterExpr);

          // Inspect user domain filters
          final userFilters = await endpoints.rbacAdmin.getUserDomainFilters(
            adminSessionBuilder,
            userIdentifier: 'creator-1',
            permission: 'video.upload',
            resource: 'video',
          );
          expect(userFilters, contains(filterExpr));

          // Evaluate user domain access
          final access = await endpoints.rbacAdmin.getUserDomainAccess(
            adminSessionBuilder,
            userIdentifier: 'creator-1',
            permission: 'video.upload',
            resource: 'video',
          );
          expect(access.isAllowed, isTrue);
          expect(access.hasDomains, isTrue);
          expect(access.filterExpressions, contains(filterExpr));
        },
      );
    });
  });
}
