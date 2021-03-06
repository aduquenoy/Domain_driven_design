import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domainDrivenDesign/domain/core/error.dart';
import 'package:uuid/uuid.dart';
import 'failure.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  bool isValid() => value.isRight();
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit{return value.fold((l) => left(l), (r) => right(unit));}

  /// Throws [UnexpectedValueError] containing [ValueFailure]
  T getOrCrash() {
    // (r) => r OR id (identity .. same as writing (right) => right)
    return value.fold((f) => throw UnexpectedValueError(f), (r) => r);
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ValueObject<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}

class UniqueId extends ValueObject<String>{
  @override
  final Either<ValueFailure<String>, String> value;

  // String input
  factory UniqueId(){
    return UniqueId._(
      right(Uuid().v1()),
    );
  }

  factory UniqueId.fromUniqueString(String uniqueId){
    assert(uniqueId != null);
    return UniqueId._(
      right(uniqueId),
    );
  }

  const UniqueId._(this.value);
}
