<?php
require_once __DIR__ . "/../includes/auth_check.php";
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/nav_admin.php";
include __DIR__ . "/../includes/header_public.php";

echo "<h2>Gestión de Préstamos</h2>";
echo "<p><a href='prestamo_form.php'>Nuevo préstamo</a></p>";

$sql = "SELECT p.id_prestamo, c.nombre as curso, c.semestre, c.seccion, a.nombre as ambiente, 
               p.fecha_prestamo, p.fecha_devolucion, p.estado
        FROM prestamos p
        JOIN cursos c ON p.id_curso=c.id_curso
        JOIN ambientes a ON p.id_ambiente=a.id_ambiente
        ORDER BY p.fecha_prestamo DESC";
$res = $conn->query($sql);

echo "<table class='table'><thead><tr><th>ID</th><th>Curso</th><th>Ambiente</th><th>Fecha</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>";
while($r = $res->fetch_assoc()){
    echo "<tr>";
    echo "<td>".$r['id_prestamo']."</td>";
    echo "<td>".htmlspecialchars($r['curso'])." (S".$r['semestre']."-".$r['seccion'].")</td>";
    echo "<td>".htmlspecialchars($r['ambiente'])."</td>";
    echo "<td>".$r['fecha_prestamo']."</td>";
    echo "<td>".$r['estado']."</td>";
    echo "<td>
            <a href='procesar/cambiar_estado_prestamo.php?id=".$r['id_prestamo']."&estado=DEVUELTO'>Marcar Devuelto</a> |
            <a href='procesar/cambiar_estado_prestamo.php?id=".$r['id_prestamo']."&estado=ATRASADO'>Marcar Atrasado</a> |
            <a href='procesar/eliminar_prestamo.php?id=".$r['id_prestamo']."' onclick='return confirm(\"Eliminar?\")'>Eliminar</a>
          </td>";
    echo "</tr>";
}
echo "</tbody></table>";

include __DIR__ . "/../includes/footer.php";
