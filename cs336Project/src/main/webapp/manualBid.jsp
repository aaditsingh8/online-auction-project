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
			
			float highestBid=0.0f; 
			float initialPrice=0.0f;
			float minIncrement=0.0f;
			
			Connection conn = null;

			String url = "jdbc:mysql://localhost:3306/auctionproject";
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(url, "root", "Daniel123909@");
			
			
			
			String insert = "SELECT a.aID, a.initPrice, a.minIncrement FROM auction a WHERE a.aID = ?;";
			PreparedStatement ps = conn.prepareStatement(insert);    
			String aID = request.getParameter("aID");
			ps.setString(1,aID);
			ResultSet results = ps.executeQuery();
			if(results.next()) {
				initialPrice = results.getFloat(2);
				minIncrement = results.getFloat(3);
				
			}
			else {
				out.println("<h4>Error: Inactive auction not found.</h4>");
			}
			
			ps.close();
			results.close();
			
			
		%>
		<div>
			<form action="manualBidHandler.jsp" method="POST">	
				<h5>Minimum Price Increment: <%=minIncrement%></h5>
				<label for="bid">Your Bid:</label>
				<input type="text" name="bid" id="bid"> <br>
				<input type="hidden" name="aID" value="<%= aID%>"/>
				<input type="submit" value="Submit">
			</form>
		</div>	
	</body>
</html>