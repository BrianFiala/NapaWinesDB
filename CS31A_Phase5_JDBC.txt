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

import java.sql.*;
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

/* ----------------------------------------------------------------------------
 * Class ConnInterface: provides methods for establishing a database connection,
 * querying and updating the database, and closing the connection.
 */

class ConnInterface
{
   private Connection conn = null;
   private String user, pass;
   private Scanner userInput = new Scanner(System.in);

   // constructor
   public ConnInterface(String user, String pass)
   {
      setUser(user);
      setPass(pass);
   } // end constructor

   public boolean openConn()
   {
      try
      {
         Class.forName("oracle.jdbc.driver.OracleDriver");
         conn = DriverManager.getConnection("jdbc:oracle:thin:" + user + "/"
            + pass + "@//127.0.01:1521/PDB1");
      }
      catch (ClassNotFoundException e)
      {
         System.out.println("Could not load the driver");
         return false;
      }
      catch (SQLException e)
      {
         System.out.println("Error establishing connection");
         return false;
      }
      return true;
   } // end openConn

   public void closeConn()
   {
      try
      {
         conn.close();
      }
      catch (Exception e)
      {
         System.out.println("Error closing connection");
         e.printStackTrace();
      }
   } // end closeConn

   public void closeScanner()
   {
      userInput.close();
   }

   public String getUser()
   {
      return user;
   } // end getUser

   public void setUser(String user)
   {
      this.user = user;
   } // end setUser

   public String getPass()
   {
      return pass;
   } // end getPass

   public void setPass(String pass)
   {
      this.pass = pass;
   } // end setPass

   public boolean printWines()
   {
      try
      {
         Statement stmt = conn.createStatement();
         ResultSet rset = stmt.executeQuery("SELECT * FROM Wines");
         System.out.println("\nWine Name            Vintage Maker Name"
            + "                     Color\n");
         String winePad, vintagePad, makerPad;
         String padBuffer = "                              ";
         while (rset.next())
         {
            winePad = padBuffer.substring(0, 21 - rset.getString(1).length());
            vintagePad = "    ";
            makerPad = padBuffer.substring(0, 31 - rset.getString(3).length());
            System.out.println(rset.getString(1) + winePad
               + rset.getString(2) + vintagePad
               + rset.getString(3) + makerPad
               + rset.getString(4));
         }
         stmt.close();
      }
      catch (SQLException e)
      {
         System.out.println("SQL error: bad connection, statement,"
            + " or result set");
         e.printStackTrace();
         return false;
      }
      return true;
   } // end printWines

   public boolean lookupAppellation()
   {
      try
      {
         // create prepared statement
         PreparedStatement stmt = conn.prepareStatement(
            "SELECT Appellations.appellationName, county, climate "
               + "FROM Appellations, Origin "
               + "WHERE Appellations.appellationName = Origin.appellationName "
               + "AND Origin.wineName LIKE ? "
               + "AND Origin.vintage LIKE ? "
               + "AND Origin.makerName LIKE ? ");

         // Query user for wine and set statement parameters
         System.out.println("Enter the wine name, exactly: ");
         stmt.setString(1, userInput.nextLine());
         System.out.println("Enter the vintage: ");
         stmt.setString(2, userInput.nextLine());
         System.out.println("Enter the maker name, exactly: ");
         stmt.setString(3, userInput.nextLine());

         // execute the query and display the results
         ResultSet rset = stmt.executeQuery();
         System.out.println("\nAppellation Name     County     Climate\n");
         String appellationPad, countyPad;
         String padBuffer = "                    ";

         while (rset.next())
         {
            appellationPad = padBuffer.substring(0,
               21 - rset.getString(1).length());
            countyPad = padBuffer.substring(0, 11 - rset.getString(2).length());
            System.out.println(rset.getString(1) + appellationPad
               + rset.getString(2) + countyPad
               + rset.getString(3));
         }
         stmt.close();
      }
      catch (SQLException e)
      {
         System.out.println("SQL error: bad connection, statement,"
            + " or result set");
         e.printStackTrace();
         return false;
      }
      return true;
   } // end lookupAppellation

   public boolean findRestaurants()
   {
      try
      {
         // create prepared statement
         PreparedStatement stmt = conn.prepareStatement(
            "SELECT DISTINCT Restaurants.restaurantName, "
               + "Restaurants.restaurantAddress "
               + "FROM Restaurants, Serves "
               + "WHERE Restaurants.restaurantAddress = "
                  + "Serves.restaurantAddress "
               + "AND Serves.wineName LIKE ? "
               + "AND Serves.vintage LIKE ? "
               + "AND Serves.makerName LIKE ? ");

         // Query user for wine and set statement parameters
         System.out.println("Enter the wine name, exactly: ");
         stmt.setString(1, userInput.nextLine());
         System.out.println("Enter the vintage: ");
         stmt.setString(2, userInput.nextLine());
         System.out.println("Enter the maker name, exactly: ");
         stmt.setString(3, userInput.nextLine());

         // execute the query and display the results
         ResultSet rset = stmt.executeQuery();
         System.out.println("\nRestaurant Name                "
            + "Restaurant Address\n");
         String namePad;
         String padBuffer = "                              ";

         while (rset.next())
         {
            namePad = padBuffer.substring(0, 31 - rset.getString(1).length());
            System.out.println(rset.getString(1) + namePad
               + rset.getString(2));
         }
         stmt.close();
      }
      catch (SQLException e)
      {
         System.out.println("SQL error: bad connection, statement,"
            + " or result set");
         e.printStackTrace();
         return false;
      }
      return true;
   } // end findRestaurants

   public boolean findPotBuddies()
   {
      try
      {
         // create prepared statement
         PreparedStatement stmt = conn.prepareStatement(
            "SELECT DISTINCT F2.clientName, F2.clientAddress "
               + "FROM Frequents F1, Frequents F2 "
               + "WHERE F1.restaurantName = F2.restaurantName "
               + "AND F1.restaurantAddress = F2.restaurantAddress "
               + "AND F1.clientName LIKE ? "
               + "AND F1.clientAddress LIKE ? "
               + "AND F2.clientName NOT LIKE ? "
               + "AND F2.clientAddress NOT LIKE ? ");

         // Query user for client info and set statement parameters
         String name, address;
         System.out.println("Enter the client's name, exactly: ");
         name = userInput.nextLine();
         stmt.setString(1, name);
         stmt.setString(3, name);
         System.out.println("Enter the client's address, exactly: ");
         address = userInput.nextLine();
         stmt.setString(2, address);
         stmt.setString(4, address);

         // execute the query and display the results
         ResultSet rset = stmt.executeQuery();
         System.out.println("\nClient Names         Client Addresses\n");
         String namePad;
         String padBuffer = "                              ";

         while (rset.next())
         {
            namePad = padBuffer.substring(0, 21 - rset.getString(1).length());
            System.out.println(rset.getString(1) + namePad
               + rset.getString(2));
         }
         stmt.close();
      }
      catch (SQLException e)
      {
         System.out.println("SQL error: bad connection, statement,"
            + " or result set");
         e.printStackTrace();
         return false;
      }
      return true;
   } // end findPotBuddies

   public boolean addWine()
   {
      try
      {
         // create prepared statement
         PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO Wine_Info VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

         // Query user for wine info and set statement parameters
         System.out.println("Enter the wine name: ");
         stmt.setString(1, userInput.nextLine());
         System.out.println("Enter the vintage (later than 1850): ");
         stmt.setString(2, userInput.nextLine());
         System.out.println("Enter the maker's name, exactly "
            + "(must be an existing maker): ");
         stmt.setString(3, userInput.nextLine());
         System.out.println("Enter the color (Red, White, or Rose): ");
         stmt.setString(4, userInput.nextLine());
         System.out.println("Enter the varietal: ");
         stmt.setString(5, userInput.nextLine());
         System.out.println("Enter the appellation: ");
         stmt.setString(6, userInput.nextLine());
         System.out.println("Enter the county (must be Sonoma or Napa: ");
         stmt.setString(7, userInput.nextLine());
         System.out.println("Enter the climate (less than 5 characters): ");
         stmt.setString(8, userInput.nextLine());

         // execute the query and display the results
         int rows = stmt.executeUpdate();
         System.out.println("Inserted " + rows + " wine into database.");
         stmt.close();
      }
      catch (SQLException e)
      {
         System.out.println("SQL error: bad connection, statement,"
            + " or update");
         e.printStackTrace();
         return false;
      }
      return true;
   } // end addWine

   public boolean addMakerToMenu()
   {
      try
      {
         // create prepared statement
         CallableStatement stmt = conn.prepareCall(
            "{CALL AddMakerToMenu(?, ?)}");

         // Query user for wine info and set statement parameters
         System.out.println("Enter the maker's name, exactly "
            + "(must be an existing maker): ");
         String maker = userInput.nextLine();
         stmt.setString(1, maker);
         System.out.println("Enter the restaurant's address, exactly "
            + "(must be an existing location): ");
         stmt.setString(2, userInput.nextLine());

         // execute the query and display the results
         stmt.execute();
         System.out.println("Inserted " + maker + " into Serves table.");
         stmt.close();
      }
      catch (SQLException e)
      {
         System.out.println("SQL error: bad connection, statement,"
            + " or update");
         e.printStackTrace();
         return false;
      }
      return true;
   } // end addMakerToMenu

   public boolean addLocation()
   {
      try
      {
         // create prepared statement
         CallableStatement stmt = conn.prepareCall(
            "{CALL NewLocationSameMenu(?, ?)}");

         // Query user for wine info and set statement parameters
         System.out.println("Enter the restaurant's name, exactly "
            + "(must be an existing restaurant): ");
         String name = userInput.nextLine();
         stmt.setString(1, name);
         System.out.println("Enter the new location's address: ");
         stmt.setString(2, userInput.nextLine());

         // execute the query and display the results
         stmt.execute();
         System.out.println("Inserted the new location for " + name);
         stmt.close();
      }
      catch (SQLException e)
      {
         System.out.println("SQL error: bad connection, statement,"
            + " or update");
         e.printStackTrace();
         return false;
      }
      return true;
   } // end addLocation
} // end class ConnInterface ---------------------------------------------------

/*-----------------------------Paste From Console-------------------------------
Welcome to the Napa Valley wines database!


Please enter the integer corresponding to your selection:
   0. Quit
   1. Print all wines
   2. Lookup the appellation, county, climate for a wine
   3. Find restaurants that serve a wine
   4. Find clients that frequent the same restaurants as a given client
   5. Add a wine to the database
   6. Add a maker to a restaurant's menu
   7. Add a new location for a restaurant
1

Wine Name            Vintage Maker Name                     Color

Cabernet Sauvignon   2012    Alpha Omega                    Red
Cabernet Sauvignon   2011    Alpha Omega                    Red
Cabernet Sauvignon   2010    Alpha Omega                    Red
Cabernet Sauvignon   2009    Alpha Omega                    Red
Cabernet Sauvignon   2008    Alpha Omega                    Red
Chardonnay           2012    Alpha Omega                    White
Chardonnay           2011    Alpha Omega                    White
Chardonnay           2010    Alpha Omega                    White
Chardonnay           2009    Alpha Omega                    White
Chardonnay           2008    Alpha Omega                    White
Sauvignon Blanc      2012    Alpha Omega                    White
Sauvignon Blanc      2011    Alpha Omega                    White
Sauvignon Blanc      2010    Alpha Omega                    White
Sauvignon Blanc      2009    Alpha Omega                    White
Sauvignon Blanc      2008    Alpha Omega                    White
Grenache             2012    Domaine Chandon Winery         White
Grenache             2011    Domaine Chandon Winery         White
Chenin Blanc         2012    Domaine Chandon Winery         White
Chenin Blanc         2011    Domaine Chandon Winery         White
Menage a Trois       2012    Domaine Chandon Winery         Red
Menage a Trois       2011    Domaine Chandon Winery         Red
Reserve Pinot Noir   2011    Domaine Chandon Winery         Red
Merlot               2012    Black Stallion                 Red
Cabernet Sauvignon   2012    Black Stallion                 Red
Sauvignon Blanc      2012    Black Stallion                 White
Syrah                2012    Black Stallion                 Red
Zinfandel            2012    Black Stallion                 Red
Muscat               2012    Black Stallion                 Red
Zinfandel            2012    Chateau Montelena              Red
Chardonnay           2012    Chateau Montelena              White
Riesling             2012    Chateau Montelena              White
Petit Sirah          2012    Chateau Montelena              Red
Cabernet Sauvignon   2012    Chateau Montelena              Red
Syrah                2012    Cornerstone Cellars            Red
Cabernet Franc       2012    Cornerstone Cellars            Red
Pinot Gris           2012    Cornerstone Cellars            White
Cabernet Sauvignon   2012    Cornerstone Cellars            Red
Riesling             2012    Cornerstone Cellars            White
Pinot Noir           2012    Etude                          Red
Chardonnay           2012    Etude                          White
Pinot Blanc          2012    Etude                          White
Malbec               2012    Etude                          Red
Chardonnay           2012    Far Niente                     White
Chardonnay           2011    Far Niente                     White
Cabernet Sauvignon   2012    Far Niente                     Red
Cabernet Sauvignon   2011    Far Niente                     Red
Malbec               2012    Arrowood Winery                Red
Merlot               2012    Arrowood Winery                Red
Syrah                2012    Arrowood Winery                Red
Cabernet Sauvignon   2012    Arrowood Winery                Red
Syrah                2012    Balletto Winery                Red
Pinot Noir           2012    Balletto Winery                Red
Chardonnay           2012    Balletto Winery                White
Zinfandel            2012    Balletto Winery                Red
Gerwurztraminer      2012    Balletto Winery                White
Best Evil Wine Ever  1850    Domaine Chandon Winery         Rose


Please enter the integer corresponding to your selection:
   0. Quit
   1. Print all wines
   2. Lookup the appellation, county, climate for a wine
   3. Find restaurants that serve a wine
   4. Find clients that frequent the same restaurants as a given client
   5. Add a wine to the database
   6. Add a maker to a restaurant's menu
   7. Add a new location for a restaurant
2
Enter the wine name, exactly:
Chardonnay
Enter the vintage:
2012
Enter the maker name, exactly:
Far Niente

Appellation Name     County     Climate

Rutherford           Napa       Warm


Please enter the integer corresponding to your selection:
   0. Quit
   1. Print all wines
   2. Lookup the appellation, county, climate for a wine
   3. Find restaurants that serve a wine
   4. Find clients that frequent the same restaurants as a given client
   5. Add a wine to the database
   6. Add a maker to a restaurant's menu
   7. Add a new location for a restaurant
3
Enter the wine name, exactly:
Chardonnay
Enter the vintage:
2012
Enter the maker name, exactly:
Far Niente

Restaurant Name                Restaurant Address

French Laundry                 1003 2nd St., Napa, CA 94599
French Laundry                 6640 Washington St., Yountville, CA 94599
Mustards Grill                 7399 Saint Helena Hwy., Napa, CA 94588
LaSalette                      452 1st St. E, Sonoma, CA 95476


Please enter the integer corresponding to your selection:
   0. Quit
   1. Print all wines
   2. Lookup the appellation, county, climate for a wine
   3. Find restaurants that serve a wine
   4. Find clients that frequent the same restaurants as a given client
   5. Add a wine to the database
   6. Add a maker to a restaurant's menu
   7. Add a new location for a restaurant
4
Enter the client's name, exactly:
Brian Fiala
Enter the client's address, exactly:
1018 Robin Way, Sunnyvale, CA 94087

Client Names         Client Addresses

Marco Garcia         123 Main St., Soledad, CA 93960
John Peterson        1911 Grand Ave., Oakland, CA 94653
Chynna Rowe          1248 Burnett St., Berkeley, CA 94710
Cyrus Goh            508 California St., Mountain View, CA 94041
Alex Brandmeyer      1627 59th St., Oakland, CA 94657


Please enter the integer corresponding to your selection:
   0. Quit
   1. Print all wines
   2. Lookup the appellation, county, climate for a wine
   3. Find restaurants that serve a wine
   4. Find clients that frequent the same restaurants as a given client
   5. Add a wine to the database
   6. Add a maker to a restaurant's menu
   7. Add a new location for a restaurant
5
Enter the wine name:
Best Evil Wine Ever
Enter the vintage (later than 1850):
2050
Enter the maker's name, exactly (must be an existing maker):
Domaine Chandon Winery
Enter the color (Red, White, or Rose):
Rose
Enter the varietal:
Super GMO Grape
Enter the appellation:
Monsanto Napa
Enter the county (must be Sonoma or Napa:
Napa
Enter the climate (less than 5 characters):
Hot
Inserted 1 wine into database.


Please enter the integer corresponding to your selection:
   0. Quit
   1. Print all wines
   2. Lookup the appellation, county, climate for a wine
   3. Find restaurants that serve a wine
   4. Find clients that frequent the same restaurants as a given client
   5. Add a wine to the database
   6. Add a maker to a restaurant's menu
   7. Add a new location for a restaurant
1

Wine Name            Vintage Maker Name                     Color

Best Evil Wine Ever  2050    Domaine Chandon Winery         Rose
Cabernet Sauvignon   2012    Alpha Omega                    Red
Cabernet Sauvignon   2011    Alpha Omega                    Red
Cabernet Sauvignon   2010    Alpha Omega                    Red
Cabernet Sauvignon   2009    Alpha Omega                    Red
Cabernet Sauvignon   2008    Alpha Omega                    Red
Chardonnay           2012    Alpha Omega                    White
Chardonnay           2011    Alpha Omega                    White
Chardonnay           2010    Alpha Omega                    White
Chardonnay           2009    Alpha Omega                    White
Chardonnay           2008    Alpha Omega                    White
Sauvignon Blanc      2012    Alpha Omega                    White
Sauvignon Blanc      2011    Alpha Omega                    White
Sauvignon Blanc      2010    Alpha Omega                    White
Sauvignon Blanc      2009    Alpha Omega                    White
Sauvignon Blanc      2008    Alpha Omega                    White
Grenache             2012    Domaine Chandon Winery         White
Grenache             2011    Domaine Chandon Winery         White
Chenin Blanc         2012    Domaine Chandon Winery         White
Chenin Blanc         2011    Domaine Chandon Winery         White
Menage a Trois       2012    Domaine Chandon Winery         Red
Menage a Trois       2011    Domaine Chandon Winery         Red
Reserve Pinot Noir   2011    Domaine Chandon Winery         Red
Merlot               2012    Black Stallion                 Red
Cabernet Sauvignon   2012    Black Stallion                 Red
Sauvignon Blanc      2012    Black Stallion                 White
Syrah                2012    Black Stallion                 Red
Zinfandel            2012    Black Stallion                 Red
Muscat               2012    Black Stallion                 Red
Zinfandel            2012    Chateau Montelena              Red
Chardonnay           2012    Chateau Montelena              White
Riesling             2012    Chateau Montelena              White
Petit Sirah          2012    Chateau Montelena              Red
Cabernet Sauvignon   2012    Chateau Montelena              Red
Syrah                2012    Cornerstone Cellars            Red
Cabernet Franc       2012    Cornerstone Cellars            Red
Pinot Gris           2012    Cornerstone Cellars            White
Cabernet Sauvignon   2012    Cornerstone Cellars            Red
Riesling             2012    Cornerstone Cellars            White
Pinot Noir           2012    Etude                          Red
Chardonnay           2012    Etude                          White
Pinot Blanc          2012    Etude                          White
Malbec               2012    Etude                          Red
Chardonnay           2012    Far Niente                     White
Chardonnay           2011    Far Niente                     White
Cabernet Sauvignon   2012    Far Niente                     Red
Cabernet Sauvignon   2011    Far Niente                     Red
Malbec               2012    Arrowood Winery                Red
Merlot               2012    Arrowood Winery                Red
Syrah                2012    Arrowood Winery                Red
Cabernet Sauvignon   2012    Arrowood Winery                Red
Syrah                2012    Balletto Winery                Red
Pinot Noir           2012    Balletto Winery                Red
Chardonnay           2012    Balletto Winery                White
Zinfandel            2012    Balletto Winery                Red
Gerwurztraminer      2012    Balletto Winery                White
Best Evil Wine Ever  1850    Domaine Chandon Winery         Rose


Please enter the integer corresponding to your selection:
   0. Quit
   1. Print all wines
   2. Lookup the appellation, county, climate for a wine
   3. Find restaurants that serve a wine
   4. Find clients that frequent the same restaurants as a given client
   5. Add a wine to the database
   6. Add a maker to a restaurant's menu
   7. Add a new location for a restaurant
6
Enter the maker's name, exactly (must be an existing maker):
Domaine Chandon Winery
Enter the restaurant's address, exactly (must be an existing location):
400 1st St. E, Sonoma, CA 95476
Inserted Domaine Chandon Winery into Serves table.


Please enter the integer corresponding to your selection:
   0. Quit
   1. Print all wines
   2. Lookup the appellation, county, climate for a wine
   3. Find restaurants that serve a wine
   4. Find clients that frequent the same restaurants as a given client
   5. Add a wine to the database
   6. Add a maker to a restaurant's menu
   7. Add a new location for a restaurant
7
Enter the restaurant's name, exactly (must be an existing restaurant):
Burgers and Vine
Enter the new location's address:
1 Landfill Ave., Richmond, CA 92345
Inserted the new location for Burgers and Vine


Please enter the integer corresponding to your selection:
   0. Quit
   1. Print all wines
   2. Lookup the appellation, county, climate for a wine
   3. Find restaurants that serve a wine
   4. Find clients that frequent the same restaurants as a given client
   5. Add a wine to the database
   6. Add a maker to a restaurant's menu
   7. Add a new location for a restaurant
0
Thank you for using the Team Awesome Napa Valley wines database.
Closing the database connection and quitting.
----------------------------End Paste From Console----------------------------*/
