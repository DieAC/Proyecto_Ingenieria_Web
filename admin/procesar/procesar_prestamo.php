<?php
require_once __DIR__ . "/../../includes/auth_check.php";
require_once __DIR__ . "/../../config/conexion.php";

$id_curso = intval($_POST['id_curso']);
$id_ambiente = intval($_POST['id_ambiente']);
$id_material = intval($_POST['id_material']);
$id_tecnico = $_SESSION['id_usuario'];      // quien lo registra
// encargado puede ser el admin por defecto (id 1), o seleccionar; aquí usamos el admin actual como aprobador
$id_encargado = 1;

$conn->begin_transaction();
try {
    $stmt = $conn->prepare("INSERT INTO prestamos (id_curso, id_tecnico, id_encargado, id_ambiente, fecha_prestamo, estado) VALUES (?,?,?,?,NOW(),'PENDIENTE')");
    $stmt->bind_param("iiii",$id_curso, $id_tecnico, $id_encargado, $id_ambiente);
    $stmt->execute();
    $id_prestamo = $conn->insert_id;

    $stmt2 = $conn->prepare("INSERT INTO detalle_prestamo (id_prestamo, id_material) VALUES (?,?)");
    $stmt2->bind_param("ii",$id_prestamo, $id_material);
    $stmt2->execute();

    // actualizar estado de la unidad a 'prestado'
    $upd = $conn->prepare("UPDATE materiales SET estado='prestado' WHERE id_material = ?");
    $upd->bind_param("i",$id_material);
    $upd->execute();

    $conn->commit();
    header("Location: /cecom/admin/prestamos.php");
    exit;
} catch (Exception $e) {
    $conn->rollback();
    echo "Error: " . $e->getMessage();
}
