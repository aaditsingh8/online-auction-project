<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Your Bids</title>
	</head>
	<body>
		<form action="AuctionInfo.jsp">
	        <input type="hidden" name="aID" value="<%= request.getParameter("aID") %>"/>
	        <input type="submit" value="back" />
	    </form>
		
		<h1>Buy Me</h1>
		<h4>Auction #<%= request.getParameter("aID") %></h4>
		
		<%
		
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String aID = request.getParameter("aID"), seller = "";
			
			String insert_info = "SELECT a.aID, c.name, a.initPrice, a.closeDateTime, a.username " +
							"FROM auction a " +
							"JOIN sells s USING (aID) " +
							"JOIN clothes c USING (itemID) " +
							"WHERE a.aID = ?";
			
			PreparedStatement ps_info = connect.prepareStatement(insert_info);     
			ps_info.setString(1, aID);
			
			ResultSet results_info = ps_info.executeQuery();
		%>
			
			<table style="border:1px solid black;border-collapse:collapse;">
				<caption>Auction Information</caption>
				<thead>
					<tr>    
						<th style="border:1px solid black;padding:5px"> aID </th>
						<th style="border:1px solid black;padding:5px"> Name </th>
						<th style="border:1px solid black;padding:5px"> Initial Price </th>
						<th style="border:1px solid black;padding:5px"> Closing Time </th>
						<th style="border:1px solid black;padding:5px"> Seller </th>
					</tr>
				</thead>
				
				<% if (results_info.next()) {
					seller = results_info.getString(5); %>
					<tr>    
						<td style="border:1px solid black;padding:5px"><%= results_info.getString(1) %></td>
						<td style="border:1px solid black;padding:5px"><%= results_info.getString(2) %></td>
						<td style="border:1px solid black;padding:5px"><%= results_info.getString(3) %></td>
						<td style="border:1px solid black;padding:5px"><%= results_info.getString(4) %></td>
						<td style="border:1px solid black;padding:5px"><%= results_info.getString(5) %></td>
					</tr>
				<% } else { %>
					<tr>
						<td colspan="5" style="text-align: center;">None</td>
					</tr>
				<% } %>
			</table>
			
			<br>
			
			<!-- -------------------------------------------------------------------------------------------------------------------- -->

			<% 
			
			String insert = "SELECT b.username, b.price, a.isAnon " +
							"FROM bids b " +
							"JOIN accounts a USING (username) " +
							"WHERE b.aID = ? " +
							"ORDER BY b.price DESC";
			                                                                      
			PreparedStatement ps = connect.prepareStatement(insert);     
			ps.setString(1, aID);
			
			ResultSet results = ps.executeQuery();
			
			%>
			
			<p>Bid History (latest to oldest):</p>
			
			<table style="border:1px solid black;border-collapse:collapse;">
				<thead>
					<tr>    
						<th style="border:1px solid black;padding:5px"> User </th>
						<th style="border:1px solid black;padding:5px"> Bid Price </th>
					</tr>
				</thead>
				<% if (!results.next()) { %>
					<tr>
						<td colspan="2" style="text-align: center;">No Bids Yet</td>
					</tr>
				<% }
				results.previous();
				while (results.next()) { %>
					<tr>    
						<% if(results.getBoolean(3)) { %>
							<td>Anonymous</td>
						<% } else { %>
							<td style="border:1px solid black;padding:5px"><%= results.getString(1) %></td>
						<% } %>
						<td style="border:1px solid black;padding:5px"><%= results.getString(2) %></td>
					</tr>
				<% } %>
			</table>

		<% if (!seller.equals(session.getAttribute("user").toString())) { %>
			<br>
			<form action="----.jsp" method="post">
		        <input type="hidden" name="aID" value="<%= aID %>"/>
		        <input type="submit" value="Bid on Item" />
		    </form>
		<% }
			
			ps.close();
			results.close();
			connect.close();
			
		} catch (Exception e){
			
			out.println(e);
			
		}
		%>
		
	</body>
</html>