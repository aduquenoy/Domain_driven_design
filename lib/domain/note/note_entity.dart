import 'package:dartz/dartz.dart';
import 'package:domainDrivenDesign/domain/core/failure.dart';
import 'package:domainDrivenDesign/domain/core/value_object.dart';
import 'package:domainDrivenDesign/domain/note/todo_entity.dart';
import 'package:domainDrivenDesign/domain/note/value_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
part 'note_entity.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();

  const factory Note({
    @required UniqueId id,
    @required NoteBody body,
    @required NoteColor color,
    @required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(""),
        color: NoteColor(NoteColor.predefinedColors[0]),
        // Emulation de la Kotlin list
        todos: List3(emptyList()),
      );

  /* we get the Ktlist of the Todos items And then we extract the failure option from
  each and every to-do item .. next up we get only the actual failed to do items from this
  list or we at least try to get only the failed todo items from the list and then we basically
  check are there any failed to do items inside the list .. if there are we return left with the value
  failure .. if there are none failed todo items present we return right unit which signifies that
  everything is valid then lastly from this whole chain of short-circuiting validation calls with
  and then that's called it like that. We return some if there is a failure Or we return
  none if there is no failure and just like that. We have the ability to validate all of the
  object held inside an empty at once. */

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(color.failureOrUnit)
        .andThen(todos.failureOrUnit)
        .andThen(
          todos
              .getOrCrash()
              .map((todoItem) => todoItem.failureOption)
              .filter((o) => o.isSome())
              .getOrElse(0, (_) => none())
              .fold(() => right(unit), (f) => left(f)),
        )
        .fold((f) => some(f), (_) => none());
  }
}