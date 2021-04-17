<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Login Request</title>
	</head>
	<body>
		<br>
		Processing...
		
		<%
		
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			
			// String insert = "SELECT username, password FROM Accounts WHERE Username=? AND Password=?";
			String insert = "SELECT username, password FROM Accounts WHERE Username=? AND Password=?";

			PreparedStatement ps = connect.prepareStatement(insert); 
			ps.setString(1, username);
			ps.setString(2, password);

			ResultSet results = ps.executeQuery();

	
			if(results.next()){
			
				session.setAttribute("user", username);
				session.setAttribute("pass", password);
				session.setAttribute("valid", "true");
				
				results.close();
				ps.close();
				connect.close();
			
				response.sendRedirect("LoggedIn.jsp");
		
			} else {
				
				session.setAttribute("valid", "false");
				
				results.close();
				ps.close();
				connect.close();

				response.sendRedirect("LoginPage.jsp");
			}
			
			
		} catch (Exception e){
			
			out.println("Something went wrong, please try again!\n<br>");
			out.println("Error: " + e.toString());
			
		}
		
		%>
	
	</body>
</html>