<?php
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/header_public.php";

echo "<h2>Personal CECOM</h2>";
$sql = "SELECT nombre, rol, correo, celular FROM usuarios";
$res = $conn->query($sql);
echo "<ul>";
while($r = $res->fetch_assoc()){
    echo "<li><strong>{$r['nombre']}</strong> ({$r['rol']})";
    if(!empty($r['correo'])) echo " - {$r['correo']}";
    if(!empty($r['celular'])) echo " - Cel: {$r['celular']}";
    echo "</li>";
}
echo "</ul>";

include __DIR__ . "/../includes/footer.php";
