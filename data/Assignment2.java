import java.sql.*;
import java.util.List;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
import java.util.ArrayList;
//import java.util.Map;
//import java.util.HashMap;
//import java.util.Set;
//import java.util.HashSet;
public class Assignment2 extends JDBCSubmission {

//	public Connection connection;

    public Assignment2() throws ClassNotFoundException {

        Class.forName("org.postgresql.Driver");
   	
	 }

    @Override
    public boolean connectDB(String url, String username, String password) {
        // Implement this method!
    	//Connection conn;
		try {
			super.connection = DriverManager.getConnection(url, username, password);
		
		}
		catch (SQLException se) {
			System.err.println("SQL Exception." +
					 "<Message>: " + se.getMessage());
			return false;
		}

		return true;
	}

    @Override
    public boolean disconnectDB() {
        // Implement this method!
        try {
			super.connection.close();
			return true;
    	}
		catch (SQLException se) {
			System.err.println("SQL Exception." +
				"<Message>: " + se.getMessage());
			return false;
		}
	}

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
        // Implement this method!
		//just use arraylist for now
		List<Integer> elections = new ArrayList<>();
		List<Integer> cabinets = new ArrayList<>();

    	JDBCSubmission.ElectionCabinetResult result = new JDBCSubmission.ElectionCabinetResult(elections, cabinets);
		    
		
		return null;
    
	}

    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
        // Implement this method!
        return null;
    }

    public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
        System.out.println("Hello");
		PreparedStatement pStatement;
        ResultSet rs;
        String queryString;   
		String url =  "jdbc:postgresql://localhost:5432/csc343h-lewilli1";
		String name = "lewilli1";	
		String password = "";
		Assignment2 a2; 
		try {
			a2 = new Assignment2();
			System.out.println(a2.connectDB(url, name, password));
			try {
  			  //some testing
              queryString = "select* from party";
              PreparedStatement ps = a2.connection.prepareStatement(queryString);
              rs = ps.executeQuery();
              while (rs.next()) {
                  System.out.println(rs.getString("name"));
              }
          	}
          catch (SQLException se) {
                System.err.println("SQL Exception." +
                    "<Message>: " + se.getMessage());
          }		

		}
        catch (ClassNotFoundException e) {
			System.out.println("Failed to find the JDBC driver");
	 	}




	}
}

