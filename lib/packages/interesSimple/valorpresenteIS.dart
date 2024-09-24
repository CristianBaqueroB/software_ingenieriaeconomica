import 'package:flutter/material.dart';

class VPresent extends StatefulWidget {
  const VPresent({super.key});

  @override
  _VPresentState createState() => _VPresentState();
}

class _VPresentState extends State<VPresent> {
  final _futureAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _yearsController = TextEditingController();
  final _monthsController = TextEditingController();
  final _daysController = TextEditingController();
  double? _presentValue;
  String _interestFrequency = "Anual"; // Valor por defecto: Anual

  void _calculatePresentValue() {
    final futureAmount = double.tryParse(_futureAmountController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final years = double.tryParse(_yearsController.text);
    final months = double.tryParse(_monthsController.text);
    final days = double.tryParse(_daysController.text);

    if (futureAmount != null && interestRate != null && (years != null || months != null || days != null)) {
      // Convertir porcentaje a decimal
      final rateDecimal = interestRate / 100;

      double timeInYears = years ?? 0;
      if (months != null) {
        timeInYears += months / 12; // Convertir meses a años
      }
      if (days != null) {
        timeInYears += days / 365; // Convertir días a años
      }

      // Calcular valor presente usando la fórmula de valor presente
      final calculatedPresentValue = futureAmount / (1+ rateDecimal * timeInYears);

      setState(() {
        _presentValue = calculatedPresentValue;
      });
    } else {
      setState(() {
        _presentValue = null; // Asegurarse de limpiar el resultado si los datos son inválidos
      });
    }
  }

  void _clearFields() {
    _futureAmountController.clear();
    _interestRateController.clear();
    _yearsController.clear();
    _monthsController.clear();
    _daysController.clear();
    setState(() {
      _presentValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calcular Valor Presente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Card para ingresar monto futuro y tasa de interés
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _futureAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Monto Futuro',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _interestRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Tasa de Interés (%)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "Frecuencia de Interés: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _interestFrequency,
                          items: <String>["Anual", "Mensual"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _interestFrequency = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Card para ingresar años, meses y días
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tiempo:",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _yearsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Años',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: _monthsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Meses',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: _daysController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
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
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculatePresentValue,
                  child: const Text("Valor Presente"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_presentValue != null) ...[
              const SizedBox(height: 10),
              Text(
                "Valor Presente: ${_presentValue!.toStringAsFixed(2)}",
                style: const TextStyle(
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
