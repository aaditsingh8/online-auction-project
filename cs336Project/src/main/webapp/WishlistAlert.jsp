<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Wishlist Request</title>

	</head>
	<body>
	<% 
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String username = session.getAttribute("user").toString();
			String aID = request.getParameter("aID");
			
			// CREATING AUCTION QUERY
			
			String query = "SELECT c.category, c.name, c.brand, c.material, c.color, c.size " + 
						   "FROM clothes c " +
						   "JOIN sells s USING (itemID) " +
						   "JOIN auction a USING (aID) " +
						   "WHERE aID = " + aID;
			
			PreparedStatement ps_auction = connect.prepareStatement(query);
			ResultSet a_results = ps_auction.executeQuery();
			
			if(!a_results.next()) {
				ps_auction.close();
				a_results.close();
				response.sendRedirect("AuctionInfo.jsp?aID=" + aID);
			}
			
			String[] params = {"", "", "", "", "", "", ""};
			for(int i = 1; i <= 6; i++) {
				params[i] = a_results.getString(i);
			}
			
			ps_auction.close();
			a_results.close();
			
			// CREATING WISHLIST QUERY
			
			String insert = "SELECT category, name, brand, material, color, size, username, itemNum FROM wishlist";
			
			PreparedStatement ps = connect.prepareStatement(insert);
			ResultSet results = ps.executeQuery();
			
			if(!results.next()) {
				ps.close();
				results.close();
				connect.close();
				response.sendRedirect("AuctionInfo.jsp?aID=" + aID);
			} else {
				results.previous();
				while(results.next()) {
					
					boolean flag = true;
					for(int i = 1; i <= 6; i++) {
						if(results.getString(i) != null && !results.getString(i).equalsIgnoreCase(params[i])) {
							flag = false;
							break;
						}
					}
					
					if(flag) {
						
						// FINDING ALERT NUMBER
						String alert = "SELECT username, max(alertNum) FROM alerts WHERE username = '" + results.getString(7) + "' GROUP BY username";
						
						PreparedStatement ps_alert = connect.prepareStatement(alert);
						ResultSet results_alert = ps_alert.executeQuery();
						
						int alertNum = 0;
						if(results_alert.next()) {
							alertNum = Integer.parseInt(results_alert.getString(2));
						}
						alertNum++;
						
						ps_alert.close();
						results_alert.close();
						
						// CREATING ALERT
						String temp = "INSERT INTO alerts (username, alertNum, subject, text) VALUES ('" + results.getString(7) + "', " + alertNum + ", " +
									  "'An item in your Wishlist (#" + results.getString(8) + ") is now available', " +
									  "'Auction #" + aID + " is now up for auctioning and is selling an item " +
									  "that matches an item (Item ID #" + results.getString(8) + ") on your Wishlist. " + 
									  "Click <a href=\"AuctionInfo.jsp?aID=" + aID + "\">here</a> to view auction information.')";
						
						PreparedStatement stmt = connect.prepareStatement(temp);
						stmt.executeUpdate();
						
						stmt.close();
					}
				}
			}
			
			ps.close();
			results.close();
			connect.close();
			response.sendRedirect("AuctionInfo.jsp?aID=" + aID);
			
		} catch (Exception e){
			
			out.println(e);
			
		}
	%>			
	</body>
</html>