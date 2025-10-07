<?php
require_once __DIR__ . "/../includes/auth_check.php";
require_once __DIR__ . "/../config/conexion.php";
include __DIR__ . "/../includes/header_admin.php";

$id = $_GET['id'] ?? null;
$prestamo = [
    'id_curso' => '',
    'id_ambiente' => '',
    'fecha_prestamo' => '',
    'fecha_devolucion' => '',
    'estado' => 'PENDIENTE'
];

if ($id) {
    $stmt = $conn->prepare("SELECT * FROM prestamos WHERE id_prestamo = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $prestamo = $stmt->get_result()->fetch_assoc();
}
?>

<h2><?= $id ? "Editar Préstamo" : "Registrar Nuevo Préstamo" ?></h2>

<form action="procesar/procesar_prestamo.php" method="POST">
    <input type="hidden" name="id_prestamo" value="<?= $id ?>">

    <label>Semestre:</label>
    <select id="semestre" name="semestre" required>
        <option value="">Seleccione...</option>
        <?php foreach ([2,4,6,8,10] as $sem): ?>
            <option value="<?= $sem ?>"><?= $sem ?>°</option>
        <?php endforeach; ?>
    </select>

    <label>Turno (Sección):</label>
    <select id="seccion" name="seccion" required>
        <option value="">Seleccione...</option>
        <option value="A">Turno A</option>
        <option value="B">Turno B</option>
    </select>

    <label>Curso:</label>
    <select id="id_curso" name="id_curso" required>
        <option value="">Seleccione un curso...</option>
    </select>

    <label>Ambiente:</label>
    <select id="id_ambiente" name="id_ambiente" required>
        <option value="">Seleccione ambiente...</option>
        <?php
        $amb = $conn->query("SELECT id_ambiente, nombre, tipo FROM ambientes ORDER BY tipo, nombre");
        while ($a = $amb->fetch_assoc()) {
            echo "<option value='{$a['id_ambiente']}'> {$a['nombre']} ({$a['tipo']})</option>";
        }
        ?>
    </select>

    <label>Materiales a prestar:</label>
    <div class="materiales-lista">
    <?php
    $tipos = $conn->query("SELECT id_tipo, nombre FROM tipo_material ORDER BY nombre");
    while ($tipo = $tipos->fetch_assoc()) {
        echo "<div class='materiales-grupo'>";
        echo "<strong>{$tipo['nombre']}</strong>";

        // Aquí empieza la lista interna
        $mats = $conn->query("
            SELECT id_material, codigo_material 
            FROM materiales 
            WHERE id_tipo = {$tipo['id_tipo']} 
            AND estado = 'disponible'
            ORDER BY codigo_material
        ");

        if ($mats->num_rows == 0) {
            echo "<div class='items'><em>Sin materiales disponibles</em></div>";
        } else {
            echo "<div class='items'>"; // 🔹 Aquí abrimos el contenedor
            while ($m = $mats->fetch_assoc()) {
                echo "<label>
                        <input type='checkbox' name='materiales[]' value='{$m['id_material']}'>
                        {$m['codigo_material']}
                      </label>";
            }
            echo "</div>"; // 🔹 Cerramos el contenedor .items
        }

        echo "</div>"; // Cierra .materiales-grupo
    }
    ?>
    </div>

    <label>Fecha de préstamo:</label>
    <input type="datetime-local" name="fecha_prestamo" value="<?= $prestamo['fecha_prestamo'] ?>" required>

    <label>Fecha de devolución (opcional):</label>
    <input type="datetime-local" name="fecha_devolucion" value="<?= $prestamo['fecha_devolucion'] ?>">

    <button type="submit" class="btn">Guardar</button>
    <a href="prestamos.php" class="btn">Cancelar</a>
</form>

<script>
document.getElementById('seccion').addEventListener('change', cargarCursos);
document.getElementById('semestre').addEventListener('change', cargarCursos);

function cargarCursos() {
    const sem = document.getElementById('semestre').value;
    const sec = document.getElementById('seccion').value;

    if (!sem || !sec) return;

    fetch(`/cecom/api/obtener_cursos.php?semestre=${sem}&seccion=${sec}`)
        .then(r => r.json())
        .then(data => {
            const select = document.getElementById('id_curso');
            select.innerHTML = '<option value="">Seleccione un curso...</option>';
            data.forEach(curso => {
                select.innerHTML += `<option value="${curso.id_curso}">${curso.nombre}</option>`;
            });
        });
}
</script>

<?php include __DIR__ . "/../includes/footer.php"; ?>
