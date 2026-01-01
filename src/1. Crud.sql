-- CREATEING A TABLE
CREATE TABLE students(
	id INT,
	name VARCHAR(50),
	city VARCHAR(50)
);
-- INSTERTING DATA INTO TABLE
INSERT INTO students(id,name,city)
VALUES (101,'Manoj','bangalore')

INSERT INTO students VALUES(102,'Manu','Mysore');
INSERT INTO students VALUES
(103,'sham','Mumbai'),
(104,'Akash','Gujart'),
(105,'chinmai','mandya');

-- READING FROM TABLE
SELECT * FROM students;

SELECT id FROM students;

SELECT id,name FROM students;

-- UPDATING THE DATA 
UPDATE students 
	SET city='Pune'
	WHERE id=104; --WHERE is 'clause'

-- DELETING THE DATA
DELETE FROM students
	WHERE id=105;
