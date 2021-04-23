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
			ps.close();
			results.close();
		%>
		<h4>Current highest bid amount:<%=highestBid%></h4>
		<br>
		<h5>Create a manual bid:</h5>
		<form action="manualBid.jsp" method="post">
	        <input type="hidden" name="aID" value="<%= aID %>"/>
	        <input type="submit" value="Manual Bid" />
		</form>
		<h5>Create an automatic bid:</h5>
		<form action="automaticBid.jsp" method="post">
	        <input type="hidden" name="aID" value="<%= aID %>"/>
	        <input type="submit" value="Automatic Bid" />
		</form>
		<script></script>
	</body>
</html>
		