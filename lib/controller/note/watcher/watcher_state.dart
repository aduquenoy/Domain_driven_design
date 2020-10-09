part of 'watcher_bloc.dart';

@freezed
abstract class WatcherState with _$WatcherState {
  const factory WatcherState.initial() = _Initial;
  const factory WatcherState.loadingProgress() = _LoadingProgress;
  const factory WatcherState.loadSuccess(KtList<Note> notes) = _LoadSuccess;
  const factory WatcherState.loadFailure(NoteFailure noteFailure) = _LoadFailure;
}
