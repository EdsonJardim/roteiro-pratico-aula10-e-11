
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/noticia_model.dart';

class NoticiaService {
  static const String _url =
      'https://jsonplaceholder.typicode.com/posts';

  // Ative apenas para testar a tela de erro.
  static bool simularErroConexao = false;

  Future<List<NoticiaModel>> buscarNoticias() async {
    try {
      final url = simularErroConexao
          ? 'https://url-invalida-para-teste.invalid/posts'
          : _url;

      final resposta = await http.get(Uri.parse(url));

      if (resposta.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(resposta.body);

        return dados
            .map(
              (json) => NoticiaModel.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      throw Exception(
        'Falha ao carregar notícias. '
        'Código HTTP: ${resposta.statusCode}',
      );
    } catch (e) {
      throw Exception('Erro ao buscar notícias: $e');
    }
  }
}
