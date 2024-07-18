import 'package:flutter/material.dart';
import 'package:to_do_list_flutter/objetivo.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<Objetivo> tarefas = [];

  @override
  Widget build(BuildContext context) {
    List<Objetivo> emAberto = tarefas.where((obj) => !obj.concluido).toList();
    List<Objetivo> concluidos = tarefas.where((obj) => obj.concluido).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lista de Tarefas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 50, 190, 48),
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  adicionarTarefa();
                },
                child: const Text(
                  "Adicionar tarefa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              tarefas.isNotEmpty
                  ? exibeTarefas(emAberto, concluidos)
                  : const Text(
                      "Nenhuma tarefa adicionada",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget exibeTarefas(
      List<Objetivo> listaDosEmAberto, List<Objetivo> listaDosConcluidos) {
    return Column(
      children: [
        Column(
          children: listaDosEmAberto.map(
            (obj) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: obj.concluido,
                    onChanged: (bool? value) {
                      setState(
                        () {
                          obj.concluido = value ?? false;
                          if (obj.concluido) {
                            listaDosEmAberto.remove(obj);
                            obj.dataFinalizacao = DateTime.now();
                            listaDosConcluidos.add(obj);
                          }
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          mostraInformacoes(obj);
                        },
                        child: Text(
                          obj.descricao,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
        Column(
          children: listaDosConcluidos.map(
            (obj) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: obj.concluido,
                    onChanged: null,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          mostraInformacoes(obj);
                        },
                        child: Text(
                          obj.descricao,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  void adicionarTarefa() {
    final TextEditingController descricaoTextController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Tarefa'),
          content: TextFormField(
            controller: descricaoTextController,
            decoration: const InputDecoration(labelText: 'Tarefa'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (descricaoTextController.text.length > 3) {
                  setState(
                    () {
                      tarefas.add(
                        Objetivo(
                          id: tarefas.length + 1,
                          descricao: descricaoTextController.text,
                          dataCriacao: DateTime.now(),
                          dataFinalizacao: null,
                          concluido: false,
                        ),
                      );
                    },
                  );
                  Navigator.of(context).pop();
                } else {
                  mostraSnack3Digitos();
                }
              },
              child: const Text(
                'Adicionar',
                style: TextStyle(
                  color: Color.fromARGB(255, 50, 190, 48),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void mostraInformacoes(Objetivo tarefa) {
  String dataInicial =
      "${tarefa.dataCriacao.day}/${tarefa.dataCriacao.month}/${tarefa.dataCriacao.year} - ${tarefa.dataCriacao.hour}:${tarefa.dataCriacao.minute}:${tarefa.dataCriacao.second}";
  String dataFinal = tarefa.dataFinalizacao != null
      ? "${tarefa.dataFinalizacao!.day}/${tarefa.dataFinalizacao!.month}/${tarefa.dataFinalizacao!.year} - ${tarefa.dataFinalizacao!.hour}:${tarefa.dataFinalizacao!.minute}:${tarefa.dataFinalizacao!.second}"
      : " - ";
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Center(child: Text(tarefa.descricao)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Data Inicial: $dataInicial"),
                const SizedBox(height: 20),
                Text("Data de Conclusão: $dataFinal")
              ],
            ),
            actions: [
              !tarefa.concluido
                  ? TextButton(
                      onPressed: () {
                        editarTarefa(tarefa, setState);
                      },
                      child: const Text("Editar"),
                    )
                  : const SizedBox(
                      height: 1,
                    ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
            ],
          );
        },
      );
    },
  );
}

  void editarTarefa(Objetivo tarefa, void Function(void Function()) parentSetState) {
    final TextEditingController novaDescricao = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text("Editar tarefa"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: novaDescricao,
                decoration: const InputDecoration(labelText: "Nova Tarefa"),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
              if (novaDescricao.text.length < 3) {
                mostraSnack3Digitos();
              } else {
                setState(() {
                  tarefa.descricao = novaDescricao.text;
                });
                parentSetState(() {});
                Navigator.of(context).pop();
              }
            },
              child: const Text(
                "Editar",
                style: TextStyle(
                  color: Color.fromARGB(255, 50, 190, 48),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void mostraSnack3Digitos() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mínimo 3 dígitos"),
      ),
    );
  }
}
