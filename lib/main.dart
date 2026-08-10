import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MediaEscolarPage(),
    );
  }
}

class MediaEscolarPage extends StatefulWidget {
  const MediaEscolarPage({super.key});

  @override
  State<MediaEscolarPage> createState() => _MediaEscolarPageState();
}

class _MediaEscolarPageState extends State<MediaEscolarPage> {
  final nomeController = TextEditingController();
  final nota1Controller = TextEditingController();
  final nota2Controller = TextEditingController();
  final nota3Controller = TextEditingController();
  final nota4Controller = TextEditingController();
  final frequenciaController = TextEditingController();

  String nomeAluno = '';
  String situacao = '';

  double media = 0;
  double maiorNota = 0;
  double menorNota = 0;
  double faltou = 0;

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void calcularMedia() {
    String nome = nomeController.text.trim();

    double? n1 = double.tryParse(nota1Controller.text.replaceAll(',', '.'));
    double? n2 = double.tryParse(nota2Controller.text.replaceAll(',', '.'));
    double? n3 = double.tryParse(nota3Controller.text.replaceAll(',', '.'));
    double? n4 = double.tryParse(nota4Controller.text.replaceAll(',', '.'));
    double? frequencia = double.tryParse(
      frequenciaController.text.replaceAll(',', '.'),
    );

    if (nome.isEmpty ||
        n1 == null ||
        n2 == null ||
        n3 == null ||
        n4 == null ||
        frequencia == null) {
      mostrarMensagem("Preencha todos os campos.");
      return;
    }

    if (n1 < 0 ||
        n1 > 10 ||
        n2 < 0 ||
        n2 > 10 ||
        n3 < 0 ||
        n3 > 10 ||
        n4 < 0 ||
        n4 > 10) {
      mostrarMensagem("As notas devem ser entre 0 e 10.");
      return;
    }

    if (frequencia < 0 || frequencia > 100) {
      mostrarMensagem("A frequência deve estar entre 0 e 100.");
      return;
    }

    List<double> notas = [n1, n2, n3, n4];

    double mediaCalculada = (n1 + n2 + n3 + n4) / 4;

    double maior = notas.reduce((a, b) => a > b ? a : b);

    double menor = notas.reduce((a, b) => a < b ? a : b);

    double pontosFaltando = mediaCalculada >= 7 ? 0 : 7 - mediaCalculada;

    String situacaoCalculada;

    if (frequencia < 75) {
      situacaoCalculada = "REPROVADO POR FREQUÊNCIA";
    } else if (mediaCalculada >= 7) {
      situacaoCalculada = "APROVADO";
    } else if (mediaCalculada >= 5) {
      situacaoCalculada = "RECUPERAÇÃO";
    } else {
      situacaoCalculada = "REPROVADO";
    }

    setState(() {
      nomeAluno = nome;
      media = mediaCalculada;
      maiorNota = maior;
      menorNota = menor;
      faltou = pontosFaltando;
      situacao = situacaoCalculada;
    });
  }

  void limparCampos() {
    nomeController.clear();
    nota1Controller.clear();
    nota2Controller.clear();
    nota3Controller.clear();
    nota4Controller.clear();
    frequenciaController.clear();

    setState(() {
      nomeAluno = '';
      media = 0;
      maiorNota = 0;
      menorNota = 0;
      faltou = 0;
      situacao = '';
    });
  }

  IconData escolherIcone() {
    if (situacao == "APROVADO") {
      return Icons.check_circle;
    }

    if (situacao == "RECUPERAÇÃO") {
      return Icons.warning;
    }

    return Icons.cancel;
  }

  @override
  void dispose() {
    nomeController.dispose();
    nota1Controller.dispose();
    nota2Controller.dispose();
    nota3Controller.dispose();
    nota4Controller.dispose();
    frequenciaController.dispose();
    super.dispose();
  }

  Widget campoNota(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.edit),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculador de Média"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.school, size: 80),

            const SizedBox(height: 10),

            const Text(
              "Média Escolar",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

            campoNota(nota1Controller, "Nota 1"),
            campoNota(nota2Controller, "Nota 2"),
            campoNota(nota3Controller, "Nota 3"),
            campoNota(nota4Controller, "Nota 4"),

            TextField(
              controller: frequenciaController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "Frequência (%)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.percent),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: calcularMedia,
              icon: const Icon(Icons.calculate),
              label: const Text("Calcular Média"),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: limparCampos,
              icon: const Icon(Icons.delete),
              label: const Text("Limpar"),
            ),

            const SizedBox(height: 25),

            if (situacao.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(escolherIcone(), size: 70),

                      const SizedBox(height: 10),

                      Text(
                        nomeAluno,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Média: ${media.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 20),
                      ),

                      Text("Maior nota: ${maiorNota.toStringAsFixed(1)}"),

                      Text("Menor nota: ${menorNota.toStringAsFixed(1)}"),

                      Text("Faltaram: ${faltou.toStringAsFixed(2)} ponto(s)"),

                      const SizedBox(height: 10),

                      Text(
                        situacao,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
