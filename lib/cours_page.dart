import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoursPage extends StatefulWidget {
  @override
  _CoursPageState createState() => _CoursPageState();
}

class _CoursPageState extends State<CoursPage> {
  List<dynamic> _cours = [];
  List<dynamic> _filteredCours = [];
  bool _isLoading = true;
  String _errorMessage = '';

  String _searchQuery = '';
  String _selectedDay = 'Tous';
  String _selectedStartTime = '';
  String _selectedEndTime = '';

  List<String> _joursDisponibles = ['Tous'];

  @override
  void initState() {
    super.initState();
    _fetchCours();
  }

  Future<void> _fetchCours() async {
    try {
      final response = await http.post(
        Uri.parse(
          "http://127.0.0.1/tp_projet_v2_flutter/api_ranch-main/api.php",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"commande": 1}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          _cours = data;
          _joursDisponibles.addAll(
            _cours
                .map((c) => (c['jour'] ?? '').toString())
                .toSet()
                .where((j) => j.isNotEmpty),
          );
          _applyFilters();
        } else {
          throw Exception('Format de données invalide');
        }
      } else {
        throw Exception('Erreur HTTP');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur : $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredCours =
          _cours.where((cours) {
            final lib = cours['libcours']?.toLowerCase() ?? '';
            final jour = cours['jour'] ?? '';
            final hd = cours['hd'] ?? '';
            final hf = cours['hf'] ?? '';

            final matchTitle = lib.contains(_searchQuery.toLowerCase());
            final matchDay = _selectedDay == 'Tous' || jour == _selectedDay;
            final matchStart =
                _selectedStartTime.isEmpty ||
                hd.compareTo(_selectedStartTime) >= 0;
            final matchEnd =
                _selectedEndTime.isEmpty || hf.compareTo(_selectedEndTime) <= 0;

            return matchTitle && matchDay && matchStart && matchEnd;
          }).toList();
    });
  }

  Widget _buildTimeField(
    String label,
    String initialValue,
    ValueChanged<String> onChanged,
  ) {
    final controller = TextEditingController(text: initialValue);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.access_time),
      ),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des Cours')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // CHAMPS DE FILTRES
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Filtrer par titre',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (val) {
                        _searchQuery = val;
                        _applyFilters();
                      },
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedDay,
                      items:
                          _joursDisponibles
                              .map(
                                (j) =>
                                    DropdownMenuItem(child: Text(j), value: j),
                              )
                              .toList(),
                      onChanged: (val) {
                        _selectedDay = val!;
                        _applyFilters();
                      },
                      decoration: InputDecoration(
                        labelText: 'Filtrer par jour',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            'Heure début min',
                            _selectedStartTime,
                            (val) {
                              _selectedStartTime = val;
                              _applyFilters();
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildTimeField(
                            'Heure fin max',
                            _selectedEndTime,
                            (val) {
                              _selectedEndTime = val;
                              _applyFilters();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // LISTE DES COURS
                    Expanded(
                      child:
                          _filteredCours.isEmpty
                              ? Center(child: Text("Aucun cours trouvé."))
                              : ListView.builder(
                                itemCount: _filteredCours.length,
                                itemBuilder: (context, index) {
                                  final cours = _filteredCours[index];
                                  return Card(
                                    child: ListTile(
                                      title: Text(cours['libcours']),
                                      subtitle: Text(
                                        'De ${cours['hd']} à ${cours['hf']}',
                                      ),
                                      trailing: Text(cours['jour'] ?? ''),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}
