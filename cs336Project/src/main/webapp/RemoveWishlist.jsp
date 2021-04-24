<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Remove from Wishlist</title>

	</head>
	<body>
	<% 
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String username = session.getAttribute("user").toString();
			String itemNum = request.getParameter("itemNum");
			// CREATING STRING FOR QUERY
			
			String update = "DELETE FROM wishlist WHERE username = '" + username + "' AND itemNum = " + itemNum;
			
			PreparedStatement stmt = connect.prepareStatement(update);
			stmt.executeUpdate();

			stmt.close();
			connect.close();
			
			response.sendRedirect("Wishlist.jsp");
			
		} catch (Exception e){
			
			out.println(e);
			
		}
	%>			
	</body>
</html>