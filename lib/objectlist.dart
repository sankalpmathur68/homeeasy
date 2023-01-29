import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:homeeasy/tile.dart';

class objectList extends StatefulWidget {
  const objectList({required this.hid, required this.placeName});
  final hid;
  final placeName;
  @override
  State<objectList> createState() => _objectListState();
}

class _objectListState extends State<objectList> {
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref();
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: ref.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> event) {
          dynamic data = event.data?.snapshot.value;
          dynamic objectMap = data?['homes']?['${widget.hid}']?['places']
              ['${widget.placeName}'];
          List objects = [];
          if (objectMap != null) {
            objectMap.forEach((key, value) {
              if (!objects.contains(key)) {
                objects.add(key);
              }
            });
          }
          return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Home Easy",
                  style: TextStyle(letterSpacing: currentwidth / 100),
                )),
            body: Container(
              child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          TextEditingController objHandler =
                              TextEditingController();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: SingleChildScrollView(
                                    child: AlertDialog(
                                      title: Text("Enter Object"),
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextField(
                                            controller: objHandler,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                ref
                                                    .child(
                                                        'homes/${widget.hid}/places/${widget.placeName}/${objHandler.text}')
                                                    .set("${DateTime.now()}");
                                                Navigator.pop(context);
                                              },
                                              child: Text("Add"))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Text("Add Object")),
                    SizedBox(
                      height: currentHeight / 100,
                    ),
                    Text(
                      "List of Objects in ${widget.placeName.toString().toUpperCase()}",
                      style: TextStyle(
                          fontSize: currentHeight / 50,
                          color: Colors.brown,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 3),
                    ),
                    SizedBox(
                      height: currentHeight / 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: [
                        for (int i = 0; i < objects.length; i++) ...[
                          Tile(
                              title: "${objects[i]}",
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: SingleChildScrollView(
                                          child: AlertDialog(
                                            title: Text("Delete Object"),
                                            content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      ref
                                                          .child(
                                                              'homes/${widget.hid}/places/${widget.placeName}/${objects[i]}')
                                                          .remove();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Delete")),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("No"))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                          SizedBox(
                            height: currentHeight / 1000,
                          ),
                        ]
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
