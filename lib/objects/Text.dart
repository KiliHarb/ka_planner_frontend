class Text {
  String _id = '';
  String _name = '';
  String _content = '';
  String _dateOfCreation = '';
  String _dateOfEditing = '';

  Text({required String id ,required String name, required String content, required String dateOfCreation, required String dateOfEditing}) :
    _id = id,
    _name = name,
    _content = content,
    _dateOfCreation = dateOfCreation,
    _dateOfEditing = dateOfEditing;

    set id(value) => _id = value;
    set name(value) => _name = value;
    set content(value) => _content = value;
    set dateOfCreation(value) => _dateOfCreation = value;
    set dateOfEditing(value) => _dateOfEditing = value;
    
    get id => _id;
    get name => _name;
    get content => _content;
    get dateOfCreation => _dateOfCreation;
    get dateOfEditing => _dateOfEditing;
  
  Map<String, dynamic> toJson() => {
    'id': _id,
    'name': _name,
    'content': _content,
    'dateOfCreation': _dateOfCreation,
    'editingDate': _dateOfEditing
  };
}