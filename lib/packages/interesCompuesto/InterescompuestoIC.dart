import 'package:flutter/material.dart';

class InterestCompoundPage extends StatefulWidget {
  const InterestCompoundPage({super.key});

  @override
  _InterestCompoundPageState createState() => _InterestCompoundPageState();
}

class _InterestCompoundPageState extends State<InterestCompoundPage> {
  final _futureAmountController = TextEditingController();
  final _initialCapitalController = TextEditingController();
  final _timeController = TextEditingController();
  final _capitalizationFrequencyController = TextEditingController();
// Valor por defecto: Años
  double? _interestCompound;

  void _calculateInterestCompound() {
    final futureAmount = double.tryParse(_futureAmountController.text);
    final initialCapital = double.tryParse(_initialCapitalController.text);

    if (futureAmount != null && initialCapital != null) {
      // Calcular el interés compuesto usando la fórmula IC = MC - C
      final interestCompound = futureAmount - initialCapital;

      setState(() {
        _interestCompound = interestCompound;
      });
    } else {
      setState(() {
        _interestCompound = null; // Asegurarse de limpiar el resultado si los datos son inválidos
      });
    }
  }

  void _clearFields() {
    _futureAmountController.clear();
    _initialCapitalController.clear();
    _timeController.clear();
    _capitalizationFrequencyController.clear();
    setState(() {
      _interestCompound = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calcular Interés Compuesto"),
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
                labelText: 'Monto Futuro (MC)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _initialCapitalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Capital Inicial (C)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateInterestCompound,
                  child: Text("Calcular"),
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
                SizedBox(width: 80), // Espacio entre los botones
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
            if (_interestCompound != null) ...[
              SizedBox(height: 10),
              Text(
                "Interés Compuesto: \$${_interestCompound!.toStringAsFixed(2)}",
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
