WITH CLEANED_A 
AS
(
	SELECT
	dimension_1,
	dimension_2,
	SUM(measure_1) measure_1
	FROM 
	A
	GROUP BY 
	dimension_1,
	dimension_2
)
,CLEANED_MAP
AS
(
	SELECT DISTINCT 
	dimension_1,
	correct_dimension_2
	FROM MAP
)
, FIXED_DIMENSIONS_A
AS
(
	SELECT 
	A.dimension_1,
	ISNULL(M.correct_dimension_2, A.dimension_2) dimension_2,
	measure_1
	FROM CLEANED_A A
		LEFT JOIN CLEANED_MAP M ON M.dimension_1 = A.dimension_1
)
, FIXED_DIMENSIONS_B
AS
(
	SELECT 
	B.dimension_1,
	ISNULL(M.correct_dimension_2, B.dimension_2) dimension_2,
	measure_2
	FROM B
		LEFT JOIN CLEANED_MAP M ON M.dimension_1 = B.dimension_1 
)
, UNION_TABLE
AS
(
	SELECT 	
	dimension_1,
	dimension_2,
	measure_1,
	0 measure_2
	FROM FIXED_DIMENSIONS_A
	UNION
	SELECT 	
	dimension_1,
	dimension_2,
	0 measure_1,
	measure_2
	FROM FIXED_DIMENSIONS_B
)
, FINAL_RESULT
AS
(
	SELECT 
	dimension_1,
	dimension_2,
	sum(measure_1) measure_1,
	sum(measure_2) measure_2
	FROM UNION_TABLE
	GROUP BY 
	dimension_1,
	dimension_2
)
select * from FINAL_RESULT