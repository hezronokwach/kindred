import 'package:flutter/material.dart';
import '../services/serverpod_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Map<String, dynamic>? _testResults;
  String? _systemStatus;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _getSystemStatus();
  }

  Future<void> _getSystemStatus() async {
    try {
      final status = await ServerpodService.getSystemStatus();
      setState(() {
        _systemStatus = status;
      });
    } catch (e) {
      setState(() {
        _systemStatus = 'Error: $e';
      });
    }
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isRunning = true;
      _testResults = null;
    });

    try {
      final results = await ServerpodService.runAllTests();
      setState(() {
        _testResults = results;
      });
    } catch (e) {
      setState(() {
        _testResults = {'error': e.toString()};
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
      await _getSystemStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migration Test Suite'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'System Status',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_systemStatus ?? 'Loading...'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _getSystemStatus,
                      child: const Text('Refresh Status'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Migration Tests',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Verify all functionality works with Serverpod backend:'),
                    const SizedBox(height: 8),
                    const Text('• Inventory operations (get, search, update)'),
                    const Text('• Financial operations (balance, affordability)'),
                    const Text('• Action operations (stock updates, CRUD)'),
                    const Text('• Data persistence across operations'),
                    const Text('• Expense tracking and categorization'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isRunning ? null : _runAllTests,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                      ),
                      child: _isRunning
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('Running Tests...'),
                              ],
                            )
                          : const Text('Run All Tests'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test Results
            if (_testResults != null)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Test Results',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _testResults!['overall_status'] == 'PASSED'
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _testResults!['overall_status'] ?? 'UNKNOWN',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: _buildTestResults(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResults() {
    if (_testResults == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _testResults!.entries.map((entry) {
        if (entry.key == 'overall_status' || entry.key == 'timestamp') {
          return const SizedBox();
        }

        if (entry.value is Map<String, dynamic>) {
          final testGroup = entry.value as Map<String, dynamic>;
          final status = testGroup['status'] ?? 'UNKNOWN';
          
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.key.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: status == 'PASSED' ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...testGroup.entries
                      .where((e) => e.key != 'status' && e.key != 'error')
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 4),
                            child: Row(
                              children: [
                                Text('${e.key}: '),
                                Text(
                                  e.value.toString(),
                                  style: TextStyle(
                                    color: e.value == 'PASSED' ? Colors.green : 
                                           e.value == 'FAILED' ? Colors.red : null,
                                    fontWeight: e.value == 'PASSED' || e.value == 'FAILED' 
                                        ? FontWeight.bold : null,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  if (testGroup['error'] != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: Text(
                        'Error: ${testGroup['error']}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text('${entry.key}: ${entry.value}'),
        );
      }).toList(),
    );
  }
}
