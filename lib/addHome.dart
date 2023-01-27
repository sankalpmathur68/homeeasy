import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:homeeasy/login.dart';
import 'package:homeeasy/main.dart';

class AddHome extends StatefulWidget {
  const AddHome({super.key});

  @override
  State<AddHome> createState() => AddHomeState();
}

class AddHomeState extends State<AddHome> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final email = FirebaseAuth.instance.currentUser?.email;
    final id = FirebaseAuth.instance.currentUser?.email
        .toString()
        .replaceAll('.', '')
        .toString()
        .toLowerCase();
    final ref = FirebaseDatabase.instance.ref();
    return StreamBuilder(
      stream: ref.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> event) {
        dynamic data = event.data?.snapshot.value;
        dynamic homes = data?['users']?[id]?['homes'];
        DateTime Today = DateTime.now();

        List homeList = [];
        if (homes != null) {
          homes.forEach((key, value) {
            homeList.add(key);
          });
        }
        final currentHeight = MediaQuery.of(context).size.height;
        final currentwidth = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Home Easy",
                style: TextStyle(letterSpacing: currentwidth / 100),
              )),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < homeList.length; i++) ...[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context, _createRoute(Home(homeid: homeList[i])));
                    },
                    child: Text("${homeList[i]}"),
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      ref
                                          .child(
                                              'users/$id/homes/${homeList[i]}')
                                          .remove();
                                      ref
                                          .child('homes/${homeList[i]}')
                                          .remove();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Yes")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("no"))
                              ],
                            );
                          });
                    },
                  )
                ],
                ElevatedButton(
                    onPressed: () async {
                      TextEditingController hidHandler =
                          TextEditingController();

                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  title: Text("Give your Home A new ID"),
                                  content: Column(
                                    children: [
                                      TextField(
                                        controller: hidHandler,
                                      ),
                                      Text(
                                        "Do not use ' . '",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: currentwidth / 25),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            if (!hidHandler.text
                                                .contains('.')) {
                                              Map allhomeMap =
                                                  data['homes'] != null
                                                      ? data['homes']
                                                      : {};
                                              List allhomelist = [];
                                              allhomeMap != null
                                                  ? allhomeMap
                                                      .forEach((key, value) {
                                                      allhomelist.add(key);
                                                    })
                                                  : null;

                                              if (!allhomelist
                                                  .contains(hidHandler.text)) {
                                                ref
                                                    .child(
                                                        'users/$id/homes/${hidHandler.text}')
                                                    .set("${Today}");

                                                ref
                                                    .child(
                                                        'homes/${hidHandler.text}')
                                                    .set({
                                                  "createdon": "${Today}",
                                                  "admin": "$email"
                                                });
                                                Navigator.pop(context);
                                              } else {
                                                Navigator.pop(context);
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "ID Already Exist!!"),
                                                        content: Text(
                                                            "Choose A Unique ID."),
                                                      );
                                                    });
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                          "ID contains ' . '"),
                                                    );
                                                  });
                                            }
                                          },
                                          child: Text("Next"))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Text("Add New Home")),
                SizedBox(
                  height: currentHeight / 12000,
                ),
                ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(context, _createRoute(login()));
                    },
                    child: Text("Signout"))
              ],
            ),
          ),
        );
      },
    );
  }
}

class homeList extends StatefulWidget {
  const homeList({super.key});

  @override
  State<homeList> createState() => _homeListState();
}

class _homeListState extends State<homeList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Route _createRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
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
