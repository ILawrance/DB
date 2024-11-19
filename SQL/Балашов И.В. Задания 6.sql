SELECT *
FROM SQLBOT.STUDENT s 

--ИТОГОВЫЕ ЗАДАЧИ:
--1) Выведите всех студентов, которые родились в 1983 году и получают стипендию, больше 10000 руб. Также выведите название их университетов.
--Вывести: фамилию студента и через пробел первую букву имени с точкой, дату их рождения, день недели в дату их рождения в текстовом формате,
--их стипендию, название их университета и город, в котором они обучаются.
--Результат отсортировать по возрастанию фамилии.
SELECT s.SURNAME  || ' ' || SUBSTR(s.NAME,1,1) || '. ' Студент, 
s.BIRTHDAY Дата_рождения, 
TO_CHAR(TO_DATE(s.BIRTHDAY, 'dd.MM.yyyy'), 'Day') День_недели, 
s.STIPEND Стипендия, u.UNIV_NAME Универ, 
u.CITY Город_учебы
FROM SQLBOT.STUDENT s 
JOIN SQLBOT.UNIVERSITY u ON s.UNIV_ID = u.UNIV_ID 
WHERE s.STIPEND > 10000
AND s.BIRTHDAY  BETWEEN TO_DATE('01.01.1983', 'dd.MM.yyyy')
				AND TO_DATE('31.12.1983', 'dd.MM.yyyy') 
ORDER BY s.SURNAME ASC 


--2) Для каждого предмета выведите минимальную отметку, полученную на экзаменах по этому предмету. Если по предмету экзамен не проводился,
--то атрибут с минимальной отметкой заполнить как "Экзамен не проводился".
--Вывести: наименование предмета, минимальную отметку/"Экзамен не проводился".
--Результат отсортировать по убыванию названия предмета.

SELECT Предметы_оценки_для_дек.предмет,
DECODE(Предметы_оценки_для_дек.оценка, 
0, 
'Экзамен не проводился', 
Предметы_оценки_для_дек.оценка) Оценки
FROM
	(SELECT Предметы_оценки.Предмет предмет, 
	NVL(Предметы_оценки.мин_оценка, 0) оценка
	FROM 
		(SELECT s.SUBJ_NAME Предмет, 
		MIN(em.MARK) Мин_оценка
		FROM SQLBOT.SUBJECT s 
		LEFT JOIN EXAM_MARKS em ON s.SUBJ_ID = em.SUBJ_ID 
		GROUP BY s.SUBJ_NAME 
		ORDER BY s.SUBJ_NAME DESC) Предметы_оценки) Предметы_оценки_для_дек



--3) Выведите сотрудников и их руководителей, а также наименования их должностей. В случае, если нет руководителя, то укажите данные
--самого сотрудника.
--Вывести: имя сотрудника, фамилию сотрудника, наименование должности сотрудника, имя руководителя, фамилию руководителя, наименование
--должности руководителя.
--Результат отсортировать по возрастанию должности и фамилии сотрудника.
		
SELECT e.FIRST_NAME ИМЯ_СОТРУДНИКА, e.LAST_NAME ФАМИЛИЯ_СОТРУДНИКА, j.JOB_TITLE  ДОЛЖНОСТЬ_СОТРУДНИКА, 
	 CASE WHEN e2.FIRST_NAME IS NULL 
		 THEN e.FIRST_NAME	
		 ELSE e2.FIRST_NAME 
	 END ИМЯ_НАЧАЛЬНИКА, 
 CASE WHEN e2.LAST_NAME IS NULL 
	 THEN e.LAST_NAME
	 ELSE e2.LAST_NAME 
 END ФАМИЛИЯ_НАЧАЛЬНИКА,  
 CASE WHEN j2.JOB_TITLE IS NULL 
	 THEN j.JOB_TITLE
	 ELSE j2.JOB_TITLE 
 END ДОЛЖНОЛСТЬ_НАЧАЛЬНИКА
FROM SQLBOT.EMPLOYEES e 
LEFT JOIN SQLBOT.EMPLOYEES e2 ON e.MANAGER_ID = e2.EMPLOYEE_ID 
LEFT JOIN SQLBOT.JOBS j ON e.JOB_ID = j.JOB_ID 
LEFT JOIN SQLBOT.JOBS j2 ON e2.JOB_ID = j2.JOB_ID 


--4) Определите, сколько в каждой стране работает сотрудников. Если в стране нет сотрудников, то ее все равно надо вывести.
--Вывести: название страны, количество сотрудников.
--Результат отсортировать по убыванию количества сотрудников и по возрастанию наименования страны.
SELECT c.COUNTRY_NAME , COUNT(e.EMPLOYEE_ID)
FROM SQLBOT.COUNTRIES c 
LEFT JOIN SQLBOT.LOCATIONS l ON l.COUNTRY_ID = c.COUNTRY_ID
LEFT JOIN SQLBOT.DEPARTMENTS d ON d.LOCATION_ID = l.LOCATION_ID 
LEFT JOIN SQLBOT.EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID 
GROUP BY c.COUNTRY_NAME 
ORDER BY COUNT(e.EMPLOYEE_ID) DESC , c.COUNTRY_NAME ASC 


--5) Для тех сотрудников, у кого менялась должность, определите наименование их предыдущей должности, а также максимальную зарплату,
--которую они могли получать на той должности (используйте WITH и ROW_NUMBER или любую другую функцию ранжирования).
--Вывести: имя сотрудника, фамилию сотрудника, текущую должность, текущую зарплату, предыдущую должность, предыдущую зарплату.
--Результат отсортировать по возрастанию фамилии сотрудника.  
 
SELECT e.FIRST_NAME , e.LAST_NAME , j.JOB_TITLE , e.SALARY, 
LAG(j.JOB_TITLE) OVER (PARTITION BY e.EMPLOYEE_ID ORDER BY j.JOB_TITLE) Предыдущая_должность --не успею переделать
FROM SQLBOT.EMPLOYEES e 
JOIN SQLBOT.JOBS j ON j.JOB_ID = e.JOB_ID 
ORDER BY e.LAST_NAME ASC 