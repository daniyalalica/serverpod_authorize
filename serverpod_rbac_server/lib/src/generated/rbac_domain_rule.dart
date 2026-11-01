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

abstract class RbacDomainRule
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RbacDomainRule._({
    this.id,
    required this.roleId,
    this.role,
    required this.resource,
    this.permission,
    required this.filterExpression,
    this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RbacDomainRule({
    int? id,
    required int roleId,
    _im7c8v5q.RbacRole? role,
    required String resource,
    String? permission,
    required String filterExpression,
    String? description,
    DateTime? createdAt,
  }) = _RbacDomainRuleImpl;

  factory RbacDomainRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacDomainRule(
      id: jsonSerialization['id'] as int?,
      roleId: jsonSerialization['roleId'] as int,
      role: jsonSerialization['role'] == null
          ? null
          : _i0rg5xn1.Protocol().deserialize<_im7c8v5q.RbacRole>(
              jsonSerialization['role'],
            ),
      resource: jsonSerialization['resource'] as String,
      permission: jsonSerialization['permission'] as String?,
      filterExpression: jsonSerialization['filterExpression'] as String,
      description: jsonSerialization['description'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = RbacDomainRuleTable();

  static const db = RbacDomainRuleRepository._();

  @override
  int? id;

  int roleId;

  _im7c8v5q.RbacRole? role;

  String resource;

  String? permission;

  String filterExpression;

  String? description;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RbacDomainRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RbacDomainRule copyWith({
    int? id,
    int? roleId,
    _im7c8v5q.RbacRole? role,
    String? resource,
    String? permission,
    String? filterExpression,
    String? description,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacDomainRule',
      if (id != null) 'id': id,
      'roleId': roleId,
      if (role != null) 'role': role?.toJson(),
      'resource': resource,
      if (permission != null) 'permission': permission,
      'filterExpression': filterExpression,
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacDomainRule',
      if (id != null) 'id': id,
      'roleId': roleId,
      if (role != null) 'role': role?.toJsonForProtocol(),
      'resource': resource,
      if (permission != null) 'permission': permission,
      'filterExpression': filterExpression,
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  static RbacDomainRuleInclude include({_im7c8v5q.RbacRoleInclude? role}) {
    return RbacDomainRuleInclude._(role: role);
  }

  static RbacDomainRuleIncludeList includeList({
    _is.WhereExpressionBuilder<RbacDomainRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacDomainRuleTable>? orderBy,
    _is.OrderByListBuilder<RbacDomainRuleTable>? orderByList,
    RbacDomainRuleInclude? include,
  }) {
    return RbacDomainRuleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacDomainRule.t),
      orderByList: orderByList?.call(RbacDomainRule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacDomainRuleImpl extends RbacDomainRule {
  _RbacDomainRuleImpl({
    int? id,
    required int roleId,
    _im7c8v5q.RbacRole? role,
    required String resource,
    String? permission,
    required String filterExpression,
    String? description,
    DateTime? createdAt,
  }) : super._(
         id: id,
         roleId: roleId,
         role: role,
         resource: resource,
         permission: permission,
         filterExpression: filterExpression,
         description: description,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacDomainRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RbacDomainRule copyWith({
    Object? id = _Undefined,
    int? roleId,
    Object? role = _Undefined,
    String? resource,
    Object? permission = _Undefined,
    String? filterExpression,
    Object? description = _Undefined,
    DateTime? createdAt,
  }) {
    return RbacDomainRule(
      id: id is int? ? id : this.id,
      roleId: roleId ?? this.roleId,
      role: role is _im7c8v5q.RbacRole? ? role : this.role?.copyWith(),
      resource: resource ?? this.resource,
      permission: permission is String? ? permission : this.permission,
      filterExpression: filterExpression ?? this.filterExpression,
      description: description is String? ? description : this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RbacDomainRuleUpdateTable extends _is.UpdateTable<RbacDomainRuleTable> {
  RbacDomainRuleUpdateTable(super.table);

  _is.ColumnValue<int, int> roleId(int value) => _is.ColumnValue(
    table.roleId,
    value,
  );

  _is.ColumnValue<String, String> resource(String value) => _is.ColumnValue(
    table.resource,
    value,
  );

  _is.ColumnValue<String, String> permission(String? value) => _is.ColumnValue(
    table.permission,
    value,
  );

  _is.ColumnValue<String, String> filterExpression(String value) =>
      _is.ColumnValue(
        table.filterExpression,
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

class RbacDomainRuleTable extends _is.Table<int?> {
  RbacDomainRuleTable({super.tableRelation})
    : super(tableName: 'serverpod_rbac_domain_rule') {
    updateTable = RbacDomainRuleUpdateTable(this);
    roleId = _is.ColumnInt(
      'roleId',
      this,
    );
    resource = _is.ColumnString(
      'resource',
      this,
    );
    permission = _is.ColumnString(
      'permission',
      this,
    );
    filterExpression = _is.ColumnString(
      'filterExpression',
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

  late final RbacDomainRuleUpdateTable updateTable;

  late final _is.ColumnInt roleId;

  _im7c8v5q.RbacRoleTable? _role;

  late final _is.ColumnString resource;

  late final _is.ColumnString permission;

  late final _is.ColumnString filterExpression;

  late final _is.ColumnString description;

  late final _is.ColumnDateTime createdAt;

  _im7c8v5q.RbacRoleTable get role {
    if (_role != null) return _role!;
    _role = _is.createRelationTable(
      relationFieldName: 'role',
      field: RbacDomainRule.t.roleId,
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
    roleId,
    resource,
    permission,
    filterExpression,
    description,
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

class RbacDomainRuleInclude extends _is.IncludeObject {
  RbacDomainRuleInclude._({_im7c8v5q.RbacRoleInclude? role}) {
    _role = role;
  }

  _im7c8v5q.RbacRoleInclude? _role;

  @override
  Map<String, _is.Include?> get includes => {'role': _role};

  @override
  _is.Table<int?> get table => RbacDomainRule.t;
}

class RbacDomainRuleIncludeList extends _is.IncludeList {
  RbacDomainRuleIncludeList._({
    _is.WhereExpressionBuilder<RbacDomainRuleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RbacDomainRule.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RbacDomainRule.t;
}

class RbacDomainRuleRepository {
  const RbacDomainRuleRepository._();

  final attachRow = const RbacDomainRuleAttachRowRepository._();

  /// Returns a list of [RbacDomainRule]s matching the given query parameters.
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
  Future<List<RbacDomainRule>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacDomainRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacDomainRuleTable>? orderBy,
    _is.OrderByListBuilder<RbacDomainRuleTable>? orderByList,
    _is.Transaction? transaction,
    RbacDomainRuleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RbacDomainRule>(
      where: where?.call(RbacDomainRule.t),
      orderBy: orderBy?.call(RbacDomainRule.t),
      orderByList: orderByList?.call(RbacDomainRule.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RbacDomainRule] matching the given query parameters.
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
  Future<RbacDomainRule?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacDomainRuleTable>? where,
    int? offset,
    _is.OrderByBuilder<RbacDomainRuleTable>? orderBy,
    _is.OrderByListBuilder<RbacDomainRuleTable>? orderByList,
    _is.Transaction? transaction,
    RbacDomainRuleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RbacDomainRule>(
      where: where?.call(RbacDomainRule.t),
      orderBy: orderBy?.call(RbacDomainRule.t),
      orderByList: orderByList?.call(RbacDomainRule.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RbacDomainRule] by its [id] or null if no such row exists.
  Future<RbacDomainRule?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    RbacDomainRuleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RbacDomainRule>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RbacDomainRule]s in the list and returns the inserted rows.
  ///
  /// The returned [RbacDomainRule]s will have their `id` fields set.
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
  Future<List<RbacDomainRule>> insert(
    _is.DatabaseSession session,
    List<RbacDomainRule> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RbacDomainRule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RbacDomainRule] and returns the inserted row.
  ///
  /// The returned [RbacDomainRule] will have its `id` field set.
  Future<RbacDomainRule> insertRow(
    _is.DatabaseSession session,
    RbacDomainRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RbacDomainRule>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RbacDomainRule]s in the list and returns the resulting rows.
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
  /// The returned [RbacDomainRule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacDomainRule>> upsert(
    _is.DatabaseSession session,
    List<RbacDomainRule> rows, {
    required _is.ColumnSelections<RbacDomainRuleTable> conflictColumns,
    _is.ColumnSelections<RbacDomainRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacDomainRuleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RbacDomainRule>(
      rows,
      conflictColumns: conflictColumns(RbacDomainRule.t),
      updateColumns: updateColumns?.call(RbacDomainRule.t),
      updateWhere: updateWhere?.call(RbacDomainRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RbacDomainRule] and returns the resulting row.
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
  /// The returned [RbacDomainRule] will have its `id` field set.
  Future<RbacDomainRule?> upsertRow(
    _is.DatabaseSession session,
    RbacDomainRule row, {
    required _is.ColumnSelections<RbacDomainRuleTable> conflictColumns,
    _is.ColumnSelections<RbacDomainRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<RbacDomainRuleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RbacDomainRule>(
      row,
      conflictColumns: conflictColumns(RbacDomainRule.t),
      updateColumns: updateColumns?.call(RbacDomainRule.t),
      updateWhere: updateWhere?.call(RbacDomainRule.t),
      transaction: transaction,
    );
  }

  /// Updates all [RbacDomainRule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacDomainRule>> update(
    _is.DatabaseSession session,
    List<RbacDomainRule> rows, {
    _is.ColumnSelections<RbacDomainRuleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RbacDomainRule>(
      rows,
      columns: columns?.call(RbacDomainRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RbacDomainRule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RbacDomainRule> updateRow(
    _is.DatabaseSession session,
    RbacDomainRule row, {
    _is.ColumnSelections<RbacDomainRuleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RbacDomainRule>(
      row,
      columns: columns?.call(RbacDomainRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RbacDomainRule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RbacDomainRule?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RbacDomainRuleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RbacDomainRule>(
      id,
      columnValues: columnValues(RbacDomainRule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RbacDomainRule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RbacDomainRule>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RbacDomainRuleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RbacDomainRuleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RbacDomainRuleTable>? orderBy,
    _is.OrderByListBuilder<RbacDomainRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RbacDomainRule>(
      columnValues: columnValues(RbacDomainRule.t.updateTable),
      where: where(RbacDomainRule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacDomainRule.t),
      orderByList: orderByList?.call(RbacDomainRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RbacDomainRule]s in the list and returns the deleted rows.
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
  Future<List<RbacDomainRule>> delete(
    _is.DatabaseSession session,
    List<RbacDomainRule> rows, {
    _is.OrderByBuilder<RbacDomainRuleTable>? orderBy,
    _is.OrderByListBuilder<RbacDomainRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RbacDomainRule>(
      rows,
      orderBy: orderBy?.call(RbacDomainRule.t),
      orderByList: orderByList?.call(RbacDomainRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RbacDomainRule].
  Future<RbacDomainRule> deleteRow(
    _is.DatabaseSession session,
    RbacDomainRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RbacDomainRule>(
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
  Future<List<RbacDomainRule>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacDomainRuleTable> where,
    _is.OrderByBuilder<RbacDomainRuleTable>? orderBy,
    _is.OrderByListBuilder<RbacDomainRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RbacDomainRule>(
      where: where(RbacDomainRule.t),
      orderBy: orderBy?.call(RbacDomainRule.t),
      orderByList: orderByList?.call(RbacDomainRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RbacDomainRuleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RbacDomainRule>(
      where: where?.call(RbacDomainRule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RbacDomainRule] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RbacDomainRuleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RbacDomainRule>(
      where: where(RbacDomainRule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RbacDomainRuleAttachRowRepository {
  const RbacDomainRuleAttachRowRepository._();

  /// Creates a relation between the given [RbacDomainRule] and [RbacRole]
  /// by setting the [RbacDomainRule]'s foreign key `roleId` to refer to the [RbacRole].
  Future<void> role(
    _is.DatabaseSession session,
    RbacDomainRule rbacDomainRule,
    _im7c8v5q.RbacRole role, {
    _is.Transaction? transaction,
  }) async {
    if (rbacDomainRule.id == null) {
      throw ArgumentError.notNull('rbacDomainRule.id');
    }
    if (role.id == null) {
      throw ArgumentError.notNull('role.id');
    }

    var $rbacDomainRule = rbacDomainRule.copyWith(roleId: role.id);
    await session.db.updateRow<RbacDomainRule>(
      $rbacDomainRule,
      columns: [RbacDomainRule.t.roleId],
      transaction: transaction,
    );
  }
}
