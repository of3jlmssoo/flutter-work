import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'constants.dart';
import 'firebase_options.dart';
import 'firebase_providers.dart';

final log = Logger('FB-loginLogger');

Future<bool> firebaseLoginController(BuildContext context) async {
  var result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const FirebaseLogin()),
  );
  if (!context.mounted) {
    log.info('firebaseLoginController not mounted');
    return false;
  }

  if (result.runtimeType == UserCredential) {
    log.info('firebaseLoginController NOT null ${result.runtimeType}');
    return true;
  }
  log.info('firebaseLoginController null');
  return false;
}

class FirebaseLogin extends ConsumerStatefulWidget {
  const FirebaseLogin({super.key});

  @override
  ConsumerState<FirebaseLogin> createState() => _FirebaseLoginState();
}

class _FirebaseLoginState extends ConsumerState<FirebaseLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    final userinstance = ref.watch(firebaseAuthProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase login')),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                        height: 200.0,
                        child: Image.asset('assets/images/dash.png')),
                  ),
                ),
                const SizedBox(height: 48.0),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  onSaved: (value) {
                    email = value!;
                    log.info('email : $email');
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email.'),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onSaved: (value) {
                    //Do something with the user input.
                    password = value!;
                    log.info('password : $password');
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password.'),
                  // hintText: 'Enter your password.',
                ),
                const SizedBox(height: 24.0),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  title: 'Log in',
                  onpressed: () async {
                    log.info('login button pressed');
                    _formKey.currentState?.save();
                    if (_formKey.currentState!.validate()) {
                      log.info('Firebase.initializeApp()');
                      await Firebase.initializeApp(
                        options: DefaultFirebaseOptions.currentPlatform,
                      );
                      log.info('Firabase initializeApped');
                      late UserCredential userCredential;
                      try {
                        log.info('before signin : $userinstance');
                        userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: password);
                        log.info('after  signin : $userinstance');
                        log.info('FirebaseAuth..signInWithEmail authed!');
                        showSpinner = false;
                        if (!context.mounted) {
                          return;
                        } else {
                          Navigator.pop(context, userCredential);
                          setState(
                            () {
                              showSpinner = false;
                            },
                          );
                        }
                      } catch (e) {
                        showSpinner = false;
                        log.info('signInWithEmailAndPassword error --- $e');
                        if (!context.mounted) {
                          return;
                        } else {
                          Navigator.pop(context, null);
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {super.key,
      required this.color,
      required this.title,
      required this.onpressed});

  final Color color;
  final String title;

  // String screen_id;
  final Function() onpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color, // Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(32.0),
        child: MaterialButton(
          onPressed: onpressed,
          //     () {
          //   Navigator.pushNamed(context, screen_id);
          // },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title, // 'Log In',
          ),
        ),
      ),
    );
  }
}
