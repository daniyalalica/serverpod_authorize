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
import 'rbac_permission.dart' as _ijqyf5jf;
import 'rbac_role.dart' as _im7c8v5q;

abstract class RbacRolePermission
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RbacRolePermission._({
    this.id,
    required this.roleId,
    this.role,
    required this.permissionId,
    this.permission,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RbacRolePermission({
    int? id,
    required int roleId,
    _im7c8v5q.RbacRole? role,
    required int permissionId,
    _ijqyf5jf.RbacPermission? permission,
    DateTime? createdAt,
  }) = _RbacRolePermissionImpl;

  factory RbacRolePermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacRolePermission(
      id: jsonSerialization['id'] as int?,
      roleId: jsonSerialization['roleId'] as int,
      role: jsonSerialization['role'] == null
          ? null
          : _iqg09eor.Protocol().deserialize<_im7c8v5q.RbacRole>(
              jsonSerialization['role'],
            ),
      permissionId: jsonSerialization['permissionId'] as int,
      permission: jsonSerialization['permission'] == null
          ? null
          : _iqg09eor.Protocol().deserialize<_ijqyf5jf.RbacPermission>(
              jsonSerialization['permission'],
            ),
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

  int permissionId;

  _ijqyf5jf.RbacPermission? permission;

  DateTime createdAt;

  /// Returns a shallow copy of this [RbacRolePermission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RbacRolePermission copyWith({
    int? id,
    int? roleId,
    _im7c8v5q.RbacRole? role,
    int? permissionId,
    _ijqyf5jf.RbacPermission? permission,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacRolePermission',
      if (id != null) 'id': id,
      'roleId': roleId,
      if (role != null) 'role': role?.toJson(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacRolePermission',
      if (id != null) 'id': id,
      'roleId': roleId,
      if (role != null) 'role': role?.toJsonForProtocol(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacRolePermissionImpl extends RbacRolePermission {
  _RbacRolePermissionImpl({
    int? id,
    required int roleId,
    _im7c8v5q.RbacRole? role,
    required int permissionId,
    _ijqyf5jf.RbacPermission? permission,
    DateTime? createdAt,
  }) : super._(
         id: id,
         roleId: roleId,
         role: role,
         permissionId: permissionId,
         permission: permission,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RbacRolePermission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RbacRolePermission copyWith({
    Object? id = _Undefined,
    int? roleId,
    Object? role = _Undefined,
    int? permissionId,
    Object? permission = _Undefined,
    DateTime? createdAt,
  }) {
    return RbacRolePermission(
      id: id is int? ? id : this.id,
      roleId: roleId ?? this.roleId,
      role: role is _im7c8v5q.RbacRole? ? role : this.role?.copyWith(),
      permissionId: permissionId ?? this.permissionId,
      permission: permission is _ijqyf5jf.RbacPermission?
          ? permission
          : this.permission?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
