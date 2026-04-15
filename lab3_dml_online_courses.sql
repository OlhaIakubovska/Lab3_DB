-- =============================================
-- Лабораторна робота №3: Маніпулювання даними SQL (OLTP)
-- Студентка: Якубовська О.В., група ІО-45
-- Тема: Повний цикл операцій DML для всіх 7 таблиць
-- =============================================

-- ---------------------------------------------------------
-- 1. ОПЕРАЦІЇ ВИБОРУ ДАНИХ (SELECT / WHERE)
-- Мета: Отримання та фільтрація даних за умовами [cite: 140, 148]
-- ---------------------------------------------------------

-- 1.1. User: Знайти контактні дані конкретного користувача за прізвищем
SELECT FirstName, LastName, Email 
FROM "User" 
WHERE LastName = 'Коваль'; [cite: 148]

-- 1.2. Student: Показати студентів, які мають понад 200 балів [cite: 150]
SELECT UserID, TotalPoints 
FROM Student 
WHERE TotalPoints > 200;

-- 1.3. Instructor: Переглянути викладачів з рейтингом вище 4.7
SELECT UserID, Expertise, Rating 
FROM Instructor 
WHERE Rating > 4.7;

-- 1.4. Course: Список курсів, що коштують від 400 до 800 грн [cite: 151]
SELECT Title, Price 
FROM Course 
WHERE Price BETWEEN 400 AND 800;

-- 1.5. Module: Пошук посилань на контент для модулів конкретного курсу
SELECT Title, ContentURL 
FROM Module 
WHERE CourseID = 2;

-- 1.6. Enrollment: Студенти, які завершили навчання (100% прогресу) [cite: 151]
SELECT StudentID, CourseID, EnrollDate 
FROM Enrollment 
WHERE Progress = 100.00 AND Status = 'Completed';

-- 1.7. Review: Отримати всі негативні або середні відгуки (рейтинг <= 3)
SELECT CourseID, StudentID, Rating, CommentText 
FROM Review 
WHERE Rating <= 3;


-- ---------------------------------------------------------
-- 2. ДОДАВАННЯ НОВИХ ДАНИХ (INSERT)
-- Мета: Створення нових записів у системі [cite: 141, 153]
-- ---------------------------------------------------------

-- 2.1. Додавання нового користувача (майбутнього викладача)
INSERT INTO "User" (FirstName, LastName, Email, Password, RegistrationDate) 
VALUES ('Віктор', 'Сидоренко', 'v.sydorenko@kpi.ua', 'pass_99', CURRENT_DATE); [cite: 154]

-- 2.2. Реєстрація як викладача
INSERT INTO Instructor (UserID, Bio, Expertise, Rating) 
VALUES (7, 'Експерт з кібербезпеки.', 'Cybersecurity', 5.00);

-- 2.3. Створення нового курсу цим викладачем
INSERT INTO Course (Title, Description, Price, InstructorID) 
VALUES ('Основи кібербезпеки', 'Вступ до захисту даних.', 1200.00, 7);

-- 2.4. Додавання модуля до нового курсу
INSERT INTO Module (CourseID, Title, OrderNumber, ContentURL) 
VALUES (6, 'Вступ до криптографії', 1, 'https://courses.ua/sec/m1');


-- ---------------------------------------------------------
-- 3. ОНОВЛЕННЯ ДАНИХ (UPDATE / SET / WHERE)
-- Мета: Зміна існуючих записів [cite: 142, 156]
-- ---------------------------------------------------------

-- 3.1. Оновлення статусу та прогресу студента (ID 1) на курсі (ID 3) [cite: 159]
UPDATE Enrollment 
SET Progress = 75.00, Status = 'Active' 
WHERE StudentID = 1 AND CourseID = 3;

-- 3.2. Зміна опису та ціни курсу (ID 5)
UPDATE Course 
SET Description = 'Оновлений курс з UX/UI дизайну 2026', Price = 450.00 
WHERE CourseID = 5;

-- 3.3. Виправлення помилки в прізвищі користувача [cite: 159]
UPDATE "User" 
SET LastName = 'Шевченко-Бондар' 
WHERE UserID = 3;


-- ---------------------------------------------------------
-- 4. ВИДАЛЕННЯ ДАНИХ (DELETE / WHERE)
-- Мета: Безпечне видалення рядків [cite: 143, 162]
-- ---------------------------------------------------------

-- 4.1. Видалення конкретного відгуку за його ID [cite: 163]
DELETE FROM Review 
WHERE ReviewID = 5;

-- 4.2. Видалення модуля курсу (наприклад, застарілий контент) [cite: 164]
DELETE FROM Module 
WHERE CourseID = 5 AND OrderNumber = 2;


-- ---------------------------------------------------------
-- 5. КОНТРОЛЬНА ПЕРЕВІРКА (OLTP SUMMARY)
-- Мета: Перегляд фінального стану таблиць [cite: 160, 186]
-- ---------------------------------------------------------

SELECT * FROM "User";
SELECT * FROM Student;
SELECT * FROM Instructor;
SELECT * FROM Course;
SELECT * FROM Module;
SELECT * FROM Enrollment;
SELECT * FROM Review;

-- =============================================
-- ПІДСУМКОВА ПЕРЕВІРКА КІЛЬКОСТІ ЗАПИСІВ
-- Мета: Порівняння стану БД після виконання OLTP-операцій
-- =============================================

SELECT 'User' AS table_name, COUNT(*) AS row_count FROM "User"
UNION ALL
SELECT 'Student', COUNT(*) FROM Student
UNION ALL
SELECT 'Instructor', COUNT(*) FROM Instructor
UNION ALL
SELECT 'Course', COUNT(*) FROM Course
UNION ALL
SELECT 'Module', COUNT(*) FROM Module
UNION ALL
SELECT 'Enrollment', COUNT(*) FROM Enrollment
UNION ALL
SELECT 'Review', COUNT(*) FROM Review
ORDER BY row_count DESC;
