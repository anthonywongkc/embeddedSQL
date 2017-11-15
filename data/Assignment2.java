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
	 	String queryString0, queryString1, queryString2, queryString3,queryString4,queryString5;
		PreparedStatement pStatement;		    
		ResultSet rs;
		//just use arraylist for now
		List<Integer> elections = new ArrayList<>();
		List<Integer> cabinets = new ArrayList<>();

    	JDBCSubmission.ElectionCabinetResult result = new JDBCSubmission.ElectionCabinetResult(elections, cabinets);
		queryString0 = "DROP VIEW IF EXISTS all_elections CASCADE;"+
						"DROP VIEW IF EXISTS all_cabinets CASCADE;"+
						"DROP VIEW IF EXISTS p_elections CASCADE;"+
						"DROP VIEW IF EXISTS e_elections CASCADE;";
		queryString1 = "Create View all_elections as (" +
						"SELECT c.name as countryName, c.id as countryId, e.id as electionId, e_date as electionDate," +
						"e.e_type as eType, e.previous_parliament_election_id, e.previous_ep_election_id" +  
						"FROM election e, country c" +
						"WHERE e.country_id = c.id and c.name = ?);";
		queryString2 = "Create View all_cabinets as (" +
						"SELECT c2.name as countryName, c2.id as countryId, c1.start_date as startDate," +
						" c1.previous_cabinet_id, c1.election_id, c1.id as cabinetId" +
						"FROM cabinet c1, country c2" +
						"WHERE c1.country_id = c2.id" +
						"ORDER BY startDate desc);";
		queryString3 = "Create view p_elections as (" +
						"SELECT ae1.countryName, ae1.countryId, ae1.electionId,  ae1.electionDate, ae1.eType,"+
						" ae2.previous_parliament_election_id as previousId, ae2.eType as nextType, ae2.electionDate as nextDate"+  
						"FROM all_elections ae1 left join all_elections ae2 on ae2.previous_parliament_election_id = ae1.electionId and ae2.eType = ae1.eType"+
						"WHERE ae1.eType = 'Parliamentary election');";
		queryString4 = "Create view e_elections as (" +
						"SELECT ae1.countryName, ae1.countryId, ae1.electionId,  ae1.electionDate, ae1.eType,"+ 
						"ae2.previous_ep_election_id as previousId, ae2.eType as nexttype, ae2.electionDate  as nextdate"+
						"FROM all_elections ae1 left join all_elections ae2 on ae2.previous_ep_election_id = ae1.electionId and ae2.eType = ae1.eType"+
						"WHERE ae1.eType = 'European Parliament');"; 
		queryString5 = "Select * FROM" +
						"("+	

						"(SELECT a.countryName, a.electionId, a.eType, a.electionDate, a.nextDate, a.previousId, ap.cabinetId, ap.startDate"+
						"FROM"+
						"(Select *" + 
						"from p_elections"+
						"Where nextDate is not null)a  left join all_cabinets ap on a.countryName = ap.countryName and ap.startDate >= a.electionDate and  a.nextDate > ap.startDate)"+

						"union"+
						"(SELECT a.countryName, a.electionId, a.eType, a.electionDate, a.nextDate, a.previousId, ap.cabinetId, ap.startDate"+
						"FROM"+
						"(Select *"+
						"from p_elections"+
						"Where nextDate is null)a left join all_cabinets ap on a.countryName = ap.countryName and ap.startDate >= a.electionDate )"+
	
						"union"+

						"SELECT a.countryName, a.electionId, a.eType, a.electionDate, a.nextDate, a.previousId, ap.cabinetId, ap.startDate"+
						"FROM"+
						"(Select *"+
						"from e_elections"+
						"where nextDate is null)a left join all_cabinets ap on a.countryName = ap.countryName and ap.startDate >= a.electionDate"+ 

						"union" +

						"SELECT a.countryName, a.electionId, a.eType, a.electionDate, a.nextDate, a.previousId, ap.cabinetId, ap.startDate"+
						"FROM"+
						"(Select *"+
						"from e_elections"+
						"where nextDate is not null)a left join all_cabinets ap on a.countryName = ap.countryName and ap.startDate >= a.electionDate and  a.nextDate > ap.startDate"+

						")result";
 		
		try {
			PreparedStatement ps = super.connection.prepareStatement(queryString0 + queryString1+queryString2+queryString3+queryString4+queryString5);	
			ps.setString(1, countryName);
 			rs = ps.executeQuery();
		
		
			//get back stuff from execution	
			 while (rs.next()) {
				int election_id = rs.getInt("electionId");
				int cabinet_id = rs.getInt("cabinetid"); //do i have to check for null?
				result.elections.add(election_id);
				result.cabinets.add(cabinet_id);
			 }

    	}
		catch (SQLException se) {
			//do something here
		}
		return result;
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

