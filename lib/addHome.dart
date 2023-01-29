import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:homeeasy/login.dart';
import 'package:homeeasy/main.dart';
import 'package:homeeasy/tile.dart';

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
        Map? allHomes = data?['homes'];
        Map? requestsMap = data?['users']?["$id"]?['requests'];
        List<String> allhomelist = [];
        List<String> requests = [];

        if (requestsMap != null) {
          requestsMap.forEach((key, value) {
            if (!requests.contains(key)) {
              requests.add(value);
            }
          });
        }

        if (allHomes != null) {
          allHomes.forEach((key, value) {
            if (!allhomelist.contains(key)) {
              print(data?['homes']?[key]?['admin'] != '$email');
              if (data?['homes']?[key]?['admin'] != '$email')
                allhomelist.add(key);
            }
          });
        }
        print(allhomelist);
        List homeList = [];
        if (homes != null) {
          homes.forEach((key, value) {
            if (!homeList.contains(key)) {
              homeList.add(key);
            }
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

          drawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.brown,
                  ), //BoxDecoration
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.brown),
                    accountName: Text(
                      "$email",
                      style: TextStyle(fontSize: 18),
                    ),
                    accountEmail: Text(""),
                    currentAccountPictureSize: Size.square(50),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        "${email?[0]}",
                        style: TextStyle(fontSize: 30.0, color: Colors.blue),
                      ), //Text
                    ), //circleAvatar
                  ), //UserAccountDrawerHeader
                ), //DrawerHeader
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text(' Add New Home '),
                  onTap: () {
                    TextEditingController hidHandler = TextEditingController();

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
                                          if (!hidHandler.text.contains('.')) {
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
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Request Home'),
                  onTap: () {
                    Navigator.pop(context);
                    TextEditingController hidHandler = TextEditingController();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: SingleChildScrollView(
                              child: AlertDialog(
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (allhomelist
                                              .contains(hidHandler.text)) {
                                            final admin = data?['homes']
                                                ?[hidHandler.text]?['admin'];
                                            if (admin != null) {
                                              ref
                                                  .child(
                                                      'users/${admin.toString().replaceAll(".", "").toString()}/requests')
                                                  .update({
                                                '$id': '${email}'
                                              }).then((value) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content:
                                                            Text("Requested"),
                                                      );
                                                    });
                                              });
                                            }
                                          } else {
                                            Navigator.pop(context);

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                      "Incorrect ID or You Are The Owner.",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  );
                                                });
                                          }
                                        },
                                        child: Text("send request"))
                                  ],
                                  content: Column(
                                    children: [
                                      TextFormField(
                                        controller: hidHandler,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            hintText: "Entere Home ID"),
                                      )
                                    ],
                                  )),
                            ),
                          );
                        });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notification_add),
                  title: const Text('Check requests'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: SingleChildScrollView(
                              child: AlertDialog(
                                  content: Container(
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < requests.length;
                                        i++) ...[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Tile(
                                          title: "${requests[i]}",
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            if (homes != null) {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                              ref
                                                                  .child(
                                                                      'users/${requests[i].toString().replaceAll('.', '').toString()}/homes')
                                                                  .set(homes);
                                                            }
                                                          },
                                                          child:
                                                              Text("Approve")),
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            deleteRequest(
                                                                "${requests[i].toString().replaceAll('.', '').toString()}",
                                                                id,
                                                                context);
                                                          },
                                                          child:
                                                              Text("Decline"))
                                                    ],
                                                  );
                                                });
                                          })
                                    ]
                                  ],
                                ),
                              )),
                            ),
                          );
                        });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.change_circle),
                  title: const Text('Change password'),
                  onTap: () {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: "$email");
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              content: Text(
                                  "link has been sent to your email for password reset"));
                        });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('SignOut'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, _createRoute(login()));
                  },
                ),
              ],
            ),
          ), //Drawer

          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "List of Homes",
                    style: TextStyle(
                        fontSize: currentHeight / 50,
                        color: Colors.brown,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 3),
                  ),
                  for (int i = 0; i < homeList.length; i++) ...[
                    SizedBox(
                      height: currentHeight / 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 59, 30, 20)),
                      onPressed: () {
                        Navigator.push(
                            context, _createRoute(Home(homeid: homeList[i])));
                      },
                      child: Text("${homeList[i].toString().toUpperCase()}"),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// class homeList extends StatefulWidget {
//   const homeList({super.key});

//   @override
//   State<homeList> createState() => _homeListState();
// }

// class _homeListState extends State<homeList> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

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

deleteRequest(requestid, id, context) async {
  print(requestid);
  final ref = FirebaseDatabase.instance.ref();
  await ref.child('users/$id/requests/${requestid}/').remove().then((value) {
    Navigator.pop(context);
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Declined"),
          );
        });
  });
}
