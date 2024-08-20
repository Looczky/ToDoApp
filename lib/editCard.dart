import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/models/Note.dart';


  class Editcard extends StatefulWidget{
    final String id;
    
    const Editcard({super.key, required this.id});

    @override
    State<Editcard> createState() => _EditcardState();
  }

  class _EditcardState extends State<Editcard> {
    late int id;
    String title = '';
    String desc = '';
    late Note currentNote;
    late List<Note> notes;


    void updateCard(String newTitle, String newDesc) async {
      setState(() {
        title = newTitle;
        desc = newDesc;
        currentNote = Note(widget.id,newTitle,newDesc);
      });
      updateData();
    } 


  void updateData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (id == -1){
      notes.add(currentNote);
      setState(() {
        id = notes.length - 1; 
      });
    }
    else{
      notes[id] = currentNote;
    } 
    prefs.setString('note', Note.encode(notes));
  }

  void loadData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final _jsonStringList = prefs.getString('note');

    if (_jsonStringList != null && _jsonStringList. isNotEmpty){
        try{
          // final noteMap = jsonDecode(_jsonStringList) as Map<String, dynamic>;
          setState(() {
            notes = Note.decode(_jsonStringList);
          }); 
        } catch (e){
          print('Error decoding JSON: $e');
        }
      } else{
        setState(() {
          notes = [];
        });
      }
    }


  @override
  void initState(){
    super.initState();
    id = int.parse(widget.id);  
    loadData();
  } 

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 97, 185, 219)  ,  
      appBar: AppBar(
        title: const Text('Home Page'), 
      ),
      body: Container(  
        margin: const EdgeInsets.only(  top:24,bottom: 24, right: 24, left: 24,),
          child: Center(
            child: Column(
              children: [ 
                TextField(
                  onChanged: (text) { 
                    updateCard(title,text);
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
                    updateCard(text,desc);
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