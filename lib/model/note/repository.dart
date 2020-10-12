import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domainDrivenDesign/domain/note/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:domainDrivenDesign/domain/note/interface.dart';
import 'package:domainDrivenDesign/model/note/dto.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:domainDrivenDesign/domain/note/note_entity.dart';
import 'package:domainDrivenDesign/model/core/firestore_helper.dart';
import 'package:kt_dart/collection.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final Firestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    // users  collection : users/{user ID}/notes/{note ID}
    final userDoc = await _firestore.userDocument();
    userDoc.noteCollection
        .orderBy("serverTimeStamp", descending: true)
        .snapshots()
        .map(
          (snapshot) => right<NoteFailure, KtList<Note>>(
            snapshot.documents
                .map((doc) => NoteDto.fromFirestore(doc).toDomain())
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith(
      (e) {
        if (e is PlatformException && e.message.contains("PERMISSION_DENIED")) {
          return left(const NoteFailure.insufficientPermission());
        } else {
          // log.error(e.toString()); in debg mode
          return left(const NoteFailure.unexpected());
        }
      },
    );
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    userDoc.noteCollection
        .orderBy("serverTimeStamp", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.documents
              .map((doc) => NoteDto.fromFirestore(doc).toDomain()),
        )
        .map((notes) => right<NoteFailure, KtList<Note>>(
              notes
                  .where((note) =>
                      note.todos.getOrCrash().any((todoItem) => !todoItem.done))
                  .toImmutableList(),
            ))
        .onErrorReturnWith(
      (e) {
        if (e is PlatformException && e.message.contains("PERMISSION_DENIED")) {
          return left(const NoteFailure.insufficientPermission());
        } else {
          // log.error(e.toString()); in debg mode
          return left(const NoteFailure.unexpected());
        }
      },
    );
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);

      // userDoc.noteCollection.add() => not that because firestore will generate an autoid but we already have an id from note entity
      await userDoc.noteCollection
          .document(noteDto.id)
          .setData(noteDto.toJson());

      return right(unit);
    } on PlatformException catch (e) {
      // Converting exceptions from firestore to failures
      if (e.message.contains("PERMISSION_DENIED")) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);

      await userDoc.noteCollection
          .document(noteDto.id)
          .updateData(noteDto.toJson());

      return right(unit);
    } on PlatformException catch (e) {
      if (e.message.contains("PERMISSION_DENIED")) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message.contains("NOT_FOUND")) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();

      await userDoc.noteCollection
          .document(noteId).delete();

      return right(unit);
    } on PlatformException catch (e) {
      if (e.message.contains("PERMISSION_DENIED")) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message.contains("NOT_FOUND")) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}
