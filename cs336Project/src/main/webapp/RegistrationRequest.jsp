<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Registration Request</title>
	</head>
	<body>
	<% 
	
	try{
		
		ApplicationDB database = new ApplicationDB();
		Connection connect = database.getConnection();
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		
		boolean flag = false;
		
		if (password.length() < 3 || password.length() > 20){

			session.setAttribute("passError", "true");
			
			flag = true;
		}
		if (username.length() < 1 || username.length() > 20){

			session.setAttribute("userError", "true");
			
			flag = true;
		}
		if (email.length() < 3 || email.length() > 40){

			session.setAttribute("emailError", "true");
			
			flag = true;
		}
		
		if (flag) {
			response.sendRedirect("RegistrationPage.jsp");
			connect.close();
		}

		String insert = "INSERT INTO Accounts(username, password, email) VALUES (?, ?, ?)";
		                                                                      
		PreparedStatement ps = connect.prepareStatement(insert);     
		ps.setString(1, username);
		ps.setString(2, password);
		ps.setString(3, email);
		
		ps.executeUpdate();
		ps.close();
		connect.close();

		session.setAttribute("user", username);
		session.setAttribute("pass", password);
		session.setAttribute("valid", "true");
		response.sendRedirect("LoggedIn.jsp");
		
	} catch (Exception e){
		
		out.println(e);
		out.println("Registration Failed.");
		
	}

	%>
	
	</body>
</html>