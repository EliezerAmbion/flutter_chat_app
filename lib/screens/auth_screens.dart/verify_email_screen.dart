import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/helper_widgets.dart';
import 'package:flutter_chat_app/main.dart';
import '../home_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? checkEmailtimer;
  int resendEmailTimer = 30;

  @override
  void initState() {
    super.initState();

    // user needs to be created first
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      // this checkEmailtimer is used to check if the user has already clicked
      // the verification link
      checkEmailtimer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      // sendEmailVerification is a Firebase method.
      // you can only use this if the user is created first.
      // same with .emailVerified.
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: resendEmailTimer));
      setState(() => canResendEmail = true);
    } on FirebaseAuthException catch (error) {
      HelperWidget.showSnackBar(
        context: context,
        message: error.message.toString(),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      print('error ==========> ${error}');
    }
  }

  Future checkEmailVerified() async {
    // check first the new status
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    // if the user is verified, cancel the timer so that
    // this method (checkEmailVerified) will not run anymore.
    if (isEmailVerified) {
      checkEmailtimer?.cancel();
    }
  }

  @override
  void dispose() {
    checkEmailtimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomeScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Verify Email',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'A Verification Email has been sent to your email',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      // if the user wants to resend the email verification
                      // use the sendVerificationEmail again.
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      icon: const Icon(Icons.email_outlined),
                      label: Text(
                        'Resend Email',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
