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
<body><%
				
		ApplicationDB database = new ApplicationDB();
		Connection connect = database.getConnection();
		
		String auctionID = request.getParameter("auctionID");
		
		String insert = "delete from auction where aID=?";
		PreparedStatement ps = connect.prepareStatement(insert);
		ps.setString(1, auctionID);
		ps.executeUpdate();
		response.sendRedirect("RepPortal.jsp");

%>

</body>
</html>