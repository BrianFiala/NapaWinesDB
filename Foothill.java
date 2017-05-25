/* name: Brian Fiala
 * date: 6/20/14
 * Professor Mounjed Moussalem, CS31A, Foothill Community College
 * Term Project, Phase 5
 * 
 * Class Foothill: instantiates an object of class ConnInterface, and uses it to
 * establish a connection with an Oracle db that stores information about Napa
 * Valley wines. Offers the user 8 options for viewing databse information and
 * for adding new information to the database.
 */

import java.util.Scanner;

public class Foothill 
{ 
   public static void main (String args [])
   { 
      Scanner input = new Scanner(System.in);
      String user = "hr";
      String pass = "oracle";
      boolean connOpen = false;
      
      // create database interface object
      ConnInterface dbConn = new ConnInterface(user, pass);
      connOpen = dbConn.openConn();
      
      if (connOpen)
      {
         System.out.println("Welcome to the Napa Valley wines database!");
         
         int selection; // option selected by user below
         while(true)
         {
            System.out.println("\n\nPlease enter the integer corresponding to"
               + " your selection:");
            System.out.println("\t0. Quit");
            System.out.println("\t1. Print all wines");
            System.out.println("\t2. Lookup the appellation, county, climate "
               + "for a wine");
            System.out.println("\t3. Find restaurants that serve a wine");
            System.out.println("\t4. Find clients that frequent the same "
               + "restaurants as a given client");
            System.out.println("\t5. Add a wine to the database");
            System.out.println("\t6. Add a maker to a restaurant's menu");
            System.out.println("\t7. Add a new location for a restaurant");
            selection = input.nextInt();
            
            if (selection == 0)
            {
               System.out.println("Thank you for using the Team Awesome Napa "
                  + "Valley wines database.\nClosing the database connection"
                  + " and quitting.");
               break;
            }
            switch (selection)
            {
               case 1: 
                  if (!dbConn.printWines())
                     System.out.println("Error getting wines.");
                  break;
               case 2: 
                  if (!dbConn.lookupAppellation())
                     System.out.println("Error getting appellations.");
                  break;
               case 3: 
                  if (!dbConn.findRestaurants())
                     System.out.println("Error finding restaurants.");
                  break;
               case 4: 
                  if (!dbConn.findPotBuddies())
                     System.out.println("Error finding other clients.");
                  break;
               case 5: 
                  if (!dbConn.addWine())
                     System.out.println("Error adding wine to database.");
                  break;
               case 6: 
                  if (!dbConn.addMakerToMenu())
                     System.out.println("Error adding maker to menu.");
                  break;
               case 7: 
                  if (!dbConn.addLocation())
                     System.out.println("Error adding location to database.");
                  break;
               default: break;
            } // end switch
         } // end while         
         dbConn.closeScanner();
         dbConn.closeConn(); // close db connection
      } // end if (connOpen)
      
      input.close(); // close Scanner object
   } // end main
} // end class Foothill --------------------------------------------------------