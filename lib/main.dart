import 'package:flutter/material.dart';
import 'package:khairi_fyp/admin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khairi_fyp/brightness.dart';
import 'package:khairi_fyp/motion.dart';
import 'package:khairi_fyp/staff.dart';

void showMyDialog(context, title, body) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              body,
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => FutureBuilder(
              future: _fbApp,
              builder: (contect, snapshot) {
                if (snapshot.hasError)
                  return Text("Something Went Wrong");
                else if (snapshot.hasData)
                  return MyHomePage(title: 'Flutter Demo Home Page');
                else
                  return Center(child: CircularProgressIndicator());
              },
            ),
        '/admin': (context) => AdminPage(),
        '/staff': (context) => StaffPage(),
        '/motion': (context) => MotionPage(),
        '/brightness': (context) => BrightnessPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool flag = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/cover.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage("assets/img/logo.png"),
                        width: width * 0.4,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  flag
                      ? TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                          ),
                        )
                      : Text(
                          "Residential Smart Light",
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.1),
                        ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  flag
                      ? TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        )
                      : Text(
                          "The Grand Menteng Indah. control lighting area",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.03,
                          ),
                        ),
                  if (flag)
                    SizedBox(
                      height: height * 0.02,
                    ),
                  if (flag)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(width * 0.07),
                            primary: Colors.green, // <-- Button color
                            onPrimary: Colors.white, // <-- Splash color
                          ),
                          onPressed: () {
                            try {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .where('username',
                                      isEqualTo: usernameController.text)
                                  .where('password',
                                      isEqualTo: passwordController.text)
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                if (querySnapshot.size > 0)
                                  Navigator.pushReplacementNamed(context,
                                      '/' + querySnapshot.docs.first['type']);
                                else
                                  showMyDialog(context, Text("Login Fail"),
                                      Text("Wrong username or password"));
                              });
                            } catch (e) {
                              showMyDialog(context, Text("Error"),
                                  Text("Something went wrong"));
                            }
                          },
                          child: Text("Submit"),
                        ),
                      ],
                    ),
                  if (!flag)
                    SizedBox(
                      height: height * 0.15,
                    )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: !flag
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    flag = !flag;
                  });
                },
                tooltip: 'login',
                child: Icon(Icons.arrow_forward),
                backgroundColor: Colors.blueGrey,
              )
            : null);
  }
}
