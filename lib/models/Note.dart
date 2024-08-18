class Note{
  final int id;
  final String title,desc;

  Note(
    this.id,
    this.title,
    this.desc,
  );

  Note.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      title = json['title'] as String,
      desc = json['desc'] as String;
  
  Map <String, dynamic> toJson() =>{
    'id': id,
    'title': title,
    'desc': desc,
  };
} 