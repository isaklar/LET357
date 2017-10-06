
CREATE TABLE IF NOT EXISTS programs(
	name VARCHAR PRIMARY KEY,
	abbrevation VARCHAR
);

CREATE TABLE IF NOT EXISTS students(
	ssn INT PRIMARY KEY,
	studentID INT NOT NULL UNIQUE,
	name VARCHAR NOT NULL,
	program VARCHAR NOT NULL REFERENCES programs(name)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
		UNIQUE(ssn, program)
);

CREATE TABLE IF NOT EXISTS classifications(
	type VARCHAR PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS departments(
	abbreviation VARCHAR PRIMARY KEY,
	name VARCHAR NOT NULL UNIQUE
);

 CREATE TABLE IF NOT EXISTS courses(
 	code CHAR(6) PRIMARY KEY,
	credits INT NOT NULL,
	department VARCHAR NOT NULL REFERENCES departments(abbreviation)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

 CREATE TABLE IF NOT EXISTS limitedCourses(
 	code CHAR(6) NOT NULL REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	seats INT NOT NULL
 );

 CREATE TABLE IF NOT EXISTS branches(
 	name VARCHAR,
	program VARCHAR REFERENCES programs(name)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY(name,program)
 );

 CREATE TABLE IF NOT EXISTS hasRead(
 	ssn INT REFERENCES students(ssn)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	course CHAR(6) REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	grade CHAR(1) NOT NULL CHECK (grade ='3' OR grade = '4' OR grade = '5' OR grade = 'U'),
	PRIMARY KEY(ssn, course)
 );

 CREATE TABLE IF NOT EXISTS registeredTo(
 	studentID INT,
	course CHAR(6) REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(studentID) REFERENCES students(ssn)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY(studentID, course)
 );

 CREATE TABLE IF NOT EXISTS mandatoryForBranch(
 	branch VARCHAR,
	program VARCHAR,
	course CHAR(6) REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(branch, program) REFERENCES branches(name, program)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY(branch, program, course)
 );

 CREATE TABLE IF NOT EXISTS recommended(
 	branch VARCHAR,
	program VARCHAR,
	course CHAR(6) REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(branch, program) REFERENCES branches(name, program)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY(branch, program, course)
 );

CREATE TABLE IF NOT EXISTS host(
	abbreviation VARCHAR,
	program VARCHAR REFERENCES programs(name)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(abbreviation) REFERENCES departments(abbreviation)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY(abbreviation, program)
);

CREATE TABLE IF NOT EXISTS queue(
	ssn INT REFERENCES students(ssn),
	course VARCHAR REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	dateTime TIMESTAMP NOT NULL,
	UNIQUE(course,dateTime),
	PRIMARY KEY(ssn, course)
);

CREATE TABLE IF NOT EXISTS mandatoryForProgram(
	program VARCHAR REFERENCES programs(name)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	course VARCHAR REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY(program, course)
);

CREATE TABLE IF NOT EXISTS hasClassification(
	course CHAR(6) REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	classificationType VARCHAR REFERENCES classifications(type),
	PRIMARY KEY(course, classificationType)
);

CREATE TABLE IF NOT EXISTS requires(
	courseOne CHAR(6) REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	courseTwo CHAR(6) REFERENCES courses(code)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY(courseOne, courseTwo)
);

CREATE TABLE IF NOT EXISTS isPartOf(
	ssn INT,
	branch VARCHAR,
	program VARCHAR,
	FOREIGN KEY(branch, program) REFERENCES branches(name, program),
	FOREIGN KEY(ssn, program) REFERENCES students(ssn, program),
	PRIMARY KEY(ssn)
);
