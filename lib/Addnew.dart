import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:homeeasy/placeList.dart';

class Add extends StatefulWidget {
  Add({required this.hid});
  String hid;
  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  void _showForm() async {
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        showform = true;
      });
    });
  }

  @override
  bool Addnew = false;
  bool showform = false;
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HomeEasy",
          style: TextStyle(
              letterSpacing: currentwidth / 100, fontWeight: FontWeight.w200),
        ),
        centerTitle: true,
      ),
      body: Container(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                child: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        Addnew = !Addnew;
                      });
                      _showForm();
                    },
                    icon: Addnew ? Icon(Icons.arrow_back) : Icon(Icons.add),
                    label: Addnew
                        ? Text("uploaded Places")
                        : Text("Add new place")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedCrossFade(
                  sizeCurve: Curves.easeInOut,
                  firstCurve: Curves.easeInOut,
                  duration: Duration(seconds: 1),
                  firstChild: placeList(
                    hid: widget.hid,
                  ),
                  secondChild: formForNew(hid: widget.hid),
                  crossFadeState: !Addnew
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class formForNew extends StatefulWidget {
  const formForNew({required this.hid});
  final hid;
  @override
  State<formForNew> createState() => formForNewState();
}

class formForNewState extends State<formForNew> {
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    final ref = FirebaseDatabase.instance.ref();
    TextEditingController _objectHandler = TextEditingController();
    TextEditingController _placeHandler = TextEditingController();
    return StreamBuilder(
        stream: ref.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> event) {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.brown, borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Column(
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: currentwidth / 25),
                    cursorColor: Colors.white,
                    controller: _placeHandler,
                    decoration: InputDecoration(
                        hintText: "Enter new place...",
                        hintStyle: TextStyle(color: Colors.white54),
                        fillColor: Colors.black,
                        border: InputBorder.none),
                  ),
                  SizedBox(
                    child: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: currentwidth / 25),
                    cursorColor: Colors.white,
                    controller: _objectHandler,
                    decoration: InputDecoration(
                        hintText: "Enter new object...",
                        hintStyle: TextStyle(color: Colors.white54),
                        fillColor: Colors.black,
                        border: InputBorder.none),
                  ),
                  Text(
                    "*place should contain atleast one Object.",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    child: Container(
                      height: 5,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          ref
                              .child(
                                  'homes/${widget.hid}/places/${_placeHandler.text}/${_objectHandler.text}')
                              .set("${DateTime.now()}");
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 25, shadowColor: Colors.black),
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontSize: currentwidth / 20,
                              fontWeight: FontWeight.w200),
                        )),
                  )
                ],
              )));
        });
  }
}

class ActionHandling {
  AddNew() {
    final ref = FirebaseDatabase.instance.ref();
  }
}
