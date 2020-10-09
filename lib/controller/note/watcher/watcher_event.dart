part of 'watcher_bloc.dart';

@freezed
abstract class WatcherEvent with _$WatcherEvent {
  const factory WatcherEvent.watchAllStarted() = _WatchAllStarted;
  const factory WatcherEvent.watchUncompletedStarted() = _WatchUncompletedStarted;
  // will allow us to switch from allnotes to uncompleted notes
  const factory WatcherEvent.notesReceived(Either<NoteFailure, KtList<Note>> failureOrNotes) = _NotesReceived;
}