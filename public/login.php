<?php
// public/login.php
session_start();
require_once __DIR__ . "/../config/conexion.php";

$msg = "";
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usuario = $conn->real_escape_string($_POST['usuario']);
    $password = $_POST['password'];

    $sql = "SELECT id_usuario, usuario, contraseña, rol, nombre FROM usuarios WHERE usuario = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $usuario);
    $stmt->execute();
    $res = $stmt->get_result();
    if ($res->num_rows === 1) {
        $row = $res->fetch_assoc();
        $stored = $row['contraseña'];

        $is_valid = false;
        // si es hash (starts with $2y$ or $2a$) usar password_verify
        if (password_verify($password, $stored)) {
            $is_valid = true;
        } elseif ($password === $stored) {
            // contraseña en texto plano -> aceptar pero re-hash y actualizar DB
            $is_valid = true;
            $newHash = password_hash($password, PASSWORD_DEFAULT);
            $u = $row['id_usuario'];
            $upd = $conn->prepare("UPDATE usuarios SET contraseña = ? WHERE id_usuario = ?");
            $upd->bind_param("si", $newHash, $u);
            $upd->execute();
            $upd->close();
        }

        if ($is_valid) {
            $_SESSION['usuario'] = $row['usuario'];
            $_SESSION['rol'] = $row['rol'];
            $_SESSION['nombre'] = $row['nombre'];
            $_SESSION['id_usuario'] = $row['id_usuario'];
            header("Location: /cecom/admin/dashboard.php");
            exit;
        } else {
            $msg = "Usuario o contraseña incorrectos.";
        }
    } else {
        $msg = "Usuario o contraseña incorrectos.";
    }
}
include __DIR__ . "/../includes/header_public.php";
?>

<h2>Login personal autorizado</h2>
<?php if($msg) echo "<p style='color:red'>$msg</p>"; ?>
<form method="post" action="">
  <label>Usuario</label><br>
  <input type="text" name="usuario" required><br>
  <label>Contraseña</label><br>
  <input type="password" name="password" required><br><br>
  <button type="submit">Entrar</button>
</form>

<?php include __DIR__ . "/../includes/footer.php"; ?>
