import 'package:flutter/material.dart';

class InterestRatePageIS extends StatefulWidget {
  const InterestRatePageIS({super.key});

  @override
  InterestRatePageState createState() => InterestRatePageState();
}

class InterestRatePageState extends State<InterestRatePageIS> {
  final _initialCapitalController = TextEditingController();
  final _futureAmountController = TextEditingController();
  final _yearsController = TextEditingController();
  final _monthsController = TextEditingController();
  final _daysController = TextEditingController();
  double? _interestRate;

  void _calculateInterestRate() {
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final futureAmount = double.tryParse(_futureAmountController.text);
    final years = double.tryParse(_yearsController.text) ?? 0;
    final months = double.tryParse(_monthsController.text) ?? 0;
    final days = double.tryParse(_daysController.text) ?? 0;

    // Convertir todo a años
    double timeInYears = years + (months / 12) + (days / 365);

    if (initialCapital != null && futureAmount != null && timeInYears > 0) {
      // Calcular tasa de interés
      final rate = (futureAmount / initialCapital) ;
      final rate1=rate-1;
      final rate2=rate1/ timeInYears  ;
      final rate3=rate2*100; // Convertir a porcentaje
      setState(() {
        _interestRate = rate3;
      });
    } else {
      setState(() {
        _interestRate = null; // Limpiar resultado si los datos son inválidos
      });
    }
  }

  void _clearFields() {
    _initialCapitalController.clear();
    _futureAmountController.clear();
    _yearsController.clear();
    _monthsController.clear();
    _daysController.clear();
    setState(() {
      _interestRate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calcular Tasa de Interés"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _initialCapitalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Capital Inicial',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _futureAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto Final',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
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
                  onPressed: _calculateInterestRate,
                  child: const Text("Tasa de Interés"),
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
                const SizedBox(width: 20),
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
            if (_interestRate != null) ...[
              const SizedBox(height: 20),
              Text(
                "Tasa de Interés: ${_interestRate!.toStringAsFixed(2)} %",
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
