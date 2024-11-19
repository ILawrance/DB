SELECT * 
FROM dual

--1. Выведите сегодняшнюю дату, вчерашнюю дату, позавчерашнюю дату, а также дату через 1000 дней.
SELECT SYSDATE СЕГОДНЯ,
SYSDATE - 1 ВЧЕРА, 
SYSDATE - 2 ПОЗАВЧЕРА,
SYSDATE + 1000 ЧЕРЕЗ_1000_ДНЕЙ
FROM dual;

--2) Посчитайте, сколько месяцев прожил Михаил Булгаков.
SELECT ROUND(
MONTHS_BETWEEN
(TO_DATE('3-1940','MM-yyyy'),
TO_DATE('5-1891', 'MM-yyyy'))) СТОЛЬКО_МЕСЯЦЕВ_ЖИЛ_БУЛГАКОВ
FROM dual;


--3) Определите, какой день недели (и текст, и число) был в день вашего рождения.
SELECT TO_CHAR(TO_DATE('30-10-2000', 'dd-mm-yyyy'), 'Day') День, 
TO_CHAR(TO_DATE('30-10-2000', 'dd-mm-yyyy'), 'D') День_числом
FROM dual;

--4) Выведите первый день квартала и года для даты 15 марта 1994 года.
SELECT TRUNC(TO_DATE('15-3-1994', 'dd-mm-yyyy'), 'Q') Первый_день_квартала, 
TRUNC(TO_DATE('15-3-1994', 'dd-mm-yyyy'), 'YYYY') Первый_день_года
FROM dual;



--5) Определите наибольшее число среди 1321*32, 15382392/3, 4848*383, 898*999, 1234489183/3.
SELECT ROUND(GREATEST(
1321*32,
15382392/3,
4848*383,
898*999,
1234489183/3
), 2) НАИБОЛЬШЕЕ_ЧИСЛО
FROM dual;

--6) Определите количество преподавателей из таблицы LECTURER.
SELECT COUNT(l.LECTURER_ID) ВСЕГО_ПРЕПОДАВАТЕЛЕЙ
FROM SQLBOT.LECTURER l; 


--7) Определите количество уникальных имен в таблице STUDENT.
SELECT COUNT(DISTINCT s.NAME) УНИКАЛЬНЫХ_ИМЕН
FROM SQLBOT.STUDENT s;


--8) Определите максимальный и минимальный рейтинг университетов для каждого города в таблице UNIVERSITY.
SELECT MAX(u.RATING) МАКС_РЕЙТИНГ, MIN(u.RATING) МИН_РЕЙТИНГ
FROM SQLBOT.UNIVERSITY u; 

--9) Выведите города из таблицы UNIVERSITY, в которых сумма рейтингов университетов больше 500.
SELECT u.CITY ГОРОД, SUM(u.RATING) СУММА_РЕЙТИНГА
FROM SQLBOT.UNIVERSITY u
GROUP BY u.CITY
HAVING SUM(u.RATING) > 500;


--10) Выведите идентификаторы университетов из таблицы STUDENT, где количество студентов, родившихся после 01.01.1989, больше пяти.
SELECT s.UNIV_ID УНИВЕР
FROM SQLBOT.STUDENT s
WHERE s.BIRTHDAY >= TO_DATE('01-01-1989','dd-MM-yyyy') 
GROUP BY s.UNIV_ID 
HAVING COUNT(s.STUDENT_ID) > 5
ORDER BY s.UNIV_ID;


--11*) При помощи DECODE распишите, больше или меньше стипендия каждого студента в сравнении со средней стипендией в Москве.
SELECT s.NAME ИМЯ, s.SURNAME ФАМИЛИЯ, s.STIPEND СТЕПЕНДИЯ, s.CITY ГОРОД,
	ROUND((СРЕДНЯЯ_ПО_МОСКВЕ.СРЕДНЯЯ_СТЕПЕНДИЯ)) СРЕДНЯЯ_СТИПЕНДИЯ_ПО_МОСКВЕ,
	DECODE(
	SIGN(s.STIPEND - СРЕДНЯЯ_ПО_МОСКВЕ.СРЕДНЯЯ_СТЕПЕНДИЯ),
	1,
	'Стипендия больше средней',
	'Степендия меньше средней'
	)
	СТИПЕНЬДИЯ_БОЛЬШЕ_ИЛИ_МЕНЬШЕ
FROM (SELECT u2.CITY ГОРОД, AVG(s2.STIPEND) СРЕДНЯЯ_СТЕПЕНДИЯ
		FROM SQLBOT.UNIVERSITY u2
		JOIN SQLBOT.STUDENT s2 ON s2.UNIV_ID = u2.UNIV_ID
		WHERE u2.CITY = 'Москва'
		GROUP BY u2.CITY
		) СРЕДНЯЯ_ПО_МОСКВЕ,
SQLBOT.STUDENT s
JOIN UNIVERSITY u ON s.UNIV_ID = u.UNIV_ID