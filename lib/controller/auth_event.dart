part of 'auth_bloc.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  // Union cases :
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;
  const factory AuthEvent.signedOut() = SignedOut;
}