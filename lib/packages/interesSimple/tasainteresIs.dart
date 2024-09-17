import 'package:flutter/material.dart';

class InterestRatePage extends StatefulWidget {
  const InterestRatePage({super.key});

  @override
  _InterestRatePageState createState() => _InterestRatePageState();
}

class _InterestRatePageState extends State<InterestRatePage> {
  final _initialCapitalController = TextEditingController();
  final _futureAmountController = TextEditingController();
  final _timeController = TextEditingController();
  String _timeUnit = "Años"; // Valor por defecto: Años
  double? _interestRate;

  void _calculateInterestRate() {
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final futureAmount = double.tryParse(_futureAmountController.text);
    final time = double.tryParse(_timeController.text);

    if (initialCapital != null && futureAmount != null && time != null && time != 0) {
      double timeInYears;

      // Convertir tiempo a años si la unidad seleccionada es "Meses"
      if (_timeUnit == "Meses") {
        timeInYears = time / 12;
      } else {
        timeInYears = time;
      }

      // Calcular tasa de interés usando la fórmula: Tasa = (Monto Futuro - Capital) / (Capital * Tiempo)
      final rate = (futureAmount - initialCapital) / (initialCapital * timeInYears) * 100;
      setState(() {
        _interestRate = rate;
      });
    }
  }

  void _clearFields() {
    _initialCapitalController.clear();
    _futureAmountController.clear();
    _timeController.clear();
    setState(() {
      _interestRate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calcular Tasa de Interés"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _initialCapitalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Capital Inicial',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _futureAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Monto Futuro',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tiempo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Unidad de Tiempo: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _timeUnit,
                  items: <String>["Años", "Meses"].map<DropdownMenuItem<String>>((String value) {
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
              children: [
                ElevatedButton(
                  onPressed: _calculateInterestRate,
                  child: Text("Tasa de Interés"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_interestRate != null) ...[
              SizedBox(height: 20),
              Text(
                "Tasa de Interés: ${_interestRate!.toStringAsFixed(2)} %",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
