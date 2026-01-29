import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import '../utils/app_theme.dart';

class FinanceChart extends StatelessWidget {
  final List<client.Expense> expenses;
  final bool isTrend;
  final bool isComparison;
  final Map<String, dynamic>? comparisonData;

  const FinanceChart({
    super.key, 
    required this.expenses, 
    this.isTrend = false,
    this.isComparison = false,
    this.comparisonData,
  });

  @override
  Widget build(BuildContext context) {
    if (isComparison && comparisonData != null) {
      return _buildGroupedBarChart();
    }
    if (isTrend) {
      return _buildLineChart();
    }
    return _buildBarChart();
  }

  Widget _buildGroupedBarChart() {
    final Map<int, double> thisWeek = (comparisonData!['this_week'] as Map).cast<int, double>();
    final Map<int, double> lastWeek = (comparisonData!['last_week'] as Map).cast<int, double>();
    
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxY = [
      ...thisWeek.values,
      ...lastWeek.values
    ].reduce((a, b) => a > b ? a : b) * 1.2;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withValues(alpha: 0.9),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                 final day = days[group.x.toInt() - 1];
                 final isThisWeek = rodIndex == 1;
                 return BarTooltipItem(
                   '$day - ${isThisWeek ? 'This Week' : 'Last Week'}\n',
                   const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                   children: [
                     TextSpan(
                       text: '\$${rod.toY.toStringAsFixed(0)}',
                       style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.normal),
                     ),
                   ],
                 );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt() - 1;
                  if (index >= 0 && index < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(days[index], style: const TextStyle(fontSize: 12)),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text('\$${value.toInt()}', style: const TextStyle(fontSize: 10)),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (index) {
            final day = index + 1;
            return BarChartGroupData(
              x: day,
              barRods: [
                BarChartRodData(
                  toY: lastWeek[day] ?? 0,
                  color: Colors.grey.withValues(alpha: 0.5),
                  width: 12,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                ),
                BarChartRodData(
                  toY: thisWeek[day] ?? 0,
                  color: AppTheme.emerald,
                  width: 12,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    // Group expenses by category and sum amounts
    final Map<String, double> groupedExpenses = {};
    for (var expense in expenses) {
      groupedExpenses[expense.category] = 
          (groupedExpenses[expense.category] ?? 0) + expense.amount;
    }
    
    final expenseList = groupedExpenses.entries
        .map((e) => MapEntry(e.key, e.value))
        .toList();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: expenseList.isEmpty ? 100 : expenseList.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withValues(alpha: 0.9),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${expenseList[groupIndex].key}\n',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '\$${rod.toY.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < expenseList.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        expenseList[value.toInt()].key,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('\$${value.toInt()}', style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: expenseList.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value,
                  color: _getColorForCategory(entry.value.key),
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    // Group expenses by date (day)
    final Map<DateTime, double> dailyTotals = {};
    for (var expense in expenses) {
      final date = DateTime(expense.date.year, expense.date.month, expense.date.day);
      dailyTotals[date] = (dailyTotals[date] ?? 0) + expense.amount;
    }

    final sortedDates = dailyTotals.keys.toList()..sort();
    if (sortedDates.isEmpty) return const Center(child: Text('No trend data available'));

    final spots = <FlSpot>[];
    for (int i = 0; i < sortedDates.length; i++) {
        spots.add(FlSpot(i.toDouble(), dailyTotals[sortedDates[i]]!));
    }

    // Determine color based on data type (Sales vs Expenses)
    // If majority of items are 'sale' type, use Green. Otherwise use Emerald/Orange.
    final isSalesTrend = expenses.where((e) => e.type == 'sale').length > expenses.length / 2;
    final primaryColor = isSalesTrend ? Colors.green : AppTheme.orange;
    
    return Padding(
      padding: const EdgeInsets.only(right: 24, left: 12, top: 24, bottom: 12),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 100,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.1),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (sortedDates.length / 5).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < sortedDates.length) {
                    final date = sortedDates[index];
                    return Text('${date.month}/${date.day}', style: const TextStyle(fontSize: 10));
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (value, meta) => Text('\$${value.toInt()}', style: const TextStyle(fontSize: 10)),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (sortedDates.length - 1).toDouble(),
          minY: 0,
          maxY: dailyTotals.values.reduce((a, b) => a > b ? a : b) * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withValues(alpha: 0.5)],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withValues(alpha: 0.2),
                    primaryColor.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    if (category == 'Sales') return Colors.green;
    final colors = [
      AppTheme.orange,
      Colors.blue,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[category.hashCode % colors.length];
  }
}
