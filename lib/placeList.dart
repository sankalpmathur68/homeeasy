import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
    return StreamBuilder(
        stream: ref.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> event) {
          dynamic data = event.data?.snapshot.value;
          print(data);
          dynamic placeMap = data?['homes']?['${widget.hid}']?['places'];
          if (placeMap != null) {
            placeMap.forEach(() {});
          }
          print(placeMap);
          return Column();
        });
  }
}
