<?php
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/header_public.php";

echo "<h2>Anuncios</h2>";
$sql = "SELECT titulo, descripcion, imagen, fecha FROM anuncios ORDER BY fecha DESC LIMIT 20";
$res = $conn->query($sql);
if ($res->num_rows === 0) {
    echo "<p>No hay anuncios.</p>";
} else {
    while ($r = $res->fetch_assoc()) {
        echo "<article>";
        echo "<h3>".htmlspecialchars($r['titulo'])."</h3>";
        echo "<p>".nl2br(htmlspecialchars($r['descripcion']))."</p>";
        if (!empty($r['imagen'])) {
            echo "<img src='/cecom/uploads/".htmlspecialchars($r['imagen'])."' alt='' style='max-width:200px'>";
        }
        echo "<small>Publicado: {$r['fecha']}</small>";
        echo "</article><hr>";
    }
}

include __DIR__ . "/../includes/footer.php";
