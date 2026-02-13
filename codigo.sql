
CREATE DATABASE programa_apoyo_social;
USE programa_apoyo_social;

CREATE TABLE clasificacion (
    id_clasificacion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE sexo (
    id_sexo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE documento_identidad (
    id_documento_identidad INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE intervalo_temporal (
    id_intervalo_temporal INT AUTO_INCREMENT PRIMARY KEY,
    ano YEAR NOT NULL
);

CREATE TABLE preferencia_afectiva (
    id_preferencia_afectiva INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE trayectoria_migratoria (
    id_trayectoria_migratoria INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE pertenencia_etnica (
    id_pertenecia_etnica INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE grado_formacion (
    id_grado_formacion INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE situacion_laboral (
    id_situacion_laboral INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE capacidad_diferencial (
    id_capacidad_diferencial INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE jefatura_hogar (
    id_jefatura_hogar INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE sector_geografico (
    id_sector_geografico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE distrito (
    id_distrito INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    id_sector_geografico INT,
    FOREIGN KEY (id_sector_geografico) REFERENCES sector_geografico(id_sector_geografico)
);

CREATE TABLE localidad (
    id_localidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    id_distrito INT,
    FOREIGN KEY (id_distrito) REFERENCES distrito(id_distrito)
);

CREATE TABLE beneficiario_atendido (
    id_beneficiario_atendido INT AUTO_INCREMENT PRIMARY KEY,
    id_distrito INT,
    id_intervalo_temporal INT,
    id_sexo INT,
    edad INT,
    id_documento_identidad INT,
    tiene_discapacidad TINYINT(1),
    id_capacidad_diferencial INT,
    id_jefatura_hogar INT,
    id_preferencia_afectiva INT,
    id_experiencia_migratoria INT,
    id_grupo_etnico INT,
    id_grado_formacion INT,
    id_situacion_laboral INT,
    id_localidad INT,
    id_clasificacion INT,
    FOREIGN KEY (id_distrito) REFERENCES distrito(id_distrito),
    FOREIGN KEY (id_intervalo_temporal) REFERENCES intervalo_temporal(id_intervalo_temporal),
    FOREIGN KEY (id_sexo) REFERENCES sexo(id_sexo),
    FOREIGN KEY (id_documento_identidad) REFERENCES documento_identidad(id_documento_identidad),
    FOREIGN KEY (id_capacidad_diferencial) REFERENCES capacidad_diferencial(id_capacidad_diferencial),
    FOREIGN KEY (id_jefatura_hogar) REFERENCES jefatura_hogar(id_jefatura_hogar),
    FOREIGN KEY (id_preferencia_afectiva) REFERENCES preferencia_afectiva(id_preferencia_afectiva),
    FOREIGN KEY (id_experiencia_migratoria) REFERENCES trayectoria_migratoria(id_trayectoria_migratoria),
    FOREIGN KEY (id_grupo_etnico) REFERENCES pertenencia_etnica(id_pertenecia_etnica),
    FOREIGN KEY (id_grado_formacion) REFERENCES grado_formacion(id_grado_formacion),
    FOREIGN KEY (id_situacion_laboral) REFERENCES situacion_laboral(id_situacion_laboral),
    FOREIGN KEY (id_localidad) REFERENCES localidad(id_localidad),
    FOREIGN KEY (id_clasificacion) REFERENCES clasificacion(id_clasificacion)
);

INSERT INTO clasificacion (nombre)
SELECT DISTINCT CATEGORIA
FROM consolidado_usuarios
WHERE CATEGORIA IS NOT NULL AND TRIM(CATEGORIA) != '';

INSERT INTO sexo (nombre)
SELECT DISTINCT `GÉNERO`
FROM consolidado_usuarios
WHERE `GÉNERO` IS NOT NULL AND TRIM(`GÉNERO`) != '';

INSERT INTO documento_identidad (descripcion)
SELECT DISTINCT `TIPO DE IDENTIFICACION`
FROM consolidado_usuarios
WHERE `TIPO DE IDENTIFICACION` IS NOT NULL AND TRIM(`TIPO DE IDENTIFICACION`) != '';

INSERT INTO intervalo_temporal (ano)
SELECT DISTINCT REPLACE(PERIODO, ',', '')
FROM consolidado_usuarios
WHERE PERIODO IS NOT NULL AND TRIM(PERIODO) != '';

INSERT INTO preferencia_afectiva (descripcion)
SELECT DISTINCT `ORIENTACION SEXUAL COMUNIDAD LGTBI`
FROM consolidado_usuarios
WHERE `ORIENTACION SEXUAL COMUNIDAD LGTBI` IS NOT NULL AND TRIM(`ORIENTACION SEXUAL COMUNIDAD LGTBI`) != '';

INSERT INTO trayectoria_migratoria (descripcion)
SELECT DISTINCT UPPER(`EXPERIENCIA MIGRATORIA DENTRO DEL NUCLEO FAMILIAR`)
FROM consolidado_usuarios
WHERE `EXPERIENCIA MIGRATORIA DENTRO DEL NUCLEO FAMILIAR` IS NOT NULL AND TRIM(`EXPERIENCIA MIGRATORIA DENTRO DEL NUCLEO FAMILIAR`) != '';

INSERT INTO pertenencia_etnica (descripcion)
SELECT DISTINCT `GRUPOS ÉTNICOS AFRO/INDIGENA`
FROM consolidado_usuarios
WHERE `GRUPOS ÉTNICOS AFRO/INDIGENA` IS NOT NULL AND TRIM(`GRUPOS ÉTNICOS AFRO/INDIGENA`) != '';

INSERT INTO grado_formacion (descripcion)
SELECT DISTINCT `NIVEL EDUCATIVO QUE TIENE O CURSA`
FROM consolidado_usuarios
WHERE `NIVEL EDUCATIVO QUE TIENE O CURSA` IS NOT NULL AND TRIM(`NIVEL EDUCATIVO QUE TIENE O CURSA`) != '';

INSERT INTO situacion_laboral (descripcion)
SELECT DISTINCT CASE 
    WHEN TRIM(`CONDICIÓN OCUPACIONAL`) = '' THEN 'SIN INFORMACION'
    ELSE `CONDICIÓN OCUPACIONAL`
END
FROM consolidado_usuarios
WHERE `CONDICIÓN OCUPACIONAL` IS NOT NULL;

INSERT INTO capacidad_diferencial (descripcion)
SELECT DISTINCT `TIPO DE DISCAPACIDAD`
FROM consolidado_usuarios
WHERE `TIPO DE DISCAPACIDAD` IS NOT NULL AND TRIM(`TIPO DE DISCAPACIDAD`) != '';

INSERT INTO jefatura_hogar (descripcion)
SELECT DISTINCT `HOMBRES Y MUJERES CABEZA DE FAMILIA`
FROM consolidado_usuarios
WHERE `HOMBRES Y MUJERES CABEZA DE FAMILIA` IS NOT NULL AND TRIM(`HOMBRES Y MUJERES CABEZA DE FAMILIA`) != '';

INSERT INTO sector_geografico (nombre)
SELECT DISTINCT `ZONA DE RESIDENCIA`
FROM consolidado_usuarios
WHERE `ZONA DE RESIDENCIA` IS NOT NULL AND TRIM(`ZONA DE RESIDENCIA`) != '';

INSERT INTO distrito (nombre, id_sector_geografico)
SELECT DISTINCT 
    cu.`COMUNA O CORREGIMIENTO DE RESIDENCIA`,
    sg.id_sector_geografico
FROM consolidado_usuarios cu
INNER JOIN sector_geografico sg ON sg.nombre = cu.`ZONA DE RESIDENCIA`
WHERE cu.`COMUNA O CORREGIMIENTO DE RESIDENCIA` IS NOT NULL 
    AND TRIM(cu.`COMUNA O CORREGIMIENTO DE RESIDENCIA`) != '';

INSERT INTO localidad (nombre, id_distrito)
SELECT DISTINCT 
    cu.`BARRIO O VEREDA DE RESIDENCIA`,
    d.id_distrito
FROM consolidado_usuarios cu
INNER JOIN distrito d ON d.nombre = cu.`COMUNA O CORREGIMIENTO DE RESIDENCIA`
WHERE cu.`BARRIO O VEREDA DE RESIDENCIA` IS NOT NULL 
    AND TRIM(cu.`BARRIO O VEREDA DE RESIDENCIA`) != '';

INSERT INTO beneficiario_atendido (
    id_distrito,
    id_intervalo_temporal,
    id_sexo,
    edad,
    id_documento_identidad,
    tiene_discapacidad,
    id_capacidad_diferencial,
    id_jefatura_hogar,
    id_preferencia_afectiva,
    id_experiencia_migratoria,
    id_grupo_etnico,
    id_grado_formacion,
    id_situacion_laboral,
    id_localidad,
    id_clasificacion
)
SELECT 
    d.id_distrito,
    it.id_intervalo_temporal,
    s.id_sexo,
    cu.EDAD,
    di.id_documento_identidad,
    CASE 
        WHEN UPPER(cu.`PERSONAS EN CONDICIÓN DE DISCAPACIDAD`) = 'SI' THEN 1
        WHEN UPPER(cu.`PERSONAS EN CONDICIÓN DE DISCAPACIDAD`) = 'NO' THEN 2
        ELSE 2
    END,
    cd.id_capacidad_diferencial,
    jh.id_jefatura_hogar,
    pa.id_preferencia_afectiva,
    tm.id_trayectoria_migratoria,
    pe.id_pertenecia_etnica,
    gf.id_grado_formacion,
    sl.id_situacion_laboral,
    l.id_localidad,
    c.id_clasificacion
FROM consolidado_usuarios cu
INNER JOIN distrito d ON d.nombre = cu.`COMUNA O CORREGIMIENTO DE RESIDENCIA`
INNER JOIN intervalo_temporal it ON it.ano = REPLACE(cu.PERIODO, ',', '')
INNER JOIN sexo s ON s.nombre = cu.`GÉNERO`
INNER JOIN documento_identidad di ON di.descripcion = cu.`TIPO DE IDENTIFICACION`
INNER JOIN capacidad_diferencial cd ON cd.descripcion = cu.`TIPO DE DISCAPACIDAD`
INNER JOIN jefatura_hogar jh ON jh.descripcion = cu.`HOMBRES Y MUJERES CABEZA DE FAMILIA`
INNER JOIN preferencia_afectiva pa ON pa.descripcion = cu.`ORIENTACION SEXUAL COMUNIDAD LGTBI`
INNER JOIN trayectoria_migratoria tm ON tm.descripcion = UPPER(cu.`EXPERIENCIA MIGRATORIA DENTRO DEL NUCLEO FAMILIAR`)
INNER JOIN pertenencia_etnica pe ON pe.descripcion = cu.`GRUPOS ÉTNICOS AFRO/INDIGENA`
INNER JOIN grado_formacion gf ON gf.descripcion = cu.`NIVEL EDUCATIVO QUE TIENE O CURSA`
INNER JOIN situacion_laboral sl ON sl.descripcion = CASE 
    WHEN TRIM(cu.`CONDICIÓN OCUPACIONAL`) = '' THEN 'SIN INFORMACION'
    ELSE cu.`CONDICIÓN OCUPACIONAL`
END
INNER JOIN localidad l ON l.nombre = cu.`BARRIO O VEREDA DE RESIDENCIA`
INNER JOIN clasificacion c ON c.nombre = cu.CATEGORIA;