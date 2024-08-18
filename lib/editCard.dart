import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/models/Note.dart';


class Editcard extends StatefulWidget{
  const Editcard({super.key});

  @override
  State<Editcard> createState() => _EditcardState();
}

class _EditcardState extends State<Editcard> {
  String title = '';
  String desc = '';

  void updateTitle(String newTitle) async{
    title = newTitle;
    updateCard(title, desc);
  }

  void updateDesc(String newDesc) async{
    desc = newDesc;
    updateCard(title, desc);
  }

  void updateCard(String title, String desc) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newNote = new Note(1,title,desc);
    prefs.setString('note', jsonEncode(newNote)); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 97, 185, 219)  ,  
      appBar: AppBar(
        title: const Text('Home Page'), 
      ),
      body: Container(  
        margin: const EdgeInsets.only(top:24,bottom: 24, right: 24, left: 24,),
          child: Center(
            child: Column(
              children: [
                TextField(
                  onChanged: (text) {
                    updateTitle(text);
                  },
                  style: TextStyle(fontSize: 28),
                  minLines: 1,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Title'
                    ),
                  ),
                SizedBox(height: 10,),  
                TextField(
                  onChanged: (text) {
                    updateDesc(text);
                  },
                  style: TextStyle(fontSize: 18), 
                  minLines: 12,
                  maxLines: 100,
                  decoration: InputDecoration(
                    hintText: 'Larger'
                    ),
                  ),
              ],
            ),
        ),
      )
      );
  }
}

class ToDoCard extends StatelessWidget{
  final String title;
  const ToDoCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Text(title),
    );
  }
}