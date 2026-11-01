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

abstract class RbacUserRole
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RbacUserRole._({
    this.id,
    required this.userIdentifier,
    required this.roleId,
    this.role,
    this.domain,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RbacUserRole({
    int? id,
    required String userIdentifier,
    required int roleId,
    _im7c8v5q.RbacRole? role,
    String? domain,
    DateTime? createdAt,
  }) = _RbacUserRoleImpl;

  factory RbacUserRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacUserRole(
      id: jsonSerialization['id'] as int?,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      roleId: jsonSerialization['roleId'] as int,
      role: jsonSerialization['role'] == null
          ? null
          : _iqg09eor.Protocol().deserialize<_im7c8v5q.RbacRole>(
              jsonSerialization['role'],
            ),
      domain: jsonSerialization['domain'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userIdentifier;

  int roleId;

  _im7c8v5q.RbacRole? role;

  String? domain;

  DateTime createdAt;

  /// Returns a shallow copy of this [RbacUserRole]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RbacUserRole copyWith({
    int? id,
    String? userIdentifier,
    int? roleId,
    _im7c8v5q.RbacRole? role,
    String? domain,
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
      if (domain != null) 'domain': domain,
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
      if (domain != null) 'domain': domain,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacUserRoleImpl extends RbacUserRole {
  _RbacUserRoleImpl({
    int? id,
    required String userIdentifier,
    required int roleId,
    _im7c8v5q.RbacRole? role,
    String? domain,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userIdentifier: userIdentifier,
         roleId: roleId,
         role: role,
         domain: domain,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacUserRole]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RbacUserRole copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    int? roleId,
    Object? role = _Undefined,
    Object? domain = _Undefined,
    DateTime? createdAt,
  }) {
    return RbacUserRole(
      id: id is int? ? id : this.id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      roleId: roleId ?? this.roleId,
      role: role is _im7c8v5q.RbacRole? ? role : this.role?.copyWith(),
      domain: domain is String? ? domain : this.domain,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
