part of 'actor_bloc.dart';

@freezed
abstract class ActorState with _$ActorState {
  const factory ActorState.initial() = _Initial;
  const factory ActorState.actionInProgress() = _ActionInProgress;
  const factory ActorState.deleteFailure(NoteFailure noteFailure) = _DeleteFailure;
  const factory ActorState.deleteSuccess() = _DeleteSuccess;
}
