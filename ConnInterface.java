/* ----------------------------------------------------------------------------
 * Class ConnInterface: provides methods for establishing a database connection,
 * querying and updating the database, and closing the connection.
 */

import java.sql.*; 
import java.util.Scanner;

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