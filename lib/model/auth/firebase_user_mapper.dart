import 'package:domainDrivenDesign/domain/auth/auth_entity.dart';
import 'package:domainDrivenDesign/domain/core/value_object.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseUserDomainX on FirebaseUser{
  User toDomain(){
    return User(id: UniqueId.fromUniqueString(uid));
  }
}