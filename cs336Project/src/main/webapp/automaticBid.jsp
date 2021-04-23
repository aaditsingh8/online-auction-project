<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
	</head>
	<body>
	<h1>Create an automatic bid</h1>
	<form action="automaticBid.jsp" method="post">
		<label>Secret Upper Limit: </label>
        <input type="text" name="upperLimit"/><br>
        <label>Bid Increment: </label>
        <input type="text" name="bidIncrement"/><br>
        <input type="submit" value="Create Bid" />
	</form>
	<%
			
	
	%>
	</body>
	
</html>