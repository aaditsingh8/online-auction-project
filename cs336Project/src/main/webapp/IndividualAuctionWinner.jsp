<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import = "java.util.Date,java.text.SimpleDateFormat,java.text.ParseException"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Winner!</title>
	</head>
	<body>
		<%
			float minPrice;
			float highest_bid;
			PreparedStatement alertPs = null;
			//int alertNum;
			boolean isActive = false;
			
			ApplicationDB database = new ApplicationDB();
			Connection conn = database.getConnection();
			
			String insert = "SELECT a.aID, a.closeDateTime, a.minPrice, a.isActive, a.username, c.itemID FROM auction a JOIN sells s USING (aID) JOIN clothes c USING (itemID) WHERE a.aID = ?;";
			PreparedStatement ps = conn.prepareStatement(insert);
			String aID = request.getParameter("aID");
			ps.setString(1,aID);
			
			String bid = "SELECT t.aID aID, t.username username, t.price price " +
					"FROM bids t " +
					"WHERE t.price = (SELECT max(t2.price) " +
					                                   "FROM bids t2 " +
					                                   "WHERE t2.aID = t.aID " +
					                                   "GROUP BY t2.aID) " +
					"AND aID=" + aID;
			PreparedStatement ps1 = conn.prepareStatement(bid);
			
			
			ResultSet results = ps.executeQuery();
			ResultSet bidresults = ps1.executeQuery();
			results.next();
			
			isActive = results.getBoolean(4);
			
			if (!isActive) {
				ps.close();
				results.close();
				
				response.sendRedirect("AuctionInfo.jsp?aID=" + aID + "&closed=true");
				return;
				}
			
			results.previous();
			
			if(results.next()) {
				String closeDateTime = results.getString(2);
				minPrice = results.getFloat(3);
				//System.out.println("table close:" + closeDateTime);
				
				java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				
				java.util.Date date = sdf.parse(closeDateTime);
				Timestamp closeDate = new Timestamp(date.getTime());
				
				String seller = results.getString(5);
				
				String highest_bidder = "";
				if (bidresults.next()) {
					highest_bidder = bidresults.getString(2);
					highest_bid = bidresults.getFloat(3);
				}
				else {
					highest_bidder = null;
					highest_bid = 0.0f;
				}
				
				
				if (closeDate.before(new Timestamp((new java.util.Date()).getTime()))) {
					//Timestamp now = new Timestamp((new java.util.Date()).getTime()); check
					//System.out.println("works");
					//System.out.println("now:" + now);
					//System.out.println("close:" + closeDate);
					//String alertNum = aID;
					
					
					PreparedStatement pr=conn.prepareStatement("UPDATE auction SET isActive=0 WHERE aID=" + aID);
					pr.executeUpdate();
					
					if (highest_bidder == null){
						
						// FINDING ALERT NUMBER
						String alert = "SELECT username, max(alertNum) FROM alerts WHERE username = '" + seller + "' GROUP BY username";
						
						PreparedStatement ps_alert = conn.prepareStatement(alert);
						ResultSet results_alert = ps_alert.executeQuery();
						
						int alertNum = 0;
						if(results_alert.next()) {
							alertNum = Integer.parseInt(results_alert.getString(2));
						}
						alertNum++;
						
						ps_alert.close();
						results_alert.close();
						
						// CREATING ALERT
						String temp = "INSERT INTO alerts (username, alertNum, subject, text) VALUES ('" + seller + "', " + alertNum + ", " +
									  "'Your Auction (aID #" + aID + ") has closed.', " +
									  "'Auction #" + aID + " is now closed. There is no winner because there were no bids. " + 
									  "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')";
						
						PreparedStatement stmt = conn.prepareStatement(temp);
						stmt.executeUpdate();
						
						stmt.close();
						
						ps.close();
						results.close();
						
						
						response.sendRedirect("AuctionInfo.jsp?aID=" + aID + "&closed=true"); //no winner 
					} else if (highest_bid < minPrice ){
						//alert
						// FINDING ALERT NUMBER
						String alert = "SELECT username, max(alertNum) FROM alerts WHERE username = '" + seller + "' GROUP BY username";
						
						PreparedStatement ps_alert = conn.prepareStatement(alert);
						ResultSet results_alert = ps_alert.executeQuery();
						
						int alertNum = 0;
						if(results_alert.next()) {
							alertNum = Integer.parseInt(results_alert.getString(2));
						}
						alertNum++;
						
						ps_alert.close();
						results_alert.close();
						
						// CREATING ALERT
						String temp = "INSERT INTO alerts (username, alertNum, subject, text) VALUES ('" + seller + "', " + alertNum + ", " +
									  "'Your Auction (aID #" + aID + ") has closed.', " +
									  "'Auction #" + aID + " is now closed. There is no winner because nobody bid higher than your secret minimum price. " + 
									  "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')";
						
						PreparedStatement stmt = conn.prepareStatement(temp);
						stmt.executeUpdate();
						
						stmt.close();
						
						ps.close();
						results.close();
						
						
						response.sendRedirect("AuctionInfo.jsp?aID=" + aID + "&closed=true"); //no winner 
					} else {
						String win = "INSERT INTO bought (itemID, username, price) VALUES (" + results.getString(6) + ", " + highest_bidder + ", " + highest_bid + ")";
						//System.out.println("winner");
						PreparedStatement psWin = conn.prepareStatement(win);
						psWin.executeUpdate();
						//response.sendRedirect("AuctionInfo.jsp?aID=" + aID); //winner 
						
						//SELLER ALERT
						// FINDING ALERT NUMBER
						String alert = "SELECT username, max(alertNum) FROM alerts WHERE username = '" + seller + "' GROUP BY username";
						
						PreparedStatement ps_alert = conn.prepareStatement(alert);
						ResultSet results_alert = ps_alert.executeQuery();
						
						int alertNum = 0;
						if(results_alert.next()) {
							alertNum = Integer.parseInt(results_alert.getString(2));
						}
						alertNum++;
						
						ps_alert.close();
						results_alert.close();
						
						// CREATING ALERT
						String temp = "INSERT INTO alerts (username, alertNum, subject, text) VALUES ('" + seller + "', " + alertNum + ", " +
									  "'Your Auction (aID #" + aID + ") has closed.', " + //subject
									  "'Auction #" + aID + " is now closed. The winner is "+ highest_bidder + ", and selling price is " + highest_bid + ". " +  
									  "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')"; 
						
						PreparedStatement stmt = conn.prepareStatement(temp);
						stmt.executeUpdate();
						
						stmt.close();
						
						//WINNER ALERT
						// FINDING ALERT NUMBER
						String alertwin = "SELECT username, max(alertNum) FROM alerts WHERE username = '" + highest_bidder + "' GROUP BY username";
						
						PreparedStatement ps_alertwin = conn.prepareStatement(alertwin);
						ResultSet results_alertwin = ps_alertwin.executeQuery();
						
						int alertNumwin = 0;
						if(results_alertwin.next()) {
							alertNumwin = Integer.parseInt(results_alertwin.getString(2));
						}
						alertNumwin++;
						
						ps_alertwin.close();
						results_alertwin.close();
						
						// CREATING ALERT
						String tempwin = "INSERT INTO alerts (username, alertNum, subject, text) VALUES ('" + highest_bidder + "', " + alertNum + ", " +
									  "'You have won the auction (aID #" + aID + ").', " + //subject
									  "'Auction #" + aID + " is now closed. You are the winner, for a selling price of " + highest_bid + ". " +  
									  "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')"; 
						
						PreparedStatement stmtwin = conn.prepareStatement(tempwin);
						stmtwin.executeUpdate();
						
						stmtwin.close();
						
						ps.close();
						results.close();
						
						response.sendRedirect("AuctionInfo.jsp?aID=" + aID + "&closed=true"); //winner 
					}
				} else {
					ps.close();
					results.close();
					
					response.sendRedirect("BidOnAuction.jsp?aID=" + aID);
					return;
					
				}
				
			}
			else {
				ps.close();
				results.close();
				
				response.sendRedirect("BidOnAuction.jsp?aID=" + aID);
				return;
			}
			
			
			ps.close();
			results.close();
			
			
			
		
			
		%>
		<div>
			<form>	
				
			</form>
		</div>
	</body>
</html>