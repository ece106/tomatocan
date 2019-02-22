// ------------------------------------------------------------
// AUTHOR: Liliana Martinez
// FILENAME: Lab6.java
// SPECIFICATION: Collects user input to display first and last name and current age and age 10 years from now 
// FOR: CSE 110- Lab #6 
// TIME SPENT: 60 minutes
//-------------------------------------------------------------
import java.util.Scanner;
public class Lab6 {
  public static void main(String[] args) {
    Scanner in = new Scanner(System.in);
      String firstName;
      String lastName;
      int birthYear;

      System.out.println("Enter the first name of the person: ");
        firstName = in.nextLine();

      System.out.println("Enter the last name of the person: ");
        lastName = in.nextLine();

      System.out.println("Enter the birth year of the person: ");
        birthYear = in.nextInt();

    Person pi = new Person (firstName, lastName, birthYear);

    System.out.println(getFirstName() + getLastName() + "is" + getAge(2019) + "years old in 2019 and will be" + (getAge(2019)+10) + "years old in ten years.");
  }
}