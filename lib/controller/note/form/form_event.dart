part of 'form_bloc.dart';

@freezed
abstract class FormEvent with _$FormEvent {
  const factory FormEvent.initialized(Option<Note> initialNoteOption) = _Initialized;
  const factory FormEvent.bodyChanged(String bodyStr) = _BodyChanged;
  const factory FormEvent.colorChanged(Color color) = _ColorChanged;
  const factory FormEvent.todosChanged(KtList<TodoItemPrimitive> todos) = _TodosChanged;
  const factory FormEvent.saved() = _Saved;
}