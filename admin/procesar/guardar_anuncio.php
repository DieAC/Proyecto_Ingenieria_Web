<?php
require_once __DIR__ . "/../../includes/auth_check.php";
require_once __DIR__ . "/../../config/conexion.php";

$id_anuncio = $_POST['id_anuncio'] ?? null;
$titulo = $_POST['titulo'];
$descripcion = $_POST['descripcion'];
$id_usuario = $_SESSION['id_usuario'];

// Manejar imagen si se sube
$imagen = null;
if (!empty($_FILES['imagen']['name'])) {
    $nombre_archivo = time() . "_" . basename($_FILES["imagen"]["name"]);
    $ruta_destino = __DIR__ . "/../../uploads/" . $nombre_archivo;
    move_uploaded_file($_FILES["imagen"]["tmp_name"], $ruta_destino);
    $imagen = $nombre_archivo;
}

if ($id_anuncio) {
    // Editar
    if ($imagen) {
        $sql = "UPDATE anuncios SET titulo=?, descripcion=?, imagen=? WHERE id_anuncio=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sssi", $titulo, $descripcion, $imagen, $id_anuncio);
    } else {
        $sql = "UPDATE anuncios SET titulo=?, descripcion=? WHERE id_anuncio=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssi", $titulo, $descripcion, $id_anuncio);
    }
} else {
    // Nuevo
    $sql = "INSERT INTO anuncios (titulo, descripcion, imagen, id_usuario) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssi", $titulo, $descripcion, $imagen, $id_usuario);
}

$stmt->execute();
header("Location: ../anuncios.php");
exit;
?>
