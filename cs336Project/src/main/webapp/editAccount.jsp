<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
		<form action="RepPortal.jsp">
			<input type="submit" value="back">
		</form>

	<%
		ApplicationDB database = new ApplicationDB();
		Connection connect = database.getConnection();
		
		String username = request.getParameter("un");
		String insert = "select * from accounts where username=?";
		PreparedStatement ps = connect.prepareStatement(insert);
		ps.setString(1, username);
		
		ResultSet results = ps.executeQuery();
		results.next();
	%>
	
	<form method="post" action="editRequest.jsp">
		<table>
			<tr>
				<td>Username: <input type="text" name="username" value="<%= results.getString(1)%>"></td> 
				<td><input type="hidden" name="usernameOriginal" value="<%= results.getString(1)%>"></td>
			</tr>
			<tr>
				<td>Password: <input type="text" name="password" value="<%= results.getString(2)%>"></td> 
			</tr>
			<tr>
				<td>Email: <input type="text" name="email" value="<%= results.getString(3)%>"></td> 
			</tr>
			<tr>
				<td>Phone Number: <input type="text" name="phone" value="<%= results.getString(4)%>"></td> 
			</tr>
			<tr>
				<td>Anonymous:  <input type="radio" name="anon" id="false" value="0" checked="checked">
								<label for="false">False</label>
								<input type="radio" name="anon" id="true" value="1">
								<label for="true">True</label>
								
				</td>
			</tr>
			<tr>
				<td>Address: <input type="text" name="address" value="<%= results.getString(6)%>"></td> 
			</tr>
		</table>
		<input type="submit" name="request" value="request">
		</form>

</body>
</html>