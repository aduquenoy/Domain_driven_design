import 'package:domainDrivenDesign/domain/core/value_object.dart';
import 'package:domainDrivenDesign/domain/note/todo_entity.dart';
import 'package:domainDrivenDesign/domain/note/value_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_primitive.freezed.dart';

@freezed
// IMPLEMENTS and not WITH so that we can add custom methods
abstract class TodoItemPrimitive implements _$TodoItemPrimitive {
  const TodoItemPrimitive._();

  const factory TodoItemPrimitive({
    @required UniqueId id,
    @required String name,
    @required bool done,
  }) = _TodoItemPrimitive;

  factory TodoItemPrimitive.empty() => TodoItemPrimitive(
        id: UniqueId(),
        name: "",
        done: false,
      );

  // Convert Entity => DTO
  factory TodoItemPrimitive.fromDomain(TodoItem todoItem) {
    return TodoItemPrimitive(
      id: todoItem.id,
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  // Convert DTO => ENTITY
  TodoItem toDomain() {
    return TodoItem(
      id: id,
      name: TodoName(name),
      done: done,
    );
  }
}
