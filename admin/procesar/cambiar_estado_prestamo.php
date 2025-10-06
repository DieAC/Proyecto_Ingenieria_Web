<?php
require_once __DIR__ . "/../../includes/auth_check.php";
require_once __DIR__ . "/../../config/conexion.php";

$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
$estado = isset($_GET['estado']) ? $conn->real_escape_string($_GET['estado']) : '';
if ($id && in_array($estado, ['DEVUELTO','ATRASADO','PENDIENTE'])) {
    // si marca DEVUELTO, liberar las unidades asociadas
    if ($estado === 'DEVUELTO') {
        // cambiar estado de las unidades a disponible
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
    }
    $upd = $conn->prepare("UPDATE prestamos SET estado = ? WHERE id_prestamo = ?");
    $upd->bind_param("si",$estado,$id);
    $upd->execute();
}

header("Location: /cecom/admin/prestamos.php");
exit;
