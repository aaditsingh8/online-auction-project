<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Insert title here</title>
	</head>
	<body>
		<form action="LoggedIn.jsp">
			<input type="submit" value="back">
		</form>
		
		<h1>Buy Me</h1>
		<h4>Your Auctions : <%= session.getAttribute("user") %></h4>
		
		<%
		
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String user = session.getAttribute("user").toString();

			String insert = "SELECT a.aID, c.name, a.initPrice, a.minIncrement, a.minPrice, a.closeDateTime, b.username, b.price " +
							"FROM auction a " +
							"JOIN bids b USING (aID) " +
							"JOIN sells s USING (aID) " +
							"JOIN clothes c USING (itemID) " +
							"WHERE a.username = ? " +
							"AND a.isActive = 1 " +
							"AND price = (SELECT max(price) " +
										 "FROM bids b2 " +
					            		 "WHERE b2.aID = a.aID " +
					            		 "GROUP BY b2.aID)";
			                                                                      
			PreparedStatement ps = connect.prepareStatement(insert);     
			ps.setString(1, user);
			
			ResultSet results = ps.executeQuery();
		%>
			
			<table style="border:1px solid black;border-collapse:collapse;">
				<thead>
					<tr>    
						<th style="border:1px solid black;"> aID </th>
						<th style="border:1px solid black;"> Name </th>
						<th style="border:1px solid black;"> Init Price </th>
						<th style="border:1px solid black;"> Min Increment </th>
						<th style="border:1px solid black;"> Min Price </th>
						<th style="border:1px solid black;"> Close Time </th>
						<th style="border:1px solid black;"> Current Bidder </th>
						<th style="border:1px solid black;"> Bid Price </th>
					</tr>
				</thead>
					<% while (results.next()) { %>
						<tr>    
							<td style="border:1px solid black;"><%= results.getString(1) %></td>
							<td style="border:1px solid black;"><%= results.getString(2) %></td>
							<td style="border:1px solid black;"><%= results.getString(3) %></td>
							<td style="border:1px solid black;"><%= results.getString(4) %></td>
							<td style="border:1px solid black;"><%= results.getString(5) %></td>
							<td style="border:1px solid black;"><%= results.getString(6) %></td>
							<td style="border:1px solid black;"><%= results.getString(7) %></td>
							<td style="border:1px solid black;"><%= results.getString(8) %></td>
						</tr>
					<% } %>
			</table>

		<%	
			ps.close();
			results.close();
			connect.close();
			
		} catch (Exception e){
			
			out.println(e);
			
		}

		%>
		
	</body>
</html>