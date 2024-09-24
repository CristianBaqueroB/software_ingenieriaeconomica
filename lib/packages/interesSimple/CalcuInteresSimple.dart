import 'package:flutter/material.dart';

class SimpleInterestCalculationPage extends StatefulWidget {
  const SimpleInterestCalculationPage({super.key});

  @override
  SimpleInterestCalculationPageState createState() => SimpleInterestCalculationPageState();
}

class SimpleInterestCalculationPageState extends State<SimpleInterestCalculationPage> {
  final _capitalController = TextEditingController();
  final _rateController = TextEditingController();
  final _yearsController = TextEditingController();
  final _monthsController = TextEditingController();
  final _daysController = TextEditingController();
  double? _result;
  String _rateType = 'Anual'; // Valor por defecto para la tasa de interés

  void _calculateInterest() {
    final capital = double.tryParse(_capitalController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;

    final years = double.tryParse(_yearsController.text) ?? 0;
    final months = double.tryParse(_monthsController.text) ?? 0;
    final days = double.tryParse(_daysController.text) ?? 0;

    // Convertir tiempo a años: meses a fracción de año y días a fracción de año
    final timeInYears = (years + (months / 12) + (days / 365));

    // Convertir tasa de porcentaje a decimal y ajustar según si es anual o mensual
    double rateInDecimal;
    if (_rateType == 'Anual') {
      rateInDecimal = rate / 100;
    } else {
      rateInDecimal = (rate / 12) / 100;
    }

    setState(() {
      // Fórmula de interés simple: Interés = Capital * Tasa * Tiempo
      _result = capital * rateInDecimal * timeInYears;
    });
  }

  void _clearFields() {
    setState(() {
      _capitalController.clear();
      _rateController.clear();
      _yearsController.clear();
      _monthsController.clear();
      _daysController.clear();
      _result = null; // Limpiar el resultado
      _rateType = 'Anual'; // Restablecer la tasa por defecto
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
            SizedBox(height: 10),
            TextField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Tasa de Interés (%)"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Tasa de Interés: ",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _rateType,
                  items: <String>['Anual', 'Mensual'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _rateType = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            // Card para ingresar años, meses y días
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tiempo:",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _yearsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Años',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: _monthsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Meses',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: _daysController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Días',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                "Interés Simple: \$${_result!.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
