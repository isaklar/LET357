/*Programs*/
INSERT INTO programs VALUES('Data','DAI');
INSERT INTO programs VALUES('IT','IT');
INSERT INTO programs VALUES('Sjöfart och logistik','SJL');
INSERT INTO programs VALUES('Tekniskfysik', 'TFY');
/*Students*/
INSERT INTO students VALUES(1,1,'Gabriel','Data');
INSERT INTO students VALUES(2,2,'Isak','Data');
INSERT INTO students VALUES(3,3,'Rasumus','IT');
INSERT INTO students VALUES(4,4,'Hampus','IT');
INSERT INTO students VALUES(5,5,'Oskar','Tekniskfysik');
INSERT INTO students VALUES(6,6,'Magnus','Tekniskfysik');
INSERT INTO students VALUES(7,7,'Hugo','Sjöfart och logistik');
INSERT INTO students VALUES(8,8,'Daniel','Sjöfart och logistik');
INSERT INTO students VALUES(9,9,'Nicklas','Sjöfart och logistik');
INSERT INTO students VALUES(10,10,'Olle', 'IT');

/*Departments*/
INSERT INTO departments VALUES('FYS','Fysik');
INSERT INTO departments VALUES('SJÖ','Sjöfart');
INSERT INTO departments VALUES('D&I','Data och IT');

/*hosts*/
INSERT INTO host VALUES('D&I','Data');
INSERT INTO host VALUES('D&I','IT');
INSERT INTO host VALUES('SJÖ','Sjöfart och logistik');
INSERT INTO host VALUES('FYS','Tekniskfysik');

/*branches*/
INSERT INTO branches VALUES('Super programer','Data');
INSERT INTO branches VALUES('Bad programer','IT');
INSERT INTO branches VALUES('Isbergskrock', 'Sjöfart och logistik');
INSERT INTO branches VALUES('Space explorer', 'Tekniskfysik');

/*courses*/
INSERT INTO courses VALUES('TDA357', 7.5, 'D&I');
INSERT INTO courses VALUES('LIM456',7.5, 'D&I');
INSERT INTO courses VALUES('BPI888',7.5,'D&I');
INSERT INTO courses VALUES('SBK042',7.5,'D&I');
INSERT INTO courses VALUES('APD567',7.5,'D&I');
INSERT INTO courses VALUES('WPI888',7.5,'D&I');
INSERT INTO courses VALUES('SOP345',7.5,'SJÖ');
INSERT INTO courses VALUES('BDP456',7.5,'SJÖ');
INSERT INTO courses VALUES('FFS222',7.5,'SJÖ');
INSERT INTO courses VALUES('LIP332',7.5,'FYS');
INSERT INTO courses VALUES('BUP123',7.5,'FYS');
INSERT Into courses VALUES('EVF999',7.5,'FYS');
INSERT INTO courses VALUES('LIM001',7.5,'D&I');
INSERT INTO courses VALUES('LIM002',7.5,'D&I');
INSERT INTO courses VALUES('LIM003',7.5,'FYS');

/*mandatoryForProgram*/
INSERT INTO mandatoryForProgram VALUES('Data','TDA357');
INSERT INTO mandatoryForProgram VALUES('Data','APD567');
INSERT INTO mandatoryForProgram VALUES('IT','WPI888');
INSERT INTO mandatoryForProgram VALUES('IT','TDA357');
INSERT INTO mandatoryForProgram VALUES('Sjöfart och logistik','SOP345');
INSERT INTO mandatoryForProgram VALUES('Sjöfart och logistik','BDP456');
INSERT INTO mandatoryForProgram VALUES('Tekniskfysik','EVF999');
INSERT INTO mandatoryForProgram VALUES('Tekniskfysik','TDA357');

/*mandatoryForBranch*/
INSERT INTO mandatoryForBranch VALUES('Super programer','Data','BPI888');
INSERT INTO mandatoryForBranch VALUES('Bad programer','IT','APD567');
INSERT INTO mandatoryForBranch VALUES('Isbergskrock','Sjöfart och logistik','FFS222');
INSERT INTO mandatoryForBranch VALUES('Space explorer','Tekniskfysik','BUP123');

/*recommended*/
INSERT INTO recommended VALUES('Super programer','Data','LIM456');
INSERT INTO recommended VALUES('Bad programer','IT','SBK042');
INSERT INTO recommended VALUES('Isbergskrock','Sjöfart och logistik','EVF999');
INSERT INTO recommended VALUES('Space explorer','Tekniskfysik','TDA357');

/*classification*/
INSERT INTO classifications VALUES('Math');
INSERT INTO classifications VALUES('Research');
INSERT INTO classifications VALUES('Seminar');

/*hasClassification*/
INSERT INTO hasClassification VALUES('TDA357','Math');
INSERT INTO hasClassification VALUES('TDA357','Research');
INSERT INTO hasClassification VALUES('LIP332','Math');
INSERT INTO hasClassification VALUES('LIP332','Research');
INSERT INTO hasClassification VALUES('LIP332','Seminar');
INSERT INTO hasClassification VALUES('EVF999','Seminar');
INSERT INTO hasClassification VALUES('EVF999','Math');
INSERT INTO hasClassification VALUES('LIM001','Seminar');


/*limitedCourse*/
INSERT INTO limitedCourses VALUES('TDA357',100);
INSERT INTO limitedCourses VALUES('FFS222',5);
INSERT INTO limitedCourses VALUES('LIM001',2);
INSERT INTO limitedCourses VALUES('LIM002',2);
INSERT INTO limitedCourses VALUES('LIM003',2);

/*requires*/
INSERT INTO requires VALUES('BPI888','TDA357');
INSERT INTO requires VALUES('EVF999','LIP332');

/*registratedTo*/
INSERT INTO registeredto VALUES(6,'TDA357');
INSERT INTO registeredto VALUES(2,'TDA357');
INSERT INTO registeredto VALUES(1,'WPI888');
INSERT INTO registeredto VALUES(2,'WPI888');
INSERT INTO registeredto VALUES(3,'APD567');
INSERT INTO registeredto VALUES(4,'WPI888');
INSERT INTO registeredto VALUES(1,'LIM001');
INSERT INTO registeredto VALUES(2,'LIM001');
INSERT INTO registeredto VALUES(3,'LIM002');
INSERT INTO registeredto VALUES(4,'LIM002');
INSERT INTO registeredto VALUES(5,'LIM003');
INSERT INTO registeredto VALUES(6,'LIM003');

/*hasRead*/
INSERT INTO hasRead VALUES(1,'LIP332','4');
INSERT INTO hasRead VALUES(2,'LIP332','U');
INSERT INTO hasRead VALUES(4,'LIP332','3');
INSERT INTO hasRead VALUES(5,'LIP332','5');
insert into hasread values(1,'APD567','4');
insert into hasread values(1,'TDA357','4');
insert into hasread values(1,'BPI888','4');
insert into hasread values(1,'EVF999','5');

/*queue*/
INSERT INTO queue VALUES(9,'LIM003','2016-12-2 12:22:55');
INSERT INTO queue VALUES(5,'LIM001','2016-12-6 14:44:20');
INSERT INTO queue VALUES(8,'LIM002','2016-12-3 14:54:20');
INSERT INTO queue VALUES(3,'LIM001','2016-12-6 14:44:10');
INSERT INTO queue VALUES(10,'LIM003','2016-12-6 16:11:50');
INSERT INTO queue VALUES(7,'LIM002','2016-12-6 14:44:20');
INSERT INTO queue VALUES(4,'LIM001','2016-12-7 14:44:10');

/*isPartOf*/
insert into ispartof values(1,'Super programer', 'Data');
