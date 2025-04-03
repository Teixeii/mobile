import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connexion Ecuries de l\'Horizon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFCCA46),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF4F2200),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEB5C1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFF4F2200)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFEB5C1E)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<User?> _callYourApi(String username, String password) async {
    final response = await http.post(
      Uri.parse(
        'http://172.20.10.8/tp_projet_v2_flutter/api_ranch-main/api.php',
      ),
      body: {'username': username, 'password': password, 'action': 'login'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return User.fromJson(data['user']);
      }
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      User? user = await _callYourApi(
        _usernameController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
        );
      } else {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Erreur'),
                content: Text('Identifiants incorrects'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/logcav.webp', fit: BoxFit.cover),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: Offset(4, 4),
                    ),
                  ],
                  border: Border.all(color: Color(0xFFBC5D2E).withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO ICI
                    Container(
                      width: 100,
                      height: 100,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/cheval.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ECURIES DE L\'HORIZON',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bienvenue sur votre espace de gestion cavalier',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Color(0xFF707070),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _usernameController,
                            label: 'Email',
                            icon: Icons.person,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Mot de passe',
                            icon: Icons.lock,
                            isPassword: true,
                          ),
                          SizedBox(height: 32),
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFEB5C1E),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14.0,
                                    horizontal: 64.0,
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Text(
                                  'Connexion',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFFBC5D2E)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.95),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Color(0xFFBC5D2E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Color(0xFFEB5C1E), width: 2.0),
        ),
      ),
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? 'Ce champ est obligatoire'
                  : null,
    );
  }
}

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ProfilePage(user: widget.user),
      CoursesPage(user: widget.user),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Cours'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFEB5C1E),
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({required this.user});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bienvenue ${user.prenom} ${user.nom}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Email : ${user.email}', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: Icon(Icons.logout),
            label: Text('Déconnexion'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEB5C1E),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Cours {
  final String id;
  final String libelle;
  final String heureDebut;
  final String heureFin;
  final String jour;

  Cours({
    required this.id,
    required this.libelle,
    required this.heureDebut,
    required this.heureFin,
    required this.jour,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      id: json['id'].toString(),
      libelle: json['libelle'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      jour: json['jour'],
    );
  }
}

class CoursesPage extends StatefulWidget {
  final User user;
  const CoursesPage({required this.user, super.key});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<List<Cours>> _coursList;

  @override
  void initState() {
    super.initState();
    _coursList = fetchCours();
  }

  Future<List<Cours>> fetchCours() async {
    final response = await http.get(
      Uri.parse(
        'http://172.20.10.8/tp_projet_v2_flutter/api_ranch-main/get_cours.php',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Cours.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des cours');
    }
  }

  Future<void> _inscrireCours(String coursId) async {
    final response = await http.post(
      Uri.parse(
        'http://172.20.10.8/tp_projet_v2_flutter/api_ranch-main/api.php',
      ),
      body: {
        'action': 'inscription',
        'user_id': widget.user.id,
        'cours_id': coursId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Inscription réussie')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'inscription')),
        );
      }
    }
  }

  Future<void> _desinscrireCours(String coursId) async {
    final response = await http.post(
      Uri.parse(
        'http://172.20.10.8/tp_projet_v2_flutter/api_ranch-main/api.php',
      ),
      body: {
        'action': 'desinscription',
        'user_id': widget.user.id,
        'cours_id': coursId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Désinscription réussie')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la désinscription')),
        );
      }
    }
  }

  Future<void> _voirInscrits(String coursId) async {
    final response = await http.post(
      Uri.parse(
        'http://172.20.10.8/tp_projet_v2_flutter/api_ranch-main/api.php',
      ),
      body: {'action': 'voir_inscrits', 'cours_id': coursId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Inscrits au cours'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                      data['inscrits'].map<Widget>((inscrit) {
                        return Text('${inscrit['prenom']} ${inscrit['nom']}');
                      }).toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la récupération des inscrits'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des cours'),
        backgroundColor: Color(0xFFEB5C1E),
      ),
      body: FutureBuilder<List<Cours>>(
        future: _coursList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun cours trouvé'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cours = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(cours.libelle),
                    subtitle: Text(
                      'Jour : ${cours.jour}\nDe ${cours.heureDebut} à ${cours.heureFin}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAnimatedButton(
                          Icons.add,
                          () => _inscrireCours(cours.id),
                        ),
                        _buildAnimatedButton(
                          Icons.remove,
                          () => _desinscrireCours(cours.id),
                        ),
                        _buildAnimatedButton(
                          Icons.people,
                          () => _voirInscrits(cours.id),
                        ),
                      ],
                    ),
                    onTap: () => _voirInscrits(cours.id),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildAnimatedButton(IconData icon, VoidCallback onPressed) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;

        return GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          onTap: onPressed,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(isPressed ? 12 : 8),
            decoration: BoxDecoration(
              color:
                  isPressed
                      ? Color(0xFFEB5C1E).withOpacity(0.3)
                      : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFFEB5C1E)),
          ),
        );
      },
    );
  }
}
