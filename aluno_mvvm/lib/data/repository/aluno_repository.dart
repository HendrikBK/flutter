import '../model/aluno.dart';
import '../service/aluno_service.dart';

class AlunoRepository {
  final AlunoService service;

  AlunoRepository({
    required this.service,
  });

  List<Aluno> listar() {
    return service.getAll();
  }

  void adicionar(Aluno aluno) {
    service.insert(aluno);
  }

  void atualizar(Aluno aluno) {
    service.update(aluno);
  }

  void remover(String id) {
    service.delete(id);
  }

  Aluno? buscarPorId(String id) {
    return service.findById(id);
  }
}