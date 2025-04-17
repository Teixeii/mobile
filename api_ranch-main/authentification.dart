import 'dart:convert'; // Permet d'encoder et de décoder les données JSON
import 'package:http/http.dart' as http;
import 'api.dart';

// Définition de l'URL de l'API
const String url = "http://172.20.10.8/tp_projet_v2/api/api.php";

Future<Object> Auth(Map<String, dynamic> data) async {
  try {
    // Envoi d'une requête POST vers l'API
    final response = await http.post(
      Uri.parse(url), // Convertit l'URL
      headers: {
        "Content-Type": "application/json",
      }, // Définit le type de contenu JSON
      body: jsonEncode(
        '{"commande": 8, $data }',
      ), // Encode les données JSON pour la requête
    );

    // Vérifie si la requête a réussi (code HTTP 200)
    if (response.statusCode == 200) {
      print(
        "Succès: ${response.body}",
      ); // Affiche la réponse reçue en cas de succès

      // Création d'un objet ApiService avec la réponse de l'API
      Object app = ApiService(response.body);
      return app; // Retourne l'objet
    } else {
      // Affichage d'un message d'erreur en cas d'échec de la requête
      print("Erreur ${response.statusCode}: ${response.body}");
      return "error"; // Retourne une chaîne indiquant une erreur
    }
  } catch (e) {
    // Capture et affichage des exceptions en cas d'échec de la requête
    print("Échec de la requête: $e");
    return "error"; // Retourne une erreur en cas d'exception
  }
}
