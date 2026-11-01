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

abstract class RbacAbacResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RbacAbacResult._({
    required this.userIdentifier,
    this.permission,
    this.roleName,
    this.resource,
    required this.isAllowed,
    required this.hasDomains,
    required this.filterExpressions,
    required this.isUnrestricted,
  });

  factory RbacAbacResult({
    required String userIdentifier,
    String? permission,
    String? roleName,
    String? resource,
    required bool isAllowed,
    required bool hasDomains,
    required List<String> filterExpressions,
    required bool isUnrestricted,
  }) = _RbacAbacResultImpl;

  factory RbacAbacResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacAbacResult(
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      permission: jsonSerialization['permission'] as String?,
      roleName: jsonSerialization['roleName'] as String?,
      resource: jsonSerialization['resource'] as String?,
      isAllowed: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isAllowed'],
      ),
      hasDomains: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['hasDomains'],
      ),
      filterExpressions: _iqg09eor.Protocol().deserialize<List<String>>(
        jsonSerialization['filterExpressions'],
      ),
      isUnrestricted: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isUnrestricted'],
      ),
    );
  }

  String userIdentifier;

  String? permission;

  String? roleName;

  String? resource;

  bool isAllowed;

  bool hasDomains;

  List<String> filterExpressions;

  bool isUnrestricted;

  /// Returns a shallow copy of this [RbacAbacResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RbacAbacResult copyWith({
    String? userIdentifier,
    String? permission,
    String? roleName,
    String? resource,
    bool? isAllowed,
    bool? hasDomains,
    List<String>? filterExpressions,
    bool? isUnrestricted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacAbacResult',
      'userIdentifier': userIdentifier,
      if (permission != null) 'permission': permission,
      if (roleName != null) 'roleName': roleName,
      if (resource != null) 'resource': resource,
      'isAllowed': isAllowed,
      'hasDomains': hasDomains,
      'filterExpressions': filterExpressions.toJson(),
      'isUnrestricted': isUnrestricted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacAbacResult',
      'userIdentifier': userIdentifier,
      if (permission != null) 'permission': permission,
      if (roleName != null) 'roleName': roleName,
      if (resource != null) 'resource': resource,
      'isAllowed': isAllowed,
      'hasDomains': hasDomains,
      'filterExpressions': filterExpressions.toJson(),
      'isUnrestricted': isUnrestricted,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RbacAbacResultImpl extends RbacAbacResult {
  _RbacAbacResultImpl({
    required String userIdentifier,
    String? permission,
    String? roleName,
    String? resource,
    required bool isAllowed,
    required bool hasDomains,
    required List<String> filterExpressions,
    required bool isUnrestricted,
  }) : super._(
         userIdentifier: userIdentifier,
         permission: permission,
         roleName: roleName,
         resource: resource,
         isAllowed: isAllowed,
         hasDomains: hasDomains,
         filterExpressions: filterExpressions,
         isUnrestricted: isUnrestricted,
       );

  /// Returns a shallow copy of this [RbacAbacResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RbacAbacResult copyWith({
    String? userIdentifier,
    Object? permission = _Undefined,
    Object? roleName = _Undefined,
    Object? resource = _Undefined,
    bool? isAllowed,
    bool? hasDomains,
    List<String>? filterExpressions,
    bool? isUnrestricted,
  }) {
    return RbacAbacResult(
      userIdentifier: userIdentifier ?? this.userIdentifier,
      permission: permission is String? ? permission : this.permission,
      roleName: roleName is String? ? roleName : this.roleName,
      resource: resource is String? ? resource : this.resource,
      isAllowed: isAllowed ?? this.isAllowed,
      hasDomains: hasDomains ?? this.hasDomains,
      filterExpressions:
          filterExpressions ?? this.filterExpressions.map((e0) => e0).toList(),
      isUnrestricted: isUnrestricted ?? this.isUnrestricted,
    );
  }
}
