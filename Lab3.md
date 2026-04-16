# Звіт з лабораторної роботи №3
**Тема:** OLTP-запити до бази даних онлайн-курсів
**Студентка:** Якубовська О.В.
**Група:** ІО-45

---

## 1. Мета роботи
Набуття практичних навичок роботи з SQL-запитами для маніпуляції даними (DML) у середовищі PostgreSQL. Навчитися виконувати вибірку даних (SELECT) з використанням об'єднань, а також операції додавання (INSERT), оновлення (UPDATE) та видалення (DELETE) записів з дотриманням цілісності бази даних.

## 2. Хід роботи

### 2.1. Вибірка даних (SELECT-запити)
Було розроблено та протестовано 10 запитів різної складності для отримання інформації з таблиць "User", "Student", "Course", "Enrollment" тощо.

**Приклад запиту 1.4 (Курси з іменами викладачів та цінами):**
```sql
SELECT c.Title AS CourseTitle, c.Price,
       u.FirstName || ' ' || u.LastName AS InstructorName
FROM Course c
JOIN Instructor i ON c.InstructorID = i.UserID
JOIN "User" u ON i.UserID = u.UserID
ORDER BY c.Price DESC;
```
<img width="578" height="300" alt="image" src="https://github.com/user-attachments/assets/655fd882-c735-44b5-a17a-8bd5b9949c26" />

**Приклад запиту 1.9 (Студенти з високим рейтингом):**
```sql
SELECT u.FirstName, u.LastName, s.TotalPoints
FROM "User" u
JOIN Student s ON u.UserID = s.UserID
WHERE s.TotalPoints > 100
ORDER BY s.TotalPoints DESC;
```
<img width="1256" height="274" alt="image" src="https://github.com/user-attachments/assets/17bb4d0d-66a2-46da-9836-60b500b7c2da" />

### 2.2. Додавання даних (INSERT-запити)
Було реалізовано сценарій створення нового профілю користувача та його подальшої реєстрації на платформі.

**Запит 2.1 - 2.3 (Додавання Сергія Петренка та запис на курс):**
```sql
INSERT INTO "User" (FirstName, LastName, Email, Password, RegistrationDate)
VALUES ('Сергій', 'Петренко', 's.petrenko@gmail.com', 'hashed_pass_7', CURRENT_DATE);

INSERT INTO Student (UserID, AcademicLevel, TotalPoints)
VALUES ((SELECT UserID FROM "User" WHERE Email = 's.petrenko@gmail.com'), 'магістр', 0);

INSERT INTO Enrollment (StudentID, CourseID, EnrollDate, Progress, Status)
VALUES ((SELECT UserID FROM "User" WHERE Email = 's.petrenko@gmail.com'), 3, CURRENT_DATE, 0, 'Active');

```
<img width="1163" height="381" alt="Screenshot 2026-04-16 173104" src="https://github.com/user-attachments/assets/b1a935a9-c91e-4f5a-83b2-1bca574cc026" />
<img width="1048" height="404" alt="image" src="https://github.com/user-attachments/assets/90f69543-ae35-4b98-9869-3d85c48e0139" />
<img width="1517" height="530" alt="image" src="https://github.com/user-attachments/assets/7ade5920-1f13-4135-9ec7-5e205051e8f3" />

