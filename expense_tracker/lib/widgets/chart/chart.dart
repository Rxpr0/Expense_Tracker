import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:expense_tracker/widgets/chart/chart_bar.dart';
import 'package:expense_tracker/models/expense.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    if (isDarkMode) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: scheme.surfaceContainerHigh,
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.20),
          ),
          gradient: LinearGradient(
            colors: [
              scheme.surfaceContainerHigh,
              scheme.surfaceContainer,
              scheme.primary.withValues(alpha: 0.10),
            ],
            stops: const [0.0, 0.70, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _ChartContents(
          buckets: buckets,
          maxTotalExpense: maxTotalExpense,
          iconColor: scheme.secondary,
        ),
      );
    }

    final borderColor = scheme.outlineVariant.withValues(alpha: 0.28);

    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: 0.88),
              border: Border.all(color: borderColor),
              gradient: LinearGradient(
                colors: [
                  scheme.primary.withValues(alpha: 0.10),
                  scheme.tertiary.withValues(alpha: 0.06),
                  scheme.primary.withValues(alpha: 0.00),
                ],
                stops: const [0.0, 0.65, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: _ChartContents(
                buckets: buckets,
                maxTotalExpense: maxTotalExpense,
                iconColor: scheme.primary.withValues(alpha: 0.72),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartContents extends StatelessWidget {
  const _ChartContents({
    required this.buckets,
    required this.maxTotalExpense,
    required this.iconColor,
  });

  final List<ExpenseBucket> buckets;
  final double maxTotalExpense;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final bucket in buckets)
                ChartBar(
                  fill: bucket.totalExpenses == 0
                      ? 0
                      : bucket.totalExpenses / maxTotalExpense,
                )
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: buckets
              .map(
                (bucket) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      categoryIcons[bucket.category],
                      color: iconColor,
                    ),
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}