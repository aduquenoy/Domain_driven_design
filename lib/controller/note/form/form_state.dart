part of 'form_bloc.dart';

@freezed
abstract class FormState with _$FormState {
  const factory FormState({
    @required Note note,
    @required bool showErrorMessages,
    // To diferentiate between CREATE and EDIT
    @required bool isEditing,
    @required bool isSaving,
    @required Option<Either<NoteFailure, Unit>> saveFailureOrSuccessOption,
  }) = _FormState;

  factory FormState.initial() => _FormState(
        isEditing: false,
        note: Note.empty(),
        isSaving: false,
        saveFailureOrSuccessOption: none(),
        showErrorMessages: false,
      );
}
