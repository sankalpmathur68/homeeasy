import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:homeeasy/objectlist.dart';

class placeList extends StatefulWidget {
  placeList({required this.hid});
  String hid;
  @override
  State<placeList> createState() => placeListState();
}

class placeListState extends State<placeList> {
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref();
    List placesList = [];
    return StreamBuilder(
        stream: ref.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> event) {
          dynamic data = event.data?.snapshot.value;

          dynamic placeMap = data?['homes']?['${widget.hid}']?['places'];
          if (placeMap != null) {
            placeMap.forEach((key, value) {
              if (!placesList.contains(key)) {
                placesList.add(key);
              }
            });
          }
          print(placesList);
          return Center(
            child: Column(
              children: [
                for (int i = 0; i < placesList.length; i++) ...[
                  ElevatedButton(
                      onPressed: () {
                        print(placesList[i]);
                        Navigator.push(
                            context,
                            _createRoute(objectList(
                                hid: widget.hid, placeName: placesList[i])));
                      },
                      child: ListTile(
                        leading: Text("${i + 1}"),
                        dense: true,
                        textColor: Colors.white,
                        title: Text(
                          "${placesList[i].toString().toUpperCase()}",
                          style: TextStyle(fontSize: 20),
                        ),
                        tileColor: Colors.brown,
                      ))
                ]
              ],
            ),
          );
        });
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
