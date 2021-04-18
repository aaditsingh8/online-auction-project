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
				<td><%= session.getAttribute("type") %> : <%= session.getAttribute("user") %></td>
				<td><a href="Logout.jsp"> Logout </a></td>
			</tr>
		</table>
		
		<br>
		
		<h4>Options</h4>		
		<ul>
			<li> Your auctions information
				<ul>
					<li>
						<a href="UserAuctions.jsp">See Your Active Auctions</a>
					</li>
					<li>
						<a href="UserAuctionsSold.jsp">See Your Closed Auctions</a>
					</li>
				</ul>
			</li>
		</ul>

	</body>
</html>