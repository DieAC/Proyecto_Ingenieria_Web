<?php
require_once __DIR__ . "/../config/conexion.php";

$semestre = $_GET['semestre'] ?? null;
$seccion = $_GET['seccion'] ?? null;

if ($semestre && $seccion) {
    $stmt = $conn->prepare("SELECT id_curso, nombre FROM cursos WHERE semestre = ? AND seccion = ?");
    $stmt->bind_param("is", $semestre, $seccion);
    $stmt->execute();
    $res = $stmt->get_result();

    $data = [];
    while ($row = $res->fetch_assoc()) {
        $data[] = $row;
    }

    header('Content-Type: application/json');
    echo json_encode($data);
}
?>
