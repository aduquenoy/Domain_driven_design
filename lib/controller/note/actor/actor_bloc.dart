import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domainDrivenDesign/domain/note/failure.dart';
import 'package:domainDrivenDesign/domain/note/interface.dart';
import 'package:domainDrivenDesign/domain/note/note_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'actor_event.dart';
part 'actor_state.dart';
part 'actor_bloc.freezed.dart';

@injectable
class ActorBloc extends Bloc<ActorEvent, ActorState> {
  final INoteRepository _noteRepository;

  ActorBloc(this._noteRepository);

  @override
  ActorState get initialState => const ActorState.initial();

  @override
  Stream<ActorState> mapEventToState(
    ActorEvent event,
  ) async* {
    // As there only one event (delete) we do not need to map events .. no more a union
    yield const ActorState.actionInProgress();
    final possibleFailure = await _noteRepository.delete(event.note);
    yield possibleFailure.fold((f) => ActorState.deleteFailure(f), (_) => const ActorState.deleteSuccess());
  }
}
