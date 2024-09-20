import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;
  const TransactionForm(this.onSubmit, {super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _title = TextEditingController();
  final _value = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm(BuildContext context) {
    final titleControler = _title.text;
    final valueContoler = double.tryParse(_value.text) ?? 0.0;

    if (titleControler.isEmpty || valueContoler <= 0) {
      FocusScope.of(context).unfocus();
      return;
    }

    widget.onSubmit(titleControler, valueContoler, _selectedDate);

    // Remove o foco de qualquer campo de texto ativo, fazendo o teclado desaparecer
    FocusScope.of(context).unfocus();
  }

  _showDatePicker(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null){
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });

    });
  }

  @override
  Widget build(BuildContext context) {

  final locale = Localizations.maybeLocaleOf(context).toString();
  print(locale);
  final data = DateFormat('EEE, dd/MM/y', locale).format(_selectedDate);

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _title,
              onSubmitted: (_) => _submitForm(context),
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _value,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(context),
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
              ),
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: [
                        const Text("Data selecionada: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(data),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: Text('Selecionar Data',
                      style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                  ),
                  child: Text(
                    'Nova transação',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.labelLarge!.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
