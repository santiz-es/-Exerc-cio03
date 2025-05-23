class Estudante {
  int? id;
  String Nome;
  String Matricula;
  Estudante({
    this.id,
    required this.Nome,
    required this.Matricula
  });

  Map<String, dynamic> toMap(){
    return{
      "id": id,
      "nome": Nome,
      "matricula": Matricula,
    };
  }

  factory Estudante.fromMap(Map<String, dynamic>map){
    return Estudante(
      id: map['id'],
      Nome: map['nome'],
      Matricula: map['matricula'],
    );
  }
}