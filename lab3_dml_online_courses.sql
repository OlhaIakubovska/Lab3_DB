-- =============================================
-- Лабораторна робота №3
-- OLTP-запити до бази даних онлайн-курсів
-- Студентка: Якубовська О.В., група ІО-45
-- =============================================


-- ========================
-- РОЗДІЛ 1: SELECT-запити
-- ========================

-- 1.1 Отримати повний список користувачів (ім'я, прізвище, email)
SELECT FirstName, LastName, Email
FROM "User"
ORDER BY LastName;

-- 1.2 Отримати список студентів з їх академічним рівнем та балами
SELECT u.FirstName, u.LastName, s.AcademicLevel, s.TotalPoints
FROM "User" u
JOIN Student s ON u.UserID = s.UserID
ORDER BY s.TotalPoints DESC;

-- 1.3 Отримати список викладачів з їх спеціалізацією та рейтингом
SELECT u.FirstName, u.LastName, i.Expertise, i.Rating
FROM "User" u
JOIN Instructor i ON u.UserID = i.UserID
ORDER BY i.Rating DESC;

-- 1.4 Отримати всі курси з ім'ям викладача та ціною
SELECT c.Title AS CourseTitle, c.Price,
       u.FirstName || ' ' || u.LastName AS InstructorName
FROM Course c
JOIN Instructor i ON c.InstructorID = i.UserID
JOIN "User" u ON i.UserID = u.UserID
ORDER BY c.Price DESC;

-- 1.5 Отримати всі активні зарахування студентів (Status = 'Active')
SELECT u.FirstName || ' ' || u.LastName AS StudentName,
       c.Title AS CourseName,
       e.EnrollDate,
       e.Progress
FROM Enrollment e
JOIN Student s ON e.StudentID = s.UserID
JOIN "User" u ON s.UserID = u.UserID
JOIN Course c ON e.CourseID = c.CourseID
WHERE e.Status = 'Active'
ORDER BY e.Progress DESC;

-- 1.6 Отримати курси, які завершив конкретний студент (StudentID = 2)
SELECT c.Title, e.EnrollDate, e.Progress, e.Status
FROM Enrollment e
JOIN Course c ON e.CourseID = c.CourseID
WHERE e.StudentID = 2
  AND e.Status = 'Completed';

-- 1.7 Отримати відгуки на курс з назвою курсу та ім'ям студента
SELECT c.Title AS CourseName,
       u.FirstName || ' ' || u.LastName AS StudentName,
       r.Rating,
       r.CommentText,
       r.ReviewDate
FROM Review r
JOIN Course c ON r.CourseID = c.CourseID
JOIN Student s ON r.StudentID = s.UserID
JOIN "User" u ON s.UserID = u.UserID
ORDER BY r.ReviewDate DESC;

-- 1.8 Знайти курси дешевше 600 грн
SELECT Title, Price, Description
FROM Course
WHERE Price < 600
ORDER BY Price ASC;

-- 1.9 Знайти студентів, які мають більше 100 балів
SELECT u.FirstName, u.LastName, s.TotalPoints
FROM "User" u
JOIN Student s ON u.UserID = s.UserID
WHERE s.TotalPoints > 100
ORDER BY s.TotalPoints DESC;

-- 1.10 Отримати модулі конкретного курсу (CourseID = 2) у правильному порядку
SELECT m.OrderNumber, m.Title, m.ContentURL
FROM Module m
WHERE m.CourseID = 2
ORDER BY m.OrderNumber ASC;


-- ========================
-- РОЗДІЛ 2: INSERT-запити
-- ========================

-- 2.1 Додати нового користувача
INSERT INTO "User" (FirstName, LastName, Email, Password, RegistrationDate)
VALUES ('Сергій', 'Петренко', 's.petrenko@gmail.com', 'hashed_pass_7', CURRENT_DATE);

-- 2.2 Зареєструвати нового студента (використовує UserID щойно доданого користувача)
INSERT INTO Student (UserID, AcademicLevel, TotalPoints)
VALUES (
    (SELECT UserID FROM "User" WHERE Email = 's.petrenko@gmail.com'),
    'магістр',
    0
);

-- 2.3 Зарахувати студента на курс
INSERT INTO Enrollment (StudentID, CourseID, EnrollDate, Progress, Status)
VALUES (
    (SELECT UserID FROM "User" WHERE Email = 's.petrenko@gmail.com'),
    3,
    CURRENT_DATE,
    0,
    'Active'
);

-- 2.4 Додати новий курс (викладач з ID = 5)
INSERT INTO Course (Title, Description, Price, InstructorID)
VALUES (
    'Deep Learning з PyTorch',
    'Практичний курс з глибокого навчання на базі PyTorch.',
    999.00,
    5
);

-- 2.5 Додати модуль до нового курсу
INSERT INTO Module (CourseID, Title, OrderNumber, ContentURL)
VALUES (
    (SELECT CourseID FROM Course WHERE Title = 'Deep Learning з PyTorch'),
    'Вступ до нейронних мереж',
    1,
    'https://courses.example.com/dl/module1'
);

-- 2.6 Додати відгук від студента на курс (студент 1 на курс 3)
INSERT INTO Review (CourseID, StudentID, Rating, CommentText, ReviewDate)
VALUES (3, 1, 5, 'Відмінний курс з React! Дуже структуровано.', CURRENT_DATE);


-- ========================
-- РОЗДІЛ 3: UPDATE-запити
-- ========================

-- 3.1 Оновити прогрес студента на курсі
UPDATE Enrollment
SET Progress = 75.00
WHERE StudentID = 3
  AND CourseID = 3;

-- 3.2 Позначити зарахування як завершене (після досягнення 100% прогресу)
UPDATE Enrollment
SET Progress = 100.00,
    Status   = 'Completed'
WHERE StudentID = 2
  AND CourseID  = 1;

-- 3.3 Нарахувати бали студенту за завершення курсу
UPDATE Student
SET TotalPoints = TotalPoints + 50
WHERE UserID = 2;

-- 3.4 Оновити ціну курсу
UPDATE Course
SET Price = 549.00
WHERE CourseID = 5;

-- 3.5 Оновити рейтинг викладача
UPDATE Instructor
SET Rating = 4.75
WHERE UserID = 6;

-- 3.6 Виправити email користувача
UPDATE "User"
SET Email = 's.petrenko@ukr.net'
WHERE Email = 's.petrenko@gmail.com';

-- 3.7 Оновити URL-адресу модуля
UPDATE Module
SET ContentURL = 'https://courses.example.com/python/module1-v2'
WHERE CourseID = 1
  AND OrderNumber = 1;


-- ========================
-- РОЗДІЛ 4: DELETE-запити
-- ========================

-- 4.1 Видалити відгук конкретного студента на курс
DELETE FROM Review
WHERE StudentID = 1
  AND CourseID  = 3;

-- 4.2 Скасувати зарахування студента на курс (відрахувати з курсу)
DELETE FROM Enrollment
WHERE StudentID = (SELECT UserID FROM "User" WHERE Email = 's.petrenko@ukr.net')
  AND CourseID  = 3;

-- 4.3 Видалити модуль курсу
DELETE FROM Module
WHERE CourseID    = (SELECT CourseID FROM Course WHERE Title = 'Deep Learning з PyTorch')
  AND OrderNumber = 1;

-- 4.4 Видалити щойно доданий курс (спочатку видаляються модулі через CASCADE)
DELETE FROM Course
WHERE Title = 'Deep Learning з PyTorch';

-- 4.5 Видалити нового користувача разом із записом студента (через CASCADE)
DELETE FROM "User"
WHERE Email = 's.petrenko@ukr.net';


-- ========================
-- РОЗДІЛ 5: ПЕРЕВІРКА
-- ========================

-- Перевірити поточний стан таблиць після всіх операцій
SELECT * FROM "User";
SELECT * FROM Student;
SELECT * FROM Instructor;
SELECT * FROM Course;
SELECT * FROM Module;
SELECT * FROM Enrollment;
SELECT * FROM Review;
