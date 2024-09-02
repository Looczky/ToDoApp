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
  final Color titleColor = Color.fromARGB(255, 133, 205, 223);
  final Color descColor = Color.fromARGB(255, 133, 205, 223);
  late ScrollController _scrollController;
  late FocusNode _descFocusNode;


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
  _scrollController = ScrollController();
  _descFocusNode = FocusNode();

  void _scrollToFocusedLine() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  } 

  _descFocusNode.addListener(() {
      if (_descFocusNode.hasFocus) {
        // Scroll to the focused line in the TextFormField
        _scrollToFocusedLine();
      }
    });
} 



@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 97, 185, 219),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 24,
          bottom: 24,
          right: 24,
          left: 24,
        ),
        child: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: titleColor, // replace with titleColor
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextFormField(
                      initialValue: widget.id == -1 ? null : widget.title,
                      onChanged: (newTitle) {
                        updateCard(newTitle, desc);
                      },
                      minLines: 1,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        contentPadding: EdgeInsets.symmetric( 
                            horizontal: 16.0, vertical: 16),
                      ),
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded( 
                    child: Container(
                      decoration: BoxDecoration(
                        color: descColor, // replace with descColor
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: TextFormField(
                          focusNode: _descFocusNode,
                          initialValue:
                              widget.id == -1 ? null : widget.desc,
                          onChanged: (newDesc) {
                            updateCard(title, newDesc);
                          },
                          style: const TextStyle(fontSize: 18),
                          minLines: 12,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16),
                          ),
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}