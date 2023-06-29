import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override


  Future<void> addUserDetails(User user) async {
    try {
      await firestore.collection('users').add({
        'name': user.name,
        'email': user.email,
      });
      print('User details added successfully!');
    } catch (e) {
      print('Error adding user details: $e');
    }
  }

  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Firestore Example',
      home: Scaffold(
        appBar: AppBar(title: Text('Firestore Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  User newUser = User(name: 'John Doe', email: 'johndoe@example.com');
                  addUserDetails(newUser);
                },
                child: Text('Add User Details'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: buildUserList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



Widget buildUserList() {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  return StreamBuilder<QuerySnapshot>(
    stream: firestore.collection('users').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(data['name']),
            subtitle: Text(data['email']),
          );
        }).toList(),
      );
    },
  );
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}


