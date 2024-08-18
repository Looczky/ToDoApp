import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/models/Note.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? notes = '';    

  void loadData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      notes = prefs.getString('note') ?? '';
    });
  }

  @override
  void initState(){
    loadData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCEEAF7),
      body: Container(
        margin: const EdgeInsets.only(top:24,bottom: 24, right: 12, left: 12,),
        child: ListView(
          children: [
            const Center(child: Text('My notes:',style: TextStyle(fontSize: 28),)),
            const SizedBox(height: 10,),
            Card(
              child: ListTile(
                leading: TextButton(
                  onPressed: () async{
                    loadData();
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    final jsonString = prefs.getString('note') ?? '';
                    final noteMap = jsonDecode(jsonString) as Map<String, dynamic>;
                    final note = Note.fromJson(noteMap); 
                    print(note.desc);
                    },
                  child: const Text('Hello'),
                ),
                title: const Text('Created:'),
              ),
            ),
            Card(
              // Removing ListTile and placing ElevatedButton directly
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => context.go('/editCard'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Full width button
                  ),
                  child: const Text(
                    'Add new!',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
