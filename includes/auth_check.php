<?php
// includes/auth_check.php
session_start();
if (!isset($_SESSION['usuario'])) {
    header("Location: /cecom/public/login.php");
    exit;
}
// sólo permitir roles encagado o tecnico
if (!in_array($_SESSION['rol'], ['encargado','tecnico'])) {
    echo "Acceso denegado.";
    exit;
}
?>
