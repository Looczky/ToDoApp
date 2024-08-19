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

    Note? note;    

    @override
    void initState(){
      super.initState();
      loadData();
    } 

    void loadData() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final _jsonString = prefs.getString('note');

      if (_jsonString != null && _jsonString.isNotEmpty){
        try{
          final noteMap = jsonDecode(_jsonString) as Map<String, dynamic>;
          setState(() {
            note = Note.fromJson(noteMap);
          }); 
        } catch (e){
          print('Error decoding JSON: $e');
        }
      } else{
        setState(() {
          note = null;
        });
      }
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
                    print(note?.desc);
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
