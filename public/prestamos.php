<?php
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/header_public.php";

echo "<h2>Préstamos - (Vista pública)</h2>";
$sql = "SELECT p.id_prestamo, c.nombre as curso, c.semestre, c.seccion,
               a.nombre as ambiente, p.fecha_prestamo, p.fecha_devolucion, p.estado
        FROM prestamos p
        JOIN cursos c ON p.id_curso = c.id_curso
        JOIN ambientes a ON p.id_ambiente = a.id_ambiente
        ORDER BY p.fecha_prestamo DESC
        LIMIT 200";
$res = $conn->query($sql);

echo "<table class='table'><thead><tr><th>ID</th><th>Curso</th><th>Ambiente</th><th>Fecha</th><th>Estado</th></tr></thead><tbody>";
while($r = $res->fetch_assoc()){
    echo "<tr>";
    echo "<td>".$r['id_prestamo']."</td>";
    echo "<td>".htmlspecialchars($r['curso'])." (S".$r['semestre']."-".$r['seccion'].")</td>";
    echo "<td>".htmlspecialchars($r['ambiente'])."</td>";
    echo "<td>".$r['fecha_prestamo']."</td>";
    echo "<td>".$r['estado']."</td>";
    echo "</tr>";
}
echo "</tbody></table>";

include __DIR__ . "/../includes/footer.php";
