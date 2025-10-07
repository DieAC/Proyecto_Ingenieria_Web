<?php
require_once __DIR__ . "/../includes/auth_check.php";
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/header_admin.php";

echo "<h2>Gestión de Préstamos</h2>";
echo "<p><a class='btn' href='prestamo_form.php'>+ Nuevo Préstamo</a></p>";

$sql = "
SELECT 
    p.id_prestamo,
    d.nombre AS docente,
    e.nombre AS estudiante,
    e.apellido AS apellido_est,
    c.semestre,
    c.seccion,
    c.nombre AS curso,
    GROUP_CONCAT(CONCAT(tm.nombre, ' (', m.codigo_material, ')') SEPARATOR ', ') AS materiales,
    p.fecha_prestamo,
    p.estado
FROM prestamos p
JOIN cursos c ON p.id_curso = c.id_curso
LEFT JOIN docentes d ON c.id_docente = d.id_docente
LEFT JOIN estudiantes e ON c.id_delegado = e.id_estudiante
LEFT JOIN detalle_prestamo dp ON p.id_prestamo = dp.id_prestamo
LEFT JOIN materiales m ON dp.id_material = m.id_material
LEFT JOIN tipo_material tm ON m.id_tipo = tm.id_tipo
GROUP BY p.id_prestamo
ORDER BY p.fecha_prestamo DESC";

$res = $conn->query($sql);

if ($res && $res->num_rows > 0): ?>
    <table class="tabla">
        <tr>
            <th>N°</th>
            <th>Docente</th>
            <th>Estudiante</th>
            <th>Semestre</th>
            <th>Curso</th>
            <th>Turno</th>
            <th>Material(es)</th>
            <th>Fecha</th>
            <th>Estado</th>
            <th>Acciones</th>
        </tr>
        <?php $n = 1; while ($fila = $res->fetch_assoc()): ?>
            <tr>
                <td><?= $n++ ?></td>
                <td><?= htmlspecialchars($fila['docente'] ?? '-') ?></td>
                <td><?= htmlspecialchars($fila['estudiante'] . ' ' . $fila['apellido_est']) ?></td>
                <td><?= htmlspecialchars($fila['semestre']) ?></td>
                <td><?= htmlspecialchars($fila['curso']) ?></td>
                <td><?= htmlspecialchars($fila['seccion']) ?></td>
                <td><?= htmlspecialchars($fila['materiales'] ?? '-') ?></td>
                <td><?= htmlspecialchars($fila['fecha_prestamo']) ?></td>
                <td><?= htmlspecialchars($fila['estado']) ?></td>
                <td>
                    <a href="prestamo_form.php?id=<?= $fila['id_prestamo'] ?>">Editar</a> |
                    <a href="procesar/eliminar_prestamo.php?id=<?= $fila['id_prestamo'] ?>" onclick="return confirm('¿Eliminar préstamo?')">Eliminar</a>
                </td>
            </tr>
        <?php endwhile; ?>
    </table>
<?php else: ?>
    <p>No hay préstamos registrados.</p>
<?php endif;

include __DIR__ . "/../includes/footer.php";
?>
