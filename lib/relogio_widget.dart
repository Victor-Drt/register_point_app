import 'package:flutter/material.dart';

class Relogio extends StatefulWidget {
  const Relogio(this.horaSelecionada, {super.key});

  final TimeOfDay horaSelecionada;

  @override
  State<Relogio> createState() => _RelogioState();
}

class _RelogioState extends State<Relogio> {
  @override
  Widget build(BuildContext context) {
    var hora = widget.horaSelecionada;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color.fromRGBO(124, 175, 196, 1),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Text(
        "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}",
        style: const TextStyle(
            fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
