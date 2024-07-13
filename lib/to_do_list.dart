import 'package:flutter/material.dart';
import 'package:to_do_list_flutter/objetivo.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<Objetivo> emAberto = [];
  List<Objetivo> concluidos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de tarefas"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              emAberto.isNotEmpty
                  ? exibeEmAberto()
                  : const Text("Nenhuma tarefa adicionada"),
              concluidos.isNotEmpty
                  ? exibeConcluidos()
                  : const Text("Nenhuma tarefa concluída"),
            ],
          ),
        ),
      ),
    );
  }

  Widget exibeEmAberto() {
    return Column(
      children: emAberto.map(
        (obj) {
          return Row(
            children: [
              Checkbox(
                value: obj.concluido,
                onChanged: (bool? value) {
                  setState(
                    () {
                      obj.concluido = value ?? false;
                      if (obj.concluido) {
                        emAberto.remove(obj);
                        concluidos.add(obj);
                      }
                    },
                  );
                },
              ),
              Text(obj.descricao),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget exibeConcluidos() {
    return Column(
      children: concluidos.map((obj) => Text(obj.descricao)).toList(),
    );
  }
}
