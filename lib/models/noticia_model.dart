
class NoticiaModel {
  final int id;
  final int autorId;
  final String titulo;
  final String resumo;
  final String conteudoCompleto;
  final String autor;
  final String urlImagem;

  NoticiaModel({
    required this.id,
    required this.autorId,
    required this.titulo,
    required this.resumo,
    required this.conteudoCompleto,
    required this.autor,
    required this.urlImagem,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    final String conteudo = json['body']?.toString() ??
        'Sem conteúdo disponível.';

    final String tituloJson =
        json['title']?.toString() ?? 'Sem título';

    final int idJson = json['id'] is int
        ? json['id'] as int
        : int.tryParse(json['id']?.toString() ?? '') ?? 0;

    final int usuarioJson = json['userId'] is int
        ? json['userId'] as int
        : int.tryParse(json['userId']?.toString() ?? '') ?? 1;

    final String resumoJson = conteudo.length > 40
        ? '${conteudo.substring(0, 40)}...'
        : conteudo;

    return NoticiaModel(
      id: idJson,
      autorId: usuarioJson,
      titulo: tituloJson,
      resumo: resumoJson,
      conteudoCompleto: conteudo,
      autor: 'Autor ID $usuarioJson',
      urlImagem: 'https://picsum.photos/seed/noticia$idJson/900/400',
    );
  }
}
