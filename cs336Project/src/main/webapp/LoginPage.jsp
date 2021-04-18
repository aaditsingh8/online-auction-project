<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Auction Website V 0.1</title>
	</head>
	<body>
		<h1>Buy Me</h1>
		<form method="post" action="LoginRequest.jsp">
			<table>
				<thead>
					<tr>
						<th colspan = "2"> Login </th>
					</tr>
				</thead>
					<tr>
						<td>Username:</td><td><input type="text" name="username"></td>
					</tr>
					<tr>
						<td>Password:</td><td><input type="password" name="password"></td>
					</tr>
					<tr>
						<td colspan="2" align = "center"><input type= "submit" value="login">
						Don't have an account? <a href="RegistrationPage.jsp">Register Here</a>
					</tr>
			</table>
		</form>
		<%
			//out.println(request.getSession().getAttribute("user"));
	
			if(session.getAttribute("valid") == "false"){
				
				out.println("<br>\nThis username and/or password does not exist, please try again!");
				session.removeAttribute("valid");
				
			}
		%>
	</body>
</html>