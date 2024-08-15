import 'package:flutter/material.dart';
import 'package:register_point_app/relogio_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculo de Horas Marcadas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var diferenca = const Duration();
  List<DateTime> pontos = [];
  TimeOfDay horaSelecionada = TimeOfDay.now();

  void _adicionarPonto(TimeOfDay hora) {
    DateTime date =
        DateTime.now().copyWith(hour: hora.hour, minute: hora.minute);
    setState(() {
      pontos.add(date);
    });
  }

  void _limpar() {
    setState(() {
      pontos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    String formatarDuracao(Duration duracao) {
      int horas = duracao.inHours;
      int minutos =
          duracao.inMinutes.remainder(60); // Obtém os minutos restantes
      return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}';
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Resultado'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Marcações: ${pontos.length}'),
                  Text('Horas no Trabalho: ${formatarDuracao(diferenca)}'),
                  Text(
                      'Total em horas (- 1h de almoço): ${formatarDuracao(diferenca - Duration(hours: 1))}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  diferenca = const Duration();
                },
              ),
            ],
          );
        },
      );
    }

    void calcular() {
      pontos.sort((a, b) {
        return b.compareTo(a);
      });

      var chunks = [];
      int chunkSize = 2;

      if (pontos.isNotEmpty && pontos.length % 2 == 0) {
        for (var i = 0; i < pontos.length; i += chunkSize) {
          chunks.add(pontos.sublist(i,
              i + chunkSize > pontos.length ? pontos.length : i + chunkSize));
        }

        for (var chunk in chunks) {
          print("diferença na chunk: ${chunk[0].difference(chunk[1])}");
          diferenca += chunk[0].difference(chunk[1]);
        }

        _showMyDialog();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Relogio(horaSelecionada),
                onPressed: () async {
                  final TimeOfDay? timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: horaSelecionada,
                      initialEntryMode: TimePickerEntryMode.dial);
                  if (timeOfDay != null) {
                    setState(() {
                      horaSelecionada = timeOfDay;
                    });
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text("Calcular"),
                    onPressed: calcular,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text("Limpar"),
                    onPressed: _limpar,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: pontos.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemPonto(pontos[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarPonto(horaSelecionada),
        tooltip: 'Adicionar',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ItemPonto extends StatelessWidget {
  const ItemPonto(this.ponto, {super.key});
  final DateTime ponto;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      height: MediaQuery.sizeOf(context).height * 0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color.fromRGBO(124, 175, 196, 1),
      ),
      alignment: Alignment.center,
      child: Text("${ponto.hour}:${ponto.minute.toString().padLeft(2, '0')}",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
