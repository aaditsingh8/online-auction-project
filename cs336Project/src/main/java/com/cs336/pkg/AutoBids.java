package com.cs336.pkg;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.*;

public class AutoBids{
	public static void updateAutoBids(ApplicationDB db, Connection connect, String aID, double highestBid, Boolean newAutoBid ) throws SQLException {
				
		connect = db.getConnection(); 
		
		String getAutoBids = "select * from bids b where b.bidLimit IS NOT NULL AND b.aID = ? ORDER BY b.timestamp";
		PreparedStatement autosPs = connect.prepareStatement(getAutoBids);
		autosPs.setString(1, aID);

		ResultSet autoBidResults = autosPs.executeQuery();
		
		String username1 = ""; 
		String username2= "";
		double upperLimit1 = 0; 
		double upperLimit2 = 0; 
		double increment1 = 0; 
		double increment2 = 0; 
		
		double currentAmt = 0;
		double currentAmtNoAuto = 0;
		//check how many autobids there are and get their info
		// ignore autobids that are already maxed out? 
		double numAutoBids = 0;  
		boolean l1AtLimit = false; 
				
		if(autoBidResults.last()) {
			username2 = autoBidResults.getString("username");
			upperLimit2 = autoBidResults.getInt("bidLimit");
			increment2 = autoBidResults.getInt("maxIncrement"); //max = 200
			currentAmt = autoBidResults.getInt("price");
			System.out.println("last:"+  username2 + " " + currentAmt);
			//if the second autobid is at its upper limit, don't update it
			if (currentAmt > upperLimit2 - increment2) {
				//don't update
				l1AtLimit = true;
			} else {
				numAutoBids++;
			}
		}
		if (autoBidResults.previous()) {
			username1 = autoBidResults.getString("username");
			upperLimit1 = autoBidResults.getInt("bidLimit");
			increment1 = autoBidResults.getInt("maxIncrement");//max = 250 	
			currentAmt = autoBidResults.getInt("price");
			System.out.println("2nd to last:"+  username1 + " " + currentAmt);
			//if the 2nd to last autobid is at its upper limit, don't update it
			if (currentAmt > upperLimit1 - increment1) {
				//don't update
			} else {
				numAutoBids++; 
			}
		}
		
		String update ="";
		update = "update bids set price = ? WHERE timestamp = (SELECT max(timestamp) FROM bids WHERE aID = ? and username = ?) AND bidLimit IS NOT NULL";
		
		String alert = "SELECT username, max(alertNum) FROM alerts WHERE username = ? GROUP BY username";
		PreparedStatement ps_alert = connect.prepareStatement(alert);
		ResultSet results_alert;
		
		if (username1.equalsIgnoreCase(username2) && newAutoBid == true) {
			System.out.println("same user");
			//if user updates their autobid
			if (upperLimit2 > upperLimit1 ) {
				autosPs = connect.prepareStatement(update);
				autosPs.setDouble(1, upperLimit1);
				autosPs.setString(2, username1);
				autosPs.setInt(3, Integer.parseInt(aID));
				System.out.println("user has updated their autobid");
				autosPs.execute();
				return;
			} 
		}
		
		if (newAutoBid == false) {
			if (highestBid >= upperLimit2) {
				//max out the bidder's price
				System.out.println(upperLimit2 + " " + username2);
				autosPs = connect.prepareStatement(update);
				autosPs.setDouble(1, upperLimit2);
				autosPs.setString(2, username2);
				autosPs.setString(3, aID);
				autosPs.execute();	
				
				System.out.println("sending alert to last autobidder after manual bid");
				ps_alert = connect.prepareStatement(alert);
				ps_alert.setString(1, username2);
				results_alert = ps_alert.executeQuery();
				
				double alertNum = 0;
				if(results_alert.next()) {
					alertNum = Integer.parseInt(results_alert.getString(2));
				}
				alertNum++;
				
				ps_alert.close();
				results_alert.close();
				
				// CREATING ALERT
				String temp = "INSERT INTO alerts (username, alertNum, subject, text) VALUES (?, ?, 'A user has bidded higher than your upperlimit', "
						+ "'Check Auction #" + aID + "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')";
				PreparedStatement stmt = connect.prepareStatement(temp);
				stmt.setString(1, username2);
				stmt.setDouble(2, alertNum);
				stmt.executeUpdate();				
				stmt.close();
			}
		}
		
		if (numAutoBids == 2){
			//do the incrementing increment1 = 5, increment2 = 10, upperLimit = 50, upperLimit = 20
			int i = 1; 
			while (true){ // 5 15 20... user1 can still increment to 25
				if (i % 2 == 1){
					if (currentAmt <= upperLimit1-increment1) {
						currentAmt += increment1; 
					} else {
						break;
					}
				} else{
					if (currentAmt <= upperLimit2-increment2) {
						currentAmt += increment2; 
					} else {
						break;
					}
				}
				i++; 
			}
						
			//determine which user outbid the other
			double lesserLimit = 0; 
			double greaterLimit = 0; 
			
			if (upperLimit1 < upperLimit2){
				//the second user outbids
				lesserLimit = upperLimit1; 
				greaterLimit = upperLimit2; 
				
				//update the bid value of the first user
				autosPs = connect.prepareStatement(update);
				autosPs.setDouble(1, currentAmt);
				autosPs.setString(2, username1);
				autosPs.setInt(3, Integer.parseInt(aID));
				System.out.println("second user has outbid.\n firstuser bid amt: " + autosPs);
				autosPs.execute();

				//add the final increment of the second person if possible
				if (currentAmt + increment2 <= upperLimit2){
					currentAmt = currentAmt + increment2; 
				}
				
				//update the bid value of the second user
				autosPs = connect.prepareStatement(update);
				autosPs.setDouble(1, currentAmt);
				autosPs.setString(2, username2);
				autosPs.setInt(3, Integer.parseInt(aID));
				autosPs.execute();
				
				
				//send alert to first user
				ps_alert.setString(1, username1);
				results_alert = ps_alert.executeQuery();
				double alertNum = 0;
				if(results_alert.next()) {
					alertNum = Integer.parseInt(results_alert.getString(2));
				}
				alertNum++;
				
				ps_alert.close();
				results_alert.close();
				
				// CREATING ALERT
				String temp = "INSERT INTO alerts (username, alertNum, subject, text) VALUES (?, ?, 'A user has bidded higher than your upperlimit', "
						+ "'Check Auction #" + aID + "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')";
				PreparedStatement stmt = connect.prepareStatement(temp);
				stmt.setString(1, username1);
				stmt.setDouble(2, alertNum);
				stmt.executeUpdate();				
				stmt.close();

			} else {
				//the first user outbids
				lesserLimit = upperLimit2; 	
				greaterLimit = upperLimit1; 
				
				//update the bid value of the second user
				autosPs = connect.prepareStatement(update);
				autosPs.setDouble(1, currentAmt);
				autosPs.setString(2, username2);
				autosPs.setString(3, aID);
				System.out.println("first user has outbid.\n seconduser bid amt: " + autosPs);

				autosPs.execute();

				//add the final increment of the first person if possible
				if (currentAmt + increment1 <= upperLimit1){
					currentAmt = currentAmt + increment1; 
				}
				
				//update the bid value of the first user
				autosPs = connect.prepareStatement(update);
				autosPs.setDouble(1, currentAmt);
				autosPs.setString(2, username1);
				autosPs.setInt(3, Integer.parseInt(aID));
				System.out.println("first user bid amt: " + autosPs);
				autosPs.execute();
				
				//send alert to second user			
				ps_alert = connect.prepareStatement(alert);
				ps_alert.setString(1, username2);
				results_alert = ps_alert.executeQuery();
				
				double alertNum = 0;
				if(results_alert.next()) {
					alertNum = Integer.parseInt(results_alert.getString(2));
				}
				alertNum++;
				
				ps_alert.close();
				results_alert.close();
				
				// CREATING ALERT
				String temp = "INSERT INTO alerts (username, alertNum, subject, text) VALUES (?, ?, 'A user has bidded higher than your upperlimit', "
						+ "'Check Auction #" + aID + "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')";
				PreparedStatement stmt = connect.prepareStatement(temp);
				stmt.setString(1, username2);
				stmt.setDouble(2, alertNum);
				stmt.executeUpdate();				
				stmt.close();
			}
		} else if (numAutoBids == 1){
			//only one auto bid
			if (newAutoBid == true) {
				System.out.println("new auto bid returning true");
				return;
			}

			//l1 = upperLimit2
			if (l1AtLimit == true) {
				System.out.println("updating second to last");

				//update L2 
				if (highestBid + increment1 <= upperLimit1) {
					highestBid += increment1;
					autosPs = connect.prepareStatement(update);
					autosPs.setDouble(1, highestBid);
					autosPs.setString(2, username1);
					autosPs.setString(3, aID);
					autosPs.execute();
				}
				
				//send alert that manual bid is higher than limit
//				if (highestBid >= upperLimit1) {
//					ps_alert = connect.prepareStatement(alert);
//					ps_alert.setString(1, username1);
//					results_alert = ps_alert.executeQuery();
//					
//					double alertNum = 0;
//					if(results_alert.next()) {
//						alertNum = Integer.parseInt(results_alert.getString(2));
//					}
//					alertNum++;
//					
//					ps_alert.close();
//					results_alert.close();
//					
//					// CREATING ALERT
//					String temp = "INSERT INTO alerts (username, alertNum, subject, text) VALUES (?, ?, 'A user has bidded higher than your upperlimit', "
//							+ "'Check Auction #" + aID + "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')";
//					PreparedStatement stmt = connect.prepareStatement(temp);
//					stmt.setString(1, username1);
//					stmt.setDouble(2, alertNum);
//					stmt.executeUpdate();				
//					stmt.close();
//				}

			} else {
				//update L1 
				System.out.println("updating last");

				if (highestBid + increment2 <= upperLimit2) {
					highestBid += increment2;
					autosPs = connect.prepareStatement(update);
					autosPs.setDouble(1, highestBid);
					autosPs.setString(2, username2);
					autosPs.setString(3, aID);
					autosPs.execute();		
				}
				
//				if (highestBid >= upperLimit2) {
//					ps_alert = connect.prepareStatement(alert);
//					ps_alert.setString(1, username2);
//					results_alert = ps_alert.executeQuery();
//					
//					double alertNum = 0;
//					if(results_alert.next()) {
//						alertNum = Integer.parseInt(results_alert.getString(2));
//					}
//					alertNum++;
//					
//					ps_alert.close();
//					results_alert.close();
//					
//					// CREATING ALERT
//					String temp = "INSERT INTO alerts (username, alertNum, subject, text) VALUES (?, ?, 'A user has bidded higher than your upperlimit', "
//							+ "'Check Auction #" + aID + "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')";
//					PreparedStatement stmt = connect.prepareStatement(temp);
//					stmt.setString(1, username2);
//					stmt.setDouble(2, alertNum);
//					stmt.executeUpdate();				
//					stmt.close();
//				}
			}
		}
		autosPs.close(); 		
		
		//when someone's upper limit is greater than yours
		//when manual bid is greater than your upper limit
	}
}