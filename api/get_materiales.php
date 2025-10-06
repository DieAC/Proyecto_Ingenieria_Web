<?php
// api/get_materiales.php
require_once __DIR__ . "/../config/conexion.php";
header('Content-Type: application/json; charset=utf-8');

$id_tipo = isset($_GET['id_tipo']) ? intval($_GET['id_tipo']) : 0;
if (!$id_tipo) { echo json_encode([]); exit; }

$sql = "SELECT id_material, codigo_material, estado FROM materiales WHERE id_tipo = ? AND estado = 'disponible' ORDER BY codigo_material";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i",$id_tipo);
$stmt->execute();
$res = $stmt->get_result();
$out = [];
while($r = $res->fetch_assoc()) $out[] = $r;
echo json_encode($out);
