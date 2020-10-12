import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domainDrivenDesign/domain/auth/interface.dart';
import 'package:domainDrivenDesign/domain/core/error.dart';
import 'package:domainDrivenDesign/injection.dart';

extension FirestoreX on Firestore{
  Future<DocumentReference> userDocument() async{
    final userOption = await getIt<IAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return Firestore.instance.collection("users").document(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference{
  CollectionReference get noteCollection => collection("notes");
}