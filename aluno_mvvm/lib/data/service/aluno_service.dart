import '../model/aluno.dart';

class AlunoService {
  final List<Aluno> _alunos = [];

  List<Aluno> getAll() {
    return List<Aluno>.from(_alunos);
  }

  void insert(Aluno aluno) {
    _alunos.add(aluno);
  }

  void update(Aluno alunoAtualizado) {
    final index = _alunos.indexWhere((aluno) => aluno.id == alunoAtualizado.id);

    if (index != -1) {
      _alunos[index] = alunoAtualizado;
    }
  }

  void delete(String id) {
    _alunos.removeWhere((aluno) => aluno.id == id);
  }

  Aluno? findById(String id) {
    try {
      return _alunos.firstWhere((aluno) => aluno.id == id);
    } catch (_) {
      return null;
    }
  }
}