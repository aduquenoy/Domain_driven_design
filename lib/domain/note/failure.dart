import 'package:freezed_annotation/freezed_annotation.dart';
part 'failure.freezed.dart';

@freezed
// Union cases :
abstract class NoteFailure with _$NoteFailure{
  const factory NoteFailure.unexpected() = _Unexpected;
  const factory NoteFailure.insufficientPermission() = _InsufficientPermission;
  const factory NoteFailure.unableToUpdate() = _UnableToUpdate;
}