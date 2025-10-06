<?php
require_once __DIR__ . "/../../includes/auth_check.php";
require_once __DIR__ . "/../../config/conexion.php";

$id_material = isset($_POST['id_material']) ? intval($_POST['id_material']) : 0;
$id_tipo = intval($_POST['id_tipo']);
$codigo = $conn->real_escape_string($_POST['codigo_material']);
$estado = $conn->real_escape_string($_POST['estado']);

if ($id_material) {
    $stmt = $conn->prepare("UPDATE materiales SET id_tipo=?, codigo_material=?, estado=? WHERE id_material=?");
    $stmt->bind_param("issi",$id_tipo,$codigo,$estado,$id_material);
    $stmt->execute();
} else {
    $stmt = $conn->prepare("INSERT INTO materiales (id_tipo, codigo_material, estado) VALUES (?,?,?)");
    $stmt->bind_param("iss",$id_tipo,$codigo,$estado);
    $stmt->execute();
}

header("Location: /cecom/admin/materiales.php");
exit;
