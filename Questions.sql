/*Average grade performance from students for each class?*/
SELECT  
    c.class_name, 
    c.class_code, 
    CAST( 
        AVG( 
            f.grade 
            ) AS DECIMAL(5,2) 
) 
         AS GRADE_AVG 
FROM FACT_COURSE_REGISTRATION f 
    JOIN DIM_CLASS c 
        ON c.class_id = f.course_id 
GROUP BY  
    c.class_name,  
    c.class_code 
ORDER BY 
    GRADE_AVG 
        DESC;

/*Colleges with the greatest amounts of undergraduate enrollment and  
colleges with the greatest amounts of post-undergraduate enrollment*/ 
SELECT 
    a.college, 
    SUM(CASE 
        WHEN a.type = 'Undergraduate' THEN 1 ELSE 0 END) AS UNDERGRAD_TOTAL, 
    SUM(CASE 
        WHEN a.type = 'Masters' OR a.type = 'Doctorate' THEN 1 ELSE 0 END) AS  
            GRAD_TOTAL 
FROM  
    DIM_ACADEMIC_PROGRAM a 
    JOIN FACT_COURSE_REGISTRATION f 
        ON a.id = f.academic_prgm_degree_id 
GROUP BY 
    a.college;

/*Total registration report over time*/ 
SELECT  
    YEAR, 
    SUM(N) OVER( 
        ORDER BY  
            YEAR 
            ) TOTAL_REGISTRATION 
FROM 
    ( 
    SELECT 
        EXTRACT( 
            YEAR  
            FROM  
                DATETIME 
                ) YEAR,  
        COUNT(*) N 
            FROM FACT_COURSE_REGISTRATION 
            GROUP BY  
                EXTRACT( 
                    YEAR  
                    FROM  
                        DATETIME 
                    ) 
        ) 
; 

/*Professor's class performance*/ 
SELECT  
    f.PROFESSOR_ID, 
    p.FIRST_NAME, 
    p.LAST_NAME, 
    p.CREDENTIAL, 
    p.IS_TENURED, 
    CAST( 
        AVG( 
            f.grade 
            ) AS DECIMAL(5, 2) 
            ) 
        AS GRADE_AVG 
FROM FACT_COURSE_REGISTRATION f 
    JOIN DIM_PROFESSOR p 
        ON p.id = f.professor_id 
GROUP BY 
    f.PROFESSOR_ID, 
    p.FIRST_NAME, 
    p.LAST_NAME, 
    p.CREDENTIAL, 
    p.IS_TENURED 
ORDER BY 
    GRADE_AVG 
        DESC;