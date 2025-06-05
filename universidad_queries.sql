
-- 1. List first surname, second surname, and name of all students ordered alphabetically
SELECT apellido1 AS surname1, apellido2 AS surname2, nombre AS name FROM persona WHERE tipo = 'alumno' ORDER BY apellido1, apellido2, nombre;

-- 2. Students without a phone number
SELECT nombre AS name, apellido1 AS surname1, apellido2 AS surname2 FROM persona WHERE tipo = 'alumno' AND telefono IS NULL;

-- 3. Students born in 1999
SELECT * FROM persona WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 4. Professors without a phone number and NIF ending in 'K'
SELECT nombre AS name, apellido1 AS surname1, apellido2 AS surname2 FROM persona WHERE tipo = 'profesor' AND telefono IS NULL AND nif LIKE '%K';

-- 5. Subjects taught in the first semester, third year, degree with ID 7
SELECT nombre AS subject_name FROM asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- 6. Professors and their department
SELECT p.apellido1 AS surname1, p.apellido2 AS surname2, p.nombre AS name, d.nombre AS department_name
FROM persona p
JOIN profesor pr ON p.id = pr.id_profesor
JOIN departamento d ON pr.id_departamento = d.id
ORDER BY p.apellido1, p.apellido2, p.nombre;

-- 7. Subjects, start year and end year of the school year for the student with NIF 26902806M
SELECT a.nombre AS subject_name, ce.anyo_inicio AS start_year, ce.anyo_fin AS end_year
FROM alumno_se_matricula_asignatura am
JOIN persona p ON am.id_alumno = p.id
JOIN asignatura a ON am.id_asignatura = a.id
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
WHERE p.nif = '26902806M';

-- 8. Departments with professors teaching subjects in Computer Engineering Degree (Plan 2015)
SELECT DISTINCT d.nombre AS department_name
FROM departamento d
JOIN profesor pr ON d.id = pr.id_departamento
JOIN asignatura a ON pr.id_profesor = a.id_profesor
JOIN grado g ON a.id_grado = g.id
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Students enrolled in any subject during the 2018/2019 school year
SELECT DISTINCT p.*
FROM persona p
JOIN alumno_se_matricula_asignatura am ON p.id = am.id_alumno
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
WHERE ce.anyo_inicio = 2018 AND ce.anyo_fin = 2019;

-- LEFT JOIN and RIGHT JOIN

-- 10. Professors and departments (including professors without a department)
SELECT d.nombre AS department_name, p.apellido1 AS surname1, p.apellido2 AS surname2, p.nombre AS name
FROM persona p
LEFT JOIN profesor pr ON p.id = pr.id_profesor
LEFT JOIN departamento d ON pr.id_departamento = d.id
WHERE p.tipo = 'profesor'
ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre;

-- 11. Professors without a department
SELECT p.nombre AS name, p.apellido1 AS surname1, p.apellido2 AS surname2
FROM persona p
LEFT JOIN profesor pr ON p.id = pr.id_profesor
WHERE p.tipo = 'profesor' AND pr.id_departamento IS NULL;

-- 12. Departments without professors
SELECT d.nombre AS department_name
FROM departamento d
LEFT JOIN profesor pr ON d.id = pr.id_departamento
WHERE pr.id_profesor IS NULL;

-- 13. Professors without subjects assigned
SELECT p.nombre AS name, p.apellido1 AS surname1, p.apellido2 AS surname2
FROM persona p
LEFT JOIN profesor pr ON p.id = pr.id_profesor
LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor' AND a.id IS NULL;

-- 14. Subjects without assigned professors
SELECT nombre AS subject_name
FROM asignatura
WHERE id_profesor IS NULL;

-- 15. Departments not teaching any subjects
SELECT d.nombre AS department_name
FROM departamento d
LEFT JOIN profesor pr ON d.id = pr.id_departamento
LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor
WHERE a.id IS NULL;

-- Summary Queries

-- 16. Total number of students
SELECT COUNT(*) FROM persona WHERE tipo = 'alumno';

-- 17. Number of students born in 1999
SELECT COUNT(*) FROM persona WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 18. Number of professors per department (only with professors)
SELECT d.nombre AS department_name, COUNT(*) AS num_professors
FROM profesor pr
JOIN departamento d ON pr.id_departamento = d.id
GROUP BY d.id
ORDER BY num_professors DESC;

-- 19. Number of professors per department (including those without professors)
SELECT d.nombre AS department_name, COUNT(pr.id_profesor) AS num_professors
FROM departamento d
LEFT JOIN profesor pr ON d.id = pr.id_departamento
GROUP BY d.id;

-- 20. Number of subjects per degree
SELECT g.nombre AS degree_name, COUNT(a.id) AS num_subjects
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id
ORDER BY num_subjects DESC;

-- 21. Number of subjects per degree (more than 40 subjects)
SELECT g.nombre AS degree_name, COUNT(a.id) AS num_subjects
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id
HAVING num_subjects > 40;

-- 22. Sum of credits per subject type per degree
SELECT g.nombre AS degree_name, a.tipo AS subject_type, SUM(a.creditos) AS total_credits
FROM grado g
JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre, a.tipo;

-- 23. Number of students enrolled per school year
SELECT ce.anyo_inicio AS start_year, COUNT(DISTINCT am.id_alumno) AS num_students
FROM curso_escolar ce
JOIN alumno_se_matricula_asignatura am ON ce.id = am.id_curso_escolar
GROUP BY ce.anyo_inicio;

-- 24. Number of subjects taught by each professor
SELECT p.id, p.nombre AS name, p.apellido1 AS surname1, p.apellido2 AS surname2, COUNT(a.id) AS num_subjects
FROM persona p
LEFT JOIN profesor pr ON p.id = pr.id_profesor
LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor'
GROUP BY p.id
ORDER BY num_subjects DESC;

-- 25. Data of the youngest student
SELECT * FROM persona WHERE tipo = 'alumno' ORDER BY fecha_nacimiento DESC LIMIT 1;

-- 26. Professors with an associated department and no assigned subjects
SELECT p.nombre AS name, p.apellido1 AS surname1, p.apellido2 AS surname2
FROM persona p
JOIN profesor pr ON p.id = pr.id_profesor
LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor' AND a.id IS NULL;
