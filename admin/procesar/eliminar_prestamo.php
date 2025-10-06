<?php
require_once __DIR__ . "/../../includes/auth_check.php";
require_once __DIR__ . "/../../config/conexion.php";
$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
if ($id) {
    // antes de eliminar, volver las unidades a disponible
    $sql = "SELECT id_material FROM detalle_prestamo WHERE id_prestamo = ?";
    $st = $conn->prepare($sql);
    $st->bind_param("i",$id);
    $st->execute();
    $res = $st->get_result();
    while($r = $res->fetch_assoc()){
        $u = intval($r['id_material']);
        $up = $conn->prepare("UPDATE materiales SET estado='disponible' WHERE id_material = ?");
        $up->bind_param("i",$u);
        $up->execute();
    }
    // eliminar detalle + prestamo (detalle tiene FK ON DELETE CASCADE)
    $del = $conn->prepare("DELETE FROM prestamos WHERE id_prestamo = ?");
    $del->bind_param("i",$id);
    $del->execute();
}
header("Location: /cecom/admin/prestamos.php");
exit;
