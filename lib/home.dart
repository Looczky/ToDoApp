import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/models/Note.dart';

// TODO: note and notes confusing a bit

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

  class _HomeState extends State<Home> {

    Note? note;
    List<Note> notes = List.empty(); 

    void loadData() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('note');

      if (jsonString != null && jsonString.isNotEmpty){
        try{
          List<Note> encoded = Note.decode(jsonString);
          setState(() {
            notes = encoded;
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

    void clearAll() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('note', '[]');
      setState(() {
        notes = List.empty();
      });{}
    }

    void deleteNote(index) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final notesUpdated = notes..removeAt(index);
      final notesStr = Note.encode(notesUpdated);
      await prefs.setString('note', notesStr);
      setState(() {
        notes = notesUpdated;
      });{}
    }

    @override
    void initState(){
      super.initState();
      loadData();
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
            for (var id = 0; id<notes.length;id++)
                Card(
                  child: ListTile(
                    onTap: () => context.go(
                      '/editCard/$id',
                      extra: {
                        'title': notes[id].title,
                        'desc': notes[id].desc, 
                      },
                    ),
                    title: Text(notes[id].title),
                    subtitle: Text(
                      notes[id].desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ), 
                    trailing: IconButton(onPressed: ()=>{deleteNote(id)}, icon: Icon(Icons.delete)),
                  ),
                ),
              Card(
                child: ListTile(
                  onTap: () => context.go('/editCard/-1'),
                  title: const Center(child: Text('Add new note!')),
                ),
              ),
            TextButton(onPressed: clearAll, child: const Text('Clear all!')),
          ],
        ),
      ),
    );
  }
}
