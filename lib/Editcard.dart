import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/models/Note.dart';
import 'package:logger/logger.dart';

Logger _logger = Logger();

class Editcard extends StatefulWidget{
  final String id;
  final String? title,desc;

  const Editcard({super.key, required this.id, this.title,this.desc});

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
  final jsonStringList = prefs.getString('note');

  if (jsonStringList != null && jsonStringList. isNotEmpty){
      try{
        // final noteMap = jsonDecode(_jsonStringList) as Map<String, dynamic>;
        setState(() {
          notes = Note.decode(jsonStringList);
        }); 
      } catch (e){
        _logger.e('Error decoding JSON: $e');
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
  if (widget.title != null) {
    title = widget.title!;
  }
  if (widget.desc != null) {
    desc = widget.desc!;
  }
  loadData();
} 

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 97, 185, 219)  ,  
    appBar: AppBar(
      title: const Text('Home Page'), 
    ),
    body: Container(  
      margin: const EdgeInsets.only(  top:24,bottom: 24, right: 24, left: 24,),
        child: Center(
          child: Builder(builder: (context) {
            if (int.parse(widget.id) == -1){
              return Column(
                children: [
                  TextField(
                    onChanged: (newTitle) { 
                      updateCard(newTitle,desc);
                    },
                    style: const TextStyle(fontSize: 28),
                    minLines: 1,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Title'
                      ),
                    ),
                  const SizedBox(height: 10,),
                  TextField(
                    onChanged: (newDesc) {
                      updateCard(title,newDesc);  
                    },
                    style: const TextStyle(fontSize: 18), 
                    minLines: 12,
                    maxLines: 100,
                    decoration: const InputDecoration(
                      hintText: 'Description'
                      ),
                  ),
                ],
              );
            } else{
                return Column(
                  children: [
                    (TextFormField(
                      initialValue: widget.title,
                      onChanged: (newTitle) { 
                        updateCard(newTitle,desc);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Title'
                        ),
                      style: const TextStyle(fontSize: 28),
                      minLines: 1,
                      maxLines: 2,
                      )
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      initialValue: widget.desc,
                      onChanged: (newDesc) {
                        updateCard(title,newDesc);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Description'
                        ),
                      style: const TextStyle(fontSize: 18), 
                      minLines: 12,
                      maxLines: 100,
                    ),
                  ],
                );
              }  
            },
          ),
      ),
    )
    );
}
}