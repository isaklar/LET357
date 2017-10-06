/* This is the driving engine of the program. It parses the command-line
 * arguments and calls the appropriate methods in the other classes.
 *
 * You should edit this file in two ways:
 * 1) Insert your database username and password in the proper places.
 * 2) Implement the three functions getInformation, registerStudent
 *    and unregisterStudent.
 */
import java.sql.*; // JDBC stuff.
import java.util.Properties;
import java.util.Scanner;
import java.io.*;  // Reading user input.
import java.lang.String.*;

public class StudentPortal
{
    /* TODO Here you should put your database name, username and password */
    static final String USERNAME = "tda357_049";
    static final String PASSWORD = "PPYbWeRL";

    /* Print command usage.
     * /!\ you don't need to change this function! */
    public static void usage () {
        System.out.println("Usage:");
        System.out.println("    i[nformation]");
        System.out.println("    r[egister] <course>");
        System.out.println("    u[nregister] <course>");
        System.out.println("    q[uit]");
    }

    /* main: parses the input commands.
     * /!\ You don't need to change this function! */
    public static void main(String[] args) throws Exception
    {
      Scanner sc = new Scanner(System.in);
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://ate.ita.chalmers.se/";
            Properties props = new Properties();
            props.setProperty("user",USERNAME);
            props.setProperty("password",PASSWORD);
            Connection conn = DriverManager.getConnection(url, props);

            String student = args[0]; // This is the identifier for the student.

            Console console = System.console();
	    // In Eclipse. System.console() returns null due to a bug (https://bugs.eclipse.org/bugs/show_bug.cgi?id=122429)
	    // In that case, use the following line instead:
	    // BufferedReader console = new BufferedReader(new InputStreamReader(System.in));
            usage();
            System.out.println("Welcome!");
            while(true) {
	        System.out.print("? > ");
                String mode = console.readLine();
                String[] cmd = mode.split(" +");
                cmd[0] = cmd[0].toLowerCase();
                if ("information".startsWith(cmd[0]) && cmd.length == 1) {
                    /* Information mode */
                    getInformation(conn, student);
                } else if ("register".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Register student mode */
                    registerStudent(conn, student, cmd[1]);
                } else if ("unregister".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Unregister student mode */
                    unregisterStudent(conn, student, cmd[1]);
                } else if ("quit".startsWith(cmd[0])) {
                    break;
                } else usage();
            }
            System.out.println("Goodbye!");
            conn.close();
        } catch (SQLException e) {
            System.err.println(e);
            System.exit(2);
        }
    }

    /* Given a student identification number, this function should print
     * - the name of the student, the students national identification number
     *   and their issued login name (something similar to a CID)
     * - the programme and branch (if any) that the student is following.
     * - the courses that the student has read, along with the grade.
     * - the courses that the student is registered to. (queue position if the student is waiting for the course)
     * - the number of mandatory courses that the student has yet to read.
     * - whether or not the student fulfills the requirements for graduation
     */
    static void getInformation(Connection conn, String student) throws SQLException
    {
        // Using statements to fetch information from the database.
        PreparedStatement students = conn.prepareStatement("SELECT * from students WHERE ssn = ?");
        PreparedStatement courses = conn.prepareStatement("SELECT * from passedcourses WHERE ssn = ?");
        PreparedStatement registeredto = conn.prepareStatement("SELECT * from registeredto WHERE studentid = ?");
        PreparedStatement graduation = conn.prepareStatement("SELECT * from pathtograduation WHERE ssn = ?");

        // Sets what column to put the input parameter. In this case: ssn.
        students.setInt(1,Integer.parseInt(student));
        courses.setInt(1,Integer.parseInt(student));
        registeredto.setInt(1,Integer.parseInt(student));
        graduation.setInt(1,Integer.parseInt(student));

        // Takes the information from the statements and executes it.
        ResultSet studentsResult = students.executeQuery();
        ResultSet coursesResult = courses.executeQuery();
        ResultSet registeredtoResult = registeredto.executeQuery();
        ResultSet graduationResult = graduation.executeQuery();


        if(studentsResult.next())
        {
          /* -------------- STUDENT --------------------- */

          //variables
          int ssn = studentsResult.getInt("ssn");
          int id = studentsResult.getInt("studentid");
          String name = studentsResult.getString("name");
          String program = studentsResult.getString("program");

          //print
          System.out.println("#### STUDENT ####");
          System.out.println("Name: " + name);
          System.out.println("SSN: " + ssn);
          System.out.println("ID: " + id);
          System.out.println("Program: " + program);
        }

        /* -------------- COURSES ---------------------*/

        System.out.println(" ");
        System.out.println(" ");
        System.out.println("#### COURSES ####");

        while(coursesResult.next())
        {
          //variables
          String code  = coursesResult.getString("code");
          int credits = coursesResult.getInt("credits");
          int grade  = coursesResult.getInt("grade");

          //print
          System.out.println("Courses: " + code + " Credits: " + credits + " Grade: " + grade);
        }

        /* -------------- REGISTRATED TO --------------------- */

        System.out.println(" ");
        System.out.println(" ");
        System.out.println("#### REGISTERED TO ####");

        while(registeredtoResult.next())
        {
          //variables
          String course = registeredtoResult.getString("course");

          //print
          System.out.println("Courses: " + course);
        }

        /* -------------- PATH TO GRADUATION --------------------- */

        System.out.println(" ");
        System.out.println(" ");
        System.out.println("#### PATH TO GRADUATION ####");

        while(graduationResult .next())
        {
          //variables
          int seminar = graduationResult .getInt("seminarcredits");
          int math = graduationResult .getInt("mathcredits");
          int research = graduationResult .getInt("researchcredits");
          int totalcredits = graduationResult .getInt("credits");
          String status = graduationResult .getString("graduationstatus");

          //print
          System.out.println("Seminar credits taken: " + seminar);
          System.out.println("Math credits taken: " + math);
          System.out.println("Seminar credits taken: " + research);
          System.out.println("Total credits taken: " + totalcredits);
          System.out.println("Fulfills the requirements for graduation: " + status);
        }
    }

    /* Register: Given a student id number and a course code, this function
     * should try to register the student for that course.
     */
    static void registerStudent(Connection conn, String student, String course)
    throws SQLException
    {
        //registrate student for course
        PreparedStatement regStudentForCourse = conn.prepareStatement("insert into registrations values(?,?)");
        regStudentForCourse.setInt(1,Integer.parseInt(student));
        regStudentForCourse.setString(2,course);

        //if one row was added the query was successfully executed
        if(regStudentForCourse.executeUpdate() == 1){
          //check if the student got registrated to the course or put to queue for the course
          PreparedStatement checkRegStatus = conn.prepareStatement("select status from registrations where ssn = ? and course = ?");
          checkRegStatus.setInt(1,Integer.parseInt(student));
          checkRegStatus.setString(2,course);
          ResultSet statusSet = checkRegStatus.executeQuery();
          statusSet.next();
          if(statusSet.getString("status").equals("registered")){
            System.out.println("You are now successfully registered to course "+course);
          }
          else{
            System.out.println("Course "+course+" is full, you are put in waiting list.");
          }
        }
    }

    /* Unregister: Given a student id number and a course code, this function
     * should unregister the student from that course.
     */
    static void unregisterStudent(Connection conn, String student, String course)
    throws SQLException
    {
        //Unregister student from course
        PreparedStatement checkIfReged = conn.prepareStatement("select * from registrations where ssn = ? and course = ?");
        checkIfReged.setInt(1,Integer.parseInt(student));
        checkIfReged.setString(2, course);
        ResultSet reged = checkIfReged.executeQuery();
        if(reged.next()){
          PreparedStatement unRegFromCourse = conn.prepareStatement("delete from registrations where ssn = ? and course = ?");
          unRegFromCourse.setInt(1, Integer.parseInt(student));
          unRegFromCourse.setString(2, course);
          unRegFromCourse.executeUpdate();
          System.out.println("You are now unregisterd from course: "+course);
        }
        else{
          System.out.println("You were never registrated to course: "+course);
        }

        // TODO: Your implementation here
    }
}
