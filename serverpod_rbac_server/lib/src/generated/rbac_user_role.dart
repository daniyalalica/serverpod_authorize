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
import 'rbac_role.dart' as _im7c8v5q;

abstract class RbacUserRole
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RbacUserRole._({
    this.id,
    required this.userIdentifier,
    required this.roleId,
    this.role,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RbacUserRole({
    int? id,
    required String userIdentifier,
    required int roleId,
    _im7c8v5q.RbacRole? role,
    DateTime? createdAt,
  }) = _RbacUserRoleImpl;

  factory RbacUserRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacUserRole(
      id: jsonSerialization['id'] as int?,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      roleId: jsonSerialization['roleId'] as int,
      role: jsonSerialization['role'] == null
          ? null
          : _i0rg5xn1.Protocol().deserialize<_im7c8v5q.RbacRole>(
              jsonSerialization['role'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = RbacUserRoleTable();

  static const db = RbacUserRoleRepository._();

  @override
  int? id;

  String userIdentifier;

  int roleId;

  _im7c8v5q.RbacRole? role;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RbacUserRole]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RbacUserRole copyWith({
    int? id,
    String? userIdentifier,
    int? roleId,
    _im7c8v5q.RbacRole? role,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacUserRole',
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      'roleId': roleId,
      if (role != null) 'role': role?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacUserRole',
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      'roleId': roleId,
      if (role != null) 'role': role?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
    };
  }

  static RbacUserRoleInclude include({_im7c8v5q.RbacRoleInclude? role}) {
    return RbacUserRoleInclude._(role: role);
  }

  static RbacUserRoleIncludeList includeList({
    _is.WhereExpressionBuilder<RbacUserRoleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacUserRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacUserRoleTable>? orderByList,
    RbacUserRoleInclude? include,
  }) {
    return RbacUserRoleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacUserRole.t),
      orderByList: orderByList?.call(RbacUserRole.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacUserRoleImpl extends RbacUserRole {
  _RbacUserRoleImpl({
    int? id,
    required String userIdentifier,
    required int roleId,
    _im7c8v5q.RbacRole? role,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userIdentifier: userIdentifier,
         roleId: roleId,
         role: role,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacUserRole]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RbacUserRole copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    int? roleId,
    Object? role = _Undefined,
    DateTime? createdAt,
  }) {
    return RbacUserRole(
      id: id is int? ? id : this.id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      roleId: roleId ?? this.roleId,
      role: role is _im7c8v5q.RbacRole? ? role : this.role?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RbacUserRoleUpdateTable extends _is.UpdateTable<RbacUserRoleTable> {
  RbacUserRoleUpdateTable(super.table);

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<int, int> roleId(int value) => _is.ColumnValue(
    table.roleId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class RbacUserRoleTable extends _is.Table<int?> {
  RbacUserRoleTable({super.tableRelation})
    : super(tableName: 'serverpod_rbac_user_role') {
    updateTable = RbacUserRoleUpdateTable(this);
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    roleId = _is.ColumnInt(
      'roleId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final RbacUserRoleUpdateTable updateTable;

  late final _is.ColumnString userIdentifier;

  late final _is.ColumnInt roleId;

  _im7c8v5q.RbacRoleTable? _role;

  late final _is.ColumnDateTime createdAt;

  _im7c8v5q.RbacRoleTable get role {
    if (_role != null) return _role!;
    _role = _is.createRelationTable(
      relationFieldName: 'role',
      field: RbacUserRole.t.roleId,
      foreignField: _im7c8v5q.RbacRole.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _im7c8v5q.RbacRoleTable(tableRelation: foreignTableRelation),
    );
    return _role!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    userIdentifier,
    roleId,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'role') {
      return role;
    }
    return null;
  }
}

class RbacUserRoleInclude extends _is.IncludeObject {
  RbacUserRoleInclude._({_im7c8v5q.RbacRoleInclude? role}) {
    _role = role;
  }

  _im7c8v5q.RbacRoleInclude? _role;

  @override
  Map<String, _is.Include?> get includes => {'role': _role};

  @override
  _is.Table<int?> get table => RbacUserRole.t;
}

class RbacUserRoleIncludeList extends _is.IncludeList {
  RbacUserRoleIncludeList._({
    _is.WhereExpressionBuilder<RbacUserRoleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RbacUserRole.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RbacUserRole.t;
}

class RbacUserRoleRepository {
  const RbacUserRoleRepository._();

  final attachRow = const RbacUserRoleAttachRowRepository._();

  /// Returns a list of [RbacUserRole]s matching the given query parameters.
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
  Future<List<RbacUserRole>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacUserRoleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacUserRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacUserRoleTable>? orderByList,
    _is.Transaction? transaction,
    RbacUserRoleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RbacUserRole>(
      where: where?.call(RbacUserRole.t),
      orderBy: orderBy?.call(RbacUserRole.t),
      orderByList: orderByList?.call(RbacUserRole.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RbacUserRole] matching the given query parameters.
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
  Future<RbacUserRole?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacUserRoleTable>? where,
    int? offset,
    _is.OrderByBuilder<RbacUserRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacUserRoleTable>? orderByList,
    _is.Transaction? transaction,
    RbacUserRoleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RbacUserRole>(
      where: where?.call(RbacUserRole.t),
      orderBy: orderBy?.call(RbacUserRole.t),
      orderByList: orderByList?.call(RbacUserRole.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RbacUserRole] by its [id] or null if no such row exists.
  Future<RbacUserRole?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    RbacUserRoleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RbacUserRole>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RbacUserRole]s in the list and returns the inserted rows.
  ///
  /// The returned [RbacUserRole]s will have their `id` fields set.
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
  Future<List<RbacUserRole>> insert(
    _is.DatabaseSession session,
    List<RbacUserRole> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RbacUserRole>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RbacUserRole] and returns the inserted row.
  ///
  /// The returned [RbacUserRole] will have its `id` field set.
  Future<RbacUserRole> insertRow(
    _is.DatabaseSession session,
    RbacUserRole row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RbacUserRole>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RbacUserRole]s in the list and returns the resulting rows.
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
  /// The returned [RbacUserRole]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacUserRole>> upsert(
    _is.DatabaseSession session,
    List<RbacUserRole> rows, {
    required _is.ColumnSelections<RbacUserRoleTable> conflictColumns,
    _is.ColumnSelections<RbacUserRoleTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacUserRoleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RbacUserRole>(
      rows,
      conflictColumns: conflictColumns(RbacUserRole.t),
      updateColumns: updateColumns?.call(RbacUserRole.t),
      updateWhere: updateWhere?.call(RbacUserRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RbacUserRole] and returns the resulting row.
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
  /// The returned [RbacUserRole] will have its `id` field set.
  Future<RbacUserRole?> upsertRow(
    _is.DatabaseSession session,
    RbacUserRole row, {
    required _is.ColumnSelections<RbacUserRoleTable> conflictColumns,
    _is.ColumnSelections<RbacUserRoleTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacUserRoleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RbacUserRole>(
      row,
      conflictColumns: conflictColumns(RbacUserRole.t),
      updateColumns: updateColumns?.call(RbacUserRole.t),
      updateWhere: updateWhere?.call(RbacUserRole.t),
      transaction: transaction,
    );
  }

  /// Updates all [RbacUserRole]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacUserRole>> update(
    _is.DatabaseSession session,
    List<RbacUserRole> rows, {
    _is.ColumnSelections<RbacUserRoleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RbacUserRole>(
      rows,
      columns: columns?.call(RbacUserRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RbacUserRole]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RbacUserRole> updateRow(
    _is.DatabaseSession session,
    RbacUserRole row, {
    _is.ColumnSelections<RbacUserRoleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RbacUserRole>(
      row,
      columns: columns?.call(RbacUserRole.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RbacUserRole] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RbacUserRole?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RbacUserRoleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RbacUserRole>(
      id,
      columnValues: columnValues(RbacUserRole.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RbacUserRole]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacUserRole>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RbacUserRoleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RbacUserRoleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacUserRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacUserRoleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RbacUserRole>(
      columnValues: columnValues(RbacUserRole.t.updateTable),
      where: where(RbacUserRole.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacUserRole.t),
      orderByList: orderByList?.call(RbacUserRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RbacUserRole]s in the list and returns the deleted rows.
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
  Future<List<RbacUserRole>> delete(
    _is.DatabaseSession session,
    List<RbacUserRole> rows, {
    _is.OrderByBuilder<RbacUserRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacUserRoleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RbacUserRole>(
      rows,
      orderBy: orderBy?.call(RbacUserRole.t),
      orderByList: orderByList?.call(RbacUserRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RbacUserRole].
  Future<RbacUserRole> deleteRow(
    _is.DatabaseSession session,
    RbacUserRole row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RbacUserRole>(
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
  Future<List<RbacUserRole>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacUserRoleTable> where,
    _is.OrderByBuilder<RbacUserRoleTable>? orderBy,
    _is.OrderByListBuilder<RbacUserRoleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RbacUserRole>(
      where: where(RbacUserRole.t),
      orderBy: orderBy?.call(RbacUserRole.t),
      orderByList: orderByList?.call(RbacUserRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacUserRoleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RbacUserRole>(
      where: where?.call(RbacUserRole.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RbacUserRole] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacUserRoleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RbacUserRole>(
      where: where(RbacUserRole.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RbacUserRoleAttachRowRepository {
  const RbacUserRoleAttachRowRepository._();

  /// Creates a relation between the given [RbacUserRole] and [RbacRole]
  /// by setting the [RbacUserRole]'s foreign key `roleId` to refer to the [RbacRole].
  Future<void> role(
    _is.DatabaseSession session,
    RbacUserRole rbacUserRole,
    _im7c8v5q.RbacRole role, {
    _is.Transaction? transaction,
  }) async {
    if (rbacUserRole.id == null) {
      throw ArgumentError.notNull('rbacUserRole.id');
    }
    if (role.id == null) {
      throw ArgumentError.notNull('role.id');
    }

    var $rbacUserRole = rbacUserRole.copyWith(roleId: role.id);
    await session.db.updateRow<RbacUserRole>(
      $rbacUserRole,
      columns: [RbacUserRole.t.roleId],
      transaction: transaction,
    );
  }
}
