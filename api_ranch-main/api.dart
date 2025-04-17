import 'dart:convert'; // Permet d'encoder et de décoder les données JSON
import 'package:http/http.dart' as http; // Bibliothèque pour les requêtes HTTP

// Définition de la classe ApiService pour gérer les requêtes vers l'API
class ApiService {
  // URL du serveur API
  static const String url =
      "http://172.20.10.8/tp_projet_v2_flutter/api_ranch-main/api.php";

  // Identifiant de l'utilisateur (fourni lors de l'instanciation de la classe)
  String id;

  // Constructeur de la classe ApiService
  ApiService(this.id);

  // Méthode pour récupérer la liste des cours
  Future<String> GetCours() async {
    try {
      // Envoi d'une requête POST à l'API
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "commande": 1,
        }), // Envoi de la commande 1 pour obtenir les cours
      );

      // Vérifie si la requête est réussie (code HTTP 200)
      if (response.statusCode == 200) {
        print("Succès: ${response.body}");
        return response.body;
      } else {
        print("Erreur ${response.statusCode}: ${response.body}");
        return "error";
      }
    } catch (e) {
      print("Échec de la requête: $e");
      return "error";
    }
  }

  // Méthode pour récupérer les inscriptions de l'utilisateur
  Future<String> GetInscription() async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "commande": 2,
          "id": id,
        }), // Envoi de la commande 2 avec l'ID utilisateur
      );

      if (response.statusCode == 200) {
        print("Succès: ${response.body}");
        return response.body;
      } else {
        print("Erreur ${response.statusCode}: ${response.body}");
        return "error";
      }
    } catch (e) {
      print("Échec de la requête: $e");
      return "error";
    }
  }

  // Méthode pour récupérer la participation de l'utilisateur
  Future<String> GetParticipation() async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "commande": 3,
          "id": id,
        }), // Envoi de la commande 3 avec l'ID utilisateur
      );

      if (response.statusCode == 200) {
        print("Succès: ${response.body}");
        return response.body;
      } else {
        print("Erreur ${response.statusCode}: ${response.body}");
        return "error";
      }
    } catch (e) {
      print("Échec de la requête: $e");
      return "error";
    }
  }

  // Méthode pour mettre à jour une participation
  Future<String> UpdateParticipation(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "commande": 4,
          "data": data,
          "id": id,
        }), // Commande 4 avec les données et l'ID
      );

      if (response.statusCode == 200) {
        print("Succès: ${response.body}");
        return response.body;
      } else {
        print("Erreur ${response.statusCode}: ${response.body}");
        return "error";
      }
    } catch (e) {
      print("Échec de la requête: $e");
      return "error";
    }
  }

  // Méthode pour créer une nouvelle participation
  Future<String> CreateParticipation(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "commande": 5,
          "data": data,
          "id": id,
        }), // Commande 5 pour création
      );

      if (response.statusCode == 200) {
        print("Succès: ${response.body}");
        return response.body;
      } else {
        print("Erreur ${response.statusCode}: ${response.body}");
        return "error";
      }
    } catch (e) {
      print("Échec de la requête: $e");
      return "error";
    }
  }

  // Méthode pour créer une inscription
  Future<String> CreateInscription(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "commande": 6,
          "data": data,
          "id": id,
        }), // Commande 6 pour création d'inscription
      );

      if (response.statusCode == 200) {
        print("Succès: ${response.body}");
        return response.body;
      } else {
        print("Erreur ${response.statusCode}: ${response.body}");
        return "error";
      }
    } catch (e) {
      print("Échec de la requête: $e");
      return "error";
    }
  }

  // Méthode pour supprimer une inscription
  Future<String> DeleteInscription(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "commande": 7,
          "data": data,
          "id": id,
        }), // Commande 7 pour suppression
      );

      if (response.statusCode == 200) {
        print("Succès: ${response.body}");
        return response.body;
      } else {
        print("Erreur ${response.statusCode}: ${response.body}");
        return "error";
      }
    } catch (e) {
      print("Échec de la requête: $e");
      return "error";
    }
  }
}
