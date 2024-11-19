--2)
INSERT INTO LIGA_INT_SA_4 VALUES 
(
'Балашов', 'Игорь', 'Вдаимович', 23, 'Магистр', 'Павловский посад'
);

COMMIT;

--3)
SELECT *
FROM LIGA_INT_SA_4;

--4)
SELECT l.SURNAME
FROM LIGA_INT_SA_4 l;

--5)
SELECT l.NAME , l.PATRONYMIC, l.DEGREE , l.SURNAME, l.AGE 
FROM LIGA_INT_SA_4 l;

--6)
SELECT MY_TEAM.*, 5 MARK 
FROM LIGA_INT_SA_4 MY_TEAM;

--7)
SELECT l.NAME Имя, l.SURNAME Фамилия , l.PATRONYMIC Отчество , l.DEGREE Образование, l.AGE Возраст, l.CITY Город
FROM LIGA_INT_SA_4 l;

--8)
SELECT l.*, CASE 
	WHEN AGE >= 25
	THEN 'больше 25 лет'
	ELSE 'меньше 25 лет'
	END 
	AGE_RANGE
FROM LIGA_INT_SA_4 l;

--9)
SELECT DISTINCT l.AGE
FROM LIGA_INT_SA_4 l;


--10)
SELECT l.*, DECODE(
	l.CITY,
	'Москва',
	'Стажер живет в Москве',
	'Стажер не из Москвы'
	) 
	where_are_you_from
FROM LIGA_INT_SA_4 l;

--11)
SELECT l.*, 
	CASE 
	WHEN l.NAME IS not NULL
	THEN 'Молодец'
	END 
		Молодцы
FROM LIGA_INT_SA_4 l;

