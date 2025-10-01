<?php 
include("includes/header.php"); 
include("includes/db.php"); 
?>

<h2>Registrar Préstamo</h2>
<form method="post">
  <label>Curso:</label>
  <select name="curso">
    <?php
    $cursos = $conn->query("SELECT id_curso, nombre, seccion FROM cursos");
    while($c = $cursos->fetch_assoc()){
        echo "<option value='".$c['id_curso']."'>".$c['nombre']." (".$c['seccion'].")</option>";
    }
    ?>
  </select><br>

  <label>Ambiente:</label>
  <select name="ambiente">
    <?php
    $ambs = $conn->query("SELECT id_ambiente, nombre FROM ambientes");
    while($a = $ambs->fetch_assoc()){
        echo "<option value='".$a['id_ambiente']."'>".$a['nombre']."</option>";
    }
    ?>
  </select><br>

  <label>Material:</label>
  <select name="material">
    <?php
    $mats = $conn->query("SELECT id_material, nombre FROM materiales WHERE cantidad_disponible > 0");
    while($m = $mats->fetch_assoc()){
        echo "<option value='".$m['id_material']."'>".$m['nombre']."</option>";
    }
    ?>
  </select><br>

  <label>Cantidad:</label>
  <input type="number" name="cantidad" min="1"><br>

  <button type="submit" name="registrar">Registrar Préstamo</button>
</form>

<?php
if(isset($_POST['registrar'])){
    $curso = $_POST['curso'];
    $ambiente = $_POST['ambiente'];
    $material = $_POST['material'];
    $cantidad = $_POST['cantidad'];

    // Aquí deberías obtener los IDs del técnico y encargado logueados.
    $tecnico = 1; 
    $encargado = 1;

    // Insertar en prestamos
    $conn->query("INSERT INTO prestamos (id_curso,id_tecnico,id_encargado,id_ambiente,fecha_prestamo) 
                  VALUES ($curso,$tecnico,$encargado,$ambiente,NOW())");

    $id_prestamo = $conn->insert_id;

    // Insertar en detalle_prestamo
    $conn->query("INSERT INTO detalle_prestamo (id_prestamo,id_material,cantidad) 
                  VALUES ($id_prestamo,$material,$cantidad)");

    // Actualizar stock
    $conn->query("UPDATE materiales SET cantidad_disponible = cantidad_disponible - $cantidad 
                  WHERE id_material=$material");

    echo "<p style='color:green'>✅ Préstamo registrado con éxito.</p>";
}
?>

<h2>Préstamos Activos</h2>
<table border="1">
  <tr><th>Curso</th><th>Material</th><th>Cantidad</th><th>Estado</th></tr>
  <?php
  $sql = "SELECT c.nombre as curso, m.nombre as material, d.cantidad, p.estado
          FROM prestamos p
          JOIN cursos c ON p.id_curso=c.id_curso
          JOIN detalle_prestamo d ON p.id_prestamo=d.id_prestamo
          JOIN materiales m ON d.id_material=m.id_material
          WHERE p.estado='PENDIENTE'";
  $result = $conn->query($sql);
  while($row = $result->fetch_assoc()){
      echo "<tr>
              <td>".$row['curso']."</td>
              <td>".$row['material']."</td>
              <td>".$row['cantidad']."</td>
              <td>".$row['estado']."</td>
            </tr>";
  }
  ?>
</table>

<?php include("includes/footer.php"); ?>
