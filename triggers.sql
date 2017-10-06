CREATE OR REPLACE FUNCTION registrate_registrations() RETURNS TRIGGER AS $reg$
  BEGIN
    --check if student already is in queue or registrated to the course--
    IF EXISTS (SELECT * FROM registrations WHERE course = NEW.course AND ssn = NEW.ssn)
          THEN RAISE EXCEPTION 'ssn: % already in queue or registrated to %', NEW.ssn, NEW.course;

    --check if student already passed the course--
    ELSIF EXISTS (SELECT * FROM passedcourses WHERE code = NEW.course AND ssn = NEW.ssn)
          THEN RAISE EXCEPTION 'ssn: % already passed %', NEW.ssn, NEW.course;

    --check if student has read required courses--
    ELSIF (EXISTS ((SELECT coursetwo FROM requires WHERE courseone = NEW.course) EXCEPT (SELECT code FROM passedcourses WHERE ssn = NEW.ssn)))
          THEN RAISE EXCEPTION 'ssn: % hasn´t passed all required courses for %', NEW.ssn, NEW.course;

    --if limited course isn´t full we registrate student for the course--
    ELSIF (SELECT seats FROM limitedCourses where code = NEW.course)
          > (SELECT COUNT(*) FROM registrations WHERE course = NEW.course AND status = 'registered')
          OR NOT EXISTS (SELECT * FROM limitedcourses WHERE code = NEW.course)
          THEN INSERT INTO registeredto VALUES(NEW.ssn, NEW.course);
          RETURN NEW;

    --if limited course is full we add student to the queue for the course--
    ELSE
          INSERT INTO queue VALUES(NEW.ssn, NEW.course,now());
          RETURN NEW;
    END IF;
  END;
$reg$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_registrations() RETURNS TRIGGER AS $del$
  DECLARE
    new_ssn INT;
  BEGIN
    --unregistrates student from course if they are registrated to the course--
    IF    (EXISTS (SELECT * FROM registeredto WHERE studentid = OLD.ssn AND course = OLD.course))
          THEN
          DELETE FROM registeredto WHERE studentid = OLD.ssn AND course = OLD.course;

          --check if there is students in queue for the course is full--
          IF  (EXISTS (SELECT * FROM queue WHERE course = OLD.course) AND
              ((SELECT seats FROM limitedcourses WHERE code = OLD.course)
              >(SELECT COUNT(*) FROM registrations WHERE course = OLD.course AND status = 'registered')))
              THEN
              --assigning the ssn of the first persen i queue for the course to new_ssn--
              SELECT ssn INTO new_ssn FROM coursequeuepositions WHERE course = OLD.course LIMIT 1;
              --registrates first person i queue--
              INSERT INTO registeredto VALUES(new_ssn,OLD.course);
              --removes the person we previously registrated from queue--
              DELETE FROM queue WHERE ssn = new_ssn AND course = OLD.course;
              RETURN NULL;
          END IF;

    --removes student from queue if student is in queue for the course--
    ELSIF (EXISTS (SELECT * FROM queue WHERE ssn = OLD.ssn AND course = OLD.course))
          THEN
          DELETE FROM queue WHERE ssn = OLD.ssn AND course = OLD.course;
    END IF;

    RETURN NULL;
  END;
$del$ LANGUAGE plpgsql;

CREATE TRIGGER reg
INSTEAD OF INSERT ON registrations
  FOR EACH ROW EXECUTE PROCEDURE registrate_registrations();

CREATE TRIGGER del
INSTEAD OF DELETE ON registrations
  FOR EACH ROW EXECUTE PROCEDURE delete_registrations();
