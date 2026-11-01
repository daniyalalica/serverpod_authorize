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
import 'package:serverpod/serverpod.dart' as _is;
import 'rbac_exception_reason.dart' as _ilr4m7ck;

abstract class RbacException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  RbacException._({
    required this.message,
    required this.reason,
    this.requiredPermission,
    this.requiredRole,
    this.requiredDomain,
    this.userIdentifier,
  });

  factory RbacException({
    required String message,
    required _ilr4m7ck.RbacExceptionReason reason,
    String? requiredPermission,
    String? requiredRole,
    String? requiredDomain,
    String? userIdentifier,
  }) = _RbacExceptionImpl;

  factory RbacException.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacException(
      message: jsonSerialization['message'] as String,
      reason: _ilr4m7ck.RbacExceptionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
      requiredPermission: jsonSerialization['requiredPermission'] as String?,
      requiredRole: jsonSerialization['requiredRole'] as String?,
      requiredDomain: jsonSerialization['requiredDomain'] as String?,
      userIdentifier: jsonSerialization['userIdentifier'] as String?,
    );
  }

  String message;

  _ilr4m7ck.RbacExceptionReason reason;

  String? requiredPermission;

  String? requiredRole;

  String? requiredDomain;

  String? userIdentifier;

  /// Returns a shallow copy of this [RbacException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RbacException copyWith({
    String? message,
    _ilr4m7ck.RbacExceptionReason? reason,
    String? requiredPermission,
    String? requiredRole,
    String? requiredDomain,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_rbac.RbacException',
      'message': message,
      'reason': reason.toJson(),
      if (requiredPermission != null) 'requiredPermission': requiredPermission,
      if (requiredRole != null) 'requiredRole': requiredRole,
      if (requiredDomain != null) 'requiredDomain': requiredDomain,
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_rbac.RbacException',
      'message': message,
      'reason': reason.toJson(),
      if (requiredPermission != null) 'requiredPermission': requiredPermission,
      if (requiredRole != null) 'requiredRole': requiredRole,
      if (requiredDomain != null) 'requiredDomain': requiredDomain,
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
    };
  }

  @override
  String toString() {
    return 'RbacException(message: $message, reason: $reason, requiredPermission: $requiredPermission, requiredRole: $requiredRole, requiredDomain: $requiredDomain, userIdentifier: $userIdentifier)';
  }
}

class _Undefined {}

class _RbacExceptionImpl extends RbacException {
  _RbacExceptionImpl({
    required String message,
    required _ilr4m7ck.RbacExceptionReason reason,
    String? requiredPermission,
    String? requiredRole,
    String? requiredDomain,
    String? userIdentifier,
  }) : super._(
         message: message,
         reason: reason,
         requiredPermission: requiredPermission,
         requiredRole: requiredRole,
         requiredDomain: requiredDomain,
         userIdentifier: userIdentifier,
       );

  /// Returns a shallow copy of this [RbacException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RbacException copyWith({
    String? message,
    _ilr4m7ck.RbacExceptionReason? reason,
    Object? requiredPermission = _Undefined,
    Object? requiredRole = _Undefined,
    Object? requiredDomain = _Undefined,
    Object? userIdentifier = _Undefined,
  }) {
    return RbacException(
      message: message ?? this.message,
      reason: reason ?? this.reason,
      requiredPermission: requiredPermission is String?
          ? requiredPermission
          : this.requiredPermission,
      requiredRole: requiredRole is String? ? requiredRole : this.requiredRole,
      requiredDomain: requiredDomain is String?
          ? requiredDomain
          : this.requiredDomain,
      userIdentifier: userIdentifier is String?
          ? userIdentifier
          : this.userIdentifier,
    );
  }
}
