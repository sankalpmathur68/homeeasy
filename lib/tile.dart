import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Tile extends StatelessWidget {
  Tile({required this.title, required this.onTap});
  final title;
  void Function() onTap;
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        // height: currentHeight/15,
        // padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
        child: Container(
            decoration: const BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Container(
              padding: EdgeInsets.fromLTRB(4, 5, 4, 5),
              child: new Center(
                child: new Text(
                  "${title.toString()}",
                  style: TextStyle(
                      fontSize: currentHeight / 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 3),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
      ),
    );
  }
}
