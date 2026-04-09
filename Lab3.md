# Лабораторна робота №3 — Маніпулювання даними SQL (OLTP)

**Студентка:** Якубовська О.В.  
**Група:** ІО-45  

---

## Тема

Виконання OLTP-запитів (SELECT, INSERT, UPDATE, DELETE) над базою даних платформи для онлайн-курсів, створеною в лабораторних роботах №1–2.

---

## Опис схеми бази даних

База даних містить **7 таблиць** для платформи онлайн-курсів:

| Таблиця | Стовпці | Ключі та обмеження |
|---|---|---|
| `User` | UserID, FirstName, LastName, Email, Password, RegistrationDate | PK: UserID; UNIQUE: Email |
| `Student` | UserID, AcademicLevel, TotalPoints | PK/FK: UserID → User |
| `Instructor` | UserID, Bio, Expertise, Rating | PK/FK: UserID → User |
| `Course` | CourseID, Title, Description, Price, InstructorID | PK: CourseID; FK: InstructorID → Instructor; CHECK: Price >= 0 |
| `Module` | ModuleID, CourseID, Title, OrderNumber, ContentURL | PK: ModuleID; FK: CourseID → Course; UNIQUE: (CourseID, OrderNumber) |
| `Enrollment` | EnrollmentID, StudentID, CourseID, EnrollDate, Progress, Status | PK: EnrollmentID; FK: StudentID, CourseID; CHECK: Progress 0–100; UNIQUE: (StudentID, CourseID) |
| `Review` | ReviewID, CourseID, StudentID, Rating, CommentText, ReviewDate | PK: ReviewID; FK: CourseID, StudentID; CHECK: Rating 1–5; UNIQUE: (StudentID, CourseID) |

---

## Виконані операції

### Розділ 1 — SELECT (отримання даних)

Усього виконано **7 SELECT-запитів** для перевірки різних аспектів даних.

**1.1 — Всі користувачі системи**
```sql
SELECT * FROM "User";
```
Повертає всі 6 записів з таблиці User.

---

**1.2 — Імена та email студентів (з JOIN)**
```sql
SELECT u.FirstName, u.LastName, u.Email
FROM "User" u
JOIN Student s ON u.UserID = s.UserID;
```
Використовує JOIN для отримання лише тих користувачів, які є студентами.

---

**1.3 — Платні курси (WHERE + фільтрація)**
```sql
SELECT CourseID, Title, Price
FROM Course
WHERE Price > 0;
```
Фільтрує курси з ціною більше нуля.

---

**1.4 — Студенти конкретного курсу**
```sql
SELECT u.FirstName, u.LastName, e.EnrollDate, e.Progress, e.Status
FROM Enrollment e
JOIN Student s ON e.StudentID = s.UserID
JOIN "User" u ON s.UserID = u.UserID
WHERE e.CourseID = 1;
```
Показує список студентів, зарахованих на курс з CourseID = 1, та їхній прогрес.

---

**1.5 — Відгуки з рейтингом ≥ 4**
```sql
SELECT r.ReviewID, u.FirstName, u.LastName, c.Title AS CourseName,
       r.Rating, r.CommentText, r.ReviewDate
FROM Review r
JOIN "User" u ON r.StudentID = u.UserID
JOIN Course c ON r.CourseID = c.CourseID
WHERE r.Rating >= 4;
```
Отримує детальні відгуки з рейтингом 4 та 5 з іменами студентів і назвами курсів.

---

**1.6 — Модулі курсу, впорядковані за порядком**
```sql
SELECT ModuleID, Title, OrderNumber, ContentURL
FROM Module
WHERE CourseID = 1
ORDER BY OrderNumber;
```
Показує модулі курсу у правильній послідовності навчання.

---

**1.7 — Кількість курсів кожного викладача (GROUP BY)**
```sql
SELECT u.FirstName, u.LastName, COUNT(c.CourseID) AS CourseCount
FROM Instructor i
JOIN "User" u ON i.UserID = u.UserID
LEFT JOIN Course c ON c.InstructorID = i.UserID
GROUP BY u.FirstName, u.LastName;
```
Агрегований запит — підраховує кількість курсів кожного викладача.

---

### Розділ 2 — INSERT (додавання даних)

Виконано **5 INSERT-операцій** для тестування додавання нових записів.

**2.1 — Новий користувач**
```sql
INSERT INTO "User" (UserID, FirstName, LastName, Email, Password, RegistrationDate)
VALUES (7, 'Михайло', 'Коваленко', 'mykhailo.kovalenko@gmail.com', 'hashed_pass_007', '2026-04-08');
```
Додає нового користувача. Після INSERT виконується SELECT для перевірки появи запису.

---

**2.2 — Запис студента**
```sql
INSERT INTO Student (UserID, AcademicLevel, TotalPoints)
VALUES (7, 'Бакалавр', 0);
```
Прив'язує нового користувача до ролі студента.

---

**2.3 — Зарахування на курс**
```sql
INSERT INTO Enrollment (EnrollmentID, StudentID, CourseID, EnrollDate, Progress, Status)
VALUES (7, 7, 2, '2026-04-08', 0, 'Active');
```
Реєструє нового студента на курс. Зафіксована дата зарахування.

---

**2.4 — Новий курс**
```sql
INSERT INTO Course (CourseID, Title, Description, Price, InstructorID)
VALUES (6, 'Основи кібербезпеки', 'Практичний курс з захисту даних та мереж', 899.99, 4);
```
Додає новий курс від існуючого викладача (InstructorID = 4).

---

**2.5 — Модуль до нового курсу**
```sql
INSERT INTO Module (ModuleID, CourseID, Title, OrderNumber, ContentURL)
VALUES (13, 6, 'Вступ до кібербезпеки', 1, 'https://courses.example.com/cybersec/module1');
```
Додає перший модуль до щойно створеного курсу.

---

### Розділ 3 — UPDATE (оновлення даних)

Виконано **5 UPDATE-операцій**. Перед кожною — SELECT для перевірки цільових рядків.

**3.1 — Прогрес студента**
```sql
UPDATE Enrollment
SET Progress = 75, Status = 'Active'
WHERE StudentID = 1 AND CourseID = 1;
```
Оновлює відсоток проходження курсу для конкретного студента. WHERE обмежує зміну одним рядком.

---

**3.2 — Email користувача**
```sql
UPDATE "User"
SET Email = 'updated.email@example.com'
WHERE UserID = 2;
```
Змінює email конкретного користувача. Обмеження UNIQUE гарантує, що новий email унікальний.

---

**3.3 — Знижка 10% на курс**
```sql
UPDATE Course
SET Price = ROUND((Price * 0.9)::numeric, 2)
WHERE CourseID = 3;
```
Застосовує знижку до ціни курсу. Функція ROUND забезпечує коректний формат числа.

---

**3.4 — Статус завершених курсів**
```sql
UPDATE Enrollment
SET Status = 'Completed'
WHERE Progress = 100 AND Status != 'Completed';
```
Масове оновлення: всі студенти з прогресом 100%, але статусом не 'Completed', отримують оновлений статус.

---

**3.5 — Рейтинг викладача**
```sql
UPDATE Instructor
SET Rating = 4.9
WHERE UserID = 4;
```
Оновлює рейтинг викладача за результатами нових відгуків.

---

### Розділ 4 — DELETE (видалення даних)

Виконано **5 DELETE-операцій** з обов'язковим WHERE та попередньою перевіркою через SELECT.

**4.1 — Видалення відгуку**
```sql
DELETE FROM Review WHERE ReviewID = 5;
```
Видаляє конкретний відгук. Перед цим виконується SELECT для перевірки, що саме видаляється.

---

**4.2 — Скасування зарахування**
```sql
DELETE FROM Enrollment WHERE StudentID = 7 AND CourseID = 2;
```
Видаляє запис про зарахування нового тестового студента на курс.

---

**4.3 — Видалення модуля**
```sql
DELETE FROM Module WHERE ModuleID = 13;
```
Видаляє тестовий модуль з курсу.

---

**4.4 — Видалення курсу**
```sql
DELETE FROM Course WHERE CourseID = 6;
```
Видаляє тестовий курс. Перед операцією перевірено відсутність активних зарахувань на нього — дотримання правила безпечного видалення.

---

**4.5 — Видалення тестового користувача**
```sql
DELETE FROM Student WHERE UserID = 7;
DELETE FROM "User" WHERE UserID = 7;
```
Видаляє спочатку дочірній запис (Student), потім батьківський (User) — для дотримання цілісності зовнішніх ключів.

---

## Дотримання найкращих практик

| Практика | Виконання |
|---|---|
| WHERE у кожному UPDATE/DELETE | ✅ Використовується в усіх запитах |
| SELECT перед UPDATE/DELETE | ✅ Перевірка цільових рядків перед кожною зміною |
| Порядок видалення (дочірні → батьківські) | ✅ Student видаляється перед User |
| Перевірка обмежень (CHECK, UNIQUE) | ✅ Враховано при INSERT (Progress=0, Rating в межах 1-5) |
| Коментарі в SQL | ✅ Кожна секція та запит мають опис |

---

## Фінальна перевірка кількості записів

```sql
SELECT 'User' AS Таблиця, COUNT(*) AS Рядків FROM "User"
UNION ALL SELECT 'Student', COUNT(*) FROM Student
UNION ALL SELECT 'Instructor', COUNT(*) FROM Instructor
UNION ALL SELECT 'Course', COUNT(*) FROM Course
UNION ALL SELECT 'Module', COUNT(*) FROM Module
UNION ALL SELECT 'Enrollment', COUNT(*) FROM Enrollment
UNION ALL SELECT 'Review', COUNT(*) FROM Review;
```

Очікувані результати після всіх операцій:

| Таблиця | Початково | Після Lab 3 |
|---|---|---|
| User | 6 | 6 |
| Student | 3 | 3 |
| Instructor | 3 | 3 |
| Course | 5 | 5 |
| Module | 12 | 12 |
| Enrollment | 6 | 6 |
| Review | 5 | 4 |

> Таблиця Review зменшилась на 1 рядок через видалення ReviewID = 5 у розділі DELETE.

---

## Висновок

У ході виконання лабораторної роботи №3 було успішно реалізовано основні операції маніпулювання даними (DML) в PostgreSQL на базі платформи для онлайн-курсів. Написано та протестовано 7 SELECT-запитів (включно з JOIN, WHERE, GROUP BY та ORDER BY), 5 INSERT-операцій для додавання нових користувачів, студентів, курсів та модулів, 5 UPDATE-операцій для оновлення прогресу, цін та рейтингів, а також 5 DELETE-операцій з дотриманням порядку видалення дочірніх/батьківських записів. У всіх запитах на зміну даних обов'язково використовувалося речення WHERE для точного вибору рядків, а перед кожною модифікацією виконувався SELECT для попередньої перевірки.
