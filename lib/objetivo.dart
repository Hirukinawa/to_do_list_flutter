class Objetivo {
  late int id;
  late String descricao;
  late DateTime dataCriacao;
  late DateTime? dataFinalizacao;
  late bool concluido;

  Objetivo({
    required this.id,
    required this.descricao,
    required this.dataCriacao,
    this.dataFinalizacao,
    required this.concluido,
  });

  void completaObjetivo() {
    concluido = true;
  }

}