-- ============================================================
-- Лабораторна робота №3: Маніпулювання даними SQL (OLTP)
-- Студентка: Якубовська О.В., Група: ІО-45
-- База даних: Платформа для онлайн-курсів
-- ============================================================

-- ============================================================
-- РОЗДІЛ 1: SELECT — отримання даних
-- ============================================================

-- 1.1 Отримати всіх користувачів системи
SELECT * FROM "User";

-- 1.2 Отримати лише імена та email студентів
SELECT u.FirstName, u.LastName, u.Email
FROM "User" u
JOIN Student s ON u.UserID = s.UserID;

-- 1.3 Отримати всі курси з ціною більше 0 (платні курси)
SELECT CourseID, Title, Price
FROM Course
WHERE Price > 0;

-- 1.4 Отримати список студентів, зарахованих на конкретний курс (CourseID = 1)
SELECT u.FirstName, u.LastName, e.EnrollDate, e.Progress, e.Status
FROM Enrollment e
JOIN Student s ON e.StudentID = s.UserID
JOIN "User" u ON s.UserID = u.UserID
WHERE e.CourseID = 1;

-- 1.5 Отримати всі відгуки з рейтингом 4 або вище
SELECT r.ReviewID, u.FirstName, u.LastName, c.Title AS CourseName,
       r.Rating, r.CommentText, r.ReviewDate
FROM Review r
JOIN "User" u ON r.StudentID = u.UserID
JOIN Course c ON r.CourseID = c.CourseID
WHERE r.Rating >= 4;

-- 1.6 Отримати всі модулі курсу з CourseID = 1, впорядковані за OrderNumber
SELECT ModuleID, Title, OrderNumber, ContentURL
FROM Module
WHERE CourseID = 1
ORDER BY OrderNumber;

-- 1.7 Отримати викладачів та кількість їхніх курсів
SELECT u.FirstName, u.LastName, COUNT(c.CourseID) AS CourseCount
FROM Instructor i
JOIN "User" u ON i.UserID = u.UserID
LEFT JOIN Course c ON c.InstructorID = i.UserID
GROUP BY u.FirstName, u.LastName;

-- ============================================================
-- РОЗДІЛ 2: INSERT — додавання нових даних
-- ============================================================

-- 2.1 Додати нового користувача (майбутній студент)
INSERT INTO "User" (UserID, FirstName, LastName, Email, Password, RegistrationDate)
VALUES (7, 'Михайло', 'Коваленко', 'mykhailo.kovalenko@gmail.com', 'hashed_pass_007', '2026-04-08');

-- Перевірка: чи з'явився новий рядок
SELECT * FROM "User" WHERE UserID = 7;

-- 2.2 Додати запис студента для нового користувача
INSERT INTO Student (UserID, AcademicLevel, TotalPoints)
VALUES (7, 'Бакалавр', 0);

-- Перевірка
SELECT u.FirstName, u.LastName, s.AcademicLevel, s.TotalPoints
FROM "User" u JOIN Student s ON u.UserID = s.UserID
WHERE u.UserID = 7;

-- 2.3 Зарахувати нового студента на курс (CourseID = 2)
INSERT INTO Enrollment (EnrollmentID, StudentID, CourseID, EnrollDate, Progress, Status)
VALUES (7, 7, 2, '2026-04-08', 0, 'Active');

-- Перевірка
SELECT e.EnrollmentID, u.FirstName, c.Title, e.EnrollDate, e.Status
FROM Enrollment e
JOIN "User" u ON e.StudentID = u.UserID
JOIN Course c ON e.CourseID = c.CourseID
WHERE e.StudentID = 7;

-- 2.4 Додати новий курс від існуючого викладача (InstructorID = 4)
INSERT INTO Course (CourseID, Title, Description, Price, InstructorID)
VALUES (6, 'Основи кібербезпеки', 'Практичний курс з захисту даних та мереж', 899.99, 4);

-- Перевірка
SELECT * FROM Course WHERE CourseID = 6;

-- 2.5 Додати модуль до нового курсу
INSERT INTO Module (ModuleID, CourseID, Title, OrderNumber, ContentURL)
VALUES (13, 6, 'Вступ до кібербезпеки', 1, 'https://courses.example.com/cybersec/module1');

-- Перевірка
SELECT * FROM Module WHERE CourseID = 6;

-- ============================================================
-- РОЗДІЛ 3: UPDATE — оновлення існуючих даних
-- ============================================================

-- 3.1 Оновити прогрес студента на курсі
-- Спочатку перевіряємо, що будемо змінювати:
SELECT * FROM Enrollment WHERE StudentID = 1 AND CourseID = 1;

-- Оновлюємо прогрес студента (StudentID=1) на курсі (CourseID=1) до 75%
UPDATE Enrollment
SET Progress = 75, Status = 'Active'
WHERE StudentID = 1 AND CourseID = 1;

-- Перевірка після UPDATE
SELECT StudentID, CourseID, Progress, Status
FROM Enrollment
WHERE StudentID = 1 AND CourseID = 1;

-- 3.2 Оновити email користувача
-- Спочатку перевіряємо:
SELECT UserID, Email FROM "User" WHERE UserID = 2;

UPDATE "User"
SET Email = 'updated.email@example.com'
WHERE UserID = 2;

-- Перевірка
SELECT UserID, FirstName, Email FROM "User" WHERE UserID = 2;

-- 3.3 Оновити ціну курсу (знижка 10%)
-- Спочатку перевіряємо:
SELECT CourseID, Title, Price FROM Course WHERE CourseID = 3;

UPDATE Course
SET Price = ROUND((Price * 0.9)::numeric, 2)
WHERE CourseID = 3;

-- Перевірка
SELECT CourseID, Title, Price FROM Course WHERE CourseID = 3;

-- 3.4 Оновити статус зарахування на "Completed" для студента, який завершив курс
-- Спочатку перевіряємо студентів з прогресом 100%:
SELECT * FROM Enrollment WHERE Progress = 100;

UPDATE Enrollment
SET Status = 'Completed'
WHERE Progress = 100 AND Status != 'Completed';

-- Перевірка
SELECT StudentID, CourseID, Progress, Status
FROM Enrollment
WHERE Progress = 100;

-- 3.5 Оновити рейтинг викладача (Instructor) на основі нових відгуків
-- Спочатку перевіряємо:
SELECT i.UserID, i.Rating FROM Instructor i WHERE i.UserID = 4;

UPDATE Instructor
SET Rating = 4.9
WHERE UserID = 4;

-- Перевірка
SELECT u.FirstName, u.LastName, i.Rating
FROM Instructor i JOIN "User" u ON i.UserID = u.UserID
WHERE i.UserID = 4;

-- ============================================================
-- РОЗДІЛ 4: DELETE — видалення даних
-- ============================================================

-- 4.1 Видалити відгук студента (ReviewID = 5)
-- Спочатку перевіряємо, який відгук видаляємо:
SELECT * FROM Review WHERE ReviewID = 5;

DELETE FROM Review
WHERE ReviewID = 5;

-- Перевірка — рядка більше не повинно бути:
SELECT * FROM Review WHERE ReviewID = 5;

-- 4.2 Видалити зарахування (скасувати запис на курс)
-- Спочатку перевіряємо:
SELECT * FROM Enrollment WHERE StudentID = 7 AND CourseID = 2;

DELETE FROM Enrollment
WHERE StudentID = 7 AND CourseID = 2;

-- Перевірка
SELECT * FROM Enrollment WHERE StudentID = 7 AND CourseID = 2;

-- 4.3 Видалити модуль з курсу
-- Спочатку перевіряємо:
SELECT * FROM Module WHERE ModuleID = 13;

DELETE FROM Module
WHERE ModuleID = 13;

-- Перевірка
SELECT * FROM Module WHERE ModuleID = 13;

-- 4.4 Видалити курс (спочатку переконатися, що немає активних зарахувань)
-- Перевіряємо активні зарахування на CourseID = 6:
SELECT * FROM Enrollment WHERE CourseID = 6;

-- Курс не має зарахувань — видаляємо безпечно:
DELETE FROM Course
WHERE CourseID = 6;

-- Перевірка
SELECT * FROM Course WHERE CourseID = 6;

-- 4.5 Видалити нового тестового користувача (каскадне видалення)
-- Спочатку перевіряємо, що пов'язані записи вже видалені:
SELECT * FROM Student WHERE UserID = 7;

DELETE FROM Student WHERE UserID = 7;
DELETE FROM "User" WHERE UserID = 7;

-- Перевірка
SELECT * FROM "User" WHERE UserID = 7;

-- ============================================================
-- РОЗДІЛ 5: Фінальна перевірка стану таблиць
-- ============================================================

SELECT 'User' AS Таблиця, COUNT(*) AS Рядків FROM "User"
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
SELECT 'Review', COUNT(*) FROM Review;
