<?php
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/header_public.php";
?>

<section class="contenedor">
    <h2>Anuncios del CECOM</h2>

    <?php
    $sql = "SELECT a.*, u.nombre AS autor 
            FROM anuncios a 
            LEFT JOIN usuarios u ON a.id_usuario = u.id_usuario 
            ORDER BY a.fecha DESC";
    $res = $conn->query($sql);

    if ($res && $res->num_rows > 0): ?>
        <div class="anuncios-lista">
            <?php while ($fila = $res->fetch_assoc()): ?>
                <article class="anuncio">
                    <h3><?= htmlspecialchars($fila['titulo']) ?></h3>
                    <p><?= nl2br(htmlspecialchars($fila['descripcion'])) ?></p>

                    <?php if (!empty($fila['imagen'])): ?>
                        <img src="/cecom/uploads/<?= htmlspecialchars($fila['imagen']) ?>" 
                             alt="<?= htmlspecialchars($fila['titulo']) ?>" 
                             class="anuncio-img">
                    <?php endif; ?>

                    <small>
                        Publicado por <?= htmlspecialchars($fila['autor'] ?? 'CECOM') ?> el <?= $fila['fecha'] ?>
                    </small>
                    <hr>
                </article>
            <?php endwhile; ?>
        </div>
    <?php else: ?>
        <p>No hay anuncios disponibles por el momento.</p>
    <?php endif; ?>
</section>

<?php include __DIR__ . "/../includes/footer.php"; ?>
