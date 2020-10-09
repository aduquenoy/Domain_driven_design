part of 'actor_bloc.dart';

@freezed
abstract class ActorEvent with _$ActorEvent {
  const factory ActorEvent.deleted(Note note) = _Deleted;
}