<?php
require_once __DIR__ . "/../../includes/auth_check.php";
require_once __DIR__ . "/../../config/conexion.php";
$id = isset($_GET['id'])? intval($_GET['id']) : 0;
if ($id) {
    // Intentar eliminar; si hay FK referenciando, dará error (o puedes usar lógica para solo marcar inactivo)
    $stmt = $conn->prepare("DELETE FROM materiales WHERE id_material = ?");
    $stmt->bind_param("i",$id);
    $stmt->execute();
}
header("Location: /cecom/admin/materiales.php");
exit;
