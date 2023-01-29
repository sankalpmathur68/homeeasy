import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:homeeasy/addHome.dart';
import 'package:homeeasy/main.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref();
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    TextEditingController _mailController = TextEditingController();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return AddHome();
    }
    TextEditingController _passwordController = TextEditingController();
    return StreamBuilder(
        stream: ref.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> event) {
          return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Home Easy",
                  style: TextStyle(letterSpacing: currentwidth / 100),
                )),
            body: Padding(
              padding: const EdgeInsets.all(70.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login Or Sign up",
                              style: TextStyle(
                                  fontSize: currentwidth / 20,
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: currentHeight / 20,
                            ),
                            TextField(
                              controller: _mailController,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: currentwidth / 25),
                              decoration: InputDecoration(
                                hintText: "Email",
                              ),
                            ),
                            SizedBox(
                              height: currentHeight / 40,
                            ),
                            TextField(
                              controller: _passwordController,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: currentwidth / 25),
                              decoration: InputDecoration(
                                hintText: "Password",
                              ),
                            ),
                            SizedBox(
                              height: currentHeight / 40,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (_passwordController.text != "" &&
                                      _mailController.text != "") {
                                    LoginActions().checkAccount(
                                        '${_mailController.text}',
                                        '${_passwordController.text}',
                                        context);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content:
                                              Text("Fill Above information"),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: event.connectionState ==
                                        ConnectionState.waiting
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text("Next")),
                            SizedBox(
                              height: currentHeight / 40,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  TextEditingController emailHandler =
                                      TextEditingController();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                FirebaseAuth.instance
                                                    .sendPasswordResetEmail(
                                                        email:
                                                            "${emailHandler.text}");
                                                Navigator.pop(context);
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                          content: Text(
                                                              "link has been sent to your email for password reset"));
                                                    });
                                              },
                                              child: Text("Change"))
                                        ],
                                        content: TextFormField(
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Enter your Email Address."),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text("Forgot Password ?"))
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class LoginActions {
  checkAccount(String mail, String password, context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final ref = FirebaseDatabase.instance.ref();
    final id = mail.toString().replaceAll('.', '').toString().toLowerCase();
    DateTime Today = DateTime.now();
    bool accountExist = false;
    List mailids = [];
    dynamic dataInstance = await ref.child("users").get();
    dynamic dataValue = dataInstance.value;
    if (dataValue != null) {
      dataValue.forEach((key, pair) {
        mailids.add(key);
      });
    }
    if (mailids.contains(id)) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: mail,
          password: password,
        )
            .onError((error, stackTrace) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text("${(error as dynamic).message}"),
                );
              });
          return Future.delayed(Duration(milliseconds: 1));
        }).then((value) {
          Navigator.pushReplacement(context, _createRoute());
        });
      } on FirebaseAuthException catch (err) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("${(err as dynamic).message}"),
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text(
                  "No Account found with this Email Address. Do you want to create a new account ?"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            await auth
                                .createUserWithEmailAndPassword(
                                    email: mail, password: password)
                                .then((value) {
                              ref.child("users").set(<String, dynamic>{
                                "$id": {"Accountcreatedon": "${Today}"}
                              });
                              Navigator.pushReplacement(
                                  context, _createRoute());
                            });
                          } on FirebaseAuthException catch (e) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("${(e as dynamic).message}"),
                                  );
                                });
                          }
                        },
                        child: Text("Create Account"))
                  ],
                )
              ],
            );
          });
    }
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddHome(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
      ;
    },
  );
}
