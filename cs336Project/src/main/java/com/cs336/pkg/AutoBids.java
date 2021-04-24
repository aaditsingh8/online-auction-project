package com.cs336.pkg;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AutoBids{
	public static void updateAutoBids(ApplicationDB db, Connection connect, String aID ) throws SQLException {
		
		System.out.println("updateautobids is running");
		
		connect = db.getConnection(); 
		
		String getAutoBids = "select * from bids b where b.bidLimit IS NOT NULL AND b.aID = ? ORDER BY b.timestamp";
		PreparedStatement autosPs = connect.prepareStatement(getAutoBids);
		autosPs.setString(1, aID);
		System.out.println(autosPs); 

		ResultSet autoBidResults = autosPs.executeQuery();
		
		String username1 = ""; 
		String username2= "";
		int upperLimit1 = 0; 
		int upperLimit2 = 0; 
		int increment1 = 0; 
		int increment2 = 0; 
						
		int currentAmt = 0;
		
		//check how many autobids there are and get their info
		// ignore autobids that are already maxed out? 
		int numAutoBids = 0; 
		while(autoBidResults.next()) {
			if (numAutoBids == 0){ 
				username1 = autoBidResults.getString("username");
				upperLimit1 = autoBidResults.getInt("bidLimit");
				increment1 = autoBidResults.getInt("maxIncrement");//max = 250 		
			} else if (numAutoBids == 1){
				username2 = autoBidResults.getString("username");
				upperLimit2 = autoBidResults.getInt("bidLimit");
				increment2 = autoBidResults.getInt("maxIncrement"); //max = 200
				currentAmt = autoBidResults.getInt("price"); 
				break; 
			}
			numAutoBids++; 
		}
		
		String update ="";

		if (numAutoBids == 1){
			//do the incrementing increment1 = 5, increment2 = 10, upperLimit = 50, upperLimit = 20
			int i = 1; 
			while (currentAmt < upperLimit1-increment2 && currentAmt < upperLimit1-increment1 && 
					currentAmt < upperLimit2-increment1 && currentAmt < upperLimit2-increment2){ // 5 15 20... user1 can still increment to 25
				if (i % 2 == 1){
					currentAmt += increment1; 
				} else{
					currentAmt += increment2;
				}
				i++; 
			}
			
			System.out.println("highest before lower limit is reached: " + currentAmt);
			update = "update bids set price = ? where username = ? and aID = ?";
			
			//determine which user outbid the other
			int lesserLimit = 0; 
			int greaterLimit = 0; 
			if (upperLimit1 < upperLimit2){
				//the second user outbids
				lesserLimit = upperLimit1; 
				greaterLimit = upperLimit2; 
				
				//update the bid value of the first user
				autosPs = connect.prepareStatement(update);
				autosPs.setInt(1, currentAmt);
				autosPs.setString(2, username1);
				autosPs.setInt(3, Integer.parseInt(aID));
				System.out.println("second user has outbid.\n firstuser bid amt: " + autosPs);
				autosPs.execute();

				//add the final increment of the second person if possible
				if (currentAmt + increment2 < upperLimit2){
					currentAmt = currentAmt + increment2; 
				}
				
				//update the bid value of the second user
				autosPs = connect.prepareStatement(update);
				autosPs.setInt(1, currentAmt);
				autosPs.setString(2, username2);
				autosPs.setInt(3, Integer.parseInt(aID));
				System.out.println("second user bid amt: " + autosPs);

				autosPs.execute();

			} else {
				//the first user outbids
				lesserLimit = upperLimit2; 	
				greaterLimit = upperLimit1; 
				
				//update the bid value of the second user
				autosPs = connect.prepareStatement(update);
				autosPs.setInt(1, currentAmt);
				autosPs.setString(2, username2);
				autosPs.setString(3, aID);
				System.out.println("first user has outbid.\n seconduser bid amt: " + autosPs);

				autosPs.execute();

				//add the final increment of the first person if possible
				if (currentAmt + increment1 < upperLimit1){
					currentAmt = currentAmt + increment1; 
				}
				
				//update the bid value of the first user
				autosPs = connect.prepareStatement(update);
				autosPs.setInt(1, currentAmt);
				autosPs.setString(2, username1);
				autosPs.setInt(3, Integer.parseInt(aID));
				System.out.println("first user bid amt: " + autosPs);
				autosPs.execute();

			}
		} else {
			//only one auto bid
			if (currentAmt + increment1 < upperLimit1) {
				currentAmt += increment1;
				autosPs = connect.prepareStatement(update);
				autosPs.setInt(1, currentAmt);
				autosPs.setString(2, username1);
				autosPs.setString(3, aID);
				autosPs.execute();

			}
		}
		autosPs.close(); 
	}
	
}