<?php
require_once __DIR__ . "/../includes/auth_check.php";
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/header_admin.php";

echo "<h2>Gestión de Anuncios</h2>";
echo "<p><a class='btn' href='anuncio_form.php'>+ Nuevo Anuncio</a></p>";

$sql = "SELECT a.*, u.nombre AS autor FROM anuncios a LEFT JOIN usuarios u ON a.id_usuario = u.id_usuario ORDER BY a.fecha DESC";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo "<table class='tabla'>";
    echo "<tr><th>Título</th><th>Descripción</th><th>Autor</th><th>Fecha</th><th>Acciones</th></tr>";
    while ($fila = $result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($fila['titulo']) . "</td>";
        echo "<td>" . htmlspecialchars(substr($fila['descripcion'], 0, 50)) . "...</td>";
        echo "<td>" . htmlspecialchars($fila['autor']) . "</td>";
        echo "<td>" . $fila['fecha'] . "</td>";
        echo "<td>
            <a href='anuncio_form.php?id=" . $fila['id_anuncio'] . "'>Editar</a> |
            <a href='procesar/eliminar_anuncio.php?id=" . $fila['id_anuncio'] . "' onclick='return confirm(\"¿Eliminar este anuncio?\")'>Eliminar</a>
            </td>";
        echo "</tr>";
    }
    echo "</table>";
} else {
    echo "<p>No hay anuncios registrados.</p>";
}

include __DIR__ . "/../includes/footer.php";
?>
