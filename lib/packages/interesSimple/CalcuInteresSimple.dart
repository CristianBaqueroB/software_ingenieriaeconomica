import 'package:flutter/material.dart';

class SimpleInterestCalculationPage extends StatefulWidget {
  const SimpleInterestCalculationPage({super.key});

  @override
  _SimpleInterestCalculationPageState createState() => _SimpleInterestCalculationPageState();
}

class _SimpleInterestCalculationPageState extends State<SimpleInterestCalculationPage> {
  final _capitalController = TextEditingController();
  final _rateController = TextEditingController();
  final _timeController = TextEditingController();
  String _timeUnit = "Años"; // Valor por defecto: Años
  double? _result;

  void _calculateInterest() {
    final capital = double.tryParse(_capitalController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final time = double.tryParse(_timeController.text) ?? 0;

    double timeInYears;

    // Convertir tiempo a años dependiendo de la unidad seleccionada
    if (_timeUnit == "Meses") {
      timeInYears = time / 12;
    } else if (_timeUnit == "Días") {
      timeInYears = time / 365;
    } else {
      timeInYears = time;
    }

    setState(() {
      _result = capital * rate * timeInYears;
    });
  }

  void _clearFields() {
    setState(() {
      _capitalController.clear();
      _rateController.clear();
      _timeController.clear();
      _timeUnit = "Años"; // Restablecer a la unidad por defecto
      _result = null; // Limpiar el resultado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cálculo de Interés Simple"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _capitalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Capital"),
            ),
            TextField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Tasa de Interés (en decimal)"),
            ),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Tiempo"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Unidad de Tiempo: ",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _timeUnit,
                  items: <String>["Años", "Meses", "Días"].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _timeUnit = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _calculateInterest,
                  child: Text("Calcular"),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Cambia el color del botón
                  ),
                  child: Text("Limpiar"),
                ),
              ],
            ),
            if (_result != null) ...[
              SizedBox(height: 20),
              Text(
                "Interés Simple: ${_result!.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
