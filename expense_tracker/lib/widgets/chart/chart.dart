import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/chart/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart(
      {super.key,
      required this.expenses,
      required this.expand,
      required this.onExpandChanged});

  final void Function() onExpandChanged;

  final List<Expense> expenses;
  final bool expand;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.work),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }

  double get totalExpenses {
    double total = 0;
    //buckets.map((bucket) => total += bucket.totalExpenses);
    for (final bucket in buckets) {
      total += bucket.totalExpenses;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: EdgeInsets.only(
            top: expand ? 16 : 6,
            left: 8,
            right: 8,
            bottom: 0,
          ),
          width: double.infinity,
          height: expand ? 230 : 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
                Theme.of(context).colorScheme.primary.withOpacity(0.0)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              if (expand)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final bucket in buckets) // alternative to map()
                        ChartBar(
                          fill: bucket.totalExpenses == 0
                              ? 0
                              : bucket.totalExpenses / maxTotalExpense,
                          value: bucket.totalExpenses,
                        )
                    ],
                  ),
                ),
              if (expand) const SizedBox(height: 12),
              if (expand)
                Row(
                  children: buckets
                      .map(
                        (bucket) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              categoryIcons[bucket.category],
                              color: isDarkMode
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: onExpandChanged,
                      icon: Icon(
                        expand ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      )),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Row(
            children: [
              const Spacer(),
              Text('Total of Expenses: \$${totalExpenses.toStringAsFixed(2)}')
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
