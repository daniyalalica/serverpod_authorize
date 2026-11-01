/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_rbac_server/src/generated/protocol.dart' as _i0rg5xn1;
import 'rbac_role_permission.dart' as _is7enq59;
import 'rbac_user_role.dart' as _ig5ad0pf;

abstract class RbacRole
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RbacRole._({
    this.id,
    required this.name,
    this.description,
    bool? isSuperuser,
    bool? isSystemRole,
    this.permissions,
    this.userRoles,
    DateTime? createdAt,
  }) : isSuperuser = isSuperuser ?? false,
       isSystemRole = isSystemRole ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory RbacRole({
    int? id,
    required String name,
    String? description,
    bool? isSuperuser,
    bool? isSystemRole,
    List<_is7enq59.RbacRolePermission>? permissions,
    List<_ig5ad0pf.RbacUserRole>? userRoles,
    DateTime? createdAt,
  }) = _RbacRoleImpl;

  factory RbacRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacRole(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      isSuperuser: jsonSerialization['isSuperuser'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isSuperuser']),
      isSystemRole: jsonSerialization['isSystemRole'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isSystemRole']),
      permissions: jsonSerialization['permissions'] == null
          ? null
          : _i0rg5xn1.Protocol()
                .deserialize<List<_is7enq59.RbacRolePermission>>(
                  jsonSerialization['permissions'],
                ),
      userRoles: jsonSerialization['userRoles'] == null
          ? null
          : _i0rg5xn1.Protocol().deserialize<List<_ig5ad0pf.RbacUserRole>>(
              jsonSerialization['userRoles'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = RbacRoleTable();

  static const db = RbacRoleRepository._();

  @override
  int? id;

  String name;

  String? description;

  bool isSuperuser;

  bool isSystemRole;

  List<_is7enq59.RbacRolePermission>? permissions;

  List<_ig5ad0pf.RbacUserRole>? userRoles;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RbacRole]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RbacRole copyWith({
    int? id,
    String? name,
    String? description,
    bool? isSuperuser,
    bool? isSystemRole,
    List<_is7enq59.RbacRolePermission>? permissions,
    List<_ig5ad0pf.RbacUserRole>? userRoles,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacRole',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'isSuperuser': isSuperuser,
      'isSystemRole': isSystemRole,
      if (permissions != null)
        'permissions': permissions?.toJson(valueToJson: (v) => v.toJson()),
      if (userRoles != null)
        'userRoles': userRoles?.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacRole',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'isSuperuser': isSuperuser,
      'isSystemRole': isSystemRole,
      if (permissions != null)
        'permissions': permissions?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (userRoles != null)
        'userRoles': userRoles?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'createdAt': createdAt.toJson(),
    };
  }

  static RbacRoleInclude include({
    _is7enq59.RbacRolePermissionIncludeList? permissions,
    _ig5ad0pf.RbacUserRoleIncludeList? userRoles,
  }) {
    return RbacRoleInclude._(
      permissions: permissions,
      userRoles: userRoles,
    );
  }

  static RbacRoleIncludeList includeList({
    _is.WhereExpressionBuilder<RbacRoleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacRoleTable>? orderByList,
    RbacRoleInclude? include,
  }) {
    return RbacRoleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacRole.t),
      orderByList: orderByList?.call(RbacRole.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacRoleImpl extends RbacRole {
  _RbacRoleImpl({
    int? id,
    required String name,
    String? description,
    bool? isSuperuser,
    bool? isSystemRole,
    List<_is7enq59.RbacRolePermission>? permissions,
    List<_ig5ad0pf.RbacUserRole>? userRoles,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         isSuperuser: isSuperuser,
         isSystemRole: isSystemRole,
         permissions: permissions,
         userRoles: userRoles,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacRole]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RbacRole copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    bool? isSuperuser,
    bool? isSystemRole,
    Object? permissions = _Undefined,
    Object? userRoles = _Undefined,
    DateTime? createdAt,
  }) {
    return RbacRole(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      isSystemRole: isSystemRole ?? this.isSystemRole,
      permissions: permissions is List<_is7enq59.RbacRolePermission>?
          ? permissions
          : this.permissions?.map((e0) => e0.copyWith()).toList(),
      userRoles: userRoles is List<_ig5ad0pf.RbacUserRole>?
          ? userRoles
          : this.userRoles?.map((e0) => e0.copyWith()).toList(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RbacRoleUpdateTable extends _is.UpdateTable<RbacRoleTable> {
  RbacRoleUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<bool, bool> isSuperuser(bool value) => _is.ColumnValue(
    table.isSuperuser,
    value,
  );

  _is.ColumnValue<bool, bool> isSystemRole(bool value) => _is.ColumnValue(
    table.isSystemRole,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class RbacRoleTable extends _is.Table<int?> {
  RbacRoleTable({super.tableRelation})
    : super(tableName: 'serverpod_rbac_role') {
    updateTable = RbacRoleUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    isSuperuser = _is.ColumnBool(
      'isSuperuser',
      this,
      hasDefault: true,
    );
    isSystemRole = _is.ColumnBool(
      'isSystemRole',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final RbacRoleUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  late final _is.ColumnBool isSuperuser;

  late final _is.ColumnBool isSystemRole;

  _is7enq59.RbacRolePermissionTable? ___permissions;

  _is.ManyRelation<_is7enq59.RbacRolePermissionTable>? _permissions;

  _ig5ad0pf.RbacUserRoleTable? ___userRoles;

  _is.ManyRelation<_ig5ad0pf.RbacUserRoleTable>? _userRoles;

  late final _is.ColumnDateTime createdAt;

  _is7enq59.RbacRolePermissionTable get __permissions {
    if (___permissions != null) return ___permissions!;
    ___permissions = _is.createRelationTable(
      relationFieldName: '__permissions',
      field: RbacRole.t.id,
      foreignField: _is7enq59.RbacRolePermission.t.roleId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _is7enq59.RbacRolePermissionTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return ___permissions!;
  }

  _ig5ad0pf.RbacUserRoleTable get __userRoles {
    if (___userRoles != null) return ___userRoles!;
    ___userRoles = _is.createRelationTable(
      relationFieldName: '__userRoles',
      field: RbacRole.t.id,
      foreignField: _ig5ad0pf.RbacUserRole.t.roleId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ig5ad0pf.RbacUserRoleTable(tableRelation: foreignTableRelation),
    );
    return ___userRoles!;
  }

  _is.ManyRelation<_is7enq59.RbacRolePermissionTable> get permissions {
    if (_permissions != null) return _permissions!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'permissions',
      field: RbacRole.t.id,
      foreignField: _is7enq59.RbacRolePermission.t.roleId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _is7enq59.RbacRolePermissionTable(
        tableRelation: foreignTableRelation,
      ),
    );
    _permissions = _is.ManyRelation<_is7enq59.RbacRolePermissionTable>(
      tableWithRelations: relationTable,
      table: _is7enq59.RbacRolePermissionTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _permissions!;
  }

  _is.ManyRelation<_ig5ad0pf.RbacUserRoleTable> get userRoles {
    if (_userRoles != null) return _userRoles!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'userRoles',
      field: RbacRole.t.id,
      foreignField: _ig5ad0pf.RbacUserRole.t.roleId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ig5ad0pf.RbacUserRoleTable(tableRelation: foreignTableRelation),
    );
    _userRoles = _is.ManyRelation<_ig5ad0pf.RbacUserRoleTable>(
      tableWithRelations: relationTable,
      table: _ig5ad0pf.RbacUserRoleTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _userRoles!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    description,
    isSuperuser,
    isSystemRole,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'permissions') {
      return __permissions;
    }
    if (relationField == 'userRoles') {
      return __userRoles;
    }
    return null;
  }
}

class RbacRoleInclude extends _is.IncludeObject {
  RbacRoleInclude._({
    _is7enq59.RbacRolePermissionIncludeList? permissions,
    _ig5ad0pf.RbacUserRoleIncludeList? userRoles,
  }) {
    _permissions = permissions;
    _userRoles = userRoles;
  }

  _is7enq59.RbacRolePermissionIncludeList? _permissions;

  _ig5ad0pf.RbacUserRoleIncludeList? _userRoles;

  @override
  Map<String, _is.Include?> get includes => {
    'permissions': _permissions,
    'userRoles': _userRoles,
  };

  @override
  _is.Table<int?> get table => RbacRole.t;
}

class RbacRoleIncludeList extends _is.IncludeList {
  RbacRoleIncludeList._({
    _is.WhereExpressionBuilder<RbacRoleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RbacRole.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RbacRole.t;
}

class RbacRoleRepository {
  const RbacRoleRepository._();

  final attach = const RbacRoleAttachRepository._();

  final attachRow = const RbacRoleAttachRowRepository._();

  /// Returns a list of [RbacRole]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<RbacRole>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacRoleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacRoleTable>? orderByList,
    _is.Transaction? transaction,
    RbacRoleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RbacRole>(
      where: where?.call(RbacRole.t),
      orderBy: orderBy?.call(RbacRole.t),
      orderByList: orderByList?.call(RbacRole.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RbacRole] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<RbacRole?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacRoleTable>? where,
    int? offset,
    _is.OrderByBuilder<RbacRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacRoleTable>? orderByList,
    _is.Transaction? transaction,
    RbacRoleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RbacRole>(
      where: where?.call(RbacRole.t),
      orderBy: orderBy?.call(RbacRole.t),
      orderByList: orderByList?.call(RbacRole.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RbacRole] by its [id] or null if no such row exists.
  Future<RbacRole?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    RbacRoleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RbacRole>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RbacRole]s in the list and returns the inserted rows.
  ///
  /// The returned [RbacRole]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRole>> insert(
    _is.DatabaseSession session,
    List<RbacRole> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RbacRole>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RbacRole] and returns the inserted row.
  ///
  /// The returned [RbacRole] will have its `id` field set.
  Future<RbacRole> insertRow(
    _is.DatabaseSession session,
    RbacRole row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RbacRole>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RbacRole]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [RbacRole]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRole>> upsert(
    _is.DatabaseSession session,
    List<RbacRole> rows, {
    required _is.ColumnSelections<RbacRoleTable> conflictColumns,
    _is.ColumnSelections<RbacRoleTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacRoleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RbacRole>(
      rows,
      conflictColumns: conflictColumns(RbacRole.t),
      updateColumns: updateColumns?.call(RbacRole.t),
      updateWhere: updateWhere?.call(RbacRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RbacRole] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [RbacRole] will have its `id` field set.
  Future<RbacRole?> upsertRow(
    _is.DatabaseSession session,
    RbacRole row, {
    required _is.ColumnSelections<RbacRoleTable> conflictColumns,
    _is.ColumnSelections<RbacRoleTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacRoleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RbacRole>(
      row,
      conflictColumns: conflictColumns(RbacRole.t),
      updateColumns: updateColumns?.call(RbacRole.t),
      updateWhere: updateWhere?.call(RbacRole.t),
      transaction: transaction,
    );
  }

  /// Updates all [RbacRole]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRole>> update(
    _is.DatabaseSession session,
    List<RbacRole> rows, {
    _is.ColumnSelections<RbacRoleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RbacRole>(
      rows,
      columns: columns?.call(RbacRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RbacRole]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RbacRole> updateRow(
    _is.DatabaseSession session,
    RbacRole row, {
    _is.ColumnSelections<RbacRoleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RbacRole>(
      row,
      columns: columns?.call(RbacRole.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RbacRole] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RbacRole?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RbacRoleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RbacRole>(
      id,
      columnValues: columnValues(RbacRole.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RbacRole]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRole>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RbacRoleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RbacRoleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacRoleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RbacRole>(
      columnValues: columnValues(RbacRole.t.updateTable),
      where: where(RbacRole.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacRole.t),
      orderByList: orderByList?.call(RbacRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RbacRole]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRole>> delete(
    _is.DatabaseSession session,
    List<RbacRole> rows, {
    _is.OrderByBuilder<RbacRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacRoleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RbacRole>(
      rows,
      orderBy: orderBy?.call(RbacRole.t),
      orderByList: orderByList?.call(RbacRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RbacRole].
  Future<RbacRole> deleteRow(
    _is.DatabaseSession session,
    RbacRole row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RbacRole>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacRole>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacRoleTable> where,
    _is.OrderByBuilder<RbacRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacRoleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RbacRole>(
      where: where(RbacRole.t),
      orderBy: orderBy?.call(RbacRole.t),
      orderByList: orderByList?.call(RbacRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacRoleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RbacRole>(
      where: where?.call(RbacRole.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RbacRole] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacRoleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RbacRole>(
      where: where(RbacRole.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RbacRoleAttachRepository {
  const RbacRoleAttachRepository._();

  /// Creates a relation between this [RbacRole] and the given [RbacRolePermission]s
  /// by setting each [RbacRolePermission]'s foreign key `roleId` to refer to this [RbacRole].
  Future<void> permissions(
    _is.DatabaseSession session,
    RbacRole rbacRole,
    List<_is7enq59.RbacRolePermission> rbacRolePermission, {
    _is.Transaction? transaction,
  }) async {
    if (rbacRolePermission.any((e) => e.id == null)) {
      throw ArgumentError.notNull('rbacRolePermission.id');
    }
    if (rbacRole.id == null) {
      throw ArgumentError.notNull('rbacRole.id');
    }

    var $rbacRolePermission = rbacRolePermission
        .map((e) => e.copyWith(roleId: rbacRole.id))
        .toList();
    await session.db.update<_is7enq59.RbacRolePermission>(
      $rbacRolePermission,
      columns: [_is7enq59.RbacRolePermission.t.roleId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [RbacRole] and the given [RbacUserRole]s
  /// by setting each [RbacUserRole]'s foreign key `roleId` to refer to this [RbacRole].
  Future<void> userRoles(
    _is.DatabaseSession session,
    RbacRole rbacRole,
    List<_ig5ad0pf.RbacUserRole> rbacUserRole, {
    _is.Transaction? transaction,
  }) async {
    if (rbacUserRole.any((e) => e.id == null)) {
      throw ArgumentError.notNull('rbacUserRole.id');
    }
    if (rbacRole.id == null) {
      throw ArgumentError.notNull('rbacRole.id');
    }

    var $rbacUserRole = rbacUserRole
        .map((e) => e.copyWith(roleId: rbacRole.id))
        .toList();
    await session.db.update<_ig5ad0pf.RbacUserRole>(
      $rbacUserRole,
      columns: [_ig5ad0pf.RbacUserRole.t.roleId],
      transaction: transaction,
    );
  }
}

class RbacRoleAttachRowRepository {
  const RbacRoleAttachRowRepository._();

  /// Creates a relation between this [RbacRole] and the given [RbacRolePermission]
  /// by setting the [RbacRolePermission]'s foreign key `roleId` to refer to this [RbacRole].
  Future<void> permissions(
    _is.DatabaseSession session,
    RbacRole rbacRole,
    _is7enq59.RbacRolePermission rbacRolePermission, {
    _is.Transaction? transaction,
  }) async {
    if (rbacRolePermission.id == null) {
      throw ArgumentError.notNull('rbacRolePermission.id');
    }
    if (rbacRole.id == null) {
      throw ArgumentError.notNull('rbacRole.id');
    }

    var $rbacRolePermission = rbacRolePermission.copyWith(roleId: rbacRole.id);
    await session.db.updateRow<_is7enq59.RbacRolePermission>(
      $rbacRolePermission,
      columns: [_is7enq59.RbacRolePermission.t.roleId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [RbacRole] and the given [RbacUserRole]
  /// by setting the [RbacUserRole]'s foreign key `roleId` to refer to this [RbacRole].
  Future<void> userRoles(
    _is.DatabaseSession session,
    RbacRole rbacRole,
    _ig5ad0pf.RbacUserRole rbacUserRole, {
    _is.Transaction? transaction,
  }) async {
    if (rbacUserRole.id == null) {
      throw ArgumentError.notNull('rbacUserRole.id');
    }
    if (rbacRole.id == null) {
      throw ArgumentError.notNull('rbacRole.id');
    }

    var $rbacUserRole = rbacUserRole.copyWith(roleId: rbacRole.id);
    await session.db.updateRow<_ig5ad0pf.RbacUserRole>(
      $rbacUserRole,
      columns: [_ig5ad0pf.RbacUserRole.t.roleId],
      transaction: transaction,
    );
  }
}
