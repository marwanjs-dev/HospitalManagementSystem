import 'package:flutter/material.dart';

import '../../../Constants/routes.dart';
import '../../../Services/auth/auth_exceptions.dart';
import '../../../Services/auth/auth_service.dart';
import '../../../components/already_have_an_account_acheck.dart';
import 'package:hospitalmanagementsystem/Constants/texts.dart';
import '../../../utilities/show_error_dialog.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController _email;
  //late means that the variable will have a value later in the code but for now it is null
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _password,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                final password = _password.text;
                final email = _email.text;
                await AuthService.firebase().initialize();
                try {
                  final userCredentials = await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  // devtoools.log(userCredentials.toString());
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        VerifyEmailRoute, (route) => false);
                  }
                } on UserNotFoundAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "User not found",
                  );
                } on WrongPasswordAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "invalid password",
                  );
                } on GenericAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "Authentication Error",
                  );
                }
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
