/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_rbac_server/src/generated/rbac_permission.dart'
    as _i44dc49h;
import 'package:serverpod_rbac_server/src/generated/rbac_role.dart'
    as _inzb62ef;
import 'package:serverpod_rbac_server/src/generated/rbac_user_role.dart'
    as _iq9wo7s2;
import 'rbac_abac_result.dart' as _is9x66yl;
import 'rbac_exception.dart' as _irzd0ivn;
import 'rbac_exception_reason.dart' as _ilr4m7ck;
import 'rbac_permission.dart' as _ijqyf5jf;
import 'rbac_role.dart' as _im7c8v5q;
import 'rbac_role_permission.dart' as _is7enq59;
import 'rbac_user_permissions_info.dart' as _icgz0mns;
import 'rbac_user_role.dart' as _ig5ad0pf;
export 'rbac_abac_result.dart';
export 'rbac_exception.dart';
export 'rbac_exception_reason.dart';
export 'rbac_permission.dart';
export 'rbac_role.dart';
export 'rbac_role_permission.dart';
export 'rbac_user_permissions_info.dart';
export 'rbac_user_role.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_is.SerializationManager> _hostProtocols = {};

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'serverpod_rbac_permission',
      dartName: 'RbacPermission',
      schema: 'public',
      module: 'serverpod_rbac',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'resource',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'codename',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_rbac_perm_res_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'resource',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'codename',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'serverpod_rbac_role',
      dartName: 'RbacRole',
      schema: 'public',
      module: 'serverpod_rbac',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isSuperuser',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'isSystemRole',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_rbac_role__name__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'name',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'serverpod_rbac_role_permission',
      dartName: 'RbacRolePermission',
      schema: 'public',
      module: 'serverpod_rbac',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'roleId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'permissionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_rbac_role_permission_fk_0',
          columns: ['roleId'],
          referenceTable: 'serverpod_rbac_role',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_rbac_role_permission_fk_1',
          columns: ['permissionId'],
          referenceTable: 'serverpod_rbac_permission',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_rbac_role_perm_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'roleId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'permissionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'serverpod_rbac_user_role',
      dartName: 'RbacUserRole',
      schema: 'public',
      module: 'serverpod_rbac',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'roleId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'domain',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_rbac_user_role_fk_0',
          columns: ['roleId'],
          referenceTable: 'serverpod_rbac_role',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_rbac_user_role_user_role_domain_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'roleId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'domain',
            ),
          ],
          type: 'btree',
          isUnique: true,
          nullsDistinct: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'serverpod_rbac_user_role_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'serverpod_rbac_user_role_domain_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'domain',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
  ];

  void registerHostProtocol(
    String projectName,
    _is.SerializationManager protocol,
  ) {
    _hostProtocols.add(protocol);
  }

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    if (className == null) return null;
    if (!className.startsWith('serverpod_rbac.')) return className;
    return className.substring(15);
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _is9x66yl.RbacAbacResult) {
      return _is9x66yl.RbacAbacResult.fromJson(data) as T;
    }
    if (t == _irzd0ivn.RbacException) {
      return _irzd0ivn.RbacException.fromJson(data) as T;
    }
    if (t == _ilr4m7ck.RbacExceptionReason) {
      return _ilr4m7ck.RbacExceptionReason.fromJson(data) as T;
    }
    if (t == _ijqyf5jf.RbacPermission) {
      return _ijqyf5jf.RbacPermission.fromJson(data) as T;
    }
    if (t == _im7c8v5q.RbacRole) {
      return _im7c8v5q.RbacRole.fromJson(data) as T;
    }
    if (t == _is7enq59.RbacRolePermission) {
      return _is7enq59.RbacRolePermission.fromJson(data) as T;
    }
    if (t == _icgz0mns.RbacUserPermissionsInfo) {
      return _icgz0mns.RbacUserPermissionsInfo.fromJson(data) as T;
    }
    if (t == _ig5ad0pf.RbacUserRole) {
      return _ig5ad0pf.RbacUserRole.fromJson(data) as T;
    }
    if (t == _is.getType<_is9x66yl.RbacAbacResult?>()) {
      return (data != null ? _is9x66yl.RbacAbacResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irzd0ivn.RbacException?>()) {
      return (data != null ? _irzd0ivn.RbacException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ilr4m7ck.RbacExceptionReason?>()) {
      return (data != null
              ? _ilr4m7ck.RbacExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ijqyf5jf.RbacPermission?>()) {
      return (data != null ? _ijqyf5jf.RbacPermission.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_im7c8v5q.RbacRole?>()) {
      return (data != null ? _im7c8v5q.RbacRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_is7enq59.RbacRolePermission?>()) {
      return (data != null ? _is7enq59.RbacRolePermission.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icgz0mns.RbacUserPermissionsInfo?>()) {
      return (data != null
              ? _icgz0mns.RbacUserPermissionsInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ig5ad0pf.RbacUserRole?>()) {
      return (data != null ? _ig5ad0pf.RbacUserRole.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_is7enq59.RbacRolePermission>) {
      return (data as List)
              .map((e) => deserialize<_is7enq59.RbacRolePermission>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_is7enq59.RbacRolePermission>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_is7enq59.RbacRolePermission>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ig5ad0pf.RbacUserRole>) {
      return (data as List)
              .map((e) => deserialize<_ig5ad0pf.RbacUserRole>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ig5ad0pf.RbacUserRole>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ig5ad0pf.RbacUserRole>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i44dc49h.RbacPermission>) {
      return (data as List)
              .map((e) => deserialize<_i44dc49h.RbacPermission>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_inzb62ef.RbacRole>) {
      return (data as List)
              .map((e) => deserialize<_inzb62ef.RbacRole>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_iq9wo7s2.RbacUserRole>) {
      return (data as List)
              .map((e) => deserialize<_iq9wo7s2.RbacUserRole>(e))
              .toList()
          as T;
    }
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _is9x66yl.RbacAbacResult => 'RbacAbacResult',
      _irzd0ivn.RbacException => 'RbacException',
      _ilr4m7ck.RbacExceptionReason => 'RbacExceptionReason',
      _ijqyf5jf.RbacPermission => 'RbacPermission',
      _im7c8v5q.RbacRole => 'RbacRole',
      _is7enq59.RbacRolePermission => 'RbacRolePermission',
      _icgz0mns.RbacUserPermissionsInfo => 'RbacUserPermissionsInfo',
      _ig5ad0pf.RbacUserRole => 'RbacUserRole',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_rbac.',
        '',
      );
    }

    switch (data) {
      case _is9x66yl.RbacAbacResult():
        return 'RbacAbacResult';
      case _irzd0ivn.RbacException():
        return 'RbacException';
      case _ilr4m7ck.RbacExceptionReason():
        return 'RbacExceptionReason';
      case _ijqyf5jf.RbacPermission():
        return 'RbacPermission';
      case _im7c8v5q.RbacRole():
        return 'RbacRole';
      case _is7enq59.RbacRolePermission():
        return 'RbacRolePermission';
      case _icgz0mns.RbacUserPermissionsInfo():
        return 'RbacUserPermissionsInfo';
      case _ig5ad0pf.RbacUserRole():
        return 'RbacUserRole';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'RbacAbacResult') {
      return deserialize<_is9x66yl.RbacAbacResult>(data['data']);
    }
    if (dataClassName == 'RbacException') {
      return deserialize<_irzd0ivn.RbacException>(data['data']);
    }
    if (dataClassName == 'RbacExceptionReason') {
      return deserialize<_ilr4m7ck.RbacExceptionReason>(data['data']);
    }
    if (dataClassName == 'RbacPermission') {
      return deserialize<_ijqyf5jf.RbacPermission>(data['data']);
    }
    if (dataClassName == 'RbacRole') {
      return deserialize<_im7c8v5q.RbacRole>(data['data']);
    }
    if (dataClassName == 'RbacRolePermission') {
      return deserialize<_is7enq59.RbacRolePermission>(data['data']);
    }
    if (dataClassName == 'RbacUserPermissionsInfo') {
      return deserialize<_icgz0mns.RbacUserPermissionsInfo>(data['data']);
    }
    if (dataClassName == 'RbacUserRole') {
      return deserialize<_ig5ad0pf.RbacUserRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  Object? dynamicFieldToJson(
    Object? object, {
    bool forProtocol = false,
  }) {
    if ((object is List || object is Set || object is Map) ||
        getClassNameForObject(object) != null) {
      return super.dynamicFieldToJson(object, forProtocol: forProtocol);
    }
    for (final protocol in _hostProtocols) {
      final className = protocol.getClassNameForObject(object);
      if (className == null) continue;
      final host = protocol.getModuleName();
      final wrapped = {
        'className': className.contains('.') ? className : '$host.$className',
        'data': object,
      };
      return forProtocol
          ? _is.SerializationManager.toEncodableForProtocol(wrapped)
          : _is.SerializationManager.toEncodable(wrapped);
    }
    return super.dynamicFieldToJson(object, forProtocol: forProtocol);
  }

  @override
  dynamic deserializeDynamicFieldValue(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic> || value['className'] is! String) {
      throw FormatException(
        'Dynamic fields are encoded as a Map with className and data, but got '
        '${value.runtimeType} instead.',
      );
    }
    final className = value['className'] as String;
    for (final protocol in _hostProtocols) {
      final host = protocol.getModuleName();
      final hostPrefix = '$host.';
      if (className.startsWith(hostPrefix)) {
        final strippedClassName = className.substring(hostPrefix.length);
        if (strippedClassName.contains('.')) {
          throw FormatException(
            'Dynamic field className must not use multiple prefixes: $className',
          );
        }
        final hostData = Map<String, dynamic>.from(value);
        hostData['className'] = strippedClassName;
        return protocol.deserializeByClassName(hostData);
      }
    }
    if (className.contains('.')) {
      for (final protocol in _hostProtocols) {
        try {
          return protocol.deserializeByClassName(value);
        } on _is.DeserializationClassNameNotFoundException catch (_) {}
      }
    }
    return deserializeByClassName(value);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ijqyf5jf.RbacPermission:
        return _ijqyf5jf.RbacPermission.t;
      case _im7c8v5q.RbacRole:
        return _im7c8v5q.RbacRole.t;
      case _is7enq59.RbacRolePermission:
        return _is7enq59.RbacRolePermission.t;
      case _ig5ad0pf.RbacUserRole:
        return _ig5ad0pf.RbacUserRole.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_rbac';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _isp.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
