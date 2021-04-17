<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Buy Me User Home</title>
	</head>
	<body>
		<%
			response.setHeader("Cache-Control", "no-cache , no-store , must-revalidate");
			if(session.getAttribute("user")==null){
				response.sendRedirect("LoginPage.jsp");
			}
		%>
		<h1>Buy Me</h1>
		<table border = "1">
			<tr>
				<td> Home </td>
				<td><% out.println("Logged in as, " + request.getSession().getAttribute("user")); %></td>
				<td><a href="Logout.jsp"> Logout </a></td>
			</tr>
		</table>
	
	
	<br>
	<br>
	<br>
	<%try{
		
		ApplicationDB database = new ApplicationDB();
		Connection connect = database.getConnection();
		
		String username = (String)session.getAttribute("user");
		
		String insert = "SELECT * from Accounts where Username=?";
		PreparedStatement ps = connect.prepareStatement(insert); 
		ps.setString(1,username);
		ResultSet results = ps.executeQuery();
		ResultSetMetaData resultsMeta = results.getMetaData();
		int totalColumns = resultsMeta.getColumnCount();
		
		while(results.next()){
			for(int  i = 7; i <= totalColumns;i++){
				
		           String columnValue = results.getString(i);
		           if( columnValue.equals("0")){
		        	   out.print(resultsMeta.getColumnName(i) + ": False");
		           }else if(columnValue.equals("1")){
		        	   out.print(resultsMeta.getColumnName(i) + ": True");
		           }
		           %><br><%
		           
			}
		}
		
		
	}catch(Exception x){
		
		out.println("Error.");
	}
	%>

	</body>
</html>