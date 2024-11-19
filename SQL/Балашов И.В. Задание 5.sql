--ПРАКТИКА 5:  
--1) Для каждого экзамена у каждого студента выведите отклонение его отметки от средней, полученной на этом экзамене всеми студентами.
--Вывести дату экзамена, название предмета, идентификатор студента, фамилию студента, имя студента, его отметку, отклонение от средней
--на экзамене (округленной до двух знаков после запятой). Результат отсортировать по возрастанию даты экзамена, названия предмета 
--и идентификатора студента.
SELECT em.EXAM_DATE дата_экзамена, sub.SUBJ_NAME название_экзамена, s.STUDENT_ID ид_студента, s.SURNAME фамилия, s.NAME имя, em.MARK оценка,
em.MARK - ROUND(AVG(em.MARK) OVER(PARTITION BY sub.SUBJ_NAME) , 2) Отклонение
FROM SQLBOT.SUBJECT sub
LEFT JOIN SQLBOT.EXAM_MARKS em ON em.SUBJ_ID = sub.SUBJ_ID 
LEFT JOIN SQLBOT.STUDENT s ON s.STUDENT_ID = em.STUDENT_ID 
ORDER BY em.EXAM_DATE , sub.SUBJ_NAME , s.STUDENT_ID ASC 

--Разница в том как мы понимаем экзамен
SELECT em.EXAM_DATE дата_экзамена, sub.SUBJ_NAME название_экзамена, s.STUDENT_ID ид_студента, s.SURNAME фамилия, s.NAME имя, em.MARK оценка,
em.MARK - ROUND(AVG(em.MARK) OVER(PARTITION BY sub.SUBJ_NAME, em.EXAM_DATE) , 2) Отклонение
FROM SQLBOT.SUBJECT sub
LEFT JOIN SQLBOT.EXAM_MARKS em ON em.SUBJ_ID = sub.SUBJ_ID 
LEFT JOIN SQLBOT.STUDENT s ON s.STUDENT_ID = em.STUDENT_ID 
ORDER BY em.EXAM_DATE , sub.SUBJ_NAME , s.STUDENT_ID ASC 

--2) Для каждого студента выведите диапазон от минимальной до максимальной стипендии в его университете.
--Вывести идентификатор универститета, фамилию студента, имя студента, его стипендию, диапазон стипендий в его университете.
--Результат отсортировать по возрастанию идентификатора университета и стипендии.
SELECT u.UNIV_ID Универ, s.SURNAME Фамилия, s.NAME Имя, s.STIPEND Стипендия,
MIN(s.STIPEND) OVER (PARTITION BY u.UNIV_ID)  || ' - ' ||
MAX(s.STIPEND) OVER (PARTITION BY u.UNIV_ID) Диапозон
FROM SQLBOT.STUDENT s 
LEFT JOIN SQLBOT.UNIVERSITY u 
ON s.UNIV_ID = u.UNIV_ID 
ORDER BY u.UNIV_ID , s.STIPEND ASC

--3) Из таблицы сотрудников для каждого сотрудника определить предыдущую и следующую дату трудоустройства сотрудника его/ее должности, 
--а также первую и последнюю дату трудоустройства сотрудников в его/ее подразделение.
--Вывести имя сотрудника, фамилию сотрудника, название должности сотрудника, дату трудоустройства сотрудника, предыдущую дату трудоустройства
--другого сотрудника этой же должности, следующую дату трудоустройства другого сотрудника этой же должности, наименование подразделения 
--сотрудника, первую дату трудоустройства в подразделение сотрудника, последнюю дату трудоустройства в подразделение сотрудника.
--Результат отсортировать по возрастанию наименования должности, даты трудоустройства сотрудника, наименования подразделения.
SELECT  e.FIRST_NAME , e.LAST_NAME , j.JOB_TITLE , e.HIRE_DATE  , d.DEPARTMENT_NAME , 
LAG(e.HIRE_DATE) 
OVER (PARTITION BY j.JOB_TITLE ORDER BY e.HIRE_DATE) Предыдущая_дата, 
LEAD(e.HIRE_DATE) 
OVER (PARTITION BY j.JOB_TITLE ORDER BY e.HIRE_DATE) Следующая_дата,
FIRST_VALUE(e.HIRE_DATE) 
OVER (PARTITION BY d.DEPARTMENT_NAME ORDER BY e.HIRE_DATE) Первая_дата,
LAST_VALUE(e.HIRE_DATE) 
OVER (PARTITION BY d.DEPARTMENT_NAME ORDER BY e.HIRE_DATE 
range between unbounded preceding 
and unbounded following) Последня_дата
FROM SQLBOT.JOBS j
RIGHT JOIN
SQLBOT.EMPLOYEES e ON j.JOB_ID = e.JOB_ID 
LEFT JOIN 
SQLBOT.DEPARTMENTS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID 
ORDER BY j.JOB_TITLE , e.HIRE_DATE , d.DEPARTMENT_NAME ASC 


--4) Используя WITH и функции ранжирования, выведите без дублей худшую отметку по каждому экзамену (окно задавайте по EXAM_ID).
--Вывести название предмета, дату экзамена, худшую отметку, полученную на экзамене.
--Результат отсортировать по возрастанию наименования предмета и даты экзамена.	
WITH exams AS 
	(SELECT em.EXAM_ID ID, 
	s.SUBJ_NAME NAME, 
	em.EXAM_DATE E_DATE, 
	em.MARK MARK,
	DENSE_RANK () OVER (PARTITION BY em.EXAM_ID ORDER BY em.MARK )  РЕЙТИНГ_ОТ_ХУДШЕГО 
	FROM SQLBOT.EXAM_MARKS em
	LEFT JOIN SQLBOT.SUBJECT s 
	ON s.SUBJ_ID = em.SUBJ_ID
	)
SELECT DISTINCT e.NAME предмет, e.E_DATE дата, e.MARK оценка --220 ид пересдача
FROM exams e
WHERE e.РЕЙТИНГ_ОТ_ХУДШЕГО = 1
ORDER BY предмет, дата ASC

 
 SELECT *
 FROM SQLBOT.EXAM_MARKS em 
--5) Почему в результате предыдущего задания у предмета "Информатика на предприятии" на экзамене, который проводился
--11 июля 2010 года получилось, две худшие отметки?

--ОТВЕТ: Формально у этих экзаменов разные EXAM_ID. Видимо в этот день по данному предмету проводился экзамен 2 раза. 
--В этот день студент Владимир сдавал экзамен дважды. Сначала получил 4, а затем пошел на пересдачу и получил 5. 
--Таким образом сформировалась худшая оценка за результат среди первой попытки в которой участвовала группа студентов, 
--а затем появилась вторая худшая оценка за вторую попытку в которой был только Владимир.

--Тут видно наглядно
SELECT em.*
FROM SQLBOT.EXAM_MARKS em 
WHERE em.STUDENT_ID = 3
ORDER BY em.EXAM_ID DESC , em.STUDENT_ID ASC
