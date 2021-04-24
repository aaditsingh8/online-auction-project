<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Your Wishlist</title>
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
		<h4>Your Wishlist</h4>
		<% 
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String username = session.getAttribute("user").toString();
		
			// CREATING STRING FOR QUERY
			// Name, Category, Brand, Material, Color, Size
			
			String query = "SELECT name, category, brand, material, color, size, itemNum FROM wishlist WHERE username = '" + username + "'";
			
			PreparedStatement ps = connect.prepareStatement(query);
			ResultSet results = ps.executeQuery(); %>
			
			<table style="border:1px solid black;border-collapse:collapse;">
				<thead style="border:1px solid black;border-collapse:collapse;">
					<tr>    
						<th> Num </th>			<!-- 1  -->
						<th> Name </th>			<!-- 2  -->
						<th> Category </th>		<!-- 3  -->
						<th> Brand </th>		<!-- 4  -->
						<th> Material </th>		<!-- 5  -->
						<th> Color </th>		<!-- 6  -->
						<th> Size </th>			<!-- 7  -->
						<th> Option </th>		<!-- 8  -->
					</tr>
				</thead>
				<% if (results.next() == false) { %>
					<tr>
						<td colspan="8" style="text-align: center;">No Items in Wishlist. Add <a href="AddWishlist.jsp">here</a>.</td>
					</tr>
				<% }
				results.previous();
				
				int count = 1;
				while (results.next()) { %>
					<tr>
						<td><%= count %></td>
						<% 
							for(int i = 1; i <= 6; i++) {
								if(results.getString(i) == null) {
									out.println("<td> any </td>");
								} else {
									out.println("<td>" + results.getString(i) + "</td>");
								}
							} 
						%>
						<td>
							<form action="RemoveWishlist.jsp" method="post">
						        <input type="hidden" name="itemNum" value="<%= results.getString(7) %>"/>
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
			<form action="AddWishlist.jsp">
	        	<input type="submit" value="Add to Wishlist" />
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