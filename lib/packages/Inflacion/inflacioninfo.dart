import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/Inflacion/calculoinflacion.dart';
import 'package:software_ingenieriaeconomica/packages/Inflacion/calculovalordinero.dart';
import 'package:software_ingenieriaeconomica/packages/Inflacion/salarioporinflacion.dart';

class InflationPage extends StatelessWidget {
  const InflationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inflacion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Selecciona el tipo que quieres calcular:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 20),
            _calculationCard(
                context, "Calculo de Inflacion", InflationCalPage()),
            SizedBox(height: 10),
            _calculationCard(
                context, "Valor Futuro del Dinero ", FutureValuePage()),
            SizedBox(height: 10),
            _calculationCard(context, "Ajuste Salarial por Inflacion",
                SalaryAdjustmentPage()),
            SizedBox(height: 10),
            // Puedes descomentar la siguiente línea si decides incluir la página de Valor Presente
            // SizedBox(height: 10),
            // _calculationCard(context, "Valor Presente", PresentValueICPage()),
          ],
        ),
      ),
    );
  }

  Widget _calculationCard(BuildContext context, String label, Widget page) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
