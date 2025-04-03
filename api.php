<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

require_once 'bdd_pdo.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';

    if ($action === 'login') {
        $email = trim($_POST['username'] ?? '');
        $password = trim($_POST['password'] ?? '');

        if (empty($email) || empty($password)) {
            echo json_encode([
                "success" => false,
                "message" => "Champs requis manquants"
            ]);
            exit;
        }

        try {
            $stmt = $pdo->prepare("SELECT * FROM user WHERE emailuser = :email");
            $stmt->execute(['email' => $email]);
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user && $user['mdp'] === $password) {
                echo json_encode([
                    "success" => true,
                    "message" => "Connexion réussie",
                    "user" => [
                        "id" => $user['iduser'],
                        "nom" => $user['nomuser'],
                        "prenom" => $user['prenomuser'],
                        "email" => $user['emailuser']
                    ]
                ]);
            } else {
                echo json_encode([
                    "success" => false,
                    "message" => "Identifiants incorrects"
                ]);
            }
        } catch (PDOException $e) {
            echo json_encode([
                "success" => false,
                "message" => "Erreur serveur : " . $e->getMessage()
            ]);
        }
    } elseif ($action === 'inscription') {
        $userId = $_POST['user_id'] ?? '';
        $coursId = $_POST['cours_id'] ?? '';

        if (empty($userId) || empty($coursId)) {
            echo json_encode([
                "success" => false,
                "message" => "Champs requis manquants"
            ]);
            exit;
        }

        try {
            // Vérifier si le cours a déjà 8 inscrits
            $stmt = $pdo->prepare("SELECT COUNT(*) as count FROM inscrit WHERE idcours = :cours_id");
            $stmt->execute(['cours_id' => $coursId]);
            $count = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($count['count'] >= 8) {
                echo json_encode([
                    "success" => false,
                    "message" => "Ce cours est complet"
                ]);
                exit;
            }

            $stmt = $pdo->prepare("INSERT INTO inscrit (idcavalier, idcours) VALUES (:user_id, :cours_id)");
            $stmt->execute(['user_id' => $userId, 'cours_id' => $coursId]);
            echo json_encode([
                "success" => true,
                "message" => "Inscription réussie"
            ]);
        } catch (PDOException $e) {
            echo json_encode([
                "success" => false,
                "message" => "Erreur serveur : " . $e->getMessage()
            ]);
        }
    } elseif ($action === 'desinscription') {
        $userId = $_POST['user_id'] ?? '';
        $coursId = $_POST['cours_id'] ?? '';

        if (empty($userId) || empty($coursId)) {
            echo json_encode([
                "success" => false,
                "message" => "Champs requis manquants"
            ]);
            exit;
        }

        try {
            $stmt = $pdo->prepare("DELETE FROM inscrit WHERE idcavalier = :user_id AND idcours = :cours_id");
            $stmt->execute(['user_id' => $userId, 'cours_id' => $coursId]);
            echo json_encode([
                "success" => true,
                "message" => "Désinscription réussie"
            ]);
        } catch (PDOException $e) {
            echo json_encode([
                "success" => false,
                "message" => "Erreur serveur : " . $e->getMessage()
            ]);
        }
    } elseif ($action === 'voir_inscrits') {
        $coursId = $_POST['cours_id'] ?? '';

        if (empty($coursId)) {
            echo json_encode([
                "success" => false,
                "message" => "Champs requis manquants"
            ]);
            exit;
        }

        try {
            $stmt = $pdo->prepare("
                SELECT u.nomuser as nom, u.prenomuser as prenom
                FROM inscrit i
                JOIN user u ON i.idcavalier = u.iduser
                WHERE i.idcours = :cours_id
            ");
            $stmt->execute(['cours_id' => $coursId]);
            $inscrits = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode([
                "success" => true,
                "inscrits" => $inscrits
            ]);
        } catch (PDOException $e) {
            echo json_encode([
                "success" => false,
                "message" => "Erreur serveur : " . $e->getMessage()
            ]);
        }
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Action non reconnue"
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Méthode non autorisée"
    ]);
}
?>
