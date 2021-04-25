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
			
			try{String username = request.getParameter("username");
			String password = request.getParameter("pass");
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
			String anon = request.getParameter("anon");
			String address = request.getParameter("address");
			
			String insert = "insert into accounts "+
							"(username, password, email, phone, isAnon, address, isCustomerRep) " +
							"values (? , ?, ? ,?,?,?, 1)";
			
			PreparedStatement ps = connect.prepareStatement(insert);
			ps.setString(1, username);
			ps.setString(2, password);
			ps.setString(3, email);
			ps.setString(4, phone);
			ps.setString(5, anon);
			ps.setString(6, address);
			ps.executeUpdate();
			response.sendRedirect("adminPortal.jsp");
			}catch(Exception e){
				session.setAttribute("error", "1");
				response.sendRedirect("adminPortal.jsp");

			}
			

%>
</body>
</html>