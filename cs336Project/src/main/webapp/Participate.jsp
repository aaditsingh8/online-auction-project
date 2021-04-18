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
		<h4>Auctions with your Participation : <%= session.getAttribute("user") %></h4>
		<p>Find here all the items that you have bid on and your highest bid on that item.</p>
		
		<%
		
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String user = session.getAttribute("user").toString();

			String insert = "SELECT b.aID, c.name, if((SELECT t1.isActive FROM auction t1 WHERE t1.aID = b.aID) = 1, 'Still Active', " +
													"if((SELECT t2.username FROM bought t2 WHERE t2.aID = b.aID) = b.username, " +
							                    	  "'You', 'Not You')) bought_by, max(b.price) " +
							"FROM bids b " +
							"JOIN sells s USING (aID) " +
							"JOIN clothes c USING (itemID) " +
							"WHERE b.username = ? " +
							"GROUP BY b.aID";
			                                                                      
			PreparedStatement ps = connect.prepareStatement(insert);     
			ps.setString(1, user);
			
			ResultSet results = ps.executeQuery();
		%>
			
			<table style="border:1px solid black;border-collapse:collapse;">
				<caption>Auctions You Participated In</caption>
				<thead>
					<tr>    
						<th style="border:1px solid black;"> aID </th>
						<th style="border:1px solid black;"> Name </th>
						<th style="border:1px solid black;"> Bought By </th>
						<th style="border:1px solid black;"> Highest Bid </th>
					</tr>
				</thead>
				<% 
				if (results.next() == false) {
				%>
					<tr>
						<td colspan="4" style="text-align: center;">None</td>
					</tr>
				<%
				}
				results.previous();
				while (results.next()) { %>
					<tr>    
						<td style="border:1px solid black;"><%= results.getString(1) %></td>
						<td style="border:1px solid black;"><%= results.getString(2) %></td>
						<td style="border:1px solid black;"><%= results.getString(3) %></td>
						<td style="border:1px solid black;"><%= results.getString(4) %></td>
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