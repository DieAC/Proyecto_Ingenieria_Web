-- Script SQL ajustado con correos y celular para usuarios (encargado y técnicos) y docentes con correos generados

DROP DATABASE IF EXISTS cecom;
CREATE DATABASE cecom CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cecom;

-- TABLAS ------------------------------------------------
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    rol ENUM('encargado','tecnico') NOT NULL DEFAULT 'tecnico',
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) DEFAULT NULL,
    celular VARCHAR(20) DEFAULT NULL
);

CREATE TABLE docentes (
    id_docente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) DEFAULT NULL
);

CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    codigo_alumno VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(100) DEFAULT NULL,
    telefono VARCHAR(15) DEFAULT NULL
);

CREATE TABLE cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    semestre INT NOT NULL,
    seccion CHAR(1) NOT NULL,
    id_docente INT DEFAULT NULL,
    id_delegado INT DEFAULT NULL,
    UNIQUE (nombre, semestre, seccion),
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_delegado) REFERENCES estudiantes(id_estudiante) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE ambientes (
    id_ambiente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    tipo ENUM('AULA','LABORATORIO') NOT NULL
);

CREATE TABLE tipo_material (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE materiales (
    id_material INT AUTO_INCREMENT PRIMARY KEY,
    id_tipo INT NOT NULL,
    codigo_material VARCHAR(50) UNIQUE NOT NULL, -- Ejemplo: DRN-01, LAP-03, VR-02
    estado ENUM('disponible','prestado','en_reparacion','inactivo') DEFAULT 'disponible',
    FOREIGN KEY (id_tipo) REFERENCES tipo_material(id_tipo)
);

CREATE TABLE prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_curso INT NOT NULL,
    id_tecnico INT NOT NULL,
    id_encargado INT NOT NULL,
    id_ambiente INT NOT NULL,
    fecha_prestamo DATETIME NOT NULL,
    fecha_devolucion DATETIME DEFAULT NULL,
    estado ENUM('PENDIENTE','DEVUELTO','ATRASADO') DEFAULT 'PENDIENTE',
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_tecnico) REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_encargado) REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_ambiente) REFERENCES ambientes(id_ambiente) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE detalle_prestamo (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    id_material INT NOT NULL,
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo) ON DELETE CASCADE,
    FOREIGN KEY (id_material) REFERENCES materiales(id_material) ON DELETE RESTRICT
);

CREATE TABLE anuncios (
    id_anuncio INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    imagen VARCHAR(255),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DATOS BASE: usuarios con correos y celular -----------------------

INSERT INTO usuarios (usuario, contraseña, rol, nombre, correo, celular) VALUES
('admin',   'admin123', 'encargado', 'Arnold Christian Loaiza Fabian', 'aloaizaf@unjbg.edu.pe', '958123456'),
('tecnico1','tec123',   'tecnico',   'Jesus Manuel Sanchez Mamani',      'jsanchezm@unjbg.edu.pe', '979123321'),
('tecnico2','tec123',   'tecnico',   'Johnny Carlo Huapaya Yataco',      'jhuapayay@unjbg.edu.pe', '976543210');

-- Ambientes
INSERT INTO ambientes (nombre, tipo) VALUES
('ESPG-208','AULA'),
('BAR-04','AULA'),
('BAR-05','AULA'),
('BAR-06','AULA'),
('BAR-07','AULA'),
('LAB-ESPG','LABORATORIO'),
('LAB-A','LABORATORIO'),
('LAB-B','LABORATORIO'),
('LAB-C','LABORATORIO'),
('LAB-ELEC','LABORATORIO');

-- Tipo Materiales
INSERT INTO tipo_material (nombre, descripcion) VALUES
('Drone', 'Dron con cámara para prácticas aéreas'),
('Laptop', 'Portátil para uso académico'),
('Lentes VR', 'Lentes de realidad virtual'),
('Proyector', 'Proyector de video'),
('Extensión', 'Cable de extensión eléctrica'),
('Kit Lego de Robótica', 'Set educativo para prácticas de robótica'),
('Kit de Electrónica', 'Componentes electrónicos básicos');

-- Drones (4)
INSERT INTO materiales (id_tipo, codigo_material) VALUES
(1, 'DRN-01'),
(1, 'DRN-02'),
(1, 'DRN-03'),
(1, 'DRN-04');

-- Laptops (7)
INSERT INTO materiales (id_tipo, codigo_material) VALUES
(2, 'LAP-01'),
(2, 'LAP-02'),
(2, 'LAP-03'),
(2, 'LAP-04'),
(2, 'LAP-05'),
(2, 'LAP-06'),
(2, 'LAP-07');

-- Lentes VR (6)
INSERT INTO materiales (id_tipo, codigo_material) VALUES
(3, 'VR-01'),
(3, 'VR-02'),
(3, 'VR-03'),
(3, 'VR-04'),
(3, 'VR-05'),
(3, 'VR-06');

-- Proyectores (14)
INSERT INTO materiales (id_tipo, codigo_material) VALUES
(4, 'PROY-01'),
(4, 'PROY-02'),
(4, 'PROY-03'),
(4, 'PROY-04'),
(4, 'PROY-05'),
(4, 'PROY-06'),
(4, 'PROY-07'),
(4, 'PROY-08'),
(4, 'PROY-09'),
(4, 'PROY-10'),
(4, 'PROY-11'),
(4, 'PROY-12'),
(4, 'PROY-13'),
(4, 'PROY-14');

-- Extensiones (14)
INSERT INTO materiales (id_tipo, codigo_material) VALUES
(5, 'EXT-01'),
(5, 'EXT-02'),
(5, 'EXT-03'),
(5, 'EXT-04'),
(5, 'EXT-05'),
(5, 'EXT-06'),
(5, 'EXT-07'),
(5, 'EXT-08'),
(5, 'EXT-09'),
(5, 'EXT-10'),
(5, 'EXT-11'),
(5, 'EXT-12'),
(5, 'EXT-13'),
(5, 'EXT-14');

-- Kits Lego de Robótica (8)
INSERT INTO materiales (id_tipo, codigo_material) VALUES
(6, 'ROBO-01'),
(6, 'ROBO-02'),
(6, 'ROBO-03'),
(6, 'ROBO-04'),
(6, 'ROBO-05'),
(6, 'ROBO-06'),
(6, 'ROBO-07'),
(6, 'ROBO-08');

-- Kits de Electrónica (10)
INSERT INTO materiales (id_tipo, codigo_material) VALUES
(7, 'ELEC-01'),
(7, 'ELEC-02'),
(7, 'ELEC-03'),
(7, 'ELEC-04'),
(7, 'ELEC-05'),
(7, 'ELEC-06'),
(7, 'ELEC-07'),
(7, 'ELEC-08'),
(7, 'ELEC-09'),
(7, 'ELEC-10');

-- Docentes con correos estimados o reales si los encuentras
-- Del PDF y del sitio web de docentes (si están)
INSERT INTO docentes (nombre, correo) VALUES
('Danitza del Rosario Perca Machaca', 'dperca@unjbg.edu.pe'),
('Enrique Eugenio Rodriguez Vargas', 'erodriguez@unjbg.edu.pe'),
('Karín Yanet Supo Gavancho', 'ksupo@unjbg.edu.pe'),
('Luis Cesar Méndez Avalos', 'lmendez@unjbg.edu.pe'),
('Favio Fernando Ccallo Yllachura', 'fccallo@unjbg.edu.pe'),
('Eleocadio Dionisio Tirado Paz', 'etirado@unjbg.edu.pe'),
('Arnold Christian Loaiza Fabian', 'aloaizaf@unjbg.edu.pe'),
('Enrique Waldo Condori Siles', 'econdori@unjbg.edu.pe'),
('Carlos Hernán Acero Charaña', 'cacero@unjbg.edu.pe'),
('Edwin Antonio Hinojosa Ramos', 'ehinojosa@unjbg.edu.pe'),
('Julia Rosa Gutierrez Pérez', 'jgutierrez@unjbg.edu.pe'),
('Julio Valderrama Gamboa', 'jvalderrama@unjbg.edu.pe'),
('Isabel Lilian Peralta Rodriguez', 'iperalta@unjbg.edu.pe');

-- Estudiantes (delegados) con los delegados que ya teníamos, sin correo
INSERT INTO estudiantes (codigo_alumno, nombre, apellido, telefono) VALUES
('2025-119053','Kendra','Huanca Salcedo','986107107'),
('2025-119014','Pablo Rodrigo','Mamani Mamani','922072298'),
('2025-119056','Alison Paola','Quispe Galarza','985985180'),
('2025-119034','Fernando Alonso','Vasquez Condori','970153844'),
('2025-119020','Rodrigo Branco','Estalla Cutipa','945658873'),
('2025-119021','Carlos Aaron','Gallardo Sanchez','944840926'),
('2025-119041','Gym Erick Hugo','Mendoza Espinoza','993667114'),
('2025-119007','Wilfredo','Valdivia Vera','929397015'),
('2025-119011','Natalia Lizeth','Huanca Quispe','923859220'),
('2025-119003','Alexander Efrain','Contreras Rodriguez','970171689'),
('2025-119009','Juan Pablo','Arratia Paz','947352069'),
('2025-119055','Josue Fernando','Mamani Lima','905903825'),
('2024-119044','Alexandra Valeria','Choque Onofre','986486094'),
('2024-119036','Alejandra Del Rosario','Ramos Mamani','965737255'),
('2024-119021','Johan Aníbal','Mamani Catacora','910855032'),
('2024-119004','Jair Mark','Mendoza Flores','925358074'),
('2024-119024','Adrián Eliel','Socualaya Feliciano','948051452'),
('2024-119038','Alexander Jesús','Telléz Mesa','930678385'),
('2024-119026','Jhonel Gerson','Apaza Pacompia','936239734');

-- Cursos (semestre 2 y 4 representativos) con docentes y delegados
INSERT INTO cursos (nombre, semestre, seccion, id_docente, id_delegado) VALUES
('Ecología y medio ambiente', 2, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Danitza del Rosario Perca Machaca' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119053' LIMIT 1)
),
('Realidad nacional e internacional', 2, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Enrique Eugenio Rodriguez Vargas' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119014' LIMIT 1)
),
('Filosofia, ética y sociedad', 2, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Karín Yanet Supo Gavancho' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119056' LIMIT 1)
),
('Matemática I', 2, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Luis Cesar Méndez Avalos' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119034' LIMIT 1)
),
('Física I', 2, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Favio Fernando Ccallo Yllachura' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119020' LIMIT 1)
),
('Matemática discreta II', 2, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Eleocadio Dionisio Tirado Paz' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119021' LIMIT 1)
),
('Programación avanzada', 2, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Arnold Christian Loaiza Fabian' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119041' LIMIT 1)
),
('Análisis de sistemas', 4, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Enrique Waldo Condori Siles' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2024-119021' LIMIT 1)
),
('Sistemas digitales', 4, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Carlos Hernán Acero Charaña' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2024-119044' LIMIT 1)
),
('Modelado computacional para ingeniería', 4, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Edwin Antonio Hinojosa Ramos' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2024-119004' LIMIT 1)
),
('Contabilidad, costos y presupuestos', 4, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Julia Rosa Gutierrez Pérez' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2024-119024' LIMIT 1)
),
('Ingeniería económica', 4, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Isabel Lilian Peralta Rodriguez' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2024-119038' LIMIT 1)
);

-- FIN DEL SCRIPT

