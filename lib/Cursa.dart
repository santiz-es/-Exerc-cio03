class Cursa {
  int? id;
  int estudanteId;
  int disciplinaId;

  Cursa({
    this.id,
    required this.estudanteId,
    required this.disciplinaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estudanteId': estudanteId,
      'disciplinaId': disciplinaId,
    };
  }

  factory Cursa.fromMap(Map<String, dynamic> map) {
    return Cursa(
      id: map['id'],
      estudanteId: map['estudanteId'],
      disciplinaId: map['disciplinaId'],
    );
  }
}
