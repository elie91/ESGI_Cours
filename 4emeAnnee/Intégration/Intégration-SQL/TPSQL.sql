/********************************* TP N°1: ********************************/

/* 1 - Création de la table people */
CREATE TABLE people (
    id SERIAL PRIMARY KEY, 
    firstname VARCHAR(100) NOT NULL, 
    lastname VARCHAR(100) NOT NULL, 
    age INTEGER NOT NULL
);

/* 2 - Rendre tout obligatoire et lastname unique */
ALTER TABLE people
ALTER COLUMN firstname SET NOT NULL,
ALTER COLUMN lastname SET NOT NULL,
ADD CONSTRAINT lastname_unique UNIQUE (lastname),
ALTER COLUMN age SET NOT NULL;


/* 3 - Insérer 10 personnes en une commande */
INSERT INTO people (firstname, lastname, age)
VALUES
    (
        'Elie',
        'Bismuth',
        23
    ),
    (
        'Jhon',
        'Doe',
        40
    ),
    (
        'Damien',
        'Dupond',
        20
    ),
    (
        'Rafy',
        'Attias',
        25
    ),
    (
        'Alan',
        'Toledano',
        27
    ),
    (
        'Bryan',
        'ohayon',
        22
    ),
    (
        'Elmaleh',
        'Joyce',
        50
    ),
    (
        'Idrissa',
        'Guey',
        30
    ),
    (
        'Edinson',
        'Cavani',
        28
    ),
    (
        'Jean',
        'Neymar',
        26
    );


/* 4 - Changer le firstname de l'id 4 en remi */
UPDATE people
SET firstname = 'Tomtom'
WHERE id = 6;

/* 5 - Delete where firstname = damien */
DELETE FROM people
WHERE firstname = 'Damien';

/* 6 - Select all datas, and replace lastname by nom de famille */
SELECT id, firstname, lastname AS nom_de_famille, age
FROM people;


/********************************* TP N°2: ********************************/

/* 1 - All users between 18 and 25 and firstname starting with tom */
SELECT * 
FROM people 
WHERE age BETWEEN 18 and 25
AND firstname ILIKE 'tom%';

/* 2 - add new field joinin as timestamp and insert new users  */
ALTER TABLE people 
ADD COLUMN joined timestamp;
INSERT INTO people (firstname, lastname, age, joined)
VALUES ('Marco', 'Verrati', 28, to_date('20190923', 'YYYYMMDD'));

/* 3 - all firstname and lastname, but if firstname start with t(h)o, change by toto */
SELECT lastname,
    CASE 
        WHEN firstname SIMILAR TO 'th?o%' THEN 'toto'
        ELSE firstname 
    END as firstname
from people;

/* 4 - one single column firstname, lastname is age years old */
SELECT CONCAT(firstname, ' ', lastname, ' is ',age, ' years old')
FROM people;

/* 5 - update timestamp of the user 6 with actual date, then display it but just with the day */
UPDATE people SET joined = now() WHERE id = 6;
SELECT firstname, lastname, age, extract(day from joined) as Jour
FROM people WHERE id = 6; 

/* Question 6 :
Display all users with an extra column `comment`:
    - If firstname starts with 'di' or 'dy', display 'Didi'
    - If age is 42, display 'wow'
    - If age is 25, 32 or 44, display 'Hello random picks!'
    - If age is between 5 and 18, display 'Young'
    - If none of these requirements are met, display the age */

SELECT firstname, lastname,
   CASE
       WHEN lower(firstname) SIMILAR TO '(di|dy)%' THEN 'Didi'
       WHEN age = 42 THEN 'wow'
       WHEN age IN (25, 32, 44) THEN 'Hello random picks!'
       WHEN age BETWEEN 5 AND 18 THEN 'Young'
       ELSE age::varchar(3)
   END AS comment
FROM people;


/**************** TP N°3: **********************************/

/* 1 - count all chars of all description of school table */
SELECT SUM(char_length(description)) FROM school;

/* 2 - Test all joins with the 2 or 3 tables */


/* 3 - create a view v_student_inscription displaying people firstname and lastname and school */

CREATE VIEW v_student_description AS 
SELECT firstname, lastname, school.name 
FROM people
    JOIN people_school 
        ON people.id = people_school.id_people
    JOIN school 
        ON school.id = people_school.id_school;

/* 4 - create view v_skill_by_school ranking school by average on their student, desc order */
CREATE VIEW v_skill_by_school AS 
SELECT school.name, round(avg(people.skill_level)) AS skillLevel 
FROM school
    JOIN people_school 
        ON school.id = people_school.id_school
    JOIN people 
        ON people.id = people_school.id_people
GROUP BY school.name
ORDER BY skillLevel DESC;

/* 5 - change v_student_description to add the seniority */
CREATE OR REPLACE VIEW v_student_description AS
    SELECT firstname, lastname, school.name, age(now() , people_school.join_date) 
    FROM people
    JOIN people_school 
        ON people.id = people_school.id_people
    JOIN school 
        ON school.id = people_school.id_school;


/**************** TP N°4: **********************************/

/* 1 - get all students aren't in school yet (no join) */
SELECT * FROM people 
WHERE NOT id NOT IN(
    SELECT id_people
    FROM people_school
);

/* 2 - create procedure which set the skill level accordin to firstname and lastname */
CREATE OR REPLACE FUNCTION p_update_skill_level(firstN varchar, lastN varchar, skill integer)
RETURNS varchar as $$
BEGIN
    UPDATE people 
    SET skill_level = skill
    WHERE people.firstname = firstN
    AND people.lastname = lastN;
    RETURN 'success';
END;
$$ LANGUAGE plpgsql;

/* 3 - create procedure p_proper_school_affiliation wich update all join_date 
from people_school with todays date */

CREATE OR REPLACE FUNCTION p_proper_school_affiliation()
RETURNS trigger AS $$
BEGIN
    UPDATE people_school
    SET join_date = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* 4 - create trigger t_proper_school_affiliation at insert on people that call the procedure */
CREATE TRIGGER t_proper_school_affiliation 
AFTER INSERT ON people_school
FOR EACH ROW
EXECUTE PROCEDURE p_proper_school_affiliation();

INSERT INTO people(firstname, lastname, age, skill_level) VALUES ('Test', 'test', 
23, 95);

/* 
5 - create trigger t_update_join_date and function p_update_join_date wich
update join date if id_school of a row is modified */

CREATE OR REPLACE FUNCTION p_update_join_date()
RETURNS trigger AS $$
BEGIN
    UPDATE people_school
    SET join_date = now()
    WHERE people_school.id = NEW.id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_update_join_date
AFTER UPDATE ON people_school
FOR EACH ROW
WHEN (OLD.id_school IS DISTINCT FROM NEW.id_school)
EXECUTE FUNCTION p_update_join_date();