import 'package:flutter/material.dart';

class CapitalPage extends StatefulWidget {
  const CapitalPage({super.key});

  @override
  _CapitalPageState createState() => _CapitalPageState();
}

class _CapitalPageState extends State<CapitalPage> {
  final _futureAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _timeController = TextEditingController();
  String _timeUnit = "Años"; // Valor por defecto: Años
  String _interestRateType = "Anual"; // Valor por defecto: Anual
  double? _calculatedCapital;

  void _calculateCapital() {
    final futureAmount = double.tryParse(_futureAmountController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final time = double.tryParse(_timeController.text);

    if (futureAmount != null && interestRate != null && time != null && interestRate != 0 && time != 0) {
      double timeInYears;

      // Convertir tiempo a años dependiendo de la unidad seleccionada
      if (_timeUnit == "Meses") {
        timeInYears = time / 12;
      } else if (_timeUnit == "Días") {
        timeInYears = time / 365;
      } else {
        timeInYears = time;
      }

      // Ajustar la tasa de interés si es anual y el tiempo está en meses
      double adjustedInterestRate  ;
      if (_interestRateType == "Mensual" ) {
        adjustedInterestRate = interestRate/ 12;
      }else  {
        adjustedInterestRate = interestRate; // Tasa anual
      }

      // Calcular capital usando la fórmula: Capital = Monto Futuro / (1 + Tasa * Tiempo)
      final capital = futureAmount / (1+(adjustedInterestRate) * timeInYears);
      setState(() {
        _calculatedCapital = capital;
      });
    }
  }

  void _clearFields() {
    setState(() {
      _futureAmountController.clear();
      _interestRateController.clear();
      _timeController.clear();
      _timeUnit = "Años"; // Restablecer la unidad por defecto
      _interestRateType = "Anual"; // Restablecer el tipo de tasa por defecto
      _calculatedCapital = null; // Limpiar el resultado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calcular Capital"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            SizedBox(height: 20),
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
              controller: _interestRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tasa de Interés (%)',
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
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Tipo de Tasa de Interés: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _interestRateType,
                  items: <String>["Anual", "Mensual"].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _interestRateType = newValue!;
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
                  onPressed: _calculateCapital,
                  child: Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Cambia el color del botón de limpiar
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  child: Text("Limpiar"),
                ),
              ],
            ),
            if (_calculatedCapital != null) ...[
              SizedBox(height: 20),
              Text(
                "Capital: \$${_calculatedCapital!.toStringAsFixed(2)}",
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
