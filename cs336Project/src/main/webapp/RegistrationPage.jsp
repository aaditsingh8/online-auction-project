<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Register</title>
	</head>
	<body>
		<script>
			function checkPasswords(form){
				if(form.password.value != form.password2.value){
					alert('Passwords do not match!')
					return false;
				} else {
					return true;
				}
			}
		</script>
					<br>
		<form action="LoginPage.jsp">
		<%//session.setAttribute("valid", "true");%>
		<input type="submit" value="back">
		</form>
		<br>
		<h1>Buy Me</h1>
		<h4>Register an Account</h4>
		<br>
		<form method="post" action="RegistrationRequest.jsp" onsubmit="return checkPasswords(this);">			
			<table>
				<tr>
					<td>Email:</td><td><input type="text" name="email"></td>
				</tr>
				<tr>
					<td>Username:</td><td><input type="text" name="username"></td>
				</tr>
				<tr>
					<td>Password:</td><td><input type="text" name="password"></td>
				</tr>
				<tr>
					<td>Confirm Password:</td><td><input type="text" name="password2"></td>
				</tr>
			</table>
			<input type = "submit" value="Register">
		</form>
		<%
		if (session.getAttribute("userError") != null){

			out.println("Username should be 1 to 20 characters long.\n<br>");
			session.removeAttribute("userError");

		}
		if (session.getAttribute("passError") != null){

			out.println("Password should be 3 to 20 characters long.\n<br>");
			session.removeAttribute("passError");

		}
		if (session.getAttribute("emailError") != null){

			out.println("Email should be 3 to 40 characters long.");
			session.removeAttribute("emailError");

		}
		%>
	</body>
</html>