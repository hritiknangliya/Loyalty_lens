CREATE TABLE raw_data (
    name TEXT,
    age INT,
    salary INT,
    email TEXT
);

CREATE TABLE cleaned_data (
    name TEXT,
    age INT,
    salary INT,
    email TEXT,
    status TEXT
);

CREATE TABLE bad_data (
    name TEXT,
    age INT,
    salary INT,
    email TEXT,
    error_reason TEXT
);




CREATE OR REPLACE PROCEDURE clean_data()
LANGUAGE plpgsql
AS $$
BEGIN
    TRUNCATE TABLE cleaned_data;
    TRUNCATE TABLE bad_data;

    INSERT INTO cleaned_data
    SELECT name, age, salary, email, 'Valid'
    FROM raw_data
    WHERE name IS NOT NULL
      AND age BETWEEN 1 AND 100
      AND salary > 0
      AND email IS NOT NULL;

    INSERT INTO bad_data
    SELECT name, age, salary, email,
    CASE 
        WHEN name IS NULL THEN 'Invalid Name'
        WHEN age NOT BETWEEN 1 AND 100 THEN 'Invalid Age'
        WHEN salary <= 0 THEN 'Invalid Salary'
        WHEN email IS NULL THEN 'Invalid Email'
    END
    FROM raw_data
    WHERE name IS NULL
       OR age NOT BETWEEN 1 AND 100
       OR salary <= 0
       OR email IS NULL;
END;
$$;


SELECT * FROM raw_data;
SELECT * FROM cleaned_data;
SELECT * FROM bad_data;
