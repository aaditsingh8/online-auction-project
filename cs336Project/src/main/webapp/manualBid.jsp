<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Manual Bidding</title>
	</head>
	<body>
		
		
		<%
			String bidAmount = request.getParameter("bidAmount");
			//String user = (String)session.getAttribute("user");
			String upperLimit = request.getParameter("upperLimit");
			String bidIncrement = request.getParameter("bidIncrement");
			
			int highestBid=0; 
			int initialPrice=0;
			int minIncrement=0;
			
			Connection conn = null;
			PreparedStatement ps1 = null;
			ResultSet rs = null;
			ApplicationDB database = new ApplicationDB();
			conn = database.getConnection();
			
			
			
			String insert = "SELECT a.aID, a.initPrice, a.minIncrement FROM auction a WHERE a.aID = ?;";
			PreparedStatement ps = conn.prepareStatement(insert);    
			String aID = request.getParameter("aID");
			ps.setString(1,aID);
			ResultSet results = ps.executeQuery();
			if(results.next()) {
				initialPrice = results.getInt(2);
				minIncrement = results.getInt(3);
			}
			else {
				out.println("<h4>Error: Inactive auction not found.</h4>");
			}
			
			ps.close();
			results.close();
			
			
		%>

	</body>
</html>