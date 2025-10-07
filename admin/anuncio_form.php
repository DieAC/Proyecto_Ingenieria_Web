<?php
require_once __DIR__ . "/../includes/auth_check.php";
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/header_admin.php";

$id = $_GET['id'] ?? null;
$anuncio = ["titulo" => "", "descripcion" => "", "imagen" => ""];

if ($id) {
    $stmt = $conn->prepare("SELECT * FROM anuncios WHERE id_anuncio = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $res = $stmt->get_result();
    $anuncio = $res->fetch_assoc();
}

?>

<h2><?php echo $id ? "Editar Anuncio" : "Nuevo Anuncio"; ?></h2>

<form action="procesar/guardar_anuncio.php" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="id_anuncio" value="<?php echo $id; ?>">
    <label>Título:</label>
    <input type="text" name="titulo" value="<?php echo htmlspecialchars($anuncio['titulo']); ?>" required><br>

    <label>Descripción:</label>
    <textarea name="descripcion" rows="5" required><?php echo htmlspecialchars($anuncio['descripcion']); ?></textarea><br>

    <label>Imagen (opcional):</label>
    <input type="file" name="imagen"><br>

    <?php if (!empty($anuncio['imagen'])): ?>
        <p>Imagen actual: <img src="/cecom/uploads/<?php echo $anuncio['imagen']; ?>" width="120"></p>
    <?php endif; ?>

    <button type="submit" class="btn">Guardar</button>
    <a href="anuncios.php" class="btn">Cancelar</a>
</form>

<?php include __DIR__ . "/../includes/footer.php"; ?>
