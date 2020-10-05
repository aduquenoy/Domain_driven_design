import 'package:domainDrivenDesign/domain/core/value_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_entity.freezed.dart';

// ENTITY and not VALUE OBJECT
// Firestore unique ID .. create User type

@freezed
abstract class User with _$User{
  const factory User({
    @required UniqueId id,
  }) = _User;
}