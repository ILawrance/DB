
--24 задание
WITH lap_max AS (
SELECT p.model model,
DENSE_RANK() OVER (ORDER BY l.price DESC) max_l, 
l.price price
FROM product p 
JOIN laptop l ON l.model = p.model
), 
pc_max AS(
SELECT p.model model,
DENSE_RANK() OVER (ORDER BY pc.price DESC) max_pc, 
pc.price price
FROM product p 
JOIN pc pc ON pc.model = p.model
),
prt_max AS(
SELECT p.model model,
DENSE_RANK() OVER (ORDER BY prt.price DESC) max_prt, 
prt.price price
FROM product p 
JOIN printer prt ON prt.model = p.model
)
	SELECT top_in_all.model
	FROM (
		SELECT top_in_category.model model,
		DENSE_RANK() OVER (ORDER BY top_in_category.price DESC) rang
		FROM( 
			SELECT prt_max.model model, prt_max.max_prt , prt_max.price
			FROM prt_max 
			WHERE prt_max.max_prt = 1
		  UNION 
			SELECT lap_max.model, lap_max.max_l, lap_max.price
			FROM lap_max
			WHERE lap_max.max_l = 1
		  UNION
			SELECT pc_max.model, pc_max.max_pc, pc_max.price
			FROM pc_max
			WHERE pc_max.max_pc = 1) top_in_category) top_in_all
	WHERE top_in_all.rang = 1
	
	
--25 задание
WITH printer_makers AS(
  SELECT p.maker maker
  FROM product p
  JOIN printer prn ON p.model = prn.model
),
smallest_ram_pc AS (
  SELECT pc.model model, 
  pc.ram ram,
  pc.speed speed,
  DENSE_RANK() OVER (ORDER BY pc.ram) worst_ram
  FROM pc 
),
pc_makers AS (
  SELECT p.maker maker,
  MIN(s_ram_pc.ram) min_ram, 
  MAX(s_ram_pc.speed) max_speed
  FROM product p
  JOIN smallest_ram_pc s_ram_pc ON s_ram_pc.model = p.model 
  AND s_ram_pc.worst_ram = 1
  GROUP BY p.maker
),
print_and_pc_makers AS (
  SELECT print_m.maker maker
  FROM printer_makers print_m
  JOIN pc_makers pc_m ON print_m.maker = pc_m.maker
)
    SELECT DISTINCT print_and_pc_makers.maker
    FROM print_and_pc_makers

    
    --26 задание
WITH pc_price AS (
  SELECT pc.price pc_p
  FROM pc pc
  LEFT JOIN product p ON pc.model = p.model
  WHERE p.maker = 'A'),
lap_price AS (
  SELECT lap.price lap_p
  FROM laptop lap
  LEFT JOIN product p ON lap.model = p.model
  WHERE p.maker = 'A'),
avg_union AS (
  SELECT pp.pc_p
  FROM pc_price pp
    UNION ALL
  SELECT lp.lap_p
  FROM lap_price lp)
SELECT AVG(au.pc_p) avg
FROM avg_union au



--28

