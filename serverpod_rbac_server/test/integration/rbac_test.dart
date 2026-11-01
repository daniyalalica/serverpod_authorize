import 'package:serverpod/serverpod.dart';
import 'package:serverpod_rbac_server/serverpod_rbac_server.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given RBAC & ABAC Core Engine', (sessionBuilder, endpoints) {
    late Session session;
    final rbac = RbacService.instance;
    final abac = AbacService.instance;

    setUp(() {
      session = sessionBuilder.build();
    });

    group('Permissions and Roles Management (Single & Bulk)', () {
      test('when creating permissions individually and in bulk then all are saved', () async {
        final p1 = await rbac.createPermission(
          session,
          resource: 'article',
          codename: 'view',
          name: 'View Article',
        );
        expect(p1.id, isNotNull);
        expect(p1.resource, 'article');
        expect(p1.codename, 'view');

        final bulkPerms = [
          RbacPermission(
            resource: 'article',
            codename: 'create',
            name: 'Create Article',
          ),
          RbacPermission(
            resource: 'article',
            codename: 'edit',
            name: 'Edit Article',
          ),
          RbacPermission(
            resource: 'article',
            codename: 'delete',
            name: 'Delete Article',
          ),
        ];

        final inserted = await rbac.createPermissions(session, bulkPerms);
        expect(inserted.length, 3);

        final all = await rbac.listPermissions(session, resource: 'article');
        expect(all.length, 4);
      });

      test('when creating roles individually and in bulk then all are saved', () async {
        final r1 = await rbac.createRole(
          session,
          name: 'viewer',
          description: 'Viewer role',
        );
        expect(r1.id, isNotNull);
        expect(r1.name, 'viewer');

        final bulkRoles = [
          RbacRole(name: 'editor', description: 'Editor role'),
          RbacRole(name: 'manager', description: 'Manager role'),
        ];
        final inserted = await rbac.createRoles(session, bulkRoles);
        expect(inserted.length, 2);

        final roles = await rbac.listRoles(session);
        expect(roles.map((r) => r.name), containsAll(['viewer', 'editor', 'manager']));
      });

      test('when assigning permissions to role then permissions are linked', () async {
        await rbac.createPermission(
          session,
          resource: 'doc',
          codename: 'read',
          name: 'Read Doc',
        );
        await rbac.createPermission(
          session,
          resource: 'doc',
          codename: 'write',
          name: 'Write Doc',
        );
        await rbac.createRole(session, name: 'doc_writer');

        await rbac.assignPermissionsToRole(
          session,
          roleName: 'doc_writer',
          permissions: ['doc.read', 'doc.write'],
        );

        final rolePerms = await rbac.getRolePermissions(session, 'doc_writer');
        expect(rolePerms.length, 2);
        expect(
          rolePerms.map((p) => '${p.resource}.${p.codename}'),
          containsAll(['doc.read', 'doc.write']),
        );

        await rbac.removePermissionsFromRole(
          session,
          roleName: 'doc_writer',
          permissions: ['doc.write'],
        );
        final updated = await rbac.getRolePermissions(session, 'doc_writer');
        expect(updated.length, 1);
        expect(updated.first.codename, 'read');
      });
    });

    group('User Role Assignments & Permission Resolution', () {
      test('user only gets permissions through assigned roles', () async {
        const userId = 'user-clean-rbac';
        await rbac.createPermission(
          session,
          resource: 'report',
          codename: 'view',
          name: 'View Report',
        );
        await rbac.createPermission(
          session,
          resource: 'report',
          codename: 'export',
          name: 'Export Report',
        );
        await rbac.createRole(session, name: 'analyst');
        await rbac.assignPermissionsToRole(
          session,
          roleName: 'analyst',
          permissions: ['report.view', 'report.export'],
        );

        // Before assignment: no permissions
        expect(await rbac.hasPermission(session, 'report.view', userIdentifier: userId), isFalse);

        // Assign role
        await rbac.assignRoleToUser(
          session,
          userIdentifier: userId,
          roleName: 'analyst',
        );

        // After assignment: possesses permissions
        expect(await rbac.hasPermission(session, 'report.view', userIdentifier: userId), isTrue);
        expect(await rbac.hasPermission(session, 'report.export', userIdentifier: userId), isTrue);
        expect(await rbac.hasPermission(session, 'report.delete', userIdentifier: userId), isFalse);
        expect(await rbac.hasAllPermissions(session, ['report.view', 'report.export'], userIdentifier: userId), isTrue);
        expect(await rbac.hasAnyPermission(session, ['report.export', 'report.delete'], userIdentifier: userId), isTrue);

        final info = await rbac.getUserPermissionsInfo(session, userId);
        expect(info.roles, ['analyst']);
        expect(info.permissions, containsAll(['report.view', 'report.export']));
      });

      test('bulk user role assignment methods', () async {
        await rbac.createRole(session, name: 'auditor');
        await rbac.createRole(session, name: 'reviewer');

        // Bulk roles to single user
        await rbac.assignRolesToUser(
          session,
          userIdentifier: 'user-bulk-roles',
          roleNames: ['auditor', 'reviewer'],
        );
        final userRoles = await rbac.getUserRoles(session, 'user-bulk-roles');
        expect(userRoles.map((r) => r.name), containsAll(['auditor', 'reviewer']));

        // Bulk users to single role
        await rbac.assignRoleToUsers(
          session,
          userIdentifiers: ['user-a', 'user-b', 'user-c'],
          roleName: 'auditor',
        );
        expect(await rbac.hasRole(session, 'auditor', userIdentifier: 'user-a'), isTrue);
        expect(await rbac.hasRole(session, 'auditor', userIdentifier: 'user-b'), isTrue);
        expect(await rbac.hasRole(session, 'auditor', userIdentifier: 'user-c'), isTrue);
      });
    });

    group('ABAC Domain Service', () {
      test('global role grants unrestricted domain access (hasDomains is false)', () async {
        const userId = 'user-global-finance';
        await rbac.createPermission(
          session,
          resource: 'ledger',
          codename: 'audit',
          name: 'Audit Ledger',
        );
        await rbac.createRole(session, name: 'cfo');
        await rbac.assignPermissionsToRole(
          session,
          roleName: 'cfo',
          permissions: ['ledger.audit'],
        );

        // Global assignment (domain: null)
        await rbac.assignRoleToUser(
          session,
          userIdentifier: userId,
          roleName: 'cfo',
          domain: null,
        );

        final result = await abac.getDomainAccess(
          session,
          permission: 'ledger.audit',
          userIdentifier: userId,
        );
        expect(result.isAllowed, isTrue);
        expect(result.isUnrestricted, isTrue);
        expect(result.hasDomains, isFalse); // No domain restriction, full access!
        expect(result.domains, isEmpty);

        expect(await abac.hasDomains(session, permission: 'ledger.audit', userIdentifier: userId), isFalse);
      });

      test('domain-scoped role restricts access to specific domains (hasDomains is true)', () async {
        const userId = 'user-regional-manager';
        await rbac.createPermission(
          session,
          resource: 'store',
          codename: 'inventory',
          name: 'Store Inventory',
        );
        await rbac.createRole(session, name: 'store_manager');
        await rbac.assignPermissionsToRole(
          session,
          roleName: 'store_manager',
          permissions: ['store.inventory'],
        );

        // Assign to domain 'eu-west' and 'eu-north'
        await rbac.assignRoleToUserDomains(
          session,
          userIdentifier: userId,
          roleName: 'store_manager',
          domains: ['eu-west', 'eu-north'],
        );

        final result = await abac.getDomainAccess(
          session,
          permission: 'store.inventory',
          userIdentifier: userId,
        );
        expect(result.isAllowed, isTrue);
        expect(result.isUnrestricted, isFalse);
        expect(result.hasDomains, isTrue); // Developer should filter by domains!
        expect(result.domains, containsAll(['eu-west', 'eu-north']));

        expect(await abac.hasDomains(session, permission: 'store.inventory', userIdentifier: userId), isTrue);
        final domains = await abac.getDomains(session, permission: 'store.inventory', userIdentifier: userId);
        expect(domains, containsAll(['eu-west', 'eu-north']));

        // Check scoped permission check directly
        expect(await rbac.hasPermission(session, 'store.inventory', domain: 'eu-west', userIdentifier: userId), isTrue);
        expect(await rbac.hasPermission(session, 'store.inventory', domain: 'eu-north', userIdentifier: userId), isTrue);
        expect(await rbac.hasPermission(session, 'store.inventory', domain: 'us-east', userIdentifier: userId), isFalse);
      });

      test('role domain access check', () async {
        const userId = 'user-role-domain';
        await rbac.createRole(session, name: 'dept_lead');
        await rbac.assignRoleToUser(
          session,
          userIdentifier: userId,
          roleName: 'dept_lead',
          domain: 'engineering',
        );

        expect(await abac.hasDomainsForRole(session, roleName: 'dept_lead', userIdentifier: userId), isTrue);
        expect(
          await abac.getDomainsForRole(session, roleName: 'dept_lead', userIdentifier: userId),
          ['engineering'],
        );
      });

      test('unpermitted user returns isAllowed false and hasDomains false', () async {
        const userId = 'user-no-perms';
        final result = await abac.getDomainAccess(
          session,
          permission: 'nonexistent.permission',
          userIdentifier: userId,
        );
        expect(result.isAllowed, isFalse);
        expect(result.hasDomains, isFalse);
        expect(result.domains, isEmpty);
      });
    });

    group('Superuser Check & Exceptions', () {
      test('superuser bypasses all permission and role requirements', () async {
        const superuserId = 'superadmin-root';
        await rbac.createRole(session, name: 'root_role', isSuperuser: true);
        await rbac.assignRoleToUser(
          session,
          userIdentifier: superuserId,
          roleName: 'root_role',
        );

        expect(await rbac.isSuperuser(session, userIdentifier: superuserId), isTrue);
        expect(await rbac.hasPermission(session, 'any.perm', userIdentifier: superuserId), isTrue);
        expect(await rbac.hasRole(session, 'any_role', userIdentifier: superuserId), isTrue);

        final abacResult = await abac.getDomainAccess(
          session,
          permission: 'any.perm',
          userIdentifier: superuserId,
        );
        expect(abacResult.isAllowed, isTrue);
        expect(abacResult.isUnrestricted, isTrue);
        expect(abacResult.hasDomains, isFalse);
      });

      test('requirePermission throws RbacException when permission denied', () async {
        const userId = 'unauth-user';
        final authedSession = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(userId, {}),
        ).build();

        expect(
          () => authedSession.rbac.requirePermission('admin.access'),
          throwsA(isA<RbacException>().having(
            (e) => e.reason,
            'reason',
            RbacExceptionReason.permissionDenied,
          )),
        );
      });

      test('requirePermission throws RbacException when domain denied', () async {
        const userId = 'domain-restricted-user';
        await rbac.createPermission(session, resource: 'data', codename: 'access', name: 'Access Data');
        await rbac.createRole(session, name: 'data_viewer');
        await rbac.assignPermissionsToRole(session, roleName: 'data_viewer', permissions: ['data.access']);
        await rbac.assignRoleToUser(session, userIdentifier: userId, roleName: 'data_viewer', domain: 'asia');

        final authedSession = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(userId, {}),
        ).build();

        // Allowed in asia
        await authedSession.rbac.requirePermission('data.access', domain: 'asia');

        // Denied in europe
        expect(
          () => authedSession.rbac.requirePermission('data.access', domain: 'europe'),
          throwsA(isA<RbacException>()),
        );
      });
    });
  });
}
