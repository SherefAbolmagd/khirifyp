import 'package:flutter/material.dart';

class StaffPage extends StatefulWidget {
  StaffPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StaffPage createState() => _StaffPage();
}

class _StaffPage extends State<StaffPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/cover.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(width * 0.15),
                primary: Colors.blueGrey, // <-- Button color
                onPrimary: Colors.white, // <-- Splash color
              ),
              onPressed: () => Navigator.pushNamed(context, '/motion'),
              child: Text("Motion",
                  style:
                      TextStyle(color: Colors.green, fontSize: width * 0.05)),
            ),
            Column(
              children: [
                Text(
                  "Click On",
                  style: TextStyle(color: Colors.white, fontSize: width * 0.05),
                ),
                Text(
                  "Sensors to procced",
                  style: TextStyle(color: Colors.white, fontSize: width * 0.05),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(width * 0.15),
                primary: Colors.blueGrey, // <-- Button color
                onPrimary: Colors.white, // <-- Splash color
              ),
              onPressed: () => Navigator.pushNamed(context, '/brightness'),
              child: Text("Brightness",
                  style:
                      TextStyle(color: Colors.yellow, fontSize: width * 0.05)),
            ),
          ],
        ),
      ),
    );
  }
}
