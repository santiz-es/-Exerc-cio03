import 'package:dbestudante/Cursa.dart';
import 'package:dbestudante/Cursa_dao.dart';
import 'package:dbestudante/Disciplina.dart';
import 'package:dbestudante/Disciplina_dao.dart';
import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:flutter/material.dart';

class Pag3 extends StatefulWidget {
  const Pag3({super.key});

  @override
  State<Pag3> createState() => _Pag3State();
}

class _Pag3State extends State<Pag3> {
  final estudanteDAO = EstudanteDao();
  final disciplinaDAO = DisciplinaDao();
  final cursaDAO = CursaDao();

  List<Estudante> estudantes = [];
  List<Disciplina> disciplinas = [];
  List<Cursa> cursas = [];


  int? estudanteSelecionadoId;
  int? disciplinaSelecionadaId;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

 
  Future<void> _carregarDados() async {
    final ests = await estudanteDAO.listarEstudantes();
    final discs = await disciplinaDAO.listarDisciplina();
    final cursasList = await cursaDAO.listarCursa();

    setState(() {
      estudantes = ests;
      disciplinas = discs;
      cursas = cursasList;
    });
  }

  
  Future<void> _matricular() async {
    if (estudanteSelecionadoId == null || disciplinaSelecionadaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Estudante ou disciplina inválidos")),
      );
      return;
    }

    bool jaMatriculado = cursas.any((c) =>
        c.estudanteId == estudanteSelecionadoId &&
        c.disciplinaId == disciplinaSelecionadaId);

    if (jaMatriculado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Estudante já está matriculado nessa disciplina")),
      );
      return;
    }

    await cursaDAO.incluirCursa(
      Cursa(
        estudanteId: estudanteSelecionadoId!,
        disciplinaId: disciplinaSelecionadaId!,
      ),
    );

    await _carregarDados();
  }

  Future<void> _desmatricular(int id) async {
    await cursaDAO.deleteCursa(id);
    await _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matricular Estudante em Disciplina"),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
          
            DropdownButton<int>(
              hint: const Text("Selecione o Estudante"),
              isExpanded: true,
              value: estudanteSelecionadoId,
              onChanged: (novo) {
                setState(() {
                  estudanteSelecionadoId = novo;
                });
              },
              items: estudantes.map((e) {
                return DropdownMenuItem<int>(
                  value: e.id,
                  child: Text("${e.Nome} (Matricula: ${e.Matricula})"),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

           
            DropdownButton<int>(
              hint: const Text("Selecione a Disciplina"),
              isExpanded: true,
              value: disciplinaSelecionadaId,
              onChanged: (novo) {
                setState(() {
                  disciplinaSelecionadaId = novo;
                });
              },
              items: disciplinas.map((d) {
                return DropdownMenuItem<int>(
                  value: d.id,
                  child: Text(d.nome),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _matricular,
              child: const Text("Matricular"),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: cursas.isEmpty
                  ? const Center(child: Text("Nenhuma matrícula encontrada"))
                  : ListView.builder(
                      itemCount: cursas.length,
                      itemBuilder: (context, index) {
                        final c = cursas[index];

                        
                        final est = estudantes.firstWhere(
                          (e) => e.id == c.estudanteId,
                          orElse: () =>
                              Estudante(id: 0, Nome: "Desconhecido", Matricula: ""),
                        );

                        final disc = disciplinas.firstWhere(
                          (d) => d.id == c.disciplinaId,
                          orElse: () => Disciplina(id: 0, nome: "Desconhecida", professor: ""),
                        );

                        return ListTile(
                          title: Text(est.Nome),
                          subtitle: Text("Matriculado em: ${disc.nome}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _desmatricular(c.id!),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
