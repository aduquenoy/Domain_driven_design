// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:domainDrivenDesign/model/core/firebase_injectable_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:domainDrivenDesign/model/auth/interface.dart';
import 'package:domainDrivenDesign/domain/auth/interface.dart';
import 'package:domainDrivenDesign/model/note/repository.dart';
import 'package:domainDrivenDesign/domain/note/interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domainDrivenDesign/controller/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:domainDrivenDesign/controller/note/watcher/watcher_bloc.dart';
import 'package:domainDrivenDesign/controller/note/actor/actor_bloc.dart';
import 'package:domainDrivenDesign/controller/auth/auth_bloc.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  g.registerLazySingleton<FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth);
  g.registerLazySingleton<GoogleSignIn>(
      () => firebaseInjectableModule.googleSignIn);
  g.registerLazySingleton<IAuthFacade>(
      () => FirebaseAuthFacade(g<FirebaseAuth>(), g<GoogleSignIn>()));
  g.registerLazySingleton<INoteRepository>(
      () => NoteRepository(g<Firestore>()));
  g.registerFactory<SignInFormBloc>(() => SignInFormBloc(g<IAuthFacade>()));
  g.registerFactory<WatcherBloc>(() => WatcherBloc(g<INoteRepository>()));
  g.registerFactory<ActorBloc>(() => ActorBloc(g<INoteRepository>()));
  g.registerFactory<AuthBloc>(() => AuthBloc(g<IAuthFacade>()));
}

class _$FirebaseInjectableModule extends FirebaseInjectableModule {}
