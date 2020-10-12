import 'package:freezed_annotation/freezed_annotation.dart';
part 'failure.freezed.dart';

@freezed
abstract class NoteFailure with _$NoteFailure{
  const factory NoteFailure.unexpected() = _Unexpected;
  const factory NoteFailure.insufficientPermission() = _InsufficientPermission;
}