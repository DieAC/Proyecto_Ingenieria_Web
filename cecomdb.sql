DROP DATABASE IF EXISTS cecom;
CREATE DATABASE cecom CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cecom;

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
    codigo_material VARCHAR(50) UNIQUE NOT NULL, 
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
    descripcion TEXT NOT NULL,
    imagen VARCHAR(255),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
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

-- Docentes 
INSERT INTO docentes (nombre, correo) VALUES
('Danitza del Rosario Perca Machaca', 'dperca@unjbg.edu.pe'),
('Enrique Eugenio Rodriguez Vargas', 'erodriguez@unjbg.edu.pe'),
('Karín Yanet Supo Gavancho', 'ksupo@unjbg.edu.pe'),
('Luis Cesar Méndez Avalos', 'lmendez@unjbg.edu.pe'),
('Favio Fernando Ccallo Yllachura', 'fccallo@unjbg.edu.pe'),
('Eleocadio Dionisio Tirado Paz', 'etirado@unjbg.edu.pe'),
('Arnold Christian Loaiza Fabian', 'aloaizaf@unjbg.edu.pe'),
('Roger Daniel Sueros Ticona', 'rsuerosti@unjbg.edu.pe'),
('Cory Susana Laura Najar', 'claurana@unjbg.edu.pe'),
('Walter Zavaleta Fernández', 'wzavaletaf@unjbg.edu.pe'),
('Moises Fernando Cancho Ochoa', 'mcanchooc@unjbg.edu.pe'),
('Sergio Luis Pacheco Condori', 'spachecoco@unjbg.edu.pe'),
('Hugo Manuel Barraza Vizcarra', 'hbarrazavi@unjbg.edu.pe'),
('Gianfranco Alexey Málaga Tejada', 'gmalagate@unjbg.edu.pe'),
('Jorge Ricardo Chambilla Araca', 'jchambillaar@unjbg.edu.pe'),
('Alberto Régulo Coayla Vilca', 'acoaylavi@unjbg.edu.pe'),
('Genyfer Margaret Aldana Salgado', 'galdanasa@unjbg.edu.pe'),
('Nain Neptalí Acero Mamani', 'naceroma@unjbg.edu.pe'),
('Luis Johnson Paúl Mori Sosa', 'lmoriso@unjbg.edu.pe'),
('Manuel Yuri Apaza Valencia', 'mapazava@unjbg.edu.pe'),
('Silvana Beatriz Cabana Yupanqui', 'scabanayu@unjbg.edu.pe'),
('Nelson Abrahan Pablo Mollo Condori', 'nmollocon@unjbg.edu.pe'),
('Deisy Elizabeth Valle Castro', 'dvalleca@unjbg.edu.pe'),
('Eddy Antoni Quispe Huacani', 'equispehua@unjbg.edu.pe'),
('Israel Nazareth Chaparro Cruz', 'ichaparroc@unjbg.edu.pe'),
('Freeman Hugo Llamozas Escalante','fllamozases@unjbg.edu.pe'),
('Ana Silvia Cori Morón', 'acorimo@unjbg.edu.pe'),
('Paulo César Chuquimia Mollo', 'pchuquimiamo@unjbg.edu.pe'),
('Elena Miriam Chavez Garcés', 'echavezga@unjbg.edu.pe'),
('Milagros Gleny Cohaila Gonzales', 'mcohailago@unjbg.edu.pe'),
('Oliver Israel Santana Carbajal', 'osantanaca@unjbg.edu.pe'),
('Diana Carolina Solis Yucra', 'dsolisyu@unjbg.edu.pe'),
('Jimmy Cristian Muñoz Miranda ', 'jmunozmi@unjbg.edu.pe'),
('Carlos Hernán Acero Charaña', 'caceroch@unjbg.edu.pe'),
('Erbert Francisco Osco Mamani', 'eoscoma@unjbg.edu.pe'),
('Jorge Ricardo Chambilla Arana', 'jchambillaar@unjbg.edu.pe'),
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
('2024-119026','Jhonel Gerson','Apaza Pacompia','936239734'),
('2025-119013','Felix', 'Mamani Lopez', '994085726'),
('2024-119040', 'River', 'Calizaya Pariguana', '925269971'),
('2024-119046', 'Wesley Rivaldo', 'Laura Choquejahua', '931785299'),
('2023-119030', 'Franklin Jhonatan', 'Mamani Apaza', '916916494'),
('2024-119064', 'Oscar Alejandro', 'Ticona Fernandez', '986408779'),
('2023-119016', 'Wilbert Raúl', 'Copaja Huayta', '937523322'),
('2024-119017', 'José Antonio', 'Vilcanqui Chambi', '971985105'),
('2023-119056', 'Sebastián Joshua', 'Quispe Condori', '977970499'),
('2023-119021', 'Yefersson', 'Guerra Quispe', '947663827'),
('2023-119064', 'Victor Rodrigo', 'Ticona Quispe', '932227244'),
('2022-119029', 'Diego Alonso', 'Condori Llanos', '978319349'),
('2022-119101', 'Angel Eduardo', 'Vivanco Laura', '948115607'),
('2022-119059', 'Paolo Nicolas', 'Cala Conde', '944490011'),
('2021-119074', 'Pedro Luis', 'Aquino Garcia', '991388807'),
('2021-119085', 'Breyan Yerson', 'Huisa Condori', '920820142'),
('2022-119065', 'Max Junior', 'Coaguila Yugra', '918481291'),
('2022-119031', 'Marcos Samuel', 'Huayna Cama', '933394002'),
('2022-119035', 'Luis Sebastian', 'Nuñez Fuentes', '958627120'),
('2021-119025', 'Carlos Alfredo', 'Percca Anchapuri', '986454378'),
('2021-119007', 'Lizzeth Mercedes', 'Candia Llica', '935099454'),
('2021-119071', 'Luis Enrique', 'Rodríguez Tarqui', '984703799'),
('2021-119130', 'Elian Yeltzin', 'Paniagua Mariaca', '952249659'),
('2021-119036', 'Sabay Gonzalo', 'Chipana Huarcusi', '986966995'),
('2018-119068', 'Jose Carlos', 'Ramirez Mamani', '927923216'),
('2021-119048', 'Miriam Carolina', 'Cabrera Cunurana', '983915043'),
('2021-119079', 'Diego Emanuel', 'Chambi Centeno', '981153955'),
('2021-119043', 'David Eduardo', 'Loayza Medina', '986118994'),
('2021-119013', 'Bryanna Audrey', 'Chávez Bautista', '973645848'),
('2021-119014', 'Yahir Sergio', 'Choquehuanca Chipana', '923103692');

-- Cursos  con docentes y delegados
INSERT INTO cursos (nombre, semestre, seccion, id_docente, id_delegado) VALUES
-- SEGUNDO SEMESTRE A
('Ecología y medio ambiente', 2, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Danitza del Rosario Perca Machaca' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119053' LIMIT 1)
),
('Realidad nacional e internacional', 2, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Enrique Eugenio Rodriguez Vargas' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119014' LIMIT 1)
),
('Filosofía, ética y sociedad', 2, 'A',
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

-- SEGUNDO SEMESTRE B
('Ecología y medio ambiente', 2, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Roger Daniel Sueros Ticona' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119011' LIMIT 1)
),
('Realidad nacional e internacional', 2, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Cory Susana Laura Najar' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119003' LIMIT 1)
),
('Filosofía, ética y sociedad', 2, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Karín Yanet Supo Gavancho' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119009' LIMIT 1)
),
('Matemática I', 2, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Walter Zavaleta Fernández' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119055' LIMIT 1)
),
('Física I', 2, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Moises Fernando Cancho Ochoa' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119054' LIMIT 1)
),
('Matemática discreta II', 2, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Sergio Luis Pacheco Condori' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119007' LIMIT 1)
),
('Programación avanzada', 2, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Hugo Manuel Barraza Vizcarra' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2025-119058' LIMIT 1)
),

-- CUARTO SEMESTRE A
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
),

-- CUARTO SEMESTRE B
('Análisis de sistemas', 4, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Gianfranco Alexey Málaga Tejada' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2024-119040' LIMIT 1)
),
('Sistemas digitales', 4, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Hugo Manuel Barraza Vizcarra' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2024-119046' LIMIT 1)
),
('Modelado computacional para ingeniería', 4, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Jorge Ricardo Chambilla Araca' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119030' LIMIT 1)
),
('Contabilidad, costos y presupuestos', 4, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Julia Rosa Gutierrez Pérez' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2024-119064' LIMIT 1)
),
('Ingeniería económica', 4, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Isabel Lilian Peralta Rodriguez' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2024-119017' LIMIT 1)
),
-- SEXTO SEMESTRE A
('Ingeniería de software I', 6, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Gianfranco Alexey Málaga Tejada' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119056' LIMIT 1)
),
('Redes I', 6, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Genyfer Margaret Aldana Salgado' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119016' LIMIT 1)
),
('Sistemas operativos', 6, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Hugo Manuel Barraza Vizcarra' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119021' LIMIT 1)
),
('Base de datos II', 6, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Arnold Christian Loaiza Fabian' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119021' LIMIT 1)
),
('Investigación operativa II', 6, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Nain Neptalí Acero Mamani' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119021' LIMIT 1)
),
('Legislación industrial e informática', 6, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Luis Johnson Paúl Mori Sosa' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119021' LIMIT 1)
),

-- SEXTO SEMESTRE B
('Ingeniería de software I', 6, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Manuel Yuri Apaza Valencia' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119064' LIMIT 1)
),
('Redes I', 6, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Enrique Waldo Condori Siles' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119064' LIMIT 1)
),
('Sistemas operativos', 6, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Silvana Beatriz Cabana Yupanqui' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119064' LIMIT 1)
),
('Base de datos II', 6, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Nelson Abrahan Pablo Mollo Condori' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119064' LIMIT 1)
),
('Investigación operativa II', 6, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Deisy Elizabeth Valle Castro' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119064' LIMIT 1)
),
('Legislación industrial e informática', 6, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Eddy Antoni Quispe Huacani' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2023-119064' LIMIT 1)
),

-- OCTAVO SEMESTRE A
('Simulación de sistemas', 8, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Israel Nazareth Chaparro Cruz' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119059' LIMIT 1)
),
('Seguridad informática', 8, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Freeman Hugo Llamozas Escalante' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119074' LIMIT 1)
),
('Ingeniería web y aplicaciones móviles', 8, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Ana Silvia Cori Morón' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119101' LIMIT 1)
),
('Gestión de ecoeficiencia en la empresa', 8, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Luis Johnson Paúl Mori Sosa' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119031' LIMIT 1)
),
('Diseño asistido por computador', 8, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Enrique Waldo Condori Siles' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119085' LIMIT 1)
),
('Sistema de información gerencial', 8, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Paulo César Chuquimia Mollo' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119065' LIMIT 1)
),
('Taller de emprendimiento e innovación', 8, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Elena Miriam Chavez Garcés' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119059' LIMIT 1)
),
('Realidad virtual', 8, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Milagros Gleny Cohaila Gonzales' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119029' LIMIT 1)
),

-- OCTAVO SEMESTRE B
('Simulación de sistemas', 8, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Israel Nazareth Chaparro Cruz' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119035' LIMIT 1)
),
('Seguridad informática', 8, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Oliver Israel Santana Carbajal' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119035' LIMIT 1)
),
('Ingeniería web y aplicaciones móviles', 8, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Ana Silvia Cori Morón' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119035' LIMIT 1)
),
('Gestión de ecoeficiencia en la empresa', 8, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Diana Carolina Solis Yucra' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119035' LIMIT 1)
),
('Diseño asistido por computador', 8, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Milagros Gleny Cohaila Gonzales' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119035' LIMIT 1)
),
('Sistema de información gerencial', 8, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Oliver Israel Santana Carbajal' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119035' LIMIT 1)
),
('Taller de emprendimiento e innovación', 8, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Deisy Elizabeth Valle Castro' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119035' LIMIT 1)
),
('Realidad virtual', 8, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Milagros Gleny Cohaila Gonzales' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2022-119035' LIMIT 1)
),

-- DÉCIMO SEMESTRE A
('Taller de tesis II', 10, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Luis Johnson Paúl Mori Sosa' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119025' LIMIT 1)
),
('Trabajo de investigación', 10, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Paulo César Chuquimia Mollo' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119025' LIMIT 1)
),
('Prácticas pre profesionales', 10, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Edwin Antonio Hinojosa Ramos' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119025' LIMIT 1)
),
('Robótica', 10, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Manuel Yuri Apaza Valencia' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119025' LIMIT 1)
),
('Auditoría de sistemas', 10, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Jimmy Cristian Muñoz Miranda' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119025' LIMIT 1)
),
('Procesamiento de imágenes', 10, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Israel Nazareth Chaparro Cruz' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119025' LIMIT 1)
),
('Minería de datos', 10, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Nelson Abrahan Pablo Mollo Condori' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119025' LIMIT 1)
),
('Redes de comunicación avanzadas', 10, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Genyfer Margaret Aldana Salgado' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119025' LIMIT 1)
),
('Criptografía', 10, 'A',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Carlos Hernán Acero Charaña' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119025' LIMIT 1)
),

-- DÉCIMO SEMESTRE B
('Taller de tesis II', 10, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Elena Miriam Chavez Garcés' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119007' LIMIT 1)
),
('Trabajo de investigación', 10, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Gianfranco Alexey Málaga Tejada' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119071' LIMIT 1)
),
('Prácticas pre profesionales', 10, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Diana Carolina Solis Yucra' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119036' LIMIT 1)
),
('Robótica', 10, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Jorge Ricardo Chambilla Arana' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2018-119068' LIMIT 1)
),
('Auditoría de sistemas', 10, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Jimmy Cristian Muñoz Miranda' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119048' LIMIT 1)
),
('Procesamiento de imágenes', 10, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Erbert Francisco Osco Mamani' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119079' LIMIT 1)
),
('Minería de datos', 10, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Edgar Aurelio Taya Acosta' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119043' LIMIT 1)
),
('Redes de comunicación avanzadas', 10, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Genyfer Margaret Aldana Salgado' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119013' LIMIT 1)
),
('Criptografía', 10, 'B',
  (SELECT id_docente FROM docentes WHERE nombre LIKE 'Paulo César Chuquimia Mollo' LIMIT 1),
  (SELECT id_estudiante FROM estudiantes WHERE codigo_alumno='2021-119014' LIMIT 1)
);

