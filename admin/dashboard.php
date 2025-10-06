<?php
require_once __DIR__ . "/../includes/auth_check.php";
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/nav_admin.php";
include __DIR__ . "/../includes/header_public.php";

echo "<h2>Panel - Bienvenido ".htmlspecialchars($_SESSION['nombre'])."</h2>";

// algunos contadores rápidos
$c1 = $conn->query("SELECT COUNT(*) as c FROM prestamos WHERE estado='PENDIENTE'")->fetch_assoc()['c'];
$c2 = $conn->query("SELECT COUNT(*) as c FROM materiales")->fetch_assoc()['c'];
echo "<p>Préstamos pendientes: <b>$c1</b></p>";
echo "<p>Total unidades registradas: <b>$c2</b></p>";

include __DIR__ . "/../includes/footer.php";
