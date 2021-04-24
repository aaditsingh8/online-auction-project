<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Automatic Bid for Auction: <%= request.getParameter("aID") %></title>
	</head>
	<body>
		<h1>Create an automatic bid</h1>
		<%
			String bidAmount = request.getParameter("bidAmount");
			//String user = (String)session.getAttribute("user");
			String upperLimit = request.getParameter("upperLimit");
			String bidIncrement = request.getParameter("bidIncrement");
			
			int highestBid=0; 
			int initialPrice=0;
			//cannot bid less than current bid price
			//cannot bid less than initial price
			ApplicationDB db = new ApplicationDB();
			Connection connect = db.getConnection();
			String insert = "SELECT a.aID, a.initPrice FROM auction a WHERE a.aID = ?;";
			PreparedStatement ps = connect.prepareStatement(insert);    
			String aID = request.getParameter("aID");
			ps.setString(1,aID);
			ResultSet results = ps.executeQuery();
			if(results.next()) {
				initialPrice = results.getInt(2);			
			}
			else {
				out.println("<h4>Error: Inactive auction not found.</h4>");
			}
			insert = "select max(b.price) from bids b join auction a on b.aid = a.aid where b.aid = ?;";
			ps = connect.prepareStatement(insert);
			ps.setString(1,aID);
			results = ps.executeQuery(); 
			if(results.next()) {
				highestBid = results.getInt(1);			
			}
			else {
				out.println("<h4>Error: Inactive auction not found.</h4>");
			}
			
			if ((Double.parseDouble(bidAmount) <= highestBid)) { %> 
				<p>Please enter a bid higher than <%=highestBid%></p>
				<form action="BidOnAuction.jsp">
					<input type="hidden" name="aID" value="<%= aID%>"/>
					<input type="submit" value="Re-enter values">
				</form>				
			<%	} else if ((Double.parseDouble(bidAmount) < initialPrice)) { %>
				<p>Please enter a bid higher than <%=initialPrice%></p>
				<form action="BidOnAuction.jsp">
					<input type="hidden" name="aID" value="<%= aID%>"/>
					<input type="submit" value="Re-enter values">
				</form>
				
			<%	} else {
				String insertBid = "INSERT INTO Bids (aID, username, price, timestamp, bidLimit, maxIncrement) VALUES (?, ?, ?, ?, ?, ?)";
				PreparedStatement bidPs = connect.prepareStatement(insertBid);
				bidPs.setString(1, aID);
				bidPs.setString(2, (String)session.getAttribute("user"));
				bidPs.setInt(3, Integer.parseInt(bidAmount));
				bidPs.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
				bidPs.setInt(5, Integer.parseInt(upperLimit));
				bidPs.setInt(6, Integer.parseInt(bidIncrement));
				bidPs.execute();
				
				bidPs.close();
				
				//update the autobids
				AutoBids.updateAutoBids(db, connect, aID);
				
				//update the highest bid
				insert = "select max(b.price) from bids b join auction a on b.aid = a.aid where b.aid = ?;";
				ps = connect.prepareStatement(insert);    
				ps.setString(1,aID);
				results = ps.executeQuery();
				if(results.next()) {
					highestBid = results.getInt(1);			
				}
				else {
					out.println("<h4>Error: Inactive auction not found.</h4>");
				}
				ps.close();
				results.close();%>
				
				<h5>Automatic bid successful!</h5>
				
				<h5>Current highest bid amount: <%=highestBid%></h5>
			<% } %>

	</body>
	
</html>