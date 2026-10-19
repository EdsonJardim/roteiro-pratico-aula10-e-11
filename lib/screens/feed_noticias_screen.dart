import 'package:flutter/material.dart';

import '../models/noticia_model.dart';
import '../services/noticia_service.dart';
import 'detalhe_noticia_screen.dart';

class FeedNoticiasScreen extends StatefulWidget {
  const FeedNoticiasScreen({super.key});

  @override
  State<FeedNoticiasScreen> createState() => _FeedNoticiasScreenState();
}

class _FeedNoticiasScreenState extends State<FeedNoticiasScreen> {
  final NoticiaService _service = NoticiaService();
  final TextEditingController _pesquisaController = TextEditingController();

  List<NoticiaModel> _noticias = [];
  bool _carregando = false;
  String? _erro;
  String _termoPesquisa = '';

  @override
  void initState() {
    super.initState();
    _carregarNoticias();
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  Future<void> _carregarNoticias() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final noticias = await _service.buscarNoticias();

      if (!mounted) return;

      setState(() {
        _noticias = noticias;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  List<NoticiaModel> get _noticiasFiltradas {
    final termo = _termoPesquisa.trim().toLowerCase();

    if (termo.isEmpty) return _noticias;

    return _noticias.where((noticia) {
      return noticia.titulo.toLowerCase().contains(termo);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed de Notícias'),
        actions: [
          IconButton(
            tooltip: 'Atualizar notícias',
            onPressed: _carregando ? null : _carregarNoticias,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _pesquisaController,
              onChanged: (valor) {
                setState(() {
                  _termoPesquisa = valor;
                });
              },
              decoration: InputDecoration(
                labelText: 'Pesquisar notícia pelo título',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _termoPesquisa.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar pesquisa',
                        onPressed: () {
                          _pesquisaController.clear();
                          setState(() {
                            _termoPesquisa = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: _buildConteudo()),
        ],
      ),
    );
  }

  Widget _buildConteudo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 56, color: Colors.red),
              const SizedBox(height: 12),
              const Text(
                'Não foi possível carregar as notícias.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _carregarNoticias,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_noticias.isEmpty) {
      return const Center(child: Text('Nenhuma notícia encontrada na API.'));
    }

    final noticias = _noticiasFiltradas;

    if (noticias.isEmpty) {
      return const Center(
        child: Text('Nenhuma notícia corresponde à pesquisa.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarNoticias,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        itemCount: noticias.length,
        itemBuilder: (context, index) {
          final noticia = noticias[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Hero(
                tag: 'noticia-${noticia.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    noticia.urlImagem,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              title: Text(
                noticia.titulo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  noticia.resumo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetalheNoticiaScreen(noticia: noticia),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
