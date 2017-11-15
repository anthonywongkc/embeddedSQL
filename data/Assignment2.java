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
		String queryString;
		queryString = "SET SEARCH_PATH to parlgov;";
		try {
			super.connection = DriverManager.getConnection(url, username, password);
			PreparedStatement ps = super.connection.prepareStatement(queryString);
			ps.executeUpdate();
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

	 	String queryString0, queryString1, queryString2, queryString3,queryString4,queryString5, queryString6;



		ResultSet rs;
		
		List<Integer> elections = new ArrayList<>();
		List<Integer> cabinets = new ArrayList<>();

		JDBCSubmission.ElectionCabinetResult result = new JDBCSubmission.ElectionCabinetResult(elections, cabinets);
		
		queryString0 = "DROP VIEW IF EXISTS all_elections CASCADE;\n"+
						"DROP VIEW IF EXISTS all_cabinets CASCADE;\n"+
						"DROP VIEW IF EXISTS p_elections CASCADE;\n"+
						"DROP VIEW IF EXISTS e_elections CASCADE;\n"+
						"DROP VIEW IF EXISTS answer CASCADE;\n";

		queryString1 = "Create View all_elections as (\n" +
		"SELECT c.name as countryName, c.id as countryId, e.id as electionId, e_date as electionDate,\n" +
		"e.e_type as eType, e.previous_parliament_election_id, e.previous_ep_election_id\n" +  
		"FROM election e, country c\n" +
		"WHERE e.country_id = c.id);\n";
		queryString2 = "Create View all_cabinets as (\n" +
		"SELECT c2.name as countryName, c2.id as countryId, c1.start_date as startDate,\n" +
		" c1.previous_cabinet_id, c1.election_id, c1.id as cabinetId\n" +
		"FROM cabinet c1, country c2\n" +
		"WHERE c1.country_id = c2.id\n" +
		"ORDER BY startDate desc);\n";
		queryString3 = "Create view p_elections as (\n" +
						"SELECT DISTINCT ON ( r.electionId) r.electionid, r.countryName, r.countryId, r.electionDate, r.eType, r.previousid, r.nextType, r.nextDate\n"+
						"FROM\n" + 
						"(Select ae1.countryName, ae1.countryId, ae1.electionId,  ae1.electionDate, ae1.eType, ae2.previous_parliament_election_id as previousId, "+
						" ae2.eType as nextType, ae2.electionDate as nextDate\n" +
						"from  all_elections ae1 left join  all_elections ae2\n" + 
						"on ae2.electionDate > ae1.electionDate and ae1.countryName =  ae2.countryName and ae1.eType = ae2.eType\n"+
						 "WHERE ae1.eType = 'Parliamentary election')r\n"+
						"ORDER by r.electionId, r.nextDate asc);"; 

		queryString4 = "Create view e_elections as (\n" +
						"SELECT DISTINCT ON ( r.electionId) r.electionid, r.countryName, r.countryId, r.electionDate, r.eType, r.previousid, r.nextType, r.nextDate\n"+
						"FROM\n" + 
						"(Select ae1.countryName, ae1.countryId, ae1.electionId, ae1.electionDate, ae1.eType, ae2.previous_ep_election_id as previousId,"+
						" ae2.eType as nextType, ae2.electionDate as nextDate\n" +
						"from  all_elections ae1 left join  all_elections ae2\n" + 
						"on ae2.electionDate > ae1.electionDate and ae1.countryName =  ae2.countryName and ae1.eType = ae2.eType\n" + 
						"WHERE ae1.eType = 'European Parliament')r" + 
						" ORDER by r.electionId, r.nextDate asc);";
 
	
		queryString5 = "Create view answer as (Select * FROM\n" +
						"(\n"+	

						"(SELECT a.countryName, a.electionId, a.eType, a.electionDate, a.nextDate, a.previousId, ap.cabinetId, ap.startDate\n"+
						"FROM\n"+
						"(Select *\n" + 
						"from p_elections\n"+
						"Where nextDate is not null)a  left join all_cabinets ap on a.countryName = ap.countryName and ap.startDate >= a.electionDate and  a.nextDate > ap.startDate)\n"+

						"union\n"+
						"(SELECT a.countryName, a.electionId, a.eType, a.electionDate, a.nextDate, a.previousId, ap.cabinetId, ap.startDate\n"+
						"FROM\n"+
						"(Select *\n"+
						"from p_elections\n"+
						"Where nextDate is null)a left join all_cabinets ap on a.countryName = ap.countryName and ap.startDate >= a.electionDate )\n"+
	
						"union\n"+

						"SELECT a.countryName, a.electionId, a.eType, a.electionDate, a.nextDate, a.previousId, ap.cabinetId, ap.startDate\n"+
						"FROM\n"+
						"(Select *\n"+
						"from e_elections\n"+
						"where nextDate is null)a left join all_cabinets ap on a.countryName = ap.countryName and ap.startDate >= a.electionDate\n"+ 

						"union\n" +

						"SELECT a.countryName, a.electionId, a.eType, a.electionDate, a.nextDate, a.previousId, ap.cabinetId, ap.startDate\n"+
						"FROM\n"+
						"(Select *\n"+
						"from e_elections\n"+
						"where nextDate is not null)a left join all_cabinets ap on a.countryName = ap.countryName and ap.startDate >= a.electionDate and  a.nextDate > ap.startDate\n"+

						")result  Order By result.electionDate desc);";
			 queryString6 = "select * from ((select * from answer) except (select * from answer where cabinetId is null))b WHERE countryName = ? ORDER BY electionDate desc ;";



//		queryString6 = queryString0+queryString1+queryString2+queryString3+queryString4+queryString5;
//		System.out.println(queryString6);
		try {

			PreparedStatement ps0 = super.connection.prepareStatement(queryString0);	
			ps0.executeUpdate();
			PreparedStatement ps1 = super.connection.prepareStatement(queryString1);		
			ps1.executeUpdate();
			PreparedStatement ps2 = super.connection.prepareStatement(queryString2); 

 			ps2.executeUpdate();

			PreparedStatement ps3 = super.connection.prepareStatement(queryString3); 
			ps3.executeUpdate();
			PreparedStatement ps4 = super.connection.prepareStatement(queryString4); 
			ps4.executeUpdate();
			PreparedStatement ps5 = super.connection.prepareStatement(queryString5); 

			ps5.executeUpdate();

			PreparedStatement ps6 = super.connection.prepareStatement(queryString6);
  			ps6.setString(1, String.valueOf(countryName));
			rs = ps6.executeQuery();


			//get back stuff from execution	
			while (rs.next()) {
				//System.out.println("got inside");
				//int election_id = rs.getInt("electionId");
				//int cabinet_id = rs.getInt("cabinetid"); //do i have to check for null?
//				System.out.println(" election id: "+ election_id + " cabinet id: " + cabinet_id);

				//System.out.println(rs.getObject(7));
				result.elections.add((Integer)rs.getObject(2));
				result.cabinets.add((Integer)rs.getObject(7));
			}

		}
		catch (SQLException se) {
			//do something here
			System.err.println("SQL Exception." +
				"<Message>: " + se.getMessage());
		}
		System.out.println(result.toString());
		System.out.println("length "+ result.elections.size() + "\n");
		System.out.println("length "+ result.cabinets.size() + "\n");

		
		return result;
	}

	@Override
	public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
	// Implement this method!
		String queryString0, queryString1;
		ResultSet rs0, rs1;

		List<Integer> presidents = new ArrayList<>();
		try {
			queryString0 = 
				"select id, description, comment " + 
				"from politician_president " + 
				"where id = " + Integer.toString(politicianName);
			PreparedStatement ps0 = super.connection.prepareStatement(queryString0);
			rs0 = ps0.executeQuery();

			String info0 = "";
			while (rs0.next()) {
				info0 = rs0.getString("description") + ", " + rs0.getString("comment");
			}

			queryString1 = 
				"select id, description, comment " + 
				"from politician_president " + 
				"where id != " + Integer.toString(politicianName);
			PreparedStatement ps1 = super.connection.prepareStatement(queryString1);
			rs1 = ps1.executeQuery();
            // Iterate through the result set and report on each tuple.
			while (rs1.next()) {
				String info1 = rs1.getString("description") + ", " + rs1.getString("comment");
				double percentage = similarity(info0, info1);
				if ((float)percentage > threshold) {
					presidents.add(Integer.parseInt(rs1.getString("id")));
					// System.out.println(rs1.getString("id"));
				}
			}

		} catch (SQLException se) {
			System.err.println("SQL Exception." +
				"<Message>: " + se.getMessage());
		}
		return presidents;
	}

	public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
		System.out.println("Hello");
		PreparedStatement pStatement;
		ResultSet rs;
		String queryString;   
		String url =  "jdbc:postgresql://localhost:5432/csc343h-wongka95";
		String name = "wongka95";	
		String password = "";
		Assignment2 a2; 
		try {
			a2 = new Assignment2();
			System.out.println(a2.connectDB(url, name, password));
//			try {
  			  //some testing
            a2.electionSequence("Canada");  
            	// a2.electionSequence("Japan");
			float similar = 0;
			a2.findSimilarPoliticians(9,similar);
		

			// queryString = "select* from party";
              //PreparedStatement ps = a2.connection.prepareStatement(queryString);
              //rs = ps.executeQuery();
             // while (rs.next()) {
              //    System.out.println(rs.getString("name"));
             // }
  //        	}
    //      	catch (SQLException se) {
      //          System.err.println("SQL Exception." +
        //            "<Message>: " + se.getMessage());
          //	}		

		}
		catch (ClassNotFoundException e) {
			System.out.println("Failed to find the JDBC driver");
		}




	}
}

