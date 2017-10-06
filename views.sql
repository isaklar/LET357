-------------------- studentsFollowing----------------
CREATE  OR REPLACE VIEW studentsFollowing AS
SELECT students.ssn, students.studentid, students.name, students.program, branch
FROM students
LEFT JOIN isPartOf
ON students.ssn = isPartOf.ssn;

-------------------- FinishedCourses------------------
CREATE OR REPLACE VIEW finishedCourses AS
SELECT students.ssn, students.name, courses.code, hasRead.grade, courses.credits
FROM students, courses, hasRead
WHERE students.ssn = hasread.ssn AND courses.code = hasread.course;

-------------------- Registrations--------------------
/*OLD APROCHE
CREATE OR REPLACE VIEW Registrations AS
SELECT sub1.ssn, sub1.name, registeredTo, queue.datetime
FROM queue
RIGHT OUTER JOIN(SELECT students.ssn, students.name, registeredTo
FROM students
LEFT OUTER JOIN registeredTo ON students.ssn = registeredTo.studentID) AS
sub1 ON sub1.ssn = queue.ssn;
*/
/*NEW APROCHE*/
CREATE OR REPLACE VIEW Registrations AS
SELECT ssn, course, 'waiting' AS status
FROM queue
UNION
SELECT studentid, course, 'registered' as status
FROM registeredto;
---------------------- PassedCourses-------------------
CREATE OR REPLACE VIEW PassedCourses AS
SELECT *
FROM FinishedCourses
WHERE grade <> 'U';

---------------------- UnreadMandatory----------------
CREATE OR REPLACE VIEW UnreadMandatory AS
(
  (
  SELECT students.ssn                AS "ssn",
         students.name               AS "name",
         courses.code                AS "code",
         courses.credits             AS "credits"

  FROM(students NATURAL LEFT JOIN mandatoryForProgram) LEFT JOIN Courses ON mandatoryForProgram.course = code
  )
  UNION
  (
  SELECT students.ssn                AS "ssn",
         students.name               AS "name",
         courses.code                AS "code",
         courses.credits             AS "credits"

  FROM ((isPartOf NATURAL LEFT JOIN mandatoryForBranch) LEFT JOIN Courses ON mandatoryForBranch.course = code) LEFT JOIN students ON students.ssn = IsPartOf.ssn
  )
  EXCEPT
  (
  SELECT "ssn",
         "name",
         "code",
         "credits"

         FROM passedCourses
       )
         ORDER BY "ssn"
  );

  ------------------ PathToGraduation----------------
  CREATE OR REPLACE VIEW PathToGraduation AS(
  WITH
  allStudentsAndCredits AS
  ((
      SELECT ssn,
          COALESCE(sum(credits),0) AS credits
          FROM
          PassedCourses
  GROUP BY ssn)
  ),
  allStudentsAndMathCredits AS(
     (
      SELECT ssn,
          COALESCE(sum(credits),0) AS mathCredits
          FROM
          PassedCourses
         INNER JOIN
         hasClassification
          ON PassedCourses.code = hasClassification.course
         WHERE hasClassification.classificationtype = 'Math'
  GROUP BY ssn)
  ),
  allStudentsAndResearchCredits AS(
     (
      SELECT ssn,
          COALESCE(sum(credits),0) AS researchCredits
          FROM
          PassedCourses
         INNER JOIN
         hasClassification
          ON PassedCourses.code = hasClassification.course
         WHERE hasClassification.classificationtype = 'Research'
  GROUP BY ssn)
  ),
  allStudentsAndSeminarCredits AS(
     (
      SELECT ssn,
          COALESCE(sum(credits),0) AS seminarCredits
          FROM
          PassedCourses
         INNER JOIN
         hasClassification
          ON PassedCourses.code = hasClassification.course
         WHERE hasClassification.classificationtype = 'Seminar'
  GROUP BY ssn)
  ),
  allNumberOfMandatoryLeft AS (
   (
       SELECT ssn,
          count(code) AS nbrOfMandatoryLeft
          FROM
          UnreadMandatory
  GROUP BY ssn
   )
  )
  SELECT students.ssn,
          credits,
          nbrOfMandatoryLeft,
          MathCredits,
          ResearchCredits,
          SeminarCredits,
          case when   nbrOfMandatoryLeft is null and
                      MathCredits >= 20 and
                      ResearchCredits >= 10 and
                      SeminarCredits > 0
               then 'Yes'
               else 'No'
          end as GraduationStatus
          from
          students
          left outer join
          allStudentsAndCredits on students.ssn = allStudentsAndCredits.ssn
          left outer join
          allNumberOfMandatoryLeft on students.ssn = allNumberOfMandatoryLeft.ssn
          left outer join
          allStudentsAndMathCredits on students.ssn = allStudentsAndMathCredits.ssn
          left outer join
          allStudentsAndResearchCredits on students.ssn = allStudentsAndResearchCredits.ssn
          left outer join
          allStudentsAndSeminarCredits on students.ssn = allStudentsAndSeminarCredits.ssn
  );
----------------------CourseQueuePositions---------------------------------------------------
CREATE OR REPLACE VIEW CourseQueuePositions AS
  SELECT *
  FROM queue
  ORDER BY course, datetime;
