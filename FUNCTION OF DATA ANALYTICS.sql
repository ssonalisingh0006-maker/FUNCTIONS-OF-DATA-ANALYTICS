CREATE TABLE Student_Performance (
student_id INT PRIMARY KEY,
name VARCHAR(50),
course VARCHAR(30),
score INT,
attendance INT,
mentor VARCHAR(50),
join_date DATE,
city VARCHAR(50)
);

INSERT INTO Student_Performance
(student_id, name, course, score, attendance, mentor, join_date, city)VALUES
(101, 'Aarav Mehta', 'Data Science', 88, 92, 'Dr. Sharma','2023-06-12', 'Mumbai'),
(102, 'Riya Singh', 'Data Science', 76, 85, 'Dr. Sharma','2023-07-01', 'Delhi'),
(103, 'Kabir Khanna', 'Python', 91, 96, 'Ms. Nair','2023-06-20', 'Mumbai'),
(104, 'Tanvi Patel', 'SQL', 84, 89, 'Mr.Iyer', '2023-05-30', 'Bengaluru'),
(105, 'Ayesha Khan', 'Python', 67, 81, 'Ms. Nair','2023-07-10', 'Hyderabad'),
(106, 'Dev Sharma', 'SQL', 73, 78, 'Mr. Iyer','2023-05-28', 'Pune'),
(107, 'Arjun Verma', 'Tableau', 95, 98, 'Ms. Kapoor','2023-06-15', 'Delhi'),
(108, 'Meera Pillai', 'Tableau', 82, 87, 'Ms. Kapoor','2023-06-18', 'Kochi'),
(109, 'Nikhil Rao', 'Data Science', 79, 82, 'Dr. Sharma','2023-07-05', 'Chennai'),
(110, 'Priya Desai', 'SQL', 92, 94, 'Mr. Iyer','2023-05-27', 'Bengaluru'),
(111, 'Siddharth Jain', 'Python', 85, 90, 'Ms. Nair','2023-07-02', 'Mumbai'),
(112, 'Sneha Kulkarni', 'Tableau', 74, 83, 'Ms. Kapoor','2023-06-10', 'Pune'),
(113, 'Rohan Gupta', 'SQL', 89, 91, 'Mr. Iyer','2023-05-25', 'Delhi'),
(114, 'Ishita Joshi', 'Data Science', 93, 97, 'Dr. Sharma','2023-06-25', 'Bengaluru'),
(115, 'Yuvraj Rao', 'Python', 73, 84, 'Ms. Nair','2023-07-12', 'Hyderabad');


-- QUESTION 1
 
SELECT 
    name, 
    score, 
    (SELECT COUNT(*) + 1 
     FROM Student_Performance s2 
     WHERE s2.score > s1.score) AS score_rank
FROM Student_Performance s1
ORDER BY score DESC;

-- QUESTION 2 
SELECT 
    t1.name, 
    t1.score, 
    (SELECT t2.score 
     FROM Student_Performance t2 
     WHERE t2.score > t1.score 
     ORDER BY t2.score ASC 
     LIMIT 1) AS previous_student_score
FROM Student_Performance t1
ORDER BY t1.score DESC;

-- QUESTION 3
SELECT UPPER(name) AS student_name_upper, 
       MONTHNAME(join_date) AS join_month
FROM Student_Performance;

-- QUESTION 4
SELECT 
    name, 
    attendance,
    (SELECT attendance 
     FROM Student_Performance s2 
     WHERE s2.attendance > s1.attendance 
     ORDER BY s2.attendance ASC 
     LIMIT 1) AS next_student_attendance
FROM Student_Performance s1
ORDER BY attendance ASC;

-- QUESTION 5
/* Workaround for NTILE(4) in MySQL 5.7 */
SELECT 
    name, 
    score,
    CASE 
        WHEN (rank_val / total_rows) <= 0.25 THEN 1
        WHEN (rank_val / total_rows) <= 0.50 THEN 2
        WHEN (rank_val / total_rows) <= 0.75 THEN 3
        ELSE 4 
    END AS performance_group
FROM (
    SELECT name, score, 
           (SELECT COUNT(*) FROM Student_Performance s2 WHERE s2.score >= s1.score) AS rank_val,
           (SELECT COUNT(*) FROM Student_Performance) AS total_rows
    FROM Student_Performance s1
) AS ranked_data
ORDER BY score DESC;

-- QUESTION 6
SELECT name, course, attendance, 
       ROW_NUMBER() OVER (PARTITION BY course ORDER BY attendance DESC) AS attendance_row_num
FROM Student_Performance;

-- QUESTION 7
SELECT name, join_date, 
       DATEDIFF('2025-01-01', join_date) AS days_enrolled
FROM Student_Performance;

-- QUESTION 8
SELECT name, 
       DATE_FORMAT(join_date, '%M %Y') AS formatted_join_date
FROM Student_Performance;

-- QUESTION 9
SELECT name, 
       REPLACE(city, 'Mumbai', 'MUM') AS city_code
FROM Student_Performance;

-- QUESTION 10
SELECT name, course, score, 
       FIRST_VALUE(score) OVER (PARTITION BY course ORDER BY score DESC) AS highest_score_in_course
FROM Student_Performance;