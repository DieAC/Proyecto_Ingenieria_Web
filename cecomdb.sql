USE cecom;

-- Usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    rol ENUM('encargado','tecnico') NOT NULL DEFAULT 'encargado',
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100)
);

-- Docentes
CREATE TABLE docentes (
    id_docente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100)
);

-- Estudiantes
CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    codigo_alumno VARCHAR(20) UNIQUE NOT NULL, 
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    telefono VARCHAR(15)
);

-- Cursos
CREATE TABLE cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    semestre INT NOT NULL, 
    seccion CHAR(1) NOT NULL, 
    id_docente INT, 
    id_delegado INT, 
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente),
    FOREIGN KEY (id_delegado) REFERENCES estudiantes(id_estudiante),
    UNIQUE (nombre, semestre, seccion) 
);

-- Materiales
CREATE TABLE materiales (
    id_material INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    cantidad_total INT NOT NULL,
    cantidad_disponible INT NOT NULL,
    estado ENUM('activo','inactivo','en_reparacion') DEFAULT 'activo'
);

-- Ambientes
CREATE TABLE ambientes (
    id_ambiente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    tipo ENUM('AULA','LABORATORIO') NOT NULL
);

-- Prestamos
CREATE TABLE prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_curso INT NOT NULL,
    id_tecnico INT NOT NULL,
    id_encargado INT NOT NULL,
    id_ambiente INT NOT NULL, -- referencia al ambiente
    fecha_prestamo DATETIME NOT NULL,
    fecha_devolucion DATETIME,
    estado ENUM('PENDIENTE','DEVUELTO','ATRASADO') DEFAULT 'PENDIENTE',
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
    FOREIGN KEY (id_tecnico) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_encargado) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_ambiente) REFERENCES ambientes(id_ambiente)
);

-- Detalle de Prestamos
CREATE TABLE detalle_prestamo (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT,
    id_material INT,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo),
    FOREIGN KEY (id_material) REFERENCES materiales(id_material)
);

CREATE TABLE anuncios (
    id_anuncio INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    imagen VARCHAR(255), 
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

