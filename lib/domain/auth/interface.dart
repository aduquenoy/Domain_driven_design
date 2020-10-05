import 'package:dartz/dartz.dart';
import 'package:domainDrivenDesign/domain/auth/failure.dart';
import 'package:domainDrivenDesign/domain/auth/auth_entity.dart';
import 'package:domainDrivenDesign/domain/auth/value_object.dart';
import 'package:meta/meta.dart';

abstract class IAuthFacade {
  //Unit is a class and not just a keyword as Void and can thus be used in Either union. It will return either a failure or nothing(like Void)
  
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });

  Future<Either<AuthFailure, Unit>> signinWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });

  Future<Either<AuthFailure, Unit>> signinWithGoogle();

  Future<Option<User>> getSignedInUser();

  Future<void> signOut();
}
