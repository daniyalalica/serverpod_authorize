/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_rbac_client/src/protocol/protocol.dart' as _iqg09eor;
import 'rbac_role.dart' as _im7c8v5q;

abstract class RbacDomainRule
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _iqg09eor.Protocol().deserialize<_im7c8v5q.RbacRole>(
              jsonSerialization['role'],
            ),
      resource: jsonSerialization['resource'] as String,
      permission: jsonSerialization['permission'] as String?,
      filterExpression: jsonSerialization['filterExpression'] as String,
      description: jsonSerialization['description'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int roleId;

  _im7c8v5q.RbacRole? role;

  String resource;

  String? permission;

  String filterExpression;

  String? description;

  DateTime createdAt;

  /// Returns a shallow copy of this [RbacDomainRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
