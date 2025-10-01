<?php
$host = "localhost";
$user = "root";     // tu usuario de MySQL
$pass = "";         // tu contraseña
$dbname = "cecom";  // nombre del schema

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die("❌ Error de conexión: " . $conn->connect_error);
}
?>