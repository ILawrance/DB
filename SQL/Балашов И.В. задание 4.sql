--ПРАКТИКА 4 (ТАБЛИЦЫ STUDENT, SUBJECT, SUBJ_LECT, EXAM_MARKS, LECTURER, UNIVERSITY)
--1) Выведите в одну строку через запятую уникальные имена всех студентов в каждом городе.
SELECT s.CITY ГОРОД, 
LISTAGG(DISTINCT s.NAME, ', ' ) 
WITHIN 
GROUP  ( ORDER BY s.CITY) УНИКАЛЬНЫЕ_ИМЕНА
FROM SQLBOT.STUDENT s 
GROUP BY s.CITY 



--2) Из таблицы преподавателей выведите родные города преподавателей, их имена и фамилии. Результат отсортируйте по возрастанию 
--названия города, имени и фамилии преподавателя.
SELECT l.CITY ГОРОД, l.NAME ИМЯ, l.SURNAME ФАМИЛИЯ
FROM SQLBOT.LECTURER l 
ORDER BY l.CITY, l.NAME, l.SURNAME ASC


--3) Выведите названия университетов, а также количество студентов, которые там обучаются. Результат отсортируйте по возрастанию 
--количества студентов.
SELECT u.UNIV_NAME УНИВЕРЫ, COUNT(s.STUDENT_ID) КОЛИЧЕСТВО_СТУДЕНТОВ
FROM SQLBOT.UNIVERSITY u 
JOIN SQLBOT.STUDENT s ON s.UNIV_ID = u.UNIV_ID 
GROUP BY u.UNIV_NAME
ORDER BY COUNT(s.STUDENT_ID) ASC


--4) Из таблицы-связки преподавателей и предметов выведите имена преподавателей, их фамилии, а также названия предметов, которые
--они преподают. Результат отсортируйте по убыванию названия предмета.
SELECT l.NAME ИМЯ, l.SURNAME ФАМИЛИЯ, s.SUBJ_NAME ПРЕДМЕТ 
FROM SQLBOT.LECTURER l 
JOIN SQLBOT.SUBJ_LECT sl ON l.LECTURER_ID = sl.LECTURER_ID 
JOIN SQLBOT.SUBJECT s ON s.SUBJ_ID = sl.SUBJ_ID 
ORDER BY s.SUBJ_NAME DESC 


--5) Без использования WHERE выведите только имена и фамилии студентов, которые сдали экзамен с идентификатором предмета, равным 10,
--на тройку.
SELECT s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ
FROM SQLBOT.STUDENT s 
JOIN SQLBOT.EXAM_MARKS em ON em.STUDENT_ID = s.STUDENT_ID 
						AND em.MARK = 3 
JOIN SQLBOT.SUBJECT su ON su.SUBJ_ID = em.SUBJ_ID AND su.SUBJ_ID = 10
			
--В2
SELECT s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ
FROM SQLBOT.SUBJECT su
JOIN SQLBOT.EXAM_MARKS em ON em.SUBJ_ID = su.SUBJ_ID 
						AND em.MARK = 3 AND su.SUBJ_ID = 10
JOIN SQLBOT.STUDENT s ON s.STUDENT_ID = em.STUDENT_ID 


--6) Выведите фамилии и имена студентов, которые сдавали экзамен 17 мая 2010 года. Также выведите их отметку, а результат отсортируйте 
--по возрастанию фамилии.
SELECT s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ, em.MARK ОЦЕНКА
FROM SQLBOT.STUDENT s 
JOIN SQLBOT.EXAM_MARKS em ON em.STUDENT_ID = s.STUDENT_ID 
WHERE em.EXAM_DATE = TO_DATE('17-05-2010', 'dd-MM-yyyy') 
ORDER BY s.SURNAME ASC 
						

--7) Для каждого города определите, сколько в нем университетов, а также сколько в этом городе обучается студентов. Результат
--отсортируйте по убыванию названия города.
SELECT u.CITY ГОРОД, COUNT(DISTINCT u.UNIV_ID) СКОЛЬКО_УНИВЕРОВ, COUNT(DISTINCT s.STUDENT_ID) СКОЛЬКО_СТУДЕНТОВ
FROM SQLBOT.STUDENT s 
RIGHT JOIN SQLBOT.UNIVERSITY u 
ON s.UNIV_ID = u.UNIV_ID 
GROUP BY u.CITY 
ORDER BY u.CITY DESC 


--8) Выведите имена студентов, их фамилии, названия их университетов, а также определите при помощи DECODE, обучаются ли студенты
--в своих родных городах или нет. 
SELECT s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ, u.UNIV_NAME УНИВЕРСИТЕТ, s.CITY ГОРОД_СТУДЕНТА, u.CITY ГОРОД_УНИВЕРА,
	DECODE(s.CITY,
	u.CITY,
	'Учится в родном городе',
	'Учится в гостях'
	) ГДЕ_УЧИТСЯ
FROM SQLBOT.STUDENT s 
JOIN SQLBOT.UNIVERSITY u ON u.UNIV_ID = s.UNIV_ID 


--9) Выведите без дублей имена и фамилии студентов, которые на отлично сдали экзамены по тем предметам, на которые в учебном плане выделено
--более 30 академических часов. Также выведите названия предметов и количество часов, а результат отсортируйте по убыванию количества часов.

--Сомневаюсь в том, что имелось в виду, ведь если убрать дубли ТОЛЬКО по имени и фамилии, то тогда поетряются некоторые оценки за предметы
SELECT DISTINCT s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ, su.SUBJ_NAME ПРЕДМЕТ, su."HOUR" ЧАСЫ
FROM 
SQLBOT.STUDENT s 
JOIN SQLBOT.EXAM_MARKS em ON s.STUDENT_ID = em.STUDENT_ID 
JOIN SQLBOT.SUBJECT su ON  su.SUBJ_ID = em.SUBJ_ID 
WHERE em.MARK = 5 
AND su."HOUR" > 30
ORDER BY su."HOUR" DESC 

--В2
SELECT DISTINCT s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ, su.SUBJ_NAME ПРЕДМЕТ, su."HOUR" ЧАСЫ
FROM 
SQLBOT.SUBJECT su
JOIN SQLBOT.EXAM_MARKS em ON su.SUBJ_ID = em.SUBJ_ID 
JOIN SQLBOT.STUDENT s ON  s.STUDENT_ID = em.STUDENT_ID 
WHERE em.MARK = 5 
AND su."HOUR" > 30
ORDER BY su."HOUR" DESC 

--В3
SELECT s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ, su.SUBJ_NAME ПРЕДМЕТ, su."HOUR" ЧАСЫ
FROM 
SQLBOT.SUBJECT su
JOIN SQLBOT.EXAM_MARKS em ON su.SUBJ_ID = em.SUBJ_ID 
JOIN SQLBOT.STUDENT s ON  s.STUDENT_ID = em.STUDENT_ID 
WHERE em.MARK = 5
AND su."HOUR" > 30
ORDER BY su."HOUR" DESC 

--Вариант 2, сомнительный и менее красивый
SELECT DISTINCT ИМЕНА_ФАМИЛИИ.ИМЯ, ИМЕНА_ФАМИЛИИ.ФАМИЛИЯ, su.SUBJ_NAME ПРЕДМЕТ, su."HOUR" ЧАСЫ
FROM 
	(SELECT DISTINCT s.STUDENT_ID ИД, s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ
	FROM 
	SQLBOT.STUDENT s 
	JOIN SQLBOT.EXAM_MARKS em ON s.STUDENT_ID = em.STUDENT_ID 
	JOIN SQLBOT.SUBJECT su ON  su.SUBJ_ID = em.SUBJ_ID 
	WHERE em.MARK = 5 
	AND su."HOUR" > 30) ИМЕНА_ФАМИЛИИ
	JOIN SQLBOT.EXAM_MARKS em ON em.STUDENT_ID = ИМЕНА_ФАМИЛИИ.ИД
	JOIN SQLBOT.SUBJECT su ON em.SUBJ_ID = su.SUBJ_ID
WHERE su."HOUR" > 30
AND em.MARK = 5
ORDER BY su."HOUR" DESC

--10) Из таблицы отметок для каждого предмета выведите название предмета, минимальную отметку, полученную за экзамены по этому предмету,
--а также список студентов, получивших минимальную отметку за экзмены по этому предмету. Студентов указать в формате: первая буква имени,
--точка, пробел, фамилия целиком. Результат отсортировать по возрастанию минимальной отметки и по возрастанию названия предмета.
SELECT ПРЕДМЕТЫ_МИНИМУМ.ПРЕДМЕТ ЭКЗАМЕН, ПРЕДМЕТЫ_МИНИМУМ.МИНИМУМ МИНИМАЛЬНАЯ_ОЦЕНКА,
LISTAGG(SUBSTR(s.NAME, 1, 1) || '. ' || s.SURNAME, ' ')
WITHIN GROUP (ORDER BY s.SURNAME) СТУДЕНТЫ_СПИСОК
FROM
		(SELECT su.SUBJ_ID ИД, su.SUBJ_NAME ПРЕДМЕТ, MIN(em.MARK) МИНИМУМ
		FROM SQLBOT.SUBJECT su
		JOIN SQLBOT.EXAM_MARKS em
		ON em.SUBJ_ID = su.SUBJ_ID 
		GROUP BY su.SUBJ_ID, su.SUBJ_NAME) 
		ПРЕДМЕТЫ_МИНИМУМ
	JOIN SQLBOT.EXAM_MARKS em 
	ON 	em.MARK = ПРЕДМЕТЫ_МИНИМУМ.МИНИМУМ 
	AND em.SUBJ_ID = ПРЕДМЕТЫ_МИНИМУМ.ИД
	JOIN SQLBOT.STUDENT s
	ON em.STUDENT_ID = s.STUDENT_ID
GROUP BY ПРЕДМЕТЫ_МИНИМУМ.ПРЕДМЕТ, ПРЕДМЕТЫ_МИНИМУМ.МИНИМУМ
ORDER BY МИНИМАЛЬНАЯ_ОЦЕНКА ASC, ЭКЗАМЕН ASC;


--Проверка наглядно верен ли запрос
SELECT s.STUDENT_ID , s.NAME, em.MARK , s2.SUBJ_NAME 
FROM SQLBOT.STUDENT s 
JOIN SQLBOT.EXAM_MARKS em ON em.STUDENT_ID = s.STUDENT_ID 
JOIN SQLBOT.SUBJECT s2 ON s2.SUBJ_ID = em.SUBJ_ID 
ORDER BY em.MARK ASC , s2.SUBJ_NAME DESC

--11) Пользуясь только тем, что мы изучили до сегодняшнего занятия включительно, для каждого студента определите, сколько студентов
--из общей выборки получают стипендию больше, чем он/она. Выведите имя студента, фамилию, стипендию, количество студентов с большей
--стипендией, а результат отсортируйте по убыванию стипендии студента.

SELECT s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ, s.STIPEND СТИПЕНДИЯ, 
	(SELECT COUNT(s2.STUDENT_ID) 
	FROM SQLBOT.STUDENT s2 
	WHERE s2.STIPEND > s.STIPEND) КОЛИЧЕСТВО_СТУДЕНТОВ_С_БОЛЬШЕЙ_СТИПЕНДИЕЙ
FROM SQLBOT.STUDENT s 
ORDER BY s.STIPEND DESC



