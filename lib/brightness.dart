import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BrightnessPage extends StatefulWidget {
  BrightnessPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BrightnessPage createState() => _BrightnessPage();
}

class _BrightnessPage extends State<BrightnessPage> {
  double _value = 50.0;
  bool brightness = false;
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => {},
                      child: Text("Brightness"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey, // <-- Button color
                        onPrimary: Colors.yellow, // <-- Splash color
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(width * 0.15),
                      primary: brightness
                          ? Colors.green
                          : Colors.blueGrey, // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    ),
                    onPressed: () async {
                      try {
                        var url = "http://192.168.1.1/brightness";
                        final response = await http.get(url);
                        if (response.statusCode == 200) {
                          setState(() {
                            brightness = !brightness;
                          });
                          print("sent");
                          return;
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          size: width * 0.3,
                        ),
                        brightness ? Text("ON") : Text("OFF")
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Brightness",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.05),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey, // <-- Button color
                          onPrimary: Colors.white, // <-- Splash color
                        ),
                        onPressed: () {},
                        child: Text("${_value.round()}%")),
                  ],
                ),
                Slider(
                  min: 0,
                  max: 255,
                  divisions: 5,
                  value: _value,
                  onChanged: (value) async {
                    try {
                      var url = "http://192.168.1.1/brightnesslight?light=" +
                          value.toInt().toString();
                      final response = await http.get(url);
                      if (response.statusCode == 200) {
                        setState(() {
                          _value = value;
                        });
                        print("sent");
                        return;
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Schedule",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.05),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey, // <-- Button color
                              onPrimary: Colors.white, // <-- Splash color
                            ),
                            onPressed: () => {},
                            child: Text("7:00 PM")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey, // <-- Button color
                              onPrimary: Colors.white, // <-- Splash color
                            ),
                            onPressed: () => {},
                            child: Text("3:00 AM")),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Total working hours / month",
                              style: TextStyle(
                                  color: Colors.white, fontSize: width * 0.05),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Text(
                              "70",
                              style: TextStyle(
                                  color: Colors.white, fontSize: width * 0.05),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.logout),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false)),
    );
  }
}
