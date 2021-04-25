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

<%
		ApplicationDB database = new ApplicationDB();
		Connection connect = database.getConnection();
		
		String qID = request.getParameter("qID");
		String ans = request.getParameter("Answer");
		String insert = "insert into answers (QID, A , username) values (? , ?, ?)";
		PreparedStatement ps = connect.prepareStatement(insert);
		ps.setString(1, qID);
		ps.setString(2, ans);
		ps.setString(3, session.getAttribute("user").toString());
		ps.executeUpdate();
		response.sendRedirect("RepPortal.jsp");


%>

</body>
</html>