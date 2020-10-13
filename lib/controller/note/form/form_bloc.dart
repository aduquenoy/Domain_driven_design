import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:domainDrivenDesign/domain/note/failure.dart';
import 'package:domainDrivenDesign/domain/note/interface.dart';
import 'package:domainDrivenDesign/domain/note/note_entity.dart';
import 'package:domainDrivenDesign/domain/note/value_object.dart';
import 'package:domainDrivenDesign/view/note/form/misc/todo_primitive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'form_event.dart';
part 'form_state.dart';
part 'form_bloc.freezed.dart';

@injectable
class FormBloc extends Bloc<FormEvent, FormState> {
  final INoteRepository _noteRepository;

  FormBloc(this._noteRepository);

  @override
  FormState get initialState => FormState.initial();

  @override
  // Event handlers :
  Stream<FormState> mapEventToState(
    FormEvent event,
  ) async* {
    yield* event.map(
      initialized: (e) async* {
        yield e.initialNoteOption.fold(
            () => state,
            (initialNote) => state.copyWith(
                  note: initialNote,
                  isEditing: true,
                ));
      },
      bodyChanged: (e) async* {
        yield state.copyWith(
          note: state.note.copyWith(body: NoteBody(e.bodyStr)),
          saveFailureOrSuccessOption: none(),
        );
      },
      colorChanged: (e) async* {
        yield state.copyWith(
          note: state.note.copyWith(color: NoteColor(e.color)),
          saveFailureOrSuccessOption: none(),
        );
      },
      todosChanged: (e) async* {
        yield state.copyWith(
          // map to turn primitives into entities
          note: state.note.copyWith(
              todos: List3(e.todos.map((primitive) => primitive.toDomain()))),
          saveFailureOrSuccessOption: none(),
        );
      },
      saved: (e) async* {
        Either<NoteFailure, Unit> failureOrSuccess;

        yield state.copyWith(
          isSaving: true,
          saveFailureOrSuccessOption: none(),
        );
        // if there is no failure
        if (state.note.failureOption.isNone()) {
          state.isEditing
              ? await _noteRepository.update(state.note)
              : await _noteRepository.update(state.note);
        }

        yield state.copyWith(
          isSaving: false,
          showErrorMessages: true,
          saveFailureOrSuccessOption: optionOf(failureOrSuccess),
        );
      },
    );
  }
}
