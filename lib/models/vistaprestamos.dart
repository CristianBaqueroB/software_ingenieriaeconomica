// lib/screens/gestion_prestamos_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:software_ingenieriaeconomica/admin/controladmin/controllvistaprestamo.dart';
import 'package:software_ingenieriaeconomica/admin/controladmin/modelvistasprestamos.dart';

class GestionPrestamosPage extends StatefulWidget {
  @override
  _GestionPrestamosPageState createState() => _GestionPrestamosPageState();
}

class _GestionPrestamosPageState extends State<GestionPrestamosPage> {
  final LoanController _loanController = LoanController();
  String _filtroEstado = 'todos';
  Future<List<Loan>>? _loanListFuture;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  void _loadLoans() {
    _loanListFuture = _loanController.fetchLoans(_filtroEstado);
  }

  void _updateLoanStatus(String loanId, String newStatus) async {
    try {
      await _loanController.updateLoanStatus(loanId, newStatus);
      _loadLoans(); // Recargar préstamos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado actualizado a: $newStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el estado.')),
      );
    }
  }

  Future<void> _editLoanDetails(BuildContext context, Loan loan) async {
    final _interesController = TextEditingController(text: loan.interes.toString());
    final _totalAPagarController = TextEditingController(text: loan.totalAPagar.toString());
    final _cantidadPagadaController = TextEditingController(text: loan.cantidadPagada.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Detalles del Préstamo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campos de edición
                _buildTextField(_interesController, 'Interés'),
                SizedBox(height: 10),
                _buildTextField(_totalAPagarController, 'Total a Pagar'),
                SizedBox(height: 10),
                _buildTextField(_cantidadPagadaController, 'Cantidad Pagada por el Usuario'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () async {
                // Guardar los cambios
                double parsedInteres = double.parse(_interesController.text);
                double parsedTotalAPagar = double.parse(_totalAPagarController.text);
                double parsedCantidadPagada = double.parse(_cantidadPagadaController.text);

                try {
                  await _loanController.editLoanDetails(loan.id, parsedInteres, parsedTotalAPagar, parsedCantidadPagada);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Detalles del préstamo actualizados con éxito.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar los detalles.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Préstamos'),
        backgroundColor: Color.fromARGB(255, 133, 238, 159),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _filtroEstado,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Filtrar por estado',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'todos', child: Text('Todos')),
                DropdownMenuItem(value: 'pendiente', child: Text('Pendientes')),
                DropdownMenuItem(value: 'aceptado', child: Text('Aceptados')),
                DropdownMenuItem(value: 'rechazado', child: Text('Rechazados')),
              ],
              onChanged: (value) {
                setState(() {
                  _filtroEstado = value!;
                  _loadLoans(); // Recargar préstamos con nuevo filtro
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Loan>>(
              future: _loanListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar las solicitudes.'));
                }

                final loans = snapshot.data ?? [];

                if (loans.isEmpty) {
                  return Center(child: Text('No hay préstamos disponibles.'));
                }

                return ListView.builder(
                  itemCount: loans.length,
                  itemBuilder: (context, index) {
                    final loan = loans[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text('Préstamo: ${loan.montoPrestamo}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estado: ${loan.estado}'),
                            Text('Fecha de Solicitud: ${DateFormat('dd/MM/yyyy').format(loan.fechaSolicitud)}'),
                            Text('Fecha Límite: ${DateFormat('dd/MM/yyyy').format(loan.fechaLimite)}'),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editLoanDetails(context, loan),
                            ),
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () => _updateLoanStatus(loan.id, 'aceptado'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
