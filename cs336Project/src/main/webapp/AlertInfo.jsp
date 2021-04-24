<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Alert Info</title>
		<style>
			td, th {
				padding: 5px;
			}
		</style>
	</head>
	<body>
		<form action="Alerts.jsp">
	        <input type="submit" value="back" />
	    </form>
		
		<h1>Buy Me</h1>

		<% 
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String username = session.getAttribute("user").toString();
			String alertNum = request.getParameter("alertNum");
		
			// CREATING STRING FOR QUERY
			
			String query = "SELECT `subject`, `text` FROM `alerts` WHERE `username` = '" + username + "' AND `alertNum` = " + alertNum;
			
			PreparedStatement ps = connect.prepareStatement(query);
			ResultSet results = ps.executeQuery(); 
			results.next(); %>
			
			<h4>Alert: <%= results.getString(1) %></h4>
			<p><%= results.getString(2) %></p>
			
			<br> Options: <br><br>
			<form action="RemoveAlert.jsp">
				<input type="hidden" name="alertNum" value="<%= alertNum %>" />
	        	<input type="submit" value="Remove Alert" />
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