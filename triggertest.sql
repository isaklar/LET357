--test insert to an empty limitedCourse--
\echo '------test insert to an empty limitedCourse-------';
SELECT * FROM registrations WHERE course = 'TESLIM';
INSERT INTO registrations VALUES(101,'TESLIM');
INSERT INTO registrations VALUES(102,'TESLIM');
SELECT * FROM registrations WHERE course = 'TESLIM';

--test insert to a full limitedCourse--
\echo '------test insert to a full limitedCourse-------';
INSERT INTO registrations VALUES(103,'TESLIM');
SELECT * FROM registrations WHERE course = 'TESLIM';

--test insert when student already is in queue or registrated to the course--
\echo '------test if student already is in queue or registrated to the course-------';
INSERT INTO registrations VALUES(102,'TESLIM');
SELECT * FROM registrations WHERE course = 'TESLIM';

--test when student already passed the course--
\echo '------test when student already passed the course-------';
INSERT INTO hasread VALUES(104,'TESLIM','3');
SELECT * FROM hasread WHERE ssn = 104;
INSERT INTO registrations VALUES(104,'TESLIM');
SELECT * FROM registrations WHERE course = 'TESLIM';

--test when student doesn´t fulfill required courses--
\echo '------test when student doesn´t fulfill required courses-------';
SELECT * FROM requires WHERE courseone = 'TESRE1';
SELECT * FROM hasread WHERE ssn ='101';
INSERT INTO registrations VALUES(101,'TESRE1');
SELECT * FROM registrations WHERE course = 'TESRE1';

--test when student fulfill requirements--
\echo '------test when student fulfill requirements-------';
INSERT INTO hasread VALUES('101','TESRE2','3');
SELECT * FROM hasread WHERE ssn ='101';
INSERT INTO registrations VALUES(101,'TESRE1');
SELECT * FROM registrations WHERE course = 'TESRE1';

--unregistrate student from course with a queue--
\echo '------unregistrate student from course with a queue-------';
SELECT * FROM registrations WHERE course = 'TESLIM';
DELETE FROM registrations WHERE course = 'TESLIM' AND ssn = 101;
SELECT * FROM registrations WHERE course ='TESLIM';

--unregistrate student from an overcrowded crouse with a queue--
\echo '------unregistrate student from an overcrowded crouse with a queue-------';
INSERT INTO registeredto VALUES(101,'TESLIM');
INSERT INTO registrations VALUES('105','TESLIM');
SELECT * FROM limitedcourses WHERE code = 'TESLIM';
SELECT * FROM registrations WHERE course ='TESLIM';
DELETE FROM registrations WHERE course = 'TESLIM' AND ssn = 101;
SELECT * FROM registrations WHERE course ='TESLIM';
