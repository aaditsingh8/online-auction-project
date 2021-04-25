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

String auctionID = request.getParameter("aID");
String username = request.getParameter("user");
String price = request.getParameter("price");

String insert = "delete from bids where aID=? and username=? and price=? ";
PreparedStatement ps = connect.prepareStatement(insert);
ps.setString(1, auctionID);
ps.setString(2, username);
ps.setString(3, price);
ps.executeUpdate();
response.sendRedirect("RepPortal.jsp");





%>

</body>
</html>