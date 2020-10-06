import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domainDrivenDesign/domain/note/note_entity.dart';
import 'package:kt_dart/collection.dart';
import 'package:domainDrivenDesign/domain/core/value_object.dart';
import 'package:domainDrivenDesign/domain/note/todo_entity.dart';
import 'package:domainDrivenDesign/domain/note/value_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dto.freezed.dart';
part 'dto.g.dart';

@freezed
abstract class NoteDto implements _$NoteDto {
  const NoteDto._();

  const factory NoteDto({
    // ID n'est pas ajouté au document .. il l'identifie juste .. on ignore
    @JsonKey(ignore: true) String id,
    @required String body,
    @required int color,
    @required List<TodoItemDto> todos,
    // Create a custom converter so that json_serializable will not crash because it only
    // accepts json standards like string int ...
    @required @ServerTimestampConverter() FieldValue serverTimeStamp,
  }) = _NoteDto;

  factory NoteDto.fromDomain(Note note) {
    return NoteDto(
      id: note.id.getOrCrash(),
      body: note.body.getOrCrash(),
      color: note.color.getOrCrash().value,
      todos: note.todos
          .getOrCrash()
          .mapIndexed(
            (index, todoItem) => TodoItemDto.fromDomain(todoItem),
          )
          .asList(),
      serverTimeStamp: FieldValue.serverTimestamp(),
    );
  }

  Note toDomain() {
    return Note(
        id: UniqueId.fromUniqueString(id),
        body: NoteBody(body),
        color: NoteColor(Color(color)),
        todos: List3(todos.map((dto) => dto.toDomain()).toImmutableList()));
  }

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  // Recuperer l'ID du document firestore pour renseigner l'ID du Note entity
  factory NoteDto.fromFirestore(DocumentSnapshot doc){
    return NoteDto.fromJson(doc.data).copyWith(id: doc.documentID);
  }
}

// On implemente la classe JsonConverter contenue dans json_serializable avec FieldValue en input et Object en output
// If u want to use a class as ANNOTATION u must turn it const
class ServerTimestampConverter implements JsonConverter<FieldValue, Object>{
  const ServerTimestampConverter();

  @override
  FieldValue fromJson(Object json){
    return FieldValue.serverTimestamp();
  }

  @override
  Object toJson(FieldValue fieldValue) => fieldValue;
}

@freezed
// DTO => Data Transfer Object
abstract class TodoItemDto implements _$TodoItemDto {
  const TodoItemDto._();

  const factory TodoItemDto({
    @required String id,
    @required String name,
    @required bool done,
  }) = _TodoItemDto;

  // Convert Entity => DTO
  factory TodoItemDto.fromDomain(TodoItem todoItem) {
    return TodoItemDto(
      id: todoItem.id.getOrCrash(),
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  // Convert DTO => ENTITY
  TodoItem toDomain() {
    return TodoItem(
      id: UniqueId.fromUniqueString(id),
      name: TodoName(name),
      done: done,
    );
  }

  factory TodoItemDto.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDtoFromJson(json);
}
