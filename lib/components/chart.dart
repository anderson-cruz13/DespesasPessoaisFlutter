import 'package:despesas_pessoais/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.recentTransaction});

  final List<Transaction> recentTransaction;
  List<Map<String, Object>> get groupedTransactions{
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;
      for(var i = 0; i < recentTransaction.length; i++){
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMoth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if(sameDay && sameMoth && sameYear){
          totalSum += recentTransaction[i].value;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum};
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, e) => sum + (e['value'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((e){
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: e['day'] as String, 
                value: (e['value'] as double), 
                percentage: _weekTotalValue == 0 ? 0 : (e['value'] as double) / _weekTotalValue));
          }).toList(),
        ),
      ),
    );
  }
} 