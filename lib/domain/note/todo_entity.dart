import 'package:dartz/dartz.dart';
import 'package:domainDrivenDesign/domain/core/failure.dart';
import 'package:domainDrivenDesign/domain/core/value_object.dart';
import 'package:domainDrivenDesign/domain/note/value_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'todo_entity.freezed.dart';

@freezed
abstract class TodoItem implements _$TodoItem {
    // Lorsqu'on souhaite etendre la freezed data/union class avec des fonctions étendues il faut remplacer le mixin avec extend et creer un private constructor
  // remplacer "abstract class TodoItem with _$TodoItem" par "abstract class TodoItem implements _$TodoItem {"
  const TodoItem._();
  
  const factory TodoItem({
    @required UniqueId id,
    @required TodoName name,
    @required bool done,
  }) = _TodoItem;

  // instanciate a new TodoItem
  factory TodoItem.empty() => TodoItem(
        id: UniqueId(),
        name: TodoName(""),
        done: false,
      );

  // getter
  Option<ValueFailure<dynamic>> get failureOption{
    return name.value.fold((f) => some(f), (_) => none());
  }
}
