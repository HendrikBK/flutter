import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repository/aluno_repository.dart';
import 'data/service/aluno_service.dart';
import 'UI/controller/aluno_controller.dart';
import 'UI/page/aluno_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final alunoService = AlunoService();

    final alunoRepository = AlunoRepository(service: alunoService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AlunoController>(
          create: (_) => AlunoController(
            repository: alunoRepository,
          )..carregarAlunos(),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cadastro de Alunos',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
        ),

        home: const AlunoPage(),
      ),
    );
  }
}