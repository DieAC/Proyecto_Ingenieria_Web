<?php
require_once __DIR__ . "/../../includes/auth_check.php";
require_once __DIR__ . "/../../config/conexion.php";

$id = $_GET['id'] ?? null;
if ($id) {
    $stmt = $conn->prepare("DELETE FROM anuncios WHERE id_anuncio = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
}
header("Location: ../anuncios.php");
exit;
?>
