<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Auction Info: <%= request.getParameter("aID") %></title>
	</head>
	<body>
		<!--  need to get the auction info from db -->
		<form action="AuctionInfo.jsp">
			<input type="hidden" name="aID" value="<%= request.getParameter("aID") %>"/>
			<input type="submit" value="back">
		</form>
		
		<h1>Bid on Auction #<%= request.getParameter("aID") %></h1>
		<%
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
		
			String aID = request.getParameter("aID");
			String insert = "select max(b.price) from bids b join auction a on b.aid = a.aid where b.aid = ?;";
			PreparedStatement ps = connect.prepareStatement(insert);    
			ps.setString(1,aID);
			ResultSet results = ps.executeQuery();
			int highestBid = 0; 
			if(results.next()) {
				highestBid = results.getInt(1);			
			}
			else {
				out.println("<h4>Error: Inactive auction not found.</h4>");
			}
			double initialPrice = 0;
			double minIncrement = 0;
			insert = "SELECT a.aID, a.initPrice, a.minIncrement FROM auction a WHERE a.aID = ?;";
			ps = connect.prepareStatement(insert);    
			aID = request.getParameter("aID");
			ps.setString(1,aID);
			results = ps.executeQuery();
			if(results.next()) {
				initialPrice = results.getDouble(2);	
				minIncrement = results.getDouble(3);
			}
			ps.close();
			results.close();
		%>
		
		<h5 style="margin-bottom:4px; margin-top:0px;">Current highest bid amount:<%=highestBid%></h5>
		<h5 style="margin-bottom:4px; margin-top:0px;">Initial (lowest possible) bid amount:<%=initialPrice%></h5>
		<h5 style="margin-bottom:4px; margin-top:0px;">Minimum Price Increment: <%=minIncrement%></h5>
		
		<div>
			<h4 style="margin-bottom:4px">Create a manual bid:</h4>
			<form action="manualBidHandler.jsp" method="POST">	
				<label for="bid">Your Bid:</label>
				<input type="text" name="bid" id="bid"> <br>
				<input type="hidden" name="aID" value="<%= aID%>"/>
				<input type="submit" value="Create Manual Bid">
			</form>
		</div>	
		<div>
			<h4 style="margin-bottom:4px">Create an automatic bid:</h4>
			<form action="automaticBid.jsp" method="POST">
				<input type="hidden" name="aID" value="<%= aID %>"/>
				<label>Bid Amount:</label> 
					<input type="text" name="bidAmount" required/> <br>
				<label>Secret upper limit:</label> 
					<input type="text" name="upperLimit" /> <br>
				<label>Bid Increment:</label> 
					<input type="text" name="bidIncrement"/> <br>
				<button type="submit" value="Submit"/>Create Autobid</button>
			</form>	
		</div>
		<script></script>
	</body>
</html>
		