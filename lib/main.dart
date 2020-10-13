import 'package:auto_route/auto_route.dart';
import 'package:domainDrivenDesign/controller/auth/session/auth_bloc.dart';
import 'package:domainDrivenDesign/injection.dart';
import 'package:domainDrivenDesign/view/route/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider(create: (context) => AuthBloc()) impossible car on a besoin de passer les arguments de IAuthFacade dans le constructeur de AuthBloc .. on va plutot utiliser get_it
        BlocProvider(create: (context) => getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested())),
      ],
      child: MaterialApp(
        title: "Notes",
        //home: SignInPage(), .. on va plutot utiliser Autorouter :
        builder: ExtendedNavigator(router: Router()),
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.green[800],
          accentColor: Colors.blueAccent,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    ),
  );
}
