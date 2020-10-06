import 'package:dartz/dartz.dart';
import 'package:domainDrivenDesign/domain/note/failure.dart';
import 'package:domainDrivenDesign/domain/note/note_entity.dart';
import 'package:kt_dart/kt.dart';

// Abstract class only holds definitions & not implementations that will be done later
abstract class INoteRepository{
  // watch notes
  // KtList => immutable List
  // We need a valuefailure that tells us what went wrong in the backend
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();
  // watch uncompleted notes
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();
  // CUD (Read are the 2 above definitions)
  Future<Either<NoteFailure, Unit>> create(Note note);
  Future<Either<NoteFailure, Unit>> update(Note note);
  Future<Either<NoteFailure, Unit>> delete(Note note);
}