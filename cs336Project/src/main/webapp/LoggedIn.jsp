<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Buy Me User Home</title>
		<style>
			td, th {
				padding: 5px;
			}
			table, thead {
				border: 1px solid black;
				border-collapse: collapse;
			}
		</style>
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
				<td><a href="Search.jsp"> Search </a></td>
				<td><%= session.getAttribute("type") %> : <%= session.getAttribute("user") %></td>
				<td><a href="Logout.jsp"> Logout </a></td>
			</tr>
		</table>
		
		<h4>Options</h4>		
		<ul>
			<li> Auction Options
				<ul>
					<li><a href="---.jsp">Create Auction</a></li>
					<li><a href="Search.jsp">Search for Auctions</a></li>
					<li> Your Auctions
						<ul>
							<li>
								<a href="UserAuctions.jsp">See your Active Auctions</a>
							</li>
							<li>
								<a href="UserAuctionsSold.jsp">See your Closed Auctions</a>
							</li>
						</ul>
					</li>
					<li> Other Auctions
						<ul>
							<li>
								<a href="Participate.jsp">Auctions You Participated In</a>
							</li>
						</ul>
					</li>
				</ul>
			</li>
			<li> Wishlist
				<ul>
					<li>
						<a href="AddWishlist.jsp">Add to your Wishlist</a>
					</li>
					<li>
						<a href="Wishlist.jsp">See your Wishlist</a>
					</li>
				</ul>
			</li>
			<li>
				<a href="Alerts.jsp">Alerts</a>
			</li>
		</ul>

	</body>
</html>