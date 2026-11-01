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

abstract class RbacUserPermissionsInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RbacUserPermissionsInfo._({
    required this.userIdentifier,
    required this.isSuperuser,
    required this.roles,
    required this.permissions,
  });

  factory RbacUserPermissionsInfo({
    required String userIdentifier,
    required bool isSuperuser,
    required List<String> roles,
    required List<String> permissions,
  }) = _RbacUserPermissionsInfoImpl;

  factory RbacUserPermissionsInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RbacUserPermissionsInfo(
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      isSuperuser: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isSuperuser'],
      ),
      roles: _iqg09eor.Protocol().deserialize<List<String>>(
        jsonSerialization['roles'],
      ),
      permissions: _iqg09eor.Protocol().deserialize<List<String>>(
        jsonSerialization['permissions'],
      ),
    );
  }

  String userIdentifier;

  bool isSuperuser;

  List<String> roles;

  List<String> permissions;

  /// Returns a shallow copy of this [RbacUserPermissionsInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RbacUserPermissionsInfo copyWith({
    String? userIdentifier,
    bool? isSuperuser,
    List<String>? roles,
    List<String>? permissions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacUserPermissionsInfo',
      'userIdentifier': userIdentifier,
      'isSuperuser': isSuperuser,
      'roles': roles.toJson(),
      'permissions': permissions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacUserPermissionsInfo',
      'userIdentifier': userIdentifier,
      'isSuperuser': isSuperuser,
      'roles': roles.toJson(),
      'permissions': permissions.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RbacUserPermissionsInfoImpl extends RbacUserPermissionsInfo {
  _RbacUserPermissionsInfoImpl({
    required String userIdentifier,
    required bool isSuperuser,
    required List<String> roles,
    required List<String> permissions,
  }) : super._(
         userIdentifier: userIdentifier,
         isSuperuser: isSuperuser,
         roles: roles,
         permissions: permissions,
       );

  /// Returns a shallow copy of this [RbacUserPermissionsInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RbacUserPermissionsInfo copyWith({
    String? userIdentifier,
    bool? isSuperuser,
    List<String>? roles,
    List<String>? permissions,
  }) {
    return RbacUserPermissionsInfo(
      userIdentifier: userIdentifier ?? this.userIdentifier,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      roles: roles ?? this.roles.map((e0) => e0).toList(),
      permissions: permissions ?? this.permissions.map((e0) => e0).toList(),
    );
  }
}
