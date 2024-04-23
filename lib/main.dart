import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MeuApp(),
  ));
}

class MeuApp extends StatefulWidget {
  const MeuApp({super.key});

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Afazeres'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        _tarefas.removeAt(index);
                      });
                    },
                    child: ListTile(
                      title: Text(_tarefas[index].descricao),
                      leading: Checkbox(
                        value: _tarefas[index].status,
                        onChanged: (novoValor) {
                          setState(() {
                            _tarefas[index].status = novoValor ?? false;
                          });
                        },
                      ),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editarTarefa(index);
                          },
                        ),
                        IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _excluirTarefa(index);
                            })
                      ]),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controlador,
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(Size(200, 60)),
                  ),
                  child: const Text('Adicionar Tarefa'),
                  onPressed: () {
                    if (controlador.text.isEmpty) {
                      return;
                    }
                    setState(() {
                      _tarefas.add(
                        Tarefa(
                          descricao: controlador.text,
                          status: false,
                        ),
                      );
                      controlador.clear();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editarTarefa(int index) {
    TextEditingController controller =
        TextEditingController(); // Novo controlador de texto

    controller.text = _tarefas[index].descricao;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Nova descrição',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tarefas[index].descricao = controller.text;
                  controlador.clear();
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _excluirTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, required this.status});
}
