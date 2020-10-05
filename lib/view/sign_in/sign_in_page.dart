import 'package:domainDrivenDesign/controller/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:domainDrivenDesign/injection.dart';
import 'package:domainDrivenDesign/view/sign_in/widget/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: BlocProvider(create: (context) => getIt<SignInFormBloc>(),
      child: SignInForm()),
    );
  }
}