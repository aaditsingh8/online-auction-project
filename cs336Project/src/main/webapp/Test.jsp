<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Wishlist Request</title>

	</head>
	<body>
	<% 
		try{

			response.sendRedirect("WishlistAlert.jsp?aID=" + 1);
			
		} catch (Exception e){
			
			out.println(e);
			
		}
	%>			
	</body>
</html>