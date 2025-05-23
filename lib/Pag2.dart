import 'package:flutter/material.dart';
import 'package:dbestudante/Disciplina.dart';
import 'package:dbestudante/Disciplina_dao.dart';

class Pag2 extends StatefulWidget {
  const Pag2({super.key});

  @override
  State<Pag2> createState() => _Pag2State();
}

class _Pag2State extends State<Pag2> {
  final _disciplinaDAO = DisciplinaDao();
  Disciplina? _disciplinaAtual;
  final _controllerNome = TextEditingController();
  final _controllerProfessor = TextEditingController();
  List<Disciplina> _listDisciplinas = [];

  @override
  void initState() {
    super.initState();
    _loadDisciplinas();
  }

  Future<void> _loadDisciplinas() async {
    List<Disciplina> temp = await _disciplinaDAO.listarDisciplina();
    setState(() {
      _listDisciplinas = temp;
    });
  }

  Future<void> _salvarOUEditar() async {
    if (_disciplinaAtual == null) {
      await _disciplinaDAO.incluirDisciplina(
        Disciplina(
          nome: _controllerNome.text,
          professor: _controllerProfessor.text,
        ),
      );
    } else {
      _disciplinaAtual!.nome = _controllerNome.text;
      _disciplinaAtual!.professor = _controllerProfessor.text;
      await _disciplinaDAO.editarDisciplina(_disciplinaAtual!);
    }
    _controllerNome.clear();
    _controllerProfessor.clear();
    setState(() {
      _disciplinaAtual = null;
    });
    await _loadDisciplinas();
  }

  Future<void> _apagarDisciplina(int id) async {
    await _disciplinaDAO.deleteDisciplina(id);
    await _loadDisciplinas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Disciplina"),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _controllerNome,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _controllerProfessor,
              decoration: InputDecoration(
                labelText: "Professor",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: _salvarOUEditar,
                child: _disciplinaAtual == null ? Text("Salvar") : Text("Atualizar"),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listDisciplinas.length,
              itemBuilder: (context, index) {
                final disciplina = _listDisciplinas[index];
                return ListTile(
                  title: Text(disciplina.nome),
                  subtitle: Text(disciplina.professor),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _apagarDisciplina(disciplina.id!);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _disciplinaAtual = disciplina;
                      _controllerNome.text = disciplina.nome;
                      _controllerProfessor.text = disciplina.professor;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
