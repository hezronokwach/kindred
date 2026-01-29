import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import '../utils/app_theme.dart';
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/app_animations.dart';

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
      padding: const EdgeInsets.all(20.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: AppColors.slateMedium.withOpacity(0.9),
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                 final day = days[group.x.toInt() - 1];
                 final isThisWeek = rodIndex == 1;
                 return BarTooltipItem(
                   '$day\n',
                   AppTypography.title.copyWith(fontSize: 14),
                   children: [
                     TextSpan(
                       text: '${isThisWeek ? 'This' : 'Last'} Week: \$${rod.toY.toStringAsFixed(0)}',
                       style: AppTypography.body.copyWith(
                        color: isThisWeek ? AppColors.emeraldLight : AppColors.gray400,
                        fontSize: 12,
                       ),
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
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        days[index], 
                        style: AppTypography.caption,
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
                getTitlesWidget: (value, meta) => Text(
                  '\$${value.toInt()}', 
                  style: AppTypography.caption,
                ),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.white.withOpacity(0.05),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (index) {
            final day = index + 1;
            return BarChartGroupData(
              x: day,
              barRods: [
                BarChartRodData(
                  toY: lastWeek[day] ?? 0,
                  color: AppColors.slateLight.withOpacity(0.4),
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: thisWeek[day] ?? 0,
                  gradient: AppColors.primaryGradient,
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final Map<String, double> groupedExpenses = {};
    for (var expense in expenses) {
      groupedExpenses[expense.category] = 
          (groupedExpenses[expense.category] ?? 0) + expense.amount;
    }
    
    final expenseList = groupedExpenses.entries
        .map((e) => MapEntry(e.key, e.value))
        .toList();
    
    final maxVal = expenseList.isEmpty ? 100.0 : expenseList.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVal,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: AppColors.slateMedium.withOpacity(0.9),
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${expenseList[groupIndex].key}\n',
                  AppTypography.title.copyWith(fontSize: 14),
                  children: [
                    TextSpan(
                      text: '\$${rod.toY.toStringAsFixed(2)}',
                      style: AppTypography.data.copyWith(fontSize: 14),
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
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        expenseList[value.toInt()].key,
                        style: AppTypography.caption,
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
                  return Text(
                    '\$${value.toInt()}', 
                    style: AppTypography.caption,
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxVal / 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.white.withOpacity(0.05),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: expenseList.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value,
                  gradient: LinearGradient(
                    colors: [
                      _getColorForCategory(entry.value.key),
                      _getColorForCategory(entry.value.key).withOpacity(0.7),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 24,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
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
    final Map<DateTime, double> dailyTotals = {};
    for (var expense in expenses) {
      final date = DateTime(expense.date.year, expense.date.month, expense.date.day);
      dailyTotals[date] = (dailyTotals[date] ?? 0) + expense.amount;
    }

    final sortedDates = dailyTotals.keys.toList()..sort();
    if (sortedDates.isEmpty) return Center(child: Text('No trend data available', style: AppTypography.body));

    final spots = <FlSpot>[];
    for (int i = 0; i < sortedDates.length; i++) {
        spots.add(FlSpot(i.toDouble(), dailyTotals[sortedDates[i]]!));
    }

    final isSalesTrend = expenses.where((e) => e.type == 'sale').length > expenses.length / 2;
    final primaryColor = isSalesTrend ? AppColors.emeraldPrimary : AppColors.sky;
    final maxVal = dailyTotals.values.reduce((a, b) => a > b ? a : b) * 1.2;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 24, 24, 12),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxVal / 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.white.withOpacity(0.05),
              strokeWidth: 1,
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: AppColors.slateMedium.withOpacity(0.9),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final date = sortedDates[spot.x.toInt()];
                  return LineTooltipItem(
                    '${date.month}/${date.day}\n',
                    AppTypography.title.copyWith(fontSize: 14),
                    children: [
                      TextSpan(
                        text: '\$${spot.y.toStringAsFixed(2)}',
                        style: AppTypography.data.copyWith(fontSize: 14),
                      ),
                    ],
                  );
                }).toList();
              },
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '${date.month}/${date.day}', 
                        style: AppTypography.caption,
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
                reservedSize: 42,
                getTitlesWidget: (value, meta) => Text(
                  '\$${value.toInt()}', 
                  style: AppTypography.caption,
                ),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (sortedDates.length - 1).toDouble(),
          minY: 0,
          maxY: maxVal,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.3)],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: primaryColor,
                  strokeWidth: 2,
                  strokeColor: AppColors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.2),
                    primaryColor.withOpacity(0.0),
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
    if (category == 'Sales') return AppColors.emeraldPrimary;
    final colors = [
      AppColors.sky,
      AppColors.amber,
      AppColors.rose,
      Colors.purpleAccent,
      Colors.indigoAccent,
    ];
    return colors[category.hashCode % colors.length];
  }
}
