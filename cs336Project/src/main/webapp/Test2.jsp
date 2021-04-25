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
			
			String closeDateTime = "26-03-2021 00:00:00";
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
			java.util.Date date = sdf.parse(closeDateTime);
			Timestamp closeDate = new Timestamp(date.getTime());
			
			closeDate.before(new Timestamp((new java.util.Date()).getTime()));
			
			Timestamp today = new Timestamp(closeDate.getTime());
			
			out.println(closeDate + "<br><br>");
			
			for(int i=0; i<30; i++) {
				today = new Timestamp(today.getTime() + (long)(1000*3600*24));
				out.println(today + "<br>");
			}
			
			out.println("<br>" + (long)(1000*3600*24));
			
		} catch (Exception e){
			
			out.println(e);
			
		}
		%>
		
				
	</body>
</html>