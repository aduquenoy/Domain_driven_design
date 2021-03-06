import 'package:domainDrivenDesign/controller/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) => {
              FlushbarHelper.createError(
                message: failure.map(
                  cancelledByUser: (_) => "Canceled",
                  serverError: (_) => "Server Error",
                  emailAlreadyInUse: (_) => "Email already in use",
                  invalidEmailAndPasswordCombination: (_) =>
                      "Invalid email and password combination",
                ),
              ).show(context)
            },
            (_) {},
          ),
        );
      },
      builder: (context, state) {
        return Form(
            autovalidate: state.showErrorMessages,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                  ),
                  autocorrect: false,
                  onChanged: (value) => context
                      .bloc<SignInFormBloc>()
                      .add(SignInFormEvent.emailChanged(value)),
                  validator: (_) => context
                      .bloc<SignInFormBloc>()
                      .state
                      .emailAddress
                      .value
                      .fold(
                        (f) => f.maybeMap(
                          invalidEmail: (_) => "Invalid Email",
                          orElse: () => null,
                        ),
                        (_) => null,
                      ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                  ),
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (value) => context
                      .bloc<SignInFormBloc>()
                      .add(SignInFormEvent.passwordChanged(value)),
                  validator: (_) =>
                      context.bloc<SignInFormBloc>().state.password.value.fold(
                            (f) => f.maybeMap(
                              invalidEmail: (_) => "Invalid Email",
                              orElse: () => null,
                            ),
                            (_) => null,
                          ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          context.bloc<SignInFormBloc>().add(
                              const SignInFormEvent
                                  .signinWithEmailAndPasswordPressed());
                        },
                        child: const Text("SIGN IN"),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          context.bloc<SignInFormBloc>().add(
                              const SignInFormEvent
                                  .registerWithEmailAndPasswordPressed());
                        },
                        child: const Text("REGISTER"),
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    context
                        .bloc<SignInFormBloc>()
                        .add(const SignInFormEvent.signinWithGooglePressed());
                  },
                  color: Colors.lightBlue,
                  child: const Text(
                    "SIGN IN WITH GOOGLE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (state.isSubmitting) ...[
                  const SizedBox(height: 10),
                  const LinearProgressIndicator(),
                ]
              ],
            ));
      },
    );
  }
}
