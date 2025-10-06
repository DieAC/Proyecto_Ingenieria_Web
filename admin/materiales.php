<?php
require_once __DIR__ . "/../includes/auth_check.php";
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/nav_admin.php";
include __DIR__ . "/../includes/header_public.php";

echo "<h2>Materiales (unidades físicas)</h2>";
echo "<p><a href='material_form.php'>+ Agregar unidad</a></p>";

$sql = "SELECT m.id_material, tm.nombre as tipo, m.codigo_material, m.estado
        FROM materiales m
        JOIN tipo_material tm ON m.id_tipo = tm.id_tipo
        ORDER BY tm.nombre, m.codigo_material";
$res = $conn->query($sql);

echo "<table class='table'><thead><tr><th>ID</th><th>Tipo</th><th>Código</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>";
while($r = $res->fetch_assoc()){
    echo "<tr>";
    echo "<td>".$r['id_material']."</td>";
    echo "<td>".htmlspecialchars($r['tipo'])."</td>";
    echo "<td>".htmlspecialchars($r['codigo_material'])."</td>";
    echo "<td>".htmlspecialchars($r['estado'])."</td>";
    echo "<td>
            <a href='material_form.php?id=".$r['id_material']."'>Editar</a> |
            <a href='procesar/eliminar_material.php?id=".$r['id_material']."' onclick='return confirm(\"Eliminar?\")'>Eliminar</a>
          </td>";
    echo "</tr>";
}
echo "</tbody></table>";

include __DIR__ . "/../includes/footer.php";
