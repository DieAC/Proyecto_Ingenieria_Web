<?php
require_once __DIR__ . "/../includes/auth_check.php";
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/nav_admin.php";
include __DIR__ . "/../includes/header_public.php";

$tipos = $conn->query("SELECT id_tipo, nombre FROM tipo_material ORDER BY nombre");
$cursos = $conn->query("SELECT id_curso, nombre, semestre, seccion FROM cursos ORDER BY nombre");
$ambientes = $conn->query("SELECT id_ambiente, nombre FROM ambientes ORDER BY nombre");
?>

<h2>Registrar nuevo préstamo</h2>
<form method="post" action="procesar/procesar_prestamo.php">
  <label>Curso</label><br>
  <select name="id_curso" required>
    <?php while($c = $cursos->fetch_assoc()){
        echo "<option value='{$c['id_curso']}'>".htmlspecialchars($c['nombre'])." (S{$c['semestre']}-{$c['seccion']})</option>";
    } ?>
  </select><br>

  <label>Ambiente</label><br>
  <select name="id_ambiente" required>
    <?php while($a = $ambientes->fetch_assoc()){
        echo "<option value='{$a['id_ambiente']}'>".htmlspecialchars($a['nombre'])."</option>";
    } ?>
  </select><br>

  <label>Tipo de material</label><br>
  <select id="tipo_material" name="id_tipo" required>
    <option value="">-- seleccionar --</option>
    <?php while($t = $tipos->fetch_assoc()){
        echo "<option value='{$t['id_tipo']}'>".htmlspecialchars($t['nombre'])."</option>";
    } ?>
  </select><br>

  <label>Unidad disponible</label><br>
  <select id="unidad_material" name="id_material" required>
    <option value="">Seleccione un tipo primero</option>
  </select><br>

  <button type="submit">Registrar préstamo</button>
</form>

<script>
document.getElementById('tipo_material').addEventListener('change', function(){
    var idtipo = this.value;
    var sel = document.getElementById('unidad_material');
    sel.innerHTML = "<option>Cargando...</option>";
    fetch('/cecom/api/get_materiales.php?id_tipo=' + idtipo)
      .then(r=>r.json())
      .then(data=>{
         sel.innerHTML = "";
         if(!data.length){ sel.innerHTML = "<option value=''>No hay unidades disponibles</option>"; return; }
         data.forEach(function(item){
             var o = document.createElement('option');
             o.value = item.id_material;
             o.text = item.codigo_material + " ("+item.estado+")";
             sel.appendChild(o);
         });
      });
});
</script>

<?php include __DIR__ . "/../includes/footer.php"; ?>
