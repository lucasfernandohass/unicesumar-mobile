import 'package:flutter/material.dart';

import '../models/filme_item.dart';
import '../main.dart';

class FilmesListView extends StatefulWidget {
  const FilmesListView({super.key, required this.filmes});

  final List<FilmeItem> filmes;

  @override
  State<FilmesListView> createState() => FilmesListViewState();
}

class FilmesListViewState extends State<FilmesListView> {
  final ScrollController scrollController = ScrollController();
  final List<FilmeItem> filmesExibidos = [];
  int paginaAtual = 0;
  bool carregando = false;
  static const int porPagina = 10;
  FilmeItem? filmeSelecionado;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    // Carrega os primeiros 10 filmes
    carregarMais();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Quando chegar a 200px do final, carrega mais
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      carregarMais();
    }
  }

  Future<void> carregarMais() async {
    if (carregando) return;
    if (filmesExibidos.length >= widget.filmes.length) return;

    setState(() {
      carregando = true;
    });

    try {
      final novosFilmes = await carregarMaisFilmes(paginaAtual, porPagina);
      if (novosFilmes.isNotEmpty) {
        setState(() {
          filmesExibidos.addAll(novosFilmes);
          paginaAtual++;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: filmesExibidos.length + 1, // +1 para o indicador
      itemBuilder: (BuildContext context, int index) {
        // Se for o último item, mostra indicador de carregamento
        if (index == filmesExibidos.length) {
          if (filmesExibidos.length < widget.filmes.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final FilmeItem filme = filmesExibidos[index];
        final bool isSelecionado = filmeSelecionado == filme;

        return Center(
          child: InkWell(
            onTap: () {
              setState(() {
                filmeSelecionado = isSelecionado ? null : filme;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 220,
              margin: const EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelecionado ? const Color(0xFF1F6FEB) : Colors.black12,
                  width: isSelecionado ? 3 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 27 / 40,
                    child: Image.network(
                      filme.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          color: const Color(0xFFB0BEC5),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder:
                          (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) {
                            return Container(
                              color: const Color(0xFFB0BEC5),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.broken_image_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      filme.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
