<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Logout</title>
	</head>
	<body>
			<%
			if(session!=null){
				session.invalidate();
				session = request.getSession(true);
				session.setAttribute("valid", "true");
				response.sendRedirect("LoginPage.jsp");
			}
			%>
	</body>
</html>