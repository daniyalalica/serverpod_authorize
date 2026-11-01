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

abstract class RbacPermission
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RbacPermission._({
    this.id,
    required this.resource,
    required this.codename,
    required this.name,
    this.description,
    this.roles,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RbacPermission({
    int? id,
    required String resource,
    required String codename,
    required String name,
    String? description,
    List<_is7enq59.RbacRolePermission>? roles,
    DateTime? createdAt,
  }) = _RbacPermissionImpl;

  factory RbacPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacPermission(
      id: jsonSerialization['id'] as int?,
      resource: jsonSerialization['resource'] as String,
      codename: jsonSerialization['codename'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      roles: jsonSerialization['roles'] == null
          ? null
          : _i0rg5xn1.Protocol()
                .deserialize<List<_is7enq59.RbacRolePermission>>(
                  jsonSerialization['roles'],
                ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = RbacPermissionTable();

  static const db = RbacPermissionRepository._();

  @override
  int? id;

  String resource;

  String codename;

  String name;

  String? description;

  List<_is7enq59.RbacRolePermission>? roles;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RbacPermission]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RbacPermission copyWith({
    int? id,
    String? resource,
    String? codename,
    String? name,
    String? description,
    List<_is7enq59.RbacRolePermission>? roles,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacPermission',
      if (id != null) 'id': id,
      'resource': resource,
      'codename': codename,
      'name': name,
      if (description != null) 'description': description,
      if (roles != null) 'roles': roles?.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacPermission',
      if (id != null) 'id': id,
      'resource': resource,
      'codename': codename,
      'name': name,
      if (description != null) 'description': description,
      if (roles != null)
        'roles': roles?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'createdAt': createdAt.toJson(),
    };
  }

  static RbacPermissionInclude include({
    _is7enq59.RbacRolePermissionIncludeList? roles,
  }) {
    return RbacPermissionInclude._(roles: roles);
  }

  static RbacPermissionIncludeList includeList({
    _is.WhereExpressionBuilder<RbacPermissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacPermissionTable>? orderByList,
    RbacPermissionInclude? include,
  }) {
    return RbacPermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacPermission.t),
      orderByList: orderByList?.call(RbacPermission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacPermissionImpl extends RbacPermission {
  _RbacPermissionImpl({
    int? id,
    required String resource,
    required String codename,
    required String name,
    String? description,
    List<_is7enq59.RbacRolePermission>? roles,
    DateTime? createdAt,
  }) : super._(
         id: id,
         resource: resource,
         codename: codename,
         name: name,
         description: description,
         roles: roles,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacPermission]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RbacPermission copyWith({
    Object? id = _Undefined,
    String? resource,
    String? codename,
    String? name,
    Object? description = _Undefined,
    Object? roles = _Undefined,
    DateTime? createdAt,
  }) {
    return RbacPermission(
      id: id is int? ? id : this.id,
      resource: resource ?? this.resource,
      codename: codename ?? this.codename,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      roles: roles is List<_is7enq59.RbacRolePermission>?
          ? roles
          : this.roles?.map((e0) => e0.copyWith()).toList(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RbacPermissionUpdateTable extends _is.UpdateTable<RbacPermissionTable> {
  RbacPermissionUpdateTable(super.table);

  _is.ColumnValue<String, String> resource(String value) => _is.ColumnValue(
    table.resource,
    value,
  );

  _is.ColumnValue<String, String> codename(String value) => _is.ColumnValue(
    table.codename,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class RbacPermissionTable extends _is.Table<int?> {
  RbacPermissionTable({super.tableRelation})
    : super(tableName: 'serverpod_rbac_permission') {
    updateTable = RbacPermissionUpdateTable(this);
    resource = _is.ColumnString(
      'resource',
      this,
    );
    codename = _is.ColumnString(
      'codename',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final RbacPermissionUpdateTable updateTable;

  late final _is.ColumnString resource;

  late final _is.ColumnString codename;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  _is7enq59.RbacRolePermissionTable? ___roles;

  _is.ManyRelation<_is7enq59.RbacRolePermissionTable>? _roles;

  late final _is.ColumnDateTime createdAt;

  _is7enq59.RbacRolePermissionTable get __roles {
    if (___roles != null) return ___roles!;
    ___roles = _is.createRelationTable(
      relationFieldName: '__roles',
      field: RbacPermission.t.id,
      foreignField: _is7enq59.RbacRolePermission.t.permissionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _is7enq59.RbacRolePermissionTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return ___roles!;
  }

  _is.ManyRelation<_is7enq59.RbacRolePermissionTable> get roles {
    if (_roles != null) return _roles!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'roles',
      field: RbacPermission.t.id,
      foreignField: _is7enq59.RbacRolePermission.t.permissionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _is7enq59.RbacRolePermissionTable(
        tableRelation: foreignTableRelation,
      ),
    );
    _roles = _is.ManyRelation<_is7enq59.RbacRolePermissionTable>(
      tableWithRelations: relationTable,
      table: _is7enq59.RbacRolePermissionTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _roles!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    resource,
    codename,
    name,
    description,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'roles') {
      return __roles;
    }
    return null;
  }
}

class RbacPermissionInclude extends _is.IncludeObject {
  RbacPermissionInclude._({_is7enq59.RbacRolePermissionIncludeList? roles}) {
    _roles = roles;
  }

  _is7enq59.RbacRolePermissionIncludeList? _roles;

  @override
  Map<String, _is.Include?> get includes => {'roles': _roles};

  @override
  _is.Table<int?> get table => RbacPermission.t;
}

class RbacPermissionIncludeList extends _is.IncludeList {
  RbacPermissionIncludeList._({
    _is.WhereExpressionBuilder<RbacPermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RbacPermission.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RbacPermission.t;
}

class RbacPermissionRepository {
  const RbacPermissionRepository._();

  final attach = const RbacPermissionAttachRepository._();

  final attachRow = const RbacPermissionAttachRowRepository._();

  /// Returns a list of [RbacPermission]s matching the given query parameters.
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
  Future<List<RbacPermission>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacPermissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacPermissionTable>? orderByList,
    _is.Transaction? transaction,
    RbacPermissionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RbacPermission>(
      where: where?.call(RbacPermission.t),
      orderBy: orderBy?.call(RbacPermission.t),
      orderByList: orderByList?.call(RbacPermission.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RbacPermission] matching the given query parameters.
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
  Future<RbacPermission?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacPermissionTable>? where,
    int? offset,
    _is.OrderByBuilder<RbacPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacPermissionTable>? orderByList,
    _is.Transaction? transaction,
    RbacPermissionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RbacPermission>(
      where: where?.call(RbacPermission.t),
      orderBy: orderBy?.call(RbacPermission.t),
      orderByList: orderByList?.call(RbacPermission.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RbacPermission] by its [id] or null if no such row exists.
  Future<RbacPermission?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    RbacPermissionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RbacPermission>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RbacPermission]s in the list and returns the inserted rows.
  ///
  /// The returned [RbacPermission]s will have their `id` fields set.
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
  Future<List<RbacPermission>> insert(
    _is.DatabaseSession session,
    List<RbacPermission> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RbacPermission>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RbacPermission] and returns the inserted row.
  ///
  /// The returned [RbacPermission] will have its `id` field set.
  Future<RbacPermission> insertRow(
    _is.DatabaseSession session,
    RbacPermission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RbacPermission>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RbacPermission]s in the list and returns the resulting rows.
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
  /// The returned [RbacPermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacPermission>> upsert(
    _is.DatabaseSession session,
    List<RbacPermission> rows, {
    required _is.ColumnSelections<RbacPermissionTable> conflictColumns,
    _is.ColumnSelections<RbacPermissionTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacPermissionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RbacPermission>(
      rows,
      conflictColumns: conflictColumns(RbacPermission.t),
      updateColumns: updateColumns?.call(RbacPermission.t),
      updateWhere: updateWhere?.call(RbacPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RbacPermission] and returns the resulting row.
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
  /// The returned [RbacPermission] will have its `id` field set.
  Future<RbacPermission?> upsertRow(
    _is.DatabaseSession session,
    RbacPermission row, {
    required _is.ColumnSelections<RbacPermissionTable> conflictColumns,
    _is.ColumnSelections<RbacPermissionTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacPermissionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RbacPermission>(
      row,
      conflictColumns: conflictColumns(RbacPermission.t),
      updateColumns: updateColumns?.call(RbacPermission.t),
      updateWhere: updateWhere?.call(RbacPermission.t),
      transaction: transaction,
    );
  }

  /// Updates all [RbacPermission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacPermission>> update(
    _is.DatabaseSession session,
    List<RbacPermission> rows, {
    _is.ColumnSelections<RbacPermissionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RbacPermission>(
      rows,
      columns: columns?.call(RbacPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RbacPermission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RbacPermission> updateRow(
    _is.DatabaseSession session,
    RbacPermission row, {
    _is.ColumnSelections<RbacPermissionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RbacPermission>(
      row,
      columns: columns?.call(RbacPermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RbacPermission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RbacPermission?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RbacPermissionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RbacPermission>(
      id,
      columnValues: columnValues(RbacPermission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RbacPermission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacPermission>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RbacPermissionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RbacPermissionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacPermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RbacPermission>(
      columnValues: columnValues(RbacPermission.t.updateTable),
      where: where(RbacPermission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacPermission.t),
      orderByList: orderByList?.call(RbacPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RbacPermission]s in the list and returns the deleted rows.
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
  Future<List<RbacPermission>> delete(
    _is.DatabaseSession session,
    List<RbacPermission> rows, {
    _is.OrderByBuilder<RbacPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacPermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RbacPermission>(
      rows,
      orderBy: orderBy?.call(RbacPermission.t),
      orderByList: orderByList?.call(RbacPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RbacPermission].
  Future<RbacPermission> deleteRow(
    _is.DatabaseSession session,
    RbacPermission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RbacPermission>(
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
  Future<List<RbacPermission>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacPermissionTable> where,
    _is.OrderByBuilder<RbacPermissionTable>? orderBy,
    _is.OrderByListBuilder<RbacPermissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RbacPermission>(
      where: where(RbacPermission.t),
      orderBy: orderBy?.call(RbacPermission.t),
      orderByList: orderByList?.call(RbacPermission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacPermissionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RbacPermission>(
      where: where?.call(RbacPermission.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RbacPermission] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacPermissionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RbacPermission>(
      where: where(RbacPermission.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RbacPermissionAttachRepository {
  const RbacPermissionAttachRepository._();

  /// Creates a relation between this [RbacPermission] and the given [RbacRolePermission]s
  /// by setting each [RbacRolePermission]'s foreign key `permissionId` to refer to this [RbacPermission].
  Future<void> roles(
    _is.DatabaseSession session,
    RbacPermission rbacPermission,
    List<_is7enq59.RbacRolePermission> rbacRolePermission, {
    _is.Transaction? transaction,
  }) async {
    if (rbacRolePermission.any((e) => e.id == null)) {
      throw ArgumentError.notNull('rbacRolePermission.id');
    }
    if (rbacPermission.id == null) {
      throw ArgumentError.notNull('rbacPermission.id');
    }

    var $rbacRolePermission = rbacRolePermission
        .map((e) => e.copyWith(permissionId: rbacPermission.id))
        .toList();
    await session.db.update<_is7enq59.RbacRolePermission>(
      $rbacRolePermission,
      columns: [_is7enq59.RbacRolePermission.t.permissionId],
      transaction: transaction,
    );
  }
}

class RbacPermissionAttachRowRepository {
  const RbacPermissionAttachRowRepository._();

  /// Creates a relation between this [RbacPermission] and the given [RbacRolePermission]
  /// by setting the [RbacRolePermission]'s foreign key `permissionId` to refer to this [RbacPermission].
  Future<void> roles(
    _is.DatabaseSession session,
    RbacPermission rbacPermission,
    _is7enq59.RbacRolePermission rbacRolePermission, {
    _is.Transaction? transaction,
  }) async {
    if (rbacRolePermission.id == null) {
      throw ArgumentError.notNull('rbacRolePermission.id');
    }
    if (rbacPermission.id == null) {
      throw ArgumentError.notNull('rbacPermission.id');
    }

    var $rbacRolePermission = rbacRolePermission.copyWith(
      permissionId: rbacPermission.id,
    );
    await session.db.updateRow<_is7enq59.RbacRolePermission>(
      $rbacRolePermission,
      columns: [_is7enq59.RbacRolePermission.t.permissionId],
      transaction: transaction,
    );
  }
}
