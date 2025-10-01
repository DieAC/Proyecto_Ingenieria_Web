<?php 
include("includes/header.php"); 
include("includes/db.php"); 
?>

<h2>Anuncios</h2>
<?php
$sql = "SELECT titulo, descripcion, imagen, fecha FROM anuncios ORDER BY fecha DESC";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()){
        echo "<article>";
        echo "<h3>".$row['titulo']."</h3>";
        echo "<p>".$row['descripcion']."</p>";
        if (!empty($row['imagen'])) {
            echo "<img src='uploads/".$row['imagen']."' alt='Imagen anuncio' width='200'>";
        }
        echo "<small>Publicado el: ".$row['fecha']."</small>";
        echo "</article><hr>";
    }
} else {
    echo "<p>No hay anuncios registrados.</p>";
}
?>

<?php include("includes/footer.php"); ?>
