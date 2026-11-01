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
import 'rbac_role_permission.dart' as _is7enq59;
import 'rbac_user_role.dart' as _ig5ad0pf;

abstract class RbacRole
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isSuperuser']),
      isSystemRole: jsonSerialization['isSystemRole'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isSystemRole']),
      permissions: jsonSerialization['permissions'] == null
          ? null
          : _iqg09eor.Protocol()
                .deserialize<List<_is7enq59.RbacRolePermission>>(
                  jsonSerialization['permissions'],
                ),
      userRoles: jsonSerialization['userRoles'] == null
          ? null
          : _iqg09eor.Protocol().deserialize<List<_ig5ad0pf.RbacUserRole>>(
              jsonSerialization['userRoles'],
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

  String name;

  String? description;

  bool isSuperuser;

  bool isSystemRole;

  List<_is7enq59.RbacRolePermission>? permissions;

  List<_ig5ad0pf.RbacUserRole>? userRoles;

  DateTime createdAt;

  /// Returns a shallow copy of this [RbacRole]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
