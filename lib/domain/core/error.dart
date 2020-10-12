import 'package:domainDrivenDesign/domain/core/failure.dart';

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() => Error.safeToString("Encountered a ValueFailure at an unrecoverable point. Terminating. Falire was : $valueFailure");
}

class NotAuthenticatedError extends Error{}