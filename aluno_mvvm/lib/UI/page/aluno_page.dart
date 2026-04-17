import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/aluno.dart';
import '../controller/aluno_controller.dart';

class AlunoPage extends StatefulWidget {
  const AlunoPage({super.key});

  @override
  State<AlunoPage> createState() => _AlunoPageState();
}

class _AlunoPageState extends State<AlunoPage> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AlunoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Alunos'),
        centerTitle: true,
      ),

      body: controller.alunos.isEmpty? const Center(
        child: Text(
          'Nenhum aluno cadastrado.',
          style: TextStyle(fontSize: 18),
        ),
      ): ListView.builder(
        itemCount: controller.alunos.length,
        itemBuilder: (context, index) {
          final aluno = controller.alunos[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(aluno.nome),

              subtitle: Text(
                'Matrícula: ${aluno.matricula}\n'
                'Curso: ${aluno.curso}',
              ),

              isThreeLine: true,

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Editar aluno',
                    onPressed: () {
                      _abrirFormulario(
                        context,
                        aluno: aluno,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Excluir aluno',
                    onPressed: () {
                      _confirmarExclusao(context, aluno);
                    },
                  ),
                ]
              ),
            )
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirFormulario(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _abrirFormulario(BuildContext context, {Aluno? aluno}) {
  final nomeController = TextEditingController(
    text: aluno?.nome ?? '',
  );

  final matriculaController = TextEditingController(
    text: aluno?.matricula ?? '',
  );

  final cursoController = TextEditingController(
    text: aluno?.curso ?? '',
  );

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          aluno == null ? 'Novo Aluno' : 'Editar Aluno',
        ),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: matriculaController,
                decoration: const InputDecoration(
                  labelText: 'Matrícula',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: cursoController,
                decoration: const InputDecoration(
                  labelText: 'Curso',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nome = nomeController.text.trim();
              final matricula = matriculaController.text.trim();
              final curso = cursoController.text.trim();

              if (nome.isEmpty || matricula.isEmpty || curso.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preencha nome, matrícula ou curso'),
                  ),
                );
                return;
              }

              final controller = context.read<AlunoController>();

              if (aluno == null) {
                controller.adicionarAluno(
                  nome: nome,
                  matricula: matricula,
                  curso: curso,
                );
              } else {
                controller.atualizarAluno(
                  id: aluno.id,
                  nome: aluno.nome,
                  matricula: aluno.matricula,
                  curso: aluno.curso,
                );
              }

              Navigator.pop(dialogContext);
            },
            child: Text(
              aluno == null ? 'Salvar' : 'Atualizar',
            ),
          ),
        ],
      );
    }
  );
}

void _confirmarExclusao(BuildContext context, Aluno aluno) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text(
          'Deseja realmente excluir o launo "${aluno.nome}"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancelar'),
          ),

          ElevatedButton(
            onPressed: () {
              context.read<AlunoController>().removerAluno(aluno.id);
              Navigator.pop(dialogContext);              
            },
            child: const Text('Excluir'),
          ),
        ],
      );
    }
  );
}