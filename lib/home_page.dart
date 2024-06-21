import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr3/auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final User? user = Auth().currentUser;
  String _data = "";
  String? username;
  List<String> parts = [];
  

  @override
  void initState() {
    super.initState();
    username = user?.email;
    parts = username!.split('@');
    _readData();
  }

  void _readData() {
    // Listening to changes in the database at the specified path ('/example')
    _database.child('${parts[0]}/temperatureData/objectTemp').onValue.listen((event) {
      final data = event.snapshot.value;
      setState(() {
        _data = data.toString();
      });
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User Email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  Widget _temp(){
    return Text('Temperature: $_data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _temp(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}