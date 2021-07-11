import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showMyDialog(context, title, body, action) async {
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
            onPressed: action,
          ),
        ],
      );
    },
  );
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/cover.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("New User"),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      TextField(
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(),
                                          labelText: 'Username',
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      TextField(
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(),
                                          labelText: 'Password',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Add'),
                                    onPressed: () {
                                      users
                                          .doc(usernameController.text)
                                          .set({
                                            'username': usernameController.text,
                                            'password': passwordController.text,
                                            'type': 'staff'
                                          })
                                          .then((value) =>
                                              Navigator.pushReplacementNamed(
                                                  context, '/admin'))
                                          .catchError((error) => {
                                                showMyDialog(
                                                    context,
                                                    Text("Error"),
                                                    Text(error), () {
                                                  Navigator.of(context).pop();
                                                })
                                              });
                                    },
                                  ),
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
                        },
                        child: Text("Add"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // <-- Button color
                          onPrimary: Colors.white, // <-- Splash color
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.65,
                  child: FutureBuilder(
                      future: users.get(),
                      builder: (contect, snapshot) {
                        if (snapshot.hasError)
                          return Text("Somthing Went Wrong");
                        else if (snapshot.hasData)
                          return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]
                                                .data()['username'],
                                            style: TextStyle(
                                                fontSize: width * 0.05),
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                .data()['password'],
                                            style: TextStyle(
                                                fontSize: width * 0.05),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                primary: Colors
                                                    .green, // <-- Button color
                                                onPrimary: Colors
                                                    .white, // <-- Splash color
                                              ),
                                              onPressed: () {
                                                usernameController.text =
                                                    snapshot.data.docs[index]
                                                        .data()['username'];
                                                passwordController.text =
                                                    snapshot.data.docs[index]
                                                        .data()['password'];
                                                return showDialog<void>(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Edit User"),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            TextField(
                                                              controller:
                                                                  usernameController,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Username',
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  height * 0.02,
                                                            ),
                                                            TextField(
                                                              controller:
                                                                  passwordController,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Password',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('Edit'),
                                                          onPressed: () {
                                                            users
                                                                .doc(snapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .id
                                                                    .toString())
                                                                .update({
                                                                  'username':
                                                                      usernameController
                                                                          .text,
                                                                  'password':
                                                                      passwordController
                                                                          .text,
                                                                })
                                                                .then((value) =>
                                                                    Navigator.pushReplacementNamed(
                                                                        context,
                                                                        '/admin'))
                                                                .catchError(
                                                                    (error) => {
                                                                          showMyDialog(
                                                                              context,
                                                                              Text(
                                                                                  "Error"),
                                                                              Text(error),
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          })
                                                                        });
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Close'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(Icons.edit)),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                primary: Colors
                                                    .red, // <-- Button color
                                                onPrimary: Colors
                                                    .white, // <-- Splash color
                                              ),
                                              onPressed: () {
                                                users
                                                    .doc(snapshot
                                                        .data.docs[index].id
                                                        .toString())
                                                    .delete()
                                                    .then((value) {
                                                  showMyDialog(
                                                      context,
                                                      Text("Successful"),
                                                      Text(
                                                          "Deleted successfully"),
                                                      () {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context, '/admin');
                                                  });
                                                }).catchError((error) {
                                                  showMyDialog(
                                                      context,
                                                      Text("Error"),
                                                      Text(error), () {
                                                    Navigator.of(context).pop();
                                                  });
                                                });
                                              },
                                              child: Icon(Icons.delete)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        else
                          return CircularProgressIndicator();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(height * 0.05),
                          primary: Colors.green, // <-- Button color
                          onPrimary: Colors.white, // <-- Splash color
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
