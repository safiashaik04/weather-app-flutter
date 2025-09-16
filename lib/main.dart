import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Info',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const WeatherHome(),
    );
  }
}

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final TextEditingController _cityCtrl = TextEditingController();
  String city = '';
  int? temp;
  String? condition;

  List<Map<String, dynamic>> forecast = [];

  final List<String> conditions = const ['Sunny', 'Cloudy', 'Rainy', 'Windy', 'Foggy'];

  void fetchWeather() {
    final rnd = Random();
    setState(() {
      city = _cityCtrl.text.trim().isEmpty ? 'Unknown City' : _cityCtrl.text.trim();
      temp = 15 + rnd.nextInt(16); // 15..30
      condition = conditions[rnd.nextInt(conditions.length)];
    });
  }

  void fetch7Day() {
    final rnd = Random();
    final today = DateTime.now();
    setState(() {
      forecast = List.generate(7, (i) {
        return {
          'day': today.add(Duration(days: i)),
          'temp': 15 + rnd.nextInt(16),
          'cond': conditions[rnd.nextInt(conditions.length)],
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weather Info'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.thermostat), text: 'Today'),
              Tab(icon: Icon(Icons.calendar_today), text: '7-Day'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _todayTab(),
            _sevenDayTab(),
          ],
        ),
      ),
    );
  }

  Widget _todayTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: _cityCtrl,
            decoration: const InputDecoration(
              labelText: 'Enter city',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: fetchWeather,
            icon: const Icon(Icons.search),
            label: const Text('Fetch Weather'),
          ),
          const SizedBox(height: 24),
          if (temp != null && condition != null) ...[
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(city),
                subtitle: Text('Current weather'),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.thermostat),
                title: Text('$temp°C'),
                subtitle: Text(condition!),
              ),
            ),
          ] else
            const Text('Enter a city and tap Fetch Weather to simulate data.'),
        ],
      ),
    );
  }

  Widget _sevenDayTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: fetch7Day,
            icon: const Icon(Icons.cloud),
            label: const Text('Get 7-Day Forecast'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: forecast.isEmpty
                ? const Center(child: Text('Tap the button to simulate a 7-day forecast. '))
                : ListView.builder(
                    itemCount: forecast.length,
                    itemBuilder: (context, index) {
                      final item = forecast[index];
                      final date = item['day'] as DateTime;
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.wb_sunny),
                          title: Text(
                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                          ),
                          subtitle: Text('${item['cond']} • ${item['temp']}°C'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}