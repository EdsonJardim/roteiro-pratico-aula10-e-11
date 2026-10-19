class NoticiaModel {
  final int id;
  final int autorId;
  final String titulo;
  final String resumo;
  final String conteudoCompleto;
  final String autor;
  final String urlImagem;
  final DateTime? dataPublicacao;

  NoticiaModel({
    required this.id,
    required this.autorId,
    required this.titulo,
    required this.resumo,
    required this.conteudoCompleto,
    required this.autor,
    required this.urlImagem,
    this.dataPublicacao,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    final String tituloJson =
        json['title']?.toString() ?? 'Sem título';

    final String resumoJson =
        json['description']?.toString() ?? 'Sem resumo disponível.';

    final String conteudo =
        json['content']?.toString() ??
        resumoJson;

    final String imagemJson =
        json['image']?.toString() ?? '';

    final Map<String, dynamic> fonte =
        json['source'] is Map<String, dynamic>
            ? json['source'] as Map<String, dynamic>
            : <String, dynamic>{};

    final String autorJson =
        fonte['name']?.toString() ?? 'Fonte não informada';

    final String? dataJson =
        json['publishedAt']?.toString();

    final DateTime? data =
        dataJson == null ? null : DateTime.tryParse(dataJson);

    final String idTexto =
        json['url']?.toString() ?? '$tituloJson|$autorJson';

    final int idJson = idTexto.hashCode.abs();

    return NoticiaModel(
      id: idJson,
      autorId: 0,
      titulo: tituloJson,
      resumo: resumoJson,
      conteudoCompleto: conteudo,
      autor: autorJson,
      urlImagem: imagemJson,
      dataPublicacao: data,
    );
  }
}