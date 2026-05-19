import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Passo 2: provider global simples para representar App State.
// Qualquer widget que tenha acesso ao Riverpod pode ler/alterar esse valor.
final StateProvider<int> contadorGlobalProvider = StateProvider<int>(
  (ref) => 0,
);

// Passo 1: setup do Riverpod no ponto de entrada.
void main() {
  runApp(
    // ProviderScope e obrigatorio para armazenar o estado de todos os providers.
    // Sem ele, o Riverpod nao consegue gerenciar nem distribuir estado no app.
    const ProviderScope(child: MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula - Gestao de Estado',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B7285)),
        useMaterial3: true,
      ),
      home: const TelaGestaoEstado(),
    );
  }
}

// Passo 3: tela principal dividida em duas metades com Column + Expanded.
class TelaGestaoEstado extends StatelessWidget {
  const TelaGestaoEstado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local State vs App State (Riverpod)'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Column(
          children: [
            // Metade superior: exemplo classico com StatefulWidget e setState.
            Expanded(child: PainelLocalState()),
            Divider(height: 1),
            // Metade inferior: exemplo com Riverpod e estado global.
            Expanded(child: PainelAppState()),
          ],
        ),
      ),
    );
  }
}

// Passo 4: metade Local State usando StatefulWidget.
class PainelLocalState extends StatefulWidget {
  const PainelLocalState({super.key});

  @override
  State<PainelLocalState> createState() => _PainelLocalStateState();
}

class _PainelLocalStateState extends State<PainelLocalState> {
  int _contadorLocal = 0;

  void _incrementarLocal() {
    // setState reconstrui apenas este widget e seus filhos.
    // Esse estado e local: nao e compartilhado com outras telas.
    setState(() {
      _contadorLocal++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Metade 1 - Local State (StatefulWidget)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Este contador usa setState(). O dado "morre" se este widget for destruido '
            'e nao e compartilhado com o restante do app.',
          ),
          const Spacer(),
          Text(
            'Valor local: $_contadorLocal',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _incrementarLocal,
            icon: const Icon(Icons.add),
            label: const Text('Incrementar Local State'),
          ),
        ],
      ),
    );
  }
}

// Passo 5: metade App State com ConsumerWidget.
class PainelAppState extends ConsumerWidget {
  const PainelAppState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch: usado dentro do build para observar mudancas e reconstruir a UI.
    final int contadorGlobal = ref.watch(contadorGlobalProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Metade 2 - App State (Riverpod)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Este contador e global (App State). Pode ser lido e alterado por qualquer '
            'widget que acesse o provider.',
          ),
          const Spacer(),
          Text(
            'Valor global: $contadorGlobal',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              // Passo 6 - Regra de ouro:
              // watch -> dentro do build para escutar mudancas e atualizar a tela.
              // read -> em eventos/metodos (como clique) para ler/alterar sem escutar.
              ref.read(contadorGlobalProvider.notifier).state++;
            },
            icon: const Icon(Icons.public),
            label: const Text('Incrementar App State (Riverpod)'),
          ),
        ],
      ),
    );
  }
}
