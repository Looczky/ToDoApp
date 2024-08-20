import 'dart:convert';

class Note{
  final String id,title,desc;

  Note(
    this.id,
    this.title,
    this.desc,
  );

  Note.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      title = json['title'] as String,
      desc = json['desc'] as String;
  
  Map <String, dynamic> toJson() =>{
    'id': id,
    'title': title,
    'desc': desc,
  };

  static Map<String,dynamic> toMap(Note note) =>{
    'id': note.id,
    'title': note.title,
    'desc': note.desc,
  };

  static String encode(List<Note> notes) => json.encode(
    notes
      .map<Map<String,dynamic>>((note) => Note.toMap(note))
      .toList(),
  );

  static List<Note> decode(String notes) =>
    (json.decode(notes) as List<dynamic>)
      .map<Note>((item) => Note.fromJson(item))
      .toList();
} 