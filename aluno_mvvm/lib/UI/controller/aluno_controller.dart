import 'package:flutter/material.dart';

import '../../data/model/aluno.dart';
import '../../data/repository/aluno_repository.dart';

class AlunoController extends ChangeNotifier {
  final AlunoRepository repository;

  AlunoController({
    required this.repository,
  });

  List<Aluno> _alunos = [];

  List<Aluno> get alunos => _alunos;

  void carregarAlunos() {
    _alunos = repository.listar();

    notifyListeners();
  }

  void adicionarAluno({
    required String nome,
    required String matricula,
    required String curso,
  }) {
    final novoAluno = Aluno(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nome: nome,
      matricula: matricula,
      curso: curso,
    );

    repository.adicionar(novoAluno);

    carregarAlunos();
  }

  void atualizarAluno({
    required String id,
    required String nome,
    required String matricula,
    required String curso,
  }) {
    final alunoAtualizado = Aluno(
      id: id,
      nome: nome,
      matricula: matricula,
      curso: curso,
    );

    repository.atualizar(alunoAtualizado);

    carregarAlunos();
  }

  void removerAluno(String id) {
    repository.remover(id);

    carregarAlunos();
  }

  Aluno? buscarAlunoPorId(String id) {
    return repository.buscarPorId(id);
  }
}