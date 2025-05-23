import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pag1 extends StatefulWidget {
  const Pag1({super.key});

  @override
  State<Pag1> createState() => _Pag1State();
}

class _Pag1State extends State<Pag1> {
  final _estudanteDAO = EstudanteDao();
  Estudante? _estudanteAtual;
  final _controllerNome = TextEditingController();
  final _controllerMatricula = TextEditingController();
  List<Estudante> _listEstudantes = [
    Estudante(Nome: "Fulano", Matricula: "123456"),
    Estudante(Nome: "Ciclano", Matricula: "789123"),
    Estudante(Nome: "Jorje", Matricula: "568970"),
  ];

  @override
  void initState() {
    _loadEstudante();
    super.initState();
  }

  _loadEstudante() async {
    List<Estudante> temp = await _estudanteDAO.listarEstudantes();
    setState(() {
      _listEstudantes = temp;
    });
  }

  _salvarOUEditar() async {
    if (_estudanteAtual == null) {
      //novo estudante
      await _estudanteDAO.incluirEstudante(
        Estudante(
          Nome: _controllerNome.text,
          Matricula: _controllerMatricula.text,
        ),
      );
    } else {
     
      _estudanteAtual!.Nome = _controllerNome.text;
      _estudanteAtual!.Matricula = _controllerMatricula.text;
      await _estudanteDAO.editarEstudante(_estudanteAtual!);
    }
    _controllerNome.clear();
    _controllerMatricula.clear();
    setState(() {
      _loadEstudante();
      _estudanteAtual = null;
    });
  }

_apagarEstudante(int id) async {
  await _estudanteDAO.deleteEstudante(id);
  _loadEstudante(); 
}

  _editarEstudante(Estudante e) async {
    await _estudanteDAO.editarEstudante(e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD estudante"),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerNome,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerMatricula,
              decoration: InputDecoration(
                labelText: "Matricula",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  _salvarOUEditar();
                },
                child:
                    _estudanteAtual == null
                        ? Text("Salvar")
                        : Text("Atualizar"),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listEstudantes.length,
              itemBuilder: (context, index) {
                
                return ListTile(
                  title: Text(_listEstudantes[index].Nome),
                  subtitle: Text(_listEstudantes[index].Matricula),
                  trailing: IconButton(
                    onPressed: () {
                      _apagarEstudante(_listEstudantes[index].id!);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  onTap: () {
                    setState(() {
                      _estudanteAtual = _listEstudantes[index];
                      _controllerNome.text = _estudanteAtual!.Nome;
                      _controllerMatricula.text = _estudanteAtual!.Matricula;
                      _editarEstudante(_estudanteAtual!);
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
