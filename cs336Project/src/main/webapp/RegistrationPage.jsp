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
		
		<form action="LoginPage.jsp">
		<input type="submit" value="back">
		</form>
		
		<br>
		<h1>Buy Me</h1>
		<h4>Register an Account</h4>
		<br>
		
		<form method="post" action="RegistrationRequest.jsp" onsubmit="return checkPasswords(this);">			
			<table>
				<tr>
					<td>Email:</td><td><input type="text" name="email" required></td>
				</tr>
				<tr>
					<td>Username:</td><td><input type="text" name="username" required></td>
				</tr>
				<tr>
					<td>Password:</td><td><input type="text" name="password" required></td>
				</tr>
				<tr>
					<td>Confirm Password:</td><td><input type="text" name="password2" required></td>
				</tr>
				<tr>
					<td>Phone Number:</td><td><input type="text" name="phone" required></td>
				</tr>
				<tr>
					<td>Address:</td><td><input type="text" name="address" required></td>
				</tr>
				<tr>
					<td>Anonymous: 
								<input type="radio" name="anon" id="false" value="0" checked="checked">
								<label for="false">False</label>
								<input type="radio" name="anon" id="true" value="1">
								<label for="true">True</label></td>
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