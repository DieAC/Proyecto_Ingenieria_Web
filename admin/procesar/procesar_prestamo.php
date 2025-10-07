<?php
require_once __DIR__ . "/../../includes/auth_check.php";
require_once __DIR__ . "/../../config/conexion.php";

$id_curso = $_POST['id_curso'];
$id_ambiente = $_POST['id_ambiente'];
$fecha_prestamo = $_POST['fecha_prestamo'];
$fecha_devolucion = $_POST['fecha_devolucion'] ?? null;
$id_encargado = $_SESSION['id_usuario'];
$id_tecnico = $_SESSION['id_usuario'];
$estado = 'PENDIENTE';

// ✅ este array puede tener varios materiales seleccionados
$materiales = $_POST['materiales'] ?? [];

// --- 1. Registrar préstamo principal ---
$stmt = $conn->prepare("INSERT INTO prestamos 
    (id_curso, id_tecnico, id_encargado, id_ambiente, fecha_prestamo, fecha_devolucion, estado)
    VALUES (?, ?, ?, ?, ?, ?, ?)");
$stmt->bind_param("iiiisss", $id_curso, $id_tecnico, $id_encargado, $id_ambiente, $fecha_prestamo, $fecha_devolucion, $estado);
$stmt->execute();
$id_prestamo = $conn->insert_id;

// --- 2. Registrar los materiales seleccionados ---
if (!empty($materiales)) {
    $stmt_det = $conn->prepare("INSERT INTO detalle_prestamo (id_prestamo, id_material) VALUES (?, ?)");

    foreach ($materiales as $id_material) {
        if (!is_numeric($id_material)) continue; // evitar valores vacíos

        $stmt_det->bind_param("ii", $id_prestamo, $id_material);
        $stmt_det->execute();

        // Cambiar estado del material a "prestado"
        $conn->query("UPDATE materiales SET estado = 'prestado' WHERE id_material = $id_material");
    }
}

// --- 3. Redirigir ---
header("Location: ../prestamos.php");
exit;
?>
