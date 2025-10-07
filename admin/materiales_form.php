<?php
require_once __DIR__ . "/../includes/auth_check.php";
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/header_admin.php";

$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
$tipo_sel = 0; $codigo = ""; $estado = "disponible";

$tipos = $conn->query("SELECT id_tipo, nombre FROM tipo_material ORDER BY nombre");
if ($id) {
    $stmt = $conn->prepare("SELECT id_tipo, codigo_material, estado FROM materiales WHERE id_material = ?");
    $stmt->bind_param("i",$id);
    $stmt->execute();
    $r = $stmt->get_result()->fetch_assoc();
    if ($r) {
        $tipo_sel = $r['id_tipo'];
        $codigo = $r['codigo_material'];
        $estado = $r['estado'];
    }
}
?>
<h2><?php echo $id ? "Editar unidad" : "Agregar unidad"; ?></h2>
<form method="post" action="procesar/procesar_material.php">
  <input type="hidden" name="id_material" value="<?php echo $id; ?>">
  <label>Tipo</label><br>
  <select name="id_tipo" required>
    <?php while($t = $tipos->fetch_assoc()){
        $sel = $t['id_tipo']==$tipo_sel ? "selected":"";
        echo "<option value='{$t['id_tipo']}' $sel>".htmlspecialchars($t['nombre'])."</option>";
    } ?>
  </select><br>
  <label>Código unidad (ej. DRN-01)</label><br>
  <input type="text" name="codigo_material" value="<?php echo htmlspecialchars($codigo); ?>" required><br>
  <label>Estado</label><br>
  <select name="estado">
    <option value="disponible" <?php if($estado=='disponible') echo "selected"; ?>>Disponible</option>
    <option value="prestado" <?php if($estado=='prestado') echo "selected"; ?>>Prestado</option>
    <option value="en_reparacion" <?php if($estado=='en_reparacion') echo "selected"; ?>>En reparación</option>
    <option value="inactivo" <?php if($estado=='inactivo') echo "selected"; ?>>Inactivo</option>
  </select><br><br>
  <button type="submit">Guardar</button>
</form>

<?php include __DIR__ . "/../includes/footer.php"; ?>
