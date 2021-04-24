<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Alerts</title>
		<style>
			td, th {
				padding: 5px;
			}
		</style>
	</head>
	<body>
		<form action="LoggedIn.jsp">
	        <input type="submit" value="back" />
	    </form>
		
		<h1>Buy Me</h1>
		<h4>Your Alerts</h4>
		<% 
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String username = session.getAttribute("user").toString();
		
			// CREATING STRING FOR QUERY
			// Name, Category, Brand, Material, Color, Size
			
			String query = "SELECT `subject`, `alertNum` FROM `alerts` WHERE `username` = '" + username + "'";
			
			PreparedStatement ps = connect.prepareStatement(query);
			ResultSet results = ps.executeQuery(); %>
			
			<table style="border:1px solid black;border-collapse:collapse;">
				<thead style="border:1px solid black;border-collapse:collapse;">
					<tr>    
						<th style="text-align: center;"> Num </th>						<!-- 1  -->
						<th style="text-align: center;"> Subject </th>					<!-- 2  -->
						<th colspan="2" style="text-align: center;"> Options </th>		<!-- 3, 4  -->
					</tr>
				</thead>
				<% if (results.next() == false) { %>
					<tr>
						<td colspan="4" style="text-align: center;">No new alerts.</td>
					</tr>
				<% }
				results.previous();
				
				int count = 1;
				while (results.next()) { %>
					<tr>
						<td><%= count %></td>
						<td><%= results.getString(1) %></td>
						<td>
							<form action="AlertInfo.jsp" method="post">
						        <input type="hidden" name="alertNum" value="<%= results.getString(2) %>"/>
						        <input type="submit" value="View" />
						    </form>
						</td>
						<td>
							<form action="RemoveAlert.jsp" method="post">
						        <input type="hidden" name="alertNum" value="<%= results.getString(2) %>"/>
						        <input type="submit" value="Remove" />
						    </form>
						</td>
					</tr>
				<% 
				count++;
				} 
				%>
			</table><br>
			
			Options: <br><br>
			<form action="RemoveAlert.jsp">
				<input type="hidden" name="alertNum" value="all" />
	        	<input type="submit" value="Clear all Alerts" />
	    	</form>

		<%	ps.close();
			results.close();
			connect.close();
			
		} catch (Exception e){
			
			out.println(e);
			
		}
		%>
		
				
	</body>
</html>