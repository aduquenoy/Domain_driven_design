import 'package:freezed_annotation/freezed_annotation.dart';
part 'failure.freezed.dart';

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEmail({
    @required T failedValue,
    // Informer l'utilisateur de la longueur max de la note
    int max,
  }) = InvalidEmail<T>;
  // Notes valuefailure
  const factory ValueFailure.empty({
    @required T failedValue,
  }) = Empty<T>;

  const factory ValueFailure.multiline({
    @required T failedValue,
  }) = Multiline<T>;

  const factory ValueFailure.listTooLong({
    @required T failedValue,
    int max,
  }) = ListTooLong<T>;

  const factory ValueFailure.shortPassword({
    @required T failedValue,
  }) = ShortPassword<T>;

  const factory ValueFailure.exceedingLength({
    @required T failedValue,
    int max,
  }) = ExceedingLength<T>;
}
