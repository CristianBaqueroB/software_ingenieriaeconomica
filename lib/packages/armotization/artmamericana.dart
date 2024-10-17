import 'package:flutter/material.dart';

class AmericanAmortization extends StatefulWidget {
  const AmericanAmortization({super.key});

  @override
  _AmericanAmortizationState createState() => _AmericanAmortizationState();
}

class _AmericanAmortizationState extends State<AmericanAmortization> {
  final TextEditingController _loanAmountController = TextEditingController(); // Monto del préstamo
  final TextEditingController _annualRateController = TextEditingController(); // Tasa de interés

  final TextEditingController _yearsController = TextEditingController(); // Años
  final TextEditingController _monthsController = TextEditingController(); // Meses
  final TextEditingController _daysController = TextEditingController(); // Días

  double _totalMonths = 0; // Total de meses calculados
  double _fixedInterestPayment = 0; // Pagos periódicos de intereses
  double _finalPayment = 0; // Pago final del capital
  List<Map<String, dynamic>> _interestPayments = []; // Pagos individuales de intereses

  String _interestType = 'Anual'; // Tipo de tasa de interés

  // Función para convertir el tiempo a meses
  void _convertTimeToMonths() {
    setState(() {
      int years = int.tryParse(_yearsController.text) ?? 0;
      int months = int.tryParse(_monthsController.text) ?? 0;
      int days = int.tryParse(_daysController.text) ?? 0;

      // Convertir años a meses y días a meses
      _totalMonths = (years) + months + (days / 30);
    });
  }

  // Función para convertir la tasa de interés dependiendo del tipo seleccionado
  double _getInterestRate() {
    double rate = double.tryParse(_annualRateController.text) ?? 0.0;

    switch (_interestType) {
      case 'Mensual':
        return rate / 100; // La tasa ya es mensual
      case 'Diaria':
        return rate / 100 * 30; // Convertir tasa diaria a mensual
      default:
        return rate / 100; // Convertir tasa anual a mensual
    }
  }

  // Función para calcular la amortización americana
  void _calculateAmortization() {
    setState(() {
      double loanAmount = double.tryParse(_loanAmountController.text) ?? 0.0;
      double monthlyRate = _getInterestRate();

      // Convertir tiempo a meses
      _convertTimeToMonths();

      if (_totalMonths > 0 && loanAmount > 0 && monthlyRate > 0) {
        // Limpiar resultados anteriores
        _interestPayments.clear();

        // Calcular los pagos periódicos de intereses
        _fixedInterestPayment = loanAmount * monthlyRate;

        // Calcular el pago final del capital
        _finalPayment = loanAmount;

        // Generar pagos individuales de intereses por cada mes
        for (int month = 1; month <= _totalMonths; month++) {
          _interestPayments.add({
            'month': month,
            'interest': _fixedInterestPayment,
            'isFinal': month == _totalMonths,
          });
        }
      }
    });
  }

  // Función para limpiar los campos
  void _clearFields() {
    setState(() {
      _loanAmountController.clear();
      _annualRateController.clear();
      _yearsController.clear();
      _monthsController.clear();
      _daysController.clear();
      _totalMonths = 0;
      _fixedInterestPayment = 0;
      _finalPayment = 0;
      _interestPayments.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amortización Americana'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ingrese los datos del préstamo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _loanAmountController,
              decoration: const InputDecoration(
                labelText: 'Monto del préstamo (USD)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number, // Solo números
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _annualRateController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number, // Solo números
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _interestType,
              items: <String>['Anual', 'Mensual', 'Diaria']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('Tasa de interés $value'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _interestType = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Ingrese el tiempo del préstamo:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _yearsController,
                      decoration: const InputDecoration(
                        labelText: 'Años',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number, // Solo números
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _monthsController,
                      decoration: const InputDecoration(
                        labelText: 'Meses',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number, // Solo números
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _daysController,
                      decoration: const InputDecoration(
                        labelText: 'Días',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number, // Solo números
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAmortization,
              child: const Text('Calcular Amortización'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearFields, // Llamar a la función para limpiar los campos
              child: const Text('Limpiar Campos'),
            ),
            const SizedBox(height: 20),
            if (_fixedInterestPayment > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pago continuo de intereses: ${_fixedInterestPayment.toStringAsFixed(2)} USD',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Pago final de capital: ${_finalPayment.toStringAsFixed(2)} USD',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pagos de intereses individuales:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _interestPayments.length,
                    itemBuilder: (context, index) {
                      final payment = _interestPayments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            'Pago ${payment['isFinal'] ? 'final (Mes ' : ' (Mes '}${payment['month']}): Interés = ${payment['interest'].toStringAsFixed(2)} USD${payment['isFinal'] ? ' + Capital = ${(_finalPayment + payment['interest']).toStringAsFixed(2)} USD' : ''}',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}


