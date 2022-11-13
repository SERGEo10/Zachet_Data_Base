-- создание базы данных для работы 
CREATE TABLE `student` (
`student_id` INTEGER PRIMARY KEY AUTOINCREMENT,
`name_student` varchar(50) DEFAULT NULL
);
CREATE TABLE `subject` (
`subject_id` INTEGER PRIMARY KEY AUTOINCREMENT,
`name_subject` varchar(30) DEFAULT NULL
);
CREATE TABLE `attempt` (
`attempt_id` INTEGER PRIMARY KEY AUTOINCREMENT,
student_id int DEFAULT NULL,
`subject_id` int DEFAULT NULL,
`date_attempt` date DEFAULT NULL,
`result` int DEFAULT NULL,
CONSTRAINT `attempt_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE,
CONSTRAINT `attempt_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE
);
CREATE TABLE `testing` (
`testing_id` INTEGER PRIMARY KEY AUTOINCREMENT,
`attempt_id` int DEFAULT NULL,
`question_id` int DEFAULT NULL,
`answer_id` int DEFAULT NULL,
CONSTRAINT `testing_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `attempt` (`attempt_id`) ON DELETE CASCADE
);
CREATE TABLE `question` (
`question_id` INTEGER PRIMARY KEY AUTOINCREMENT,
`name_question` varchar(100) DEFAULT NULL, 
`subject_id` int DEFAULT NULL,
CONSTRAINT `question_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE
);
CREATE TABLE `answer` (
`answer_id` INTEGER PRIMARY KEY AUTOINCREMENT,
`name_answer` varchar(100) DEFAULT NULL,
`question_id` int DEFAULT NULL,
`is_correct` tinyint(1) DEFAULT NULL,
CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`) ON DELETE CASCADE
);

INSERT INTO subject (subject_id,name_subject) VALUES 
(1,'Основы SQL'),
(2,'Основы баз данных'),
(3,'Физика');

INSERT INTO student (student_id,name_student) VALUES
(1,'Баранов Павел'),
(2,'Абрамова Катя'),
(3,'Семенов Иван'),
(4,'Яковлева Галина');

INSERT INTO attempt (attempt_id,student_id,subject_id,date_attempt,result) VALUES
(1,1,2,'2020-03-23',67),
(2,3,1,'2020-03-23',100),
(3,4,2,'2020-03-26',0),
(4,1,1,'2020-04-15',33),
(5,3,1,'2020-04-15',67),
(6,4,2,'2020-04-21',100),
(7,3,1,'2020-05-17',33);

INSERT INTO question (question_id,name_question,subject_id) VALUES
(1,'Запрос на выборку начинается с ключевого слова:',1),
(2,'Условие, по которому отбираются записи, задается после ключевого слова:',1),
(3,'Для сортировки используется:',1),
(4,'Какой запрос выбирает все записи из таблицы student:',1),
(5,'Для внутреннего соединения таблиц используется оператор:',1),
(6,'База данных - это:',2),
(7,'Отношение - это:',2),
(8,'Концептуальная модель используется для',2),
(9,'Какой тип данных не допустим в реляционной таблице?',2);

INSERT INTO answer (answer_id,name_answer,question_id,is_correct) VALUES
(1,'UPDATE',1,0),
(2,'SELECT',1,1),
(3,'INSERT',1,0),
(4,'GROUP BY',2,0),
(5,'FROM',2,0),
(6,'WHERE',2,1),
(7,'SELECT',2,0),
(8,'SORT',3,0),
(9,'ORDER BY',3,1),
(10,'RANG BY',3,0),
(11,'SELECT * FROM student',4,1),
(12,'SELECT student',4,0),
(13,'INNER JOIN',5,1),
(14,'LEFT JOIN',5,0),
(15,'RIGHT JOIN',5,0),
(16,'CROSS JOIN',5,0),
(17,'совокупность данных, организованных по определенным правилам',6,1),
(18,'совокупность программ для хранения и обработки больших массивов информации',6,0),
(19,'строка',7,0),
(20,'столбец',7,0),
(21,'таблица',7,1),
(22,'обобщенное представление пользователей о данных',8,1),
(23,'описание представления данных в памяти компьютера',8,0),
(24,'база данных',8,0),
(25,'file',9,1),
(26,'INT',9,0),
(27,'VARCHAR',9,0),
(28,'DATE',9,0);

INSERT INTO testing (testing_id,attempt_id,question_id,answer_id) VALUES
(1,1,9,25),
(2,1,7,19),
(3,1,6,17),
(4,2,3,9),
(5,2,1,2),
(6,2,4,11),
(7,3,6,18),
(8,3,8,24),
(9,3,9,28),
(10,4,1,2),
(11,4,5,16),
(12,4,3,10),
(13,5,2,6),
(14,5,1,2),
(15,5,4,12),
(16,6,6,17),
(17,6,8,22),
(18,6,7,21),
(19,7,1,3),
(20,7,4,11),
(21,7,5,16);
-- 3.1.2
SELECT name_student,date_attempt,result 
FROM attempt 
INNER JOIN student USING(student_id )
INNER JOIN subject USING(subject_id )

WHERE subject_id = 2 ORDER BY result DESC;
-- 3.1.3
SELECT name_subject, count(attempt.subject_id  ) AS  Количество,ROUND( avg(result ),2 ) AS Среднее
from subject LEFT  join attempt using(subject_id )
group by name_subject
ORDER BY Среднее DESC;
-- 3.1.4
SELECT name_student,   result 
FROM student 
    INNER JOIN attempt USING(student_id ) 

WHERE result = (
         SELECT MAX(result) 
         FROM attempt
      )
order by name_student;
-- 3.1.5
SELECT name_student,  name_subject,
DATEDIFF(MAX(date_attempt), MIN(date_attempt)) AS Интервал
FROM student 
INNER JOIN attempt USING(student_id ) 
INNER JOIN subject USING(subject_id)
GROUP BY name_student, name_subject
HAVING COUNT(name_student) >1 
order by Интервал;
-- 3.1.6
SELECT name_subject, COUNT(DISTINCT student_id) AS 'Количество'
FROM subject LEFT JOIN attempt USING(subject_id)
GROUP BY name_subject
ORDER BY COUNT(DISTINCT student_id) DESC, name_subject;

-- 3.1.7
SELECT question_id, name_question
FROM question INNER JOIN subject USING(subject_id)
where subject_id = 2
ORDER BY RAND() LIMIT 3;
-- 3.1.8
SELECT name_question, name_answer,  if(is_correct =1, "Верно", "Неверно"  ) as Результат 
FROM question 
INNER JOIN answer USING(question_id )
INNER JOIN testing USING(answer_id   )
where attempt_id   = 7;
-- 3.1.9
SELECT name_student  , name_subject, date_attempt ,  ROUND((SUM(answer.is_correct)/ 3) * 100 ,2) AS Результат
from attempt
    join student using(student_id)
    join subject using(subject_id)
    join testing using(attempt_id)
    join answer using(answer_id)
GROUP BY name_student, name_subject, date_attempt 
ORDER BY name_student ASC, date_attempt DESC;
-- 3.1.10
SELECT name_subject, 
       CONCAT(LEFT(name_question, 30), '...') AS Вопрос, 
       COUNT(answer_id) AS Всего_ответов, 
       ROUND(SUM(is_correct) / COUNT(answer_id) * 100, 2) AS Успешность
  FROM subject
       JOIN question USING(subject_id)
       JOIN testing  USING(question_id)
       LEFT JOIN answer  USING(answer_id)
 GROUP BY name_subject, Вопрос                            
 ORDER BY name_subject, Успешность  DESC, Вопрос;

-- 3.1.11
SELECT name_subject, 
       CONCAT(LEFT(name_question, 30), '...') AS Вопрос, 
       COUNT(answer_id) AS Всего_ответов, 
       ROUND(SUM(is_correct) / COUNT(answer_id) * 100, 2) AS Успешность
  FROM subject
       JOIN question USING(subject_id)
       JOIN testing  USING(question_id)
       LEFT JOIN answer  USING(answer_id)
 GROUP BY name_subject, Вопрос                            
 ORDER BY name_subject, Успешность  DESC, Вопрос;
-- 3.2.2
insert into  attempt(student_id , subject_id , date_attempt , result ) 
VALUE (1 , 2 ,NOW(), NULL   );
SELECT * FROM attempt;
-- 3.2.3
insert into testing(attempt_id, question_id)
select attempt_id, question_id
from question
join attempt using(subject_id)
where attempt_id =(select max(attempt_id)from attempt )
order by rand()
limit 3;
-- 3.2.4
UPDATE attempt
    SET result = (SELECT ROUND(SUM(is_correct)/3*100, 0)
        FROM answer INNER JOIN testing using(answer_id)
        WHERE attempt_id = 8)
    WHERE attempt_id = 8;
select * from attempt;
-- 3.2.5
DELETE FROM attempt WHERE date_attempt < "2020-05-01";
select * from attempt;
-- 3.2.6
insert into  attempt(student_id , subject_id , date_attempt , result ) 
VALUE (1 , 2 ,NOW(), NULL   );
SELECT * FROM attempt;
-- 3.3.2
SELECT name_enrollee  
FROM program_enrollee 
INNER JOIN enrollee using (enrollee_id )
INNER JOIN program  using (program_id )
where program_id = 4
order by name_enrollee; 
-- 3.3.3
SELECT name_program                          
FROM program 
INNER JOIN program_subject using (program_id )
INNER JOIN subject  using (subject_id )
where subject_id = 4
order by name_program  desc;
-- 3.3.4
SELECT name_subject  ,  count(enrollee_id ) AS Количество ,  MAX(result ) as   Максимум, MIN(result) as Минимум ,ROUND( AVG(result),1)  as Среднее                
FROM enrollee_subject 
INNER JOIN subject  using (subject_id )
GROUP BY name_subject 
order by name_subject   ; 
-- 3.3.5
SELECT name_program             
FROM program_subject 
INNER JOIN program  using (program_id  )
GROUP BY  name_program
HAVING MIN(min_result) >= 40 order by name_program;
-- 3.3.6
SELECT name_program, plan       
FROM program 

WHERE plan = (
         SELECT max(plan) 
         FROM program
      );
-- 3.3.7
SELECT name_enrollee,   sum(if(bonus is NULL,0, bonus)) as   Бонус  
FROM enrollee 
LEFT JOIN enrollee_achievement  using (enrollee_id   )
LEFT JOIN achievement  using (achievement_id   )

GROUP BY name_enrollee    
ORDER BY name_enrollee;
-- 3.3.8
SELECT name_department ,  program.name_program,  program.plan, count(enrollee_id ) as Количество, ROUND(count(enrollee_id )/plan, 2) as Конкурс 
FROM department 
INNER JOIN program  using (department_id)
INNER JOIN program_enrollee  using (program_id )
       
GROUP BY program_id                                                           
ORDER BY Конкурс desc;

-- 3.3.9
SELECT name_program                          
FROM program 
INNER JOIN program_subject using (program_id )
INNER JOIN subject  using (subject_id )

where name_subject = 'Информатика' OR name_subject = 'Математика'
group by name_program
having count(name_subject)= 2
order by name_program;
-- 3.3.10
SELECT name_program , name_enrollee   , SUM(result) as    itog                 
FROM program_enrollee 
INNER JOIN enrollee_subject USING(enrollee_id)
INNER JOIN program_subject USING(program_id, subject_id)
INNER JOIN enrollee USING(enrollee_id)
INNER JOIN program USING(program_id)
GROUP BY name_program, name_enrollee
ORDER BY name_program, itog DESC;
-- 3.3.11
select name_program, name_enrollee
from program 
join program_subject using(program_id) 
join enrollee_subject using(subject_id) 
join enrollee using(enrollee_id) 
join program_enrollee on program_enrollee.program_id =program.program_id and enrollee.enrollee_id=program_enrollee.enrollee_id
where result<min_result
group by name_program, name_enrollee
order by name_program, name_enrollee;
-- 3.3.12
SELECT name_program , name_enrollee   , SUM(result) as    itog                 
FROM program_enrollee 
INNER JOIN enrollee_subject USING(enrollee_id)
INNER JOIN program_subject USING(program_id, subject_id)
INNER JOIN enrollee USING(enrollee_id)
INNER JOIN program USING(program_id)
GROUP BY name_program, name_enrollee
ORDER BY name_program, itog DESC;
-- 3.4.2
CREATE TABLE applicant  AS 
SELECT program_id, enrollee_id, SUM(result) as    itog                 
FROM program_enrollee 
INNER JOIN enrollee_subject USING(enrollee_id)
INNER JOIN program_subject USING(program_id, subject_id)
INNER JOIN enrollee USING(enrollee_id)
INNER JOIN program USING(program_id)
GROUP BY program_id, enrollee_id
ORDER BY program_id, itog DESC;

select * from applicant;
-- 3.4.3
DELETE  FROM applicant using applicant
join program_subject using(program_id) 
join enrollee_subject using(subject_id,enrollee_id)
where  result<min_result;

select * from applicant;
-- 3.4.4
UPDATE applicant JOIN (
SELECT enrollee_id,   sum(if(bonus is NULL,0, bonus)) as   Бонус  
FROM enrollee_achievement 
LEFT JOIN achievement  using (achievement_id   )
GROUP BY enrollee_id 
) as  applicant using(enrollee_id)
SET itog = itog +  Бонус;


select * from applicant;
-- 3.4.5

CREATE TABLE applicant_order
 as( 
    select
    program_id, enrollee_id,itog 
    FROM applicant 
    );


DROP TABLE applicant;
SELECT * FROM applicant_order ORDER BY program_id, itog DESC;
-- 3.4.6
ALTER TABLE applicant_order  ADD str_id  VARCHAR(50) FIRST;

-- 3.4.7
SET @a := 0;
SET @b := 1;

UPDATE applicant_order
SET str_id = IF(@a = program_id, @b := @b + 1, @b := 1 +(@a := program_id)*0)
;
SELECT * FROM applicant_order;
-- 3.4.8
CREATE TABLE student
SELECT name_program, name_enrollee, itog FROM enrollee
JOIN applicant_order USING (enrollee_id)
JOIN program USING (program_id)
WHERE str_id<=plan
ORDER BY name_program, itog DESC;
select* from student;
-- 3.4.9
SELECT * FROM student ;
-- 3.5.2
SELECT CONCAT(LEFT(CONCAT(module_id, ' ', module_name), 16), '...') Модуль,
CONCAT(LEFT(CONCAT(module_id, '.', lesson_position, ' ', lesson_name), 16), '...') Урок,
CONCAT(module_id, '.', lesson_position, '.', step_position, ' ', step_name) Шаг
FROM module
INNER JOIN lesson USING(module_id)
INNER JOIN step USING(lesson_id)
WHERE step_name LIKE '%ложенн% запрос%'
ORDER BY module_id, lesson_id, step_id;
-- 3.5.3
insert into step_keyword (step_id, keyword_id)
select step_id, keyword_id
from keyword cross join step
where regexp_instr(step_name, concat('\\b', keyword_name, '\\b'));
-- 3.5.4
SELECT
concat(module_id,'.',lesson_position,
IF(step_position < 10, ".0","."),
step_position," ",step_name) AS Шаг
FROM
step
JOIN lesson USING(lesson_id)
JOIN module USING(module_id)
JOIN step_keyword USING (step_id)
JOIN keyword USING(keyword_id)
WHERE keyword_name = 'MAX' OR keyword_name ='AVG'
GROUP BY ШАГ
HAVING COUNT(*) = 2
ORDER BY 1;
-- 3.5.5
SELECT
concat(module_id,'.',lesson_position,
IF(step_position < 10, ".0","."),
step_position," ",step_name) AS Шаг
FROM
step
JOIN lesson USING(lesson_id)
JOIN module USING(module_id)
JOIN step_keyword USING (step_id)
JOIN keyword USING(keyword_id)
WHERE keyword_name = 'MAX' OR keyword_name ='AVG'
GROUP BY ШАГ
HAVING COUNT(*) = 2
ORDER BY 1;
SELECT
rate_group Группа,
CASE rate_group
WHEN 'I' THEN 'от 0 до 10'
WHEN 'II' THEN 'от 11 до 15'
WHEN 'III' THEN 'от 16 до 27'
ELSE 'больше 27'
END Интервал,
COUNT(*) Количество
FROM
(
SELECT
CASE
WHEN COUNT(DISTINCT step_id) <= 10 THEN 'I'
WHEN COUNT(DISTINCT step_id) <= 15 THEN 'II'
WHEN COUNT(DISTINCT step_id) <= 27 THEN 'III'
ELSE 'IV'
END rate_group
FROM step_student
WHERE result = 'correct'
GROUP BY student_id
) query_in
GROUP BY rate_group
ORDER BY 1;

-- 3.5.6
WITH table1 (step_name, correct, count) AS (
SELECT
step_name,
SUM( IF (result = 'correct' , 1 , 0)) AS s,
COUNT(result) AS c
FROM step
JOIN step_student USING (step_id)
GROUP BY step_name
)

SELECT step_name AS Шаг, ROUND((correct/count)*100) AS Успешность
FROM table1
ORDER BY 2, 1;
-- 3.5.7
WITH get_passed (student_name, pssd)
AS
(
SELECT student_name, COUNT(DISTINCT step_id) AS passed
FROM student JOIN step_student USING(student_id)
WHERE result = "correct"
GROUP BY student_id
ORDER BY passed
)
SELECT student_name AS Студент, ROUND(100*pssd/(SELECT COUNT(DISTINCT step_id) FROM step_student)) AS Прогресс,
CASE
WHEN ROUND(100*pssd/(SELECT COUNT(DISTINCT step_id) FROM step_student)) = 100 THEN "Сертификат с отличием"
WHEN ROUND(100*pssd/(SELECT COUNT(DISTINCT step_id) FROM step_student)) >= 80 THEN "Сертификат"
ELSE ""
END AS Результат
FROM get_passed
ORDER BY Прогресс DESC, Студент;
-- 3.5.8
SELECT student_name AS Студент,
CONCAT(LEFT(step_name, 20), '...') AS Шаг,
result AS Результат,
FROM_UNIXTIME(submission_time) AS Дата_отправки,
SEC_TO_TIME(submission_time - LAG(submission_time, 1, submission_time) OVER (ORDER BY submission_time)) AS Разница
FROM student
INNER JOIN step_student USING(student_id)
INNER JOIN step USING(step_id)
WHERE student_name = 'student_61'
ORDER BY Дата_отправки;

-- 3.5.9
SELECT ROW_NUMBER() OVER (ORDER BY Среднее_время) AS Номер,
    Урок, Среднее_время
FROM(
    SELECT 
        Урок, ROUND(AVG(difference), 2) AS Среднее_время
FROM
     (SELECT student_id,
             CONCAT(module_id, '.', lesson_position, ' ', lesson_name) AS Урок,
             SUM((submission_time - attempt_time) / 3600) AS difference
      FROM module INNER JOIN lesson USING (module_id)
                  INNER JOIN step USING (lesson_id)
                  INNER JOIN step_student USING (step_id)
      WHERE submission_time - attempt_time <= 4 * 3600
      GROUP BY 1, 2) AS query_1
GROUP BY 1) AS TA
order by 3;

-- 3.5.10
SELECT  module_id AS Модуль, student_name AS Студент, COUNT(DISTINCT step_id) AS Пройдено_шагов ,
	ROUND(COUNT(DISTINCT step_id) / 
      MAX(COUNT(DISTINCT step_id)) OVER(PARTITION BY module_id) *100, 1) AS Относительный_рейтинг
FROM lesson 
	JOIN step USING (lesson_id)
	JOIN step_student USING (step_id)
	JOIN student USING (student_id)
WHERE result = 'correct'
GROUP BY module_id, student_name
ORDER BY 1, 4 DESC, 2;

-- 3.5.11
WITH get_time_lesson(student_name,  lesson, max_submission_time)
AS(
    SELECT student_name,  CONCAT(module_id, '.', lesson_position), MAX(submission_time)
    FROM step_student INNER JOIN step USING (step_id)
                          INNER JOIN lesson USING (lesson_id)
                          INNER JOIN student USING(student_id)
    WHERE  result = 'correct'  
    GROUP BY 1,2
    ORDER BY 1),
get_students(student_name)
AS(
    SELECT student_name 
    FROM get_time_lesson
    GROUP BY student_name
    HAVING COUNT(lesson) = 3)
SELECT student_name as Студент,  
       lesson as Урок, 
       FROM_UNIXTIME(max_submission_time) as Макс_время_отправки, 
       IFNULL(CEIL((max_submission_time - LAG(max_submission_time) OVER (PARTITION BY student_name ORDER BY max_submission_time )) / 86400),'-') as Интервал 
FROM get_time_lesson
WHERE student_name in (SELECT * FROM get_students)
ORDER BY 1,3;

-- 3.5.12
SET @avg_time := (SELECT CEIL(AVG(submission_time - attempt_time))
FROM step_student INNER JOIN student USING(student_id)
WHERE student_name = "student_59" AND (submission_time - attempt_time) < 3600);
WITH get_stat
AS
(
SELECT student_name, CONCAT(module_id, ".", lesson_position, ".", step_position) AS less, step_id, RANK() OVER (PARTITION BY CONCAT(module_id, ".", lesson_position, ".", step_position) ORDER BY submission_time) AS rang, result, 
CASE
    WHEN (submission_time - attempt_time) > 3600 THEN @avg_time
    ELSE (submission_time - attempt_time)
END AS qr
FROM student 
    INNER JOIN step_student USING(student_id)
    INNER JOIN step USING(step_id)
    INNER JOIN lesson USING(lesson_id)
WHERE student_name = "student_59"
)
SELECT student_name AS Студент, less AS Шаг, rang AS Номер_попытки, result AS Результат, SEC_TO_TIME(CEIL(qr)) AS Время_попытки, ROUND((qr / (SUM(qr) OVER (PARTITION BY less ORDER BY less)) * 100), 2) AS Относительное_время
FROM get_stat
ORDER BY step_id, 3;
-- 3.5.13
WITH qr
AS
(
SELECT student_name, step_id, count(result) AS sm
FROM step_student INNER JOIN student USING(student_id)
WHERE result = "correct"
GROUP BY 1, 2
HAVING count(result) > 1
)
SELECT "I" AS Группа, student_name AS Студент, count(step_id) AS Количество_шагов
FROM (
SELECT student_name, step_id, IF(result = "correct" AND submission_time < MAX(submission_time) OVER (PARTITION BY student_name, step_id), IF(LEAD(result) OVER (PARTITION BY student_id, step_id ORDER BY submission_time) = "wrong", 1, 0), 0) AS change_res
FROM step_student INNER JOIN student USING(student_id))qr1
WHERE change_res = 1
GROUP BY 1, 2
UNION 
SELECT "II" AS Группа, student_name AS Студент, count(step_id) AS Количество_шагов
FROM qr
GROUP BY 1, 2
UNION
SELECT "III" AS Группа, student_name AS Студент, count(DISTINCT step_id) AS Количество_шагов
FROM (
    SELECT student_id, step_id, SUM(new_result) OVER (PARTITION BY student_id, step_id) AS sum_result
    FROM (
        SELECT student_id, step_id, IF(result = "wrong", 0, 1) AS new_result 
            FROM step_student)qr_1)qr_2 INNER JOIN student USING(student_id)
WHERE sum_result = 0
GROUP BY student_id
ORDER BY Группа, Количество_шагов DESC, Студент;
