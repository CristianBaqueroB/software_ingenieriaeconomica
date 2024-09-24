import 'dart:math';
import 'package:flutter/material.dart';

class CapitalICPage extends StatefulWidget {
  const CapitalICPage({super.key});

  @override
  _CapitalICPageState createState() => _CapitalICPageState();
}

class _CapitalICPageState extends State<CapitalICPage> {
  final _futureAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _yearsController = TextEditingController();
  final _monthsController = TextEditingController();
  final _daysController = TextEditingController();
  String _interestRateType = "Anual"; // Tipo de tasa de interés (Anual, Mensual, etc.)
  double? _calculatedCapital;

  void _calculateCapital() {
    final futureAmount = double.tryParse(_futureAmountController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final years = double.tryParse(_yearsController.text) ?? 0;
    final months = double.tryParse(_monthsController.text) ?? 0;
    final days = double.tryParse(_daysController.text) ?? 0;

    if (futureAmount != null && interestRate != null && interestRate != 0) {
      // Convertir tiempo a años
      final timeInYears = years;
      final timeInYearsMonths = months / 12;
      final timeInYearsDays = days / 365;

      // Calcular el tiempo total en años
      final totalTimeInYears = timeInYears + timeInYearsMonths + timeInYearsDays;

      // Calcular el periodo de inversión (PI) según el tipo de tasa
      double adjustedInterestRate;
      int periods;
      switch (_interestRateType) {
        case "Mensual":
          adjustedInterestRate = (interestRate / 100) ;
          periods = (totalTimeInYears *12).round(); // Multiplicar por 12 meses en un año
          break;
        case "Bimestral":
          adjustedInterestRate = (interestRate / 100) ;
          periods = (totalTimeInYears * 6).round(); // Multiplicar por 6 bimestres en un año
          break;
        case "Trimestral":
          adjustedInterestRate = (interestRate / 100) ;
          periods = (totalTimeInYears * 4).round(); // Multiplicar por 4 trimestres en un año
          break;
        case "Semestral":
          adjustedInterestRate = (interestRate / 100) ;
          periods = (totalTimeInYears * 2).round(); // Multiplicar por 2 semestres en un año
          break;
        default:
          adjustedInterestRate = interestRate / 100; // Tasa anual
          periods = totalTimeInYears.round(); // Para anual, el número de períodos es igual a los años
      }

      // Calcular el capital inicial usando la fórmula de interés compuesto
      final capital = futureAmount / pow((1 + adjustedInterestRate), periods);

      setState(() {
        _calculatedCapital = capital;
      });
    }
  }

  void _clearFields() {
    setState(() {
      _futureAmountController.clear();
      _interestRateController.clear();
      _yearsController.clear();
      _monthsController.clear();
      _daysController.clear();
      _interestRateType = "Anual"; // Restablecer el tipo de tasa por defecto
      _calculatedCapital = null; // Limpiar el resultado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calcular Capital Inicial"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tiempo:",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
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
            const Text(
              "Tipo de Tasa de Interés:",
              style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _interestRateType,
              items: const [
                DropdownMenuItem(
                  value: "Anual",
                  child: Text("Anual"),
                ),
                DropdownMenuItem(
                  value: "Mensual",
                  child: Text("Mensual"),
                ),
                DropdownMenuItem(
                  value: "Bimestral",
                  child: Text("Bimestral"),
                ),
                DropdownMenuItem(
                  value: "Trimestral",
                  child: Text("Trimestral"),
                ),
                DropdownMenuItem(
                  value: "Semestral",
                  child: Text("Semestral"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _interestRateType = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateCapital,
                  child: const Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_calculatedCapital != null) ...[
              const SizedBox(height: 10),
              Text(
                "Capital Inicial: ${_calculatedCapital!.toStringAsFixed(2)}",
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
