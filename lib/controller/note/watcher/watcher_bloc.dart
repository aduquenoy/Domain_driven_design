import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:domainDrivenDesign/domain/note/failure.dart';
import 'package:domainDrivenDesign/domain/note/interface.dart';
import 'package:domainDrivenDesign/domain/note/note_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

part 'watcher_event.dart';
part 'watcher_state.dart';
part 'watcher_bloc.freezed.dart';

@injectable
// Use get_it tu get new instances of the BLOC or inject other instances of other classes to the BLOC
class WatcherBloc extends Bloc<WatcherEvent, WatcherState> {
  final INoteRepository _noteRepository;

  WatcherBloc(this._noteRepository);

  // It will cancel listening from previous stream
  StreamSubscription<Either<NoteFailure, KtList<Note>>> _noteStreamSubscription;

  @override
  WatcherState get initialState => const WatcherState.initial();

  @override
  Stream<WatcherState> mapEventToState(
    WatcherEvent event,
  ) async* {
    yield* event.map(
      // This is an infinite yield loop it won't allow to switch from watchall to watch uncompleted
      watchAllStarted: (e) async* {
        yield const WatcherState.loadingProgress();
        await _noteStreamSubscription?.cancel();
        /*
        yield* _noteRepository.watchAll().map(
              (failureOrNotes) => failureOrNotes.fold(
                (f) => WatcherState.loadFailure(f),
                (notes) => $WatcherState.loadSuccess(notes),
              ),
            );
        */
        _noteStreamSubscription = _noteRepository.watchAll().listen((failureOrNotes) =>
            add(WatcherEvent.notesReceived(failureOrNotes)));
      },
      watchUncompletedStarted: (e) async* {
        yield const WatcherState.loadingProgress();
        await _noteStreamSubscription?.cancel();
        _noteStreamSubscription = _noteRepository.watchUncompleted().listen((failureOrNotes) =>
            add(WatcherEvent.notesReceived(failureOrNotes)));
      },
      notesReceived: (e) async* {
        yield e.failureOrNotes.fold(
          (f) => WatcherState.loadFailure(f),
          (notes) => $WatcherState.loadSuccess(notes),
        );
      },
    );
  }

  @override
  Future<void> close() async{
    await _noteStreamSubscription.cancel();
    return super.close();
  }
}
