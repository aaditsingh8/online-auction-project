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
		
		
		<%
		
		ApplicationDB database = new ApplicationDB();
		Connection connect = database.getConnection();
		ResultSet results = null;
		try{
			String insert = "select * from accounts";
			PreparedStatement ps = connect.prepareStatement(insert);
			results = ps.executeQuery();
		}catch (Exception e){
			
			out.println(e);
			
		}
		%>
<br>	<form method="post" action="createRep.jsp" id="test">
		<table>
	
			<tr>
				<td>Username: <input form="test" type="text" name="username" required></td>
			</tr>
			<tr>
				<td>Password: <input type="text" name="pass" required></td>
			</tr>
			<tr>
				<td>Email: <input type="text" name="email" required></td>
			</tr>
			<tr>
				<td>Phone: <input type="text" name="phone"></td>
			</tr>
			<tr><td>Anonymous: 
								<label for="false">False</label>
								<input type="radio" name="anon" id="false" value="0" checked="checked">
								<label for="true">True</label>
								<input type="radio" name="anon" id="true" value="1">
			 </td>
			 </tr>	
			 <tr>		
					<td>Address: <input type="text" name="address">
				<% if((String)session.getAttribute("error") == "1"){%> Missing Required Input <%} session.setAttribute("error", "0"); %></td>
			</tr>
			<tr>
					<td><input type="submit" name="create" value="Create Rep"></td>
			</tr>
		</table>
		</form>
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
		<%}%>
			<tr style="border-bottom: 1px solid black">
			</tr>
			<%
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
						<form method="post" action="makeRep.jsp">
							<input type="hidden" name="un" value=<%= results.getString(1) %>>
							<input type="hidden" name="rep" value="1">
							<input type="submit" name="edit" value="Make Rep">
						</form>
						<form method="post" action="makeRep.jsp">
							<input type="hidden" name="un" value=<%= results.getString(1) %>>
							<input type="hidden" name="rep" value="0">
							<input type="submit" name="edit" value="Revoke Permissions">
						</form>
					</td>
				</tr>
					
			<%}%>
	</table>
	
	
	<table style="border:1px solid black;border-collapse:collapse;">
		<thead>
			<tr>
				<th style="border:1px solid black;padding:5px; width:500px;">Sales Reports</th>
			</tr>
		</thead>
		<tr></tr>
		<tr style="border: 1px solid black">
			<td>Total Earnings: </td>
		</tr>
		<tr style="border: 1px solid black">
			<td>Best Sellers: </td>
		</tr>
		<tr style="border: 1px solid black">
			<td>Best Selling Items: </td>
		</tr>
	
	
	</table>
	
	
	






</body>
</html>