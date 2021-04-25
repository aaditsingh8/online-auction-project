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
		<form action="LoggedIn.jsp">
			<input type="submit" value="back">
		</form>
		<header>
			<h1> Customer Representative Portal</h1>
		</header>
	<%
		ApplicationDB database = new ApplicationDB();
		Connection connect = database.getConnection();
		if(request.getParameter("un") != null){
		if(!request.getParameter("un").isBlank()){
			String insert = "delete from accounts where username = ?";
			PreparedStatement ps = connect.prepareStatement(insert);
			ps.setString(1, request.getParameter("un"));
			ps.executeUpdate();
			%>  <form method="post" action="RepPortal.jsp" name="reset">
					<input type="hidden" name="un" value="">
					<input type="submit">
				</form>
				<body onload="document.reset.submit()"><%
		}
		}
		ResultSet results = null;
		
		try{
			String insert = "select * from accounts";
			PreparedStatement ps = connect.prepareStatement(insert);
			results = ps.executeQuery();
		}catch (Exception e){
			
			out.println(e);
			
		}
	%>
	<br>
	<table style="border:1px solid black;border-collapse:collapse;">
	<caption>Accounts</caption>
		<thead> 
			<tr>
				<th style="border:1px solid black;padding:5px; width:150px;">Username</th>
				<th style="border:1px solid black;padding:5px;">password</th>
				<th style="border:1px solid black;padding:5px; width:150px;">email </th>
				<th style="border:1px solid black;padding:5px; width:150px;"> phone</th>
				<th style="border:1px solid black;padding:5px;"> Anonymous </th>
				<th style="border:1px solid black;padding:5px; width:150px;">Address</th>
				<th style="border:1px solid black;padding:5px;">Customer Rep</th>
				<th style="border:1px solid black;padding:5px;">Admin</th>
				<th style="border:1px solid black;padding:5px; width: 100px">Options</th>
			</tr>
		</thead>
		<% if(results.next() == false){%>
			<tr>
				<td colspan="9" style="text-align: center;">None</td>
			</tr>   
		<%}
			results.previous();
			while(results.next()){%>
				<tr style="border-bottom: 1px solid black">
					<td> <%= results.getString(1)%> </td>
					<td> <%= results.getString(2)%></td>
					<td> <%= results.getString(3)%> </td>
					<td> <%= results.getString(4)%> </td>
					<td> <%= results.getString(5)%> </td>
					<td> <%= results.getString(6)%> </td>
					<td> <%= results.getString(7)%> </td>
					<td> <%= results.getString(8)%> </td>
					<td>
						<form method="post" action="editAccount.jsp">
							<input type="hidden" name="un" value=<%= results.getString(1) %>>
							<input type="submit" name="edit" value="edit">
						</form>
						<form method="post" action="RepPortal.jsp">
							<input type="hidden" name="un" value=<%= results.getString(1) %>>
							<input type="submit" name="delete" value="delete">
						</form>
					</td>
				</tr>
					
				
			<%}%>
	</table>
	<%
		
	String insert = "select * from auction";
	PreparedStatement ps = connect.prepareStatement(insert);
	ResultSet results2 = ps.executeQuery();
	
	
	
	
	%>
	<br>
	<table style="border:1px solid black;border-collapse:collapse;">
		<caption>Auctions</caption>
			<thead>
				<tr>
					<th style="border:1px solid black;padding:5px; width:150px;"> Auction ID</th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Initial Price</th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Minimum Increment </th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Closed</th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Active</th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Minimum Price</th>
					<th style="border:1px solid black;padding:5px; width:150px;">  Username </th>
					<th style="border:1px solid black;padding:5px; width:150px;">  Delete </th>
				</tr>
			</thead>
			<%
			if(results2.next() == false){
			%>
				<tr>
					<td colspan="9" style="text-align: center;">None</td>
				</tr>
			<% }
			results2.previous();
			while(results2.next()){%>
				<tr>
					<td style="border:1px solid black;padding:5px"><%= results2.getString(1) %></td>
					<td style="border:1px solid black;padding:5px"><%= results2.getString(2) %></td>
					<td style="border:1px solid black;padding:5px"><%= results2.getString(3) %></td>
					<td style="border:1px solid black;padding:5px"><%= results2.getString(4) %></td>
					<td style="border:1px solid black;padding:5px"><%= results2.getString(5) %></td>
					<td style="border:1px solid black;padding:5px"><%= results2.getString(6) %></td>
					<td style="border:1px solid black;padding:5px"><%= results2.getString(7) %></td>
					<td>
						<form method="post" action="deleteAuction.jsp">
						<input type="hidden" value="<%= results2.getString(1)%>" name="auctionID">
						<input type="submit" name="delete" value="delete">	
						</form>
					</td>
				</tr>
			
			<%}%>
	</table>
	<%
		
	String insert3 = "select * from bids";
	PreparedStatement ps3 = connect.prepareStatement(insert3);
	ResultSet results3 = ps3.executeQuery();
	
	
	
	
	%>
	<br>
	<table style="border:1px solid black;border-collapse:collapse;">
		<caption>Bids</caption>
			<thead>
				<tr>
					<th style="border:1px solid black;padding:5px; width:150px;"> Auction ID</th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Username</th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Bid Price</th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Time</th>
					<th style="border:1px solid black;padding:5px; width:150px;"> bid Limit</th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Max Increment</th>
					<th style="border:1px solid black;padding:5px; width:150px;">  Delete </th>
				</tr>
			</thead>
			<%
			if(results3.next() == false){
			%>
				<tr>
					<td colspan="9" style="text-align: center;">None</td>
				</tr>
			<% }
			results3.previous();
			while(results3.next()){%>
				<tr>
					<td style="border:1px solid black;padding:5px"><%= results3.getString(1) %></td>
					<td style="border:1px solid black;padding:5px"><%= results3.getString(2) %></td>
					<td style="border:1px solid black;padding:5px"><%= results3.getString(3) %></td>
					<td style="border:1px solid black;padding:5px"><%= results3.getString(4) %></td>
					<td style="border:1px solid black;padding:5px"><%= results3.getString(5) %></td>
					<td style="border:1px solid black;padding:5px"><%= results3.getString(6) %></td>
					<td>
						<form method="post" action="deleteBid.jsp">
						<input type="hidden" value="<%= results3.getString(1)%>" name="aID">
						<input type="hidden" value="<%= results3.getString(2)%>" name="user">
						<input type="hidden" value="<%= results3.getString(3)%>" name="price">
						<input type="submit" name="delete" value="delete">	
						</form>
					</td>
				</tr>
			
			<%}%>
	</table>
		<%
		
	String insert4 = "select q.QID ,q.Q from " + 
			"questions as q " +
			"left join " +
			"answers as a " +
			"on q.QID = a.QID " +
			"where a.QID is null";
	PreparedStatement ps4 = connect.prepareStatement(insert4);
	ResultSet results4 = ps4.executeQuery();
	
	
	
	
	%>
	<br>
	<table style="border:1px solid black;border-collapse:collapse;">
		<caption>Unanswered Questions</caption>
			<thead>
				<tr>
					<th style="border:1px solid black;padding:5px; width:150px;"> Question ID </th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Question </th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Answer </th>
					<th style="border:1px solid black;padding:5px; width:150px;"> Post </th>
				</tr>
			</thead>
			<%
			if(results4.next() == false){
			%>
				<tr>
					<td colspan="9" style="text-align: center;">None</td>
				</tr>
			<% }
			results4.previous();
			while(results4.next()){%>
				<tr>
					<td style="border:1px solid black;padding:5px"><%= results4.getString(1) %></td>
					<td style="border:1px solid black;padding:5px"><%= results4.getString(2) %></td>
					<td>
						<form method="post" action="answerQuestion.jsp">
						<textarea name="Answer"></textarea>
						<input type="hidden" value="<%= results4.getString(1)%>" name="qID">
						<input type="hidden" value="<%= results4.getString(2)%>" name="Q">
						<input type="submit" name="Post" value="Post">
						</form>
					</td>
					<td></td>
				</tr>
			
			<%}%>
	</table>
	
	

</body>
</html>