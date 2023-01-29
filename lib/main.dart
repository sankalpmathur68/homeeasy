import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeeasy/Addnew.dart';
import 'package:homeeasy/login.dart';
import 'package:homeeasy/placeList.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: login(),
    );
  }
}

class Home extends StatefulWidget {
  Home({required this.homeid});
  String homeid;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.black38),
        elevation: 0,
        title: isSearching
            ? TextField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Search a Place or a Thing...",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(87, 255, 255, 255),
                    )),
              )
            : Text(
                "HomeEasy",
                style: TextStyle(
                    letterSpacing: currentwidth / 100,
                    fontWeight: FontWeight.w200),
              ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
          ),
          SizedBox(
            width: currentwidth / 100,
          ),
          IconButton(
            icon: Icon(
              Icons.add_box,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(context, _createRoute(Add(hid: widget.homeid)));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Center(
              child: Column(
            children: [
              placeList(
                hid: widget.homeid,
              )
            ],
          )),
        ),
      ),
    );
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
