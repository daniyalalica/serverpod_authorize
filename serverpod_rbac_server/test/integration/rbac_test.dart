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
      test(
        'when creating permissions individually and in bulk then all are saved',
        () async {
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
        },
      );

      test(
        'when creating roles individually and in bulk then all are saved',
        () async {
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
          expect(
            roles.map((r) => r.name),
            containsAll(['viewer', 'editor', 'manager']),
          );
        },
      );

      test(
        'when assigning permissions to role then permissions are linked',
        () async {
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

          final rolePerms = await rbac.getRolePermissions(
            session,
            'doc_writer',
          );
          expect(rolePerms.length, 2);
          expect(
            rolePerms.map((p) => '${p.resource}.${p.codename}'),
            containsAll(['doc.read', 'doc.write']),
          );
        },
      );
    });

    group('User-Role Assignments & Permissions Resolution', () {
      test('assigning roles to users grants role permissions', () async {
        const userId = 'user-alice';
        await rbac.createPermission(
          session,
          resource: 'report',
          codename: 'view',
          name: 'View Report',
        );
        await rbac.createRole(session, name: 'analyst');
        await rbac.assignPermissionsToRole(
          session,
          roleName: 'analyst',
          permissions: ['report.view'],
        );

        await rbac.assignRoleToUser(
          session,
          userIdentifier: userId,
          roleName: 'analyst',
        );

        final hasPerm = await rbac.hasPermission(
          session,
          'report.view',
          userIdentifier: userId,
        );
        expect(hasPerm, isTrue);

        final hasRole = await rbac.hasRole(
          session,
          'analyst',
          userIdentifier: userId,
        );
        expect(hasRole, isTrue);

        final permsInfo = await rbac.getUserPermissionsInfo(session, userId);
        expect(permsInfo.roles, contains('analyst'));
        expect(permsInfo.permissions, contains('report.view'));
      });

      test('bulk user role assignment and removal', () async {
        const userId = 'user-bob';
        await rbac.createRole(session, name: 'role_a');
        await rbac.createRole(session, name: 'role_b');
        await rbac.createRole(session, name: 'role_c');

        await rbac.assignRolesToUser(
          session,
          userIdentifier: userId,
          roleNames: ['role_a', 'role_b', 'role_c'],
        );

        final userRoles = await rbac.getUserRoles(session, userId);
        expect(
          userRoles.map((r) => r.name),
          containsAll(['role_a', 'role_b', 'role_c']),
        );

        await rbac.removeRolesFromUser(
          session,
          userIdentifier: userId,
          roleNames: ['role_a', 'role_b'],
        );

        final remainingRoles = await rbac.getUserRoles(session, userId);
        expect(remainingRoles.map((r) => r.name), ['role_c']);
      });

      test('wildcard permission matching', () async {
        const userId = 'user-admin';
        await rbac.createPermission(
          session,
          resource: 'billing',
          codename: '*',
          name: 'All Billing',
        );
        await rbac.createRole(session, name: 'billing_admin');
        await rbac.assignPermissionsToRole(
          session,
          roleName: 'billing_admin',
          permissions: ['billing.*'],
        );
        await rbac.assignRoleToUser(
          session,
          userIdentifier: userId,
          roleName: 'billing_admin',
        );

        expect(
          await rbac.hasPermission(
            session,
            'billing.invoices',
            userIdentifier: userId,
          ),
          isTrue,
        );
        expect(
          await rbac.hasPermission(
            session,
            'billing.payments',
            userIdentifier: userId,
          ),
          isTrue,
        );
        expect(
          await rbac.hasPermission(
            session,
            'other.read',
            userIdentifier: userId,
          ),
          isFalse,
        );
      });
    });

    group('ABAC Odoo-Style Domain Rules & Evaluation', () {
      test(
        'cached domain decisions are invalidated when roles and rules change',
        () async {
          const userId = 'user-domain-cache';
          await rbac.createPermission(
            session,
            resource: 'invoice',
            codename: 'create',
            name: 'Create Invoice',
          );
          await rbac.createRole(session, name: 'invoice_creator');
          await rbac.assignPermissionsToRole(
            session,
            roleName: 'invoice_creator',
            permissions: ['invoice.create'],
          );

          final denied = await abac.getDomainAccess(
            session,
            permission: 'invoice.create',
            userIdentifier: userId,
          );
          expect(denied.isAllowed, isFalse);
          final cached = await rbac.cache.getDomainAccess(
            session,
            userIdentifier: userId,
            resource: 'invoice',
            permission: 'invoice.create',
          );
          expect(cached, isNotNull);
          cached!.filterExpressions.add('[["city", "=", "unsafe"]]');
          expect(
            (await abac.getDomainAccess(
              session,
              permission: 'invoice.create',
              userIdentifier: userId,
            )).filterExpressions,
            isEmpty,
          );

          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'invoice_creator',
          );
          final unrestricted = await abac.getDomainAccess(
            session,
            permission: 'invoice.create',
            userIdentifier: userId,
          );
          expect(unrestricted.isAllowed, isTrue);
          expect(unrestricted.isUnrestricted, isTrue);

          const rule = '[["city", "=", "Karachi"]]';
          await abac.addDomainRule(
            session,
            roleName: 'invoice_creator',
            resource: 'invoice',
            permission: 'invoice.create',
            filterExpression: rule,
          );
          final restricted = await abac.getDomainAccess(
            session,
            permission: 'invoice.create',
            userIdentifier: userId,
          );
          expect(restricted.isAllowed, isTrue);
          expect(restricted.hasDomains, isTrue);
          expect(restricted.filterExpressions, [rule]);
        },
      );

      test(
        'role without domain rules returns isUnrestricted true and hasDomains false',
        () async {
          const userId = 'user-cfo';
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

          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'cfo',
          );

          final result = await abac.getDomainAccess(
            session,
            permission: 'ledger.audit',
            resource: 'ledger',
            userIdentifier: userId,
          );
          expect(result.isAllowed, isTrue);
          expect(result.isUnrestricted, isTrue);
          expect(result.hasDomains, isFalse);
          expect(result.filterExpressions, isEmpty);

          expect(
            await abac.hasDomains(
              session,
              permission: 'ledger.audit',
              resource: 'ledger',
              userIdentifier: userId,
            ),
            isFalse,
          );
        },
      );

      test(
        'role with domain rules returns hasDomains true and stored filter expressions',
        () async {
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

          // Add Odoo-style domain rule to the role
          const ruleExpr =
              '[["region", "=", "eu-west"], ["status", "=", "active"]]';
          await abac.addDomainRule(
            session,
            roleName: 'store_manager',
            resource: 'store',
            filterExpression: ruleExpr,
            description: 'EU West active stores only',
          );

          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'store_manager',
          );

          final result = await abac.getDomainAccess(
            session,
            permission: 'store.inventory',
            resource: 'store',
            userIdentifier: userId,
          );
          expect(result.isAllowed, isTrue);
          expect(result.isUnrestricted, isFalse);
          expect(result.hasDomains, isTrue);
          expect(result.filterExpressions, contains(ruleExpr));

          expect(
            await abac.hasDomains(
              session,
              permission: 'store.inventory',
              resource: 'store',
              userIdentifier: userId,
            ),
            isTrue,
          );

          final filters = await abac.getDomainFilters(
            session,
            permission: 'store.inventory',
            resource: 'store',
            userIdentifier: userId,
          );
          expect(filters, contains(ruleExpr));

          final allFilters = await abac.getAllDomainFilters(
            session,
            resource: 'store',
            userIdentifier: userId,
          );
          expect(allFilters, contains(ruleExpr));
        },
      );

      test(
        'permission-specific domain rules apply only to the matching action',
        () async {
          const userId = 'user-invoice-actions';
          await rbac.createPermission(
            session,
            resource: 'invoice',
            codename: 'create',
            name: 'Create Invoice',
          );
          await rbac.createPermission(
            session,
            resource: 'invoice',
            codename: 'read',
            name: 'Read Invoice',
          );
          await rbac.createRole(session, name: 'invoice_operator');
          await rbac.assignPermissionsToRole(
            session,
            roleName: 'invoice_operator',
            permissions: ['invoice.create', 'invoice.read'],
          );
          const createRule = '[["createdBy", "=", 42]]';
          await abac.addDomainRule(
            session,
            roleName: 'invoice_operator',
            resource: 'INVOICE',
            permission: ' Invoice.Create ',
            filterExpression: createRule,
          );
          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'invoice_operator',
          );

          final createAccess = await abac.getDomainAccess(
            session,
            permission: 'invoice.create',
            userIdentifier: userId,
          );
          final readAccess = await abac.getDomainAccess(
            session,
            permission: 'invoice.read',
            userIdentifier: userId,
          );

          expect(createAccess.hasDomains, isTrue);
          expect(createAccess.filterExpressions, [createRule]);
          expect(readAccess.isAllowed, isTrue);
          expect(readAccess.isUnrestricted, isTrue);
          expect(readAccess.filterExpressions, isEmpty);

          final storedRules = await abac.listDomainRules(
            session,
            roleName: 'invoice_operator',
            resource: 'invoice',
            permission: 'invoice.create',
          );
          expect(storedRules, hasLength(1));
          expect(storedRules.single.permission, 'invoice.create');
        },
      );

      test(
        'domain rules from multiple roles are returned as alternative grants',
        () async {
          const userId = 'user-invoice-branches';
          await rbac.createPermission(
            session,
            resource: 'invoice',
            codename: 'create',
            name: 'Create Invoice',
          );
          await rbac.createRole(session, name: 'north_invoice_creator');
          await rbac.createRole(session, name: 'south_invoice_creator');
          for (final roleName in [
            'north_invoice_creator',
            'south_invoice_creator',
          ]) {
            await rbac.assignPermissionsToRole(
              session,
              roleName: roleName,
              permissions: ['invoice.create'],
            );
          }

          const northRule = '[["branch", "=", "north"]]';
          const southRule = '[["branch", "=", "south"]]';
          await abac.addDomainRule(
            session,
            roleName: 'north_invoice_creator',
            resource: 'invoice',
            permission: 'invoice.create',
            filterExpression: northRule,
          );
          await abac.addDomainRule(
            session,
            roleName: 'south_invoice_creator',
            resource: 'invoice',
            permission: 'invoice.create',
            filterExpression: southRule,
          );
          await rbac.assignRolesToUser(
            session,
            userIdentifier: userId,
            roleNames: [
              'north_invoice_creator',
              'south_invoice_creator',
            ],
          );

          final access = await abac.getDomainAccess(
            session,
            permission: 'invoice.create',
            userIdentifier: userId,
          );

          expect(access.isAllowed, isTrue);
          expect(access.hasDomains, isTrue);
          expect(access.isUnrestricted, isFalse);
          expect(
            access.filterExpressions,
            containsAll([northRule, southRule]),
          );
        },
      );

      test('role domain access check by role name', () async {
        const userId = 'user-role-domain';
        await rbac.createRole(session, name: 'dept_lead');
        const ruleExpr = '[["department", "=", "engineering"]]';
        await abac.addDomainRule(
          session,
          roleName: 'dept_lead',
          resource: 'employees',
          filterExpression: ruleExpr,
        );
        await rbac.assignRoleToUser(
          session,
          userIdentifier: userId,
          roleName: 'dept_lead',
        );

        final access = await abac.getRoleDomainAccess(
          session,
          roleName: 'dept_lead',
          resource: 'employees',
          userIdentifier: userId,
        );
        expect(access.isAllowed, isTrue);
        expect(access.hasDomains, isTrue);
        expect(access.filterExpressions, [ruleExpr]);
      });

      test(
        'role domain access without resource returns rules and is not unrestricted',
        () async {
          const userId = 'user-role-domain-unscoped';
          await rbac.createRole(session, name: 'multi_resource_lead');
          const employeeRule = '[["department", "=", "engineering"]]';
          const reportRule = '[["confidential", "=", false]]';
          final role = await RbacRole.db.findFirstRow(
            session,
            where: (t) => t.name.equals('multi_resource_lead'),
          );
          final roleId = role!.id!;
          await abac.addDomainRules(session, [
            RbacDomainRule(
              roleId: roleId,
              resource: 'employees',
              filterExpression: employeeRule,
            ),
            RbacDomainRule(
              roleId: roleId,
              resource: 'reports',
              filterExpression: reportRule,
            ),
          ]);
          await rbac.assignRoleToUser(
            session,
            userIdentifier: userId,
            roleName: 'multi_resource_lead',
          );

          final access = await abac.getRoleDomainAccess(
            session,
            roleName: 'multi_resource_lead',
            userIdentifier: userId,
          );

          expect(access.isAllowed, isTrue);
          expect(access.resource, isNull);
          expect(access.hasDomains, isTrue);
          expect(access.isUnrestricted, isFalse);
          expect(
            access.filterExpressions,
            containsAll([employeeRule, reportRule]),
          );
        },
      );

      test(
        'unrestricted permission role takes precedence over restricted role domains',
        () async {
          const userId = 'user-mixed-domain-access';
          await rbac.createPermission(
            session,
            resource: 'invoice',
            codename: 'read',
            name: 'Read Invoice',
          );
          await rbac.createRole(session, name: 'invoice_limited');
          await rbac.createRole(session, name: 'invoice_global');
          await rbac.assignPermissionsToRole(
            session,
            roleName: 'invoice_limited',
            permissions: ['invoice.read'],
          );
          await rbac.assignPermissionsToRole(
            session,
            roleName: 'invoice_global',
            permissions: ['invoice.read'],
          );
          await abac.addDomainRule(
            session,
            roleName: 'invoice_limited',
            resource: 'invoice',
            filterExpression: '[["ownerId", "=", 42]]',
          );
          await rbac.assignRolesToUser(
            session,
            userIdentifier: userId,
            roleNames: ['invoice_limited', 'invoice_global'],
          );

          final access = await abac.getDomainAccess(
            session,
            permission: 'invoice.read',
            userIdentifier: userId,
          );

          expect(access.isAllowed, isTrue);
          expect(access.isUnrestricted, isTrue);
          expect(access.hasDomains, isFalse);
          expect(access.filterExpressions, isEmpty);
        },
      );

      test(
        'bulk domain rules normalize resource and reject empty inputs',
        () async {
          await rbac.createRole(session, name: 'normalized_domain_role');
          final role = await RbacRole.db.findFirstRow(
            session,
            where: (t) => t.name.equals('normalized_domain_role'),
          );
          final inserted = await abac.addDomainRules(session, [
            RbacDomainRule(
              roleId: role!.id!,
              resource: '  Products ',
              filterExpression: '  [["owner_id", "=", 42]]  ',
            ),
          ]);

          expect(inserted.single.resource, 'products');
          expect(inserted.single.filterExpression, '[["owner_id", "=", 42]]');

          await expectLater(
            abac.addDomainRule(
              session,
              roleName: 'normalized_domain_role',
              resource: ' ',
              filterExpression: '[["owner_id", "=", 42]]',
            ),
            throwsArgumentError,
          );
          await expectLater(
            abac.addDomainRule(
              session,
              roleName: 'normalized_domain_role',
              resource: 'products',
              filterExpression: ' ',
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'unpermitted user returns isAllowed false and hasDomains false',
        () async {
          const userId = 'user-no-perms';
          final result = await abac.getDomainAccess(
            session,
            permission: 'nonexistent.permission',
            userIdentifier: userId,
          );
          expect(result.isAllowed, isFalse);
          expect(result.hasDomains, isFalse);
          expect(result.filterExpressions, isEmpty);
        },
      );
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

        expect(
          await rbac.isSuperuser(session, userIdentifier: superuserId),
          isTrue,
        );
        expect(
          await rbac.hasPermission(
            session,
            'any.perm',
            userIdentifier: superuserId,
          ),
          isTrue,
        );
        expect(
          await rbac.hasRole(session, 'any_role', userIdentifier: superuserId),
          isTrue,
        );

        final abacResult = await abac.getDomainAccess(
          session,
          permission: 'any.perm',
          userIdentifier: superuserId,
        );
        expect(abacResult.isAllowed, isTrue);
        expect(abacResult.isUnrestricted, isTrue);
        expect(abacResult.hasDomains, isFalse);
        expect(abacResult.filterExpressions, isEmpty);
      });

      test(
        'requirePermission throws RbacException when permission denied',
        () async {
          const userId = 'unauth-user';
          final authedSession = sessionBuilder
              .copyWith(
                authentication: AuthenticationOverride.authenticationInfo(
                  userId,
                  {},
                ),
              )
              .build();

          expect(
            () => authedSession.rbac.requirePermission('admin.access'),
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
    });
  });
}
