<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Remove Alert</title>

	</head>
	<body>
	<% 
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String username = session.getAttribute("user").toString();
			String alertNum = request.getParameter("alertNum");
			// CREATING STRING FOR QUERY
			
			String update = "DELETE FROM alerts WHERE username = '" + username + "'";
			
			if(!alertNum.equalsIgnoreCase("all")){
				update += " AND alertNum = " + alertNum;
			}
			
			PreparedStatement stmt = connect.prepareStatement(update);
			stmt.executeUpdate();

			stmt.close();
			connect.close();
			
			response.sendRedirect("Alerts.jsp");
			
		} catch (Exception e){
			
			out.println(e);
			
		}
	%>			
	</body>
</html>