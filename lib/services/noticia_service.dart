import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/noticia_model.dart';

class NoticiaService {
  static const String _url =
      'https://gnews.io/api/v4/top-headlines';

  // A chave será fornecida ao executar o Flutter,
  // sem precisar escrevê-la diretamente neste arquivo.
  static const String _apiKey =
      String.fromEnvironment('GNEWS_API_KEY');

  // Ative apenas para testar a tela de erro.
  static bool simularErroConexao = false;

  Future<List<NoticiaModel>> buscarNoticias() async {
    try {
      if (_apiKey.isEmpty && !simularErroConexao) {
        throw Exception(
          'Chave da GNews não configurada. '
          'Execute o app com GNEWS_API_KEY.',
        );
      }

      final uri = simularErroConexao
          ? Uri.parse(
              'https://url-invalida-para-teste.invalid/posts',
            )
          : Uri.parse(_url).replace(
              queryParameters: {
                'category': 'general',
                'lang': 'pt',
                'country': 'br',
                'max': '10',
                'apikey': _apiKey,
              },
            );

      final resposta = await http
          .get(uri)
          .timeout(const Duration(seconds: 20));

      if (resposta.statusCode == 200) {
        final Map<String, dynamic> dados =
            jsonDecode(resposta.body) as Map<String, dynamic>;

        final List<dynamic> artigos =
            dados['articles'] as List<dynamic>? ?? [];

        return artigos
            .map(
              (artigo) => NoticiaModel.fromJson(
                artigo as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      throw Exception(
        'Falha ao carregar notícias. '
        'Código HTTP: ${resposta.statusCode}. '
        '${resposta.body}',
      );
    } catch (e) {
      throw Exception('Erro ao buscar notícias: $e');
    }
  }
}
