<?php 
include("includes/header.php"); 
include("includes/db.php"); 
?>

<h2>Encargados y Técnicos</h2>
<table border="1">
  <tr><th>Nombre</th><th>Rol</th><th>Correo</th></tr>
  <?php
  $sql = "SELECT nombre, rol, correo FROM usuarios";
  $result = $conn->query($sql);
  while($row = $result->fetch_assoc()){
      echo "<tr>
              <td>".$row['nombre']."</td>
              <td>".$row['rol']."</td>
              <td>".$row['correo']."</td>
            </tr>";
  }
  ?>
</table>

<?php include("includes/footer.php"); ?>
