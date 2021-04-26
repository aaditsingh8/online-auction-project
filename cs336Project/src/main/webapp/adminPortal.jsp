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
		if(session.getAttribute("user")==null){
			response.sendRedirect("LoginPage.jsp");
		}
		String ADMINCHECK = session.getAttribute("user").toString();
		
		ApplicationDB database = new ApplicationDB();
		Connection connect = database.getConnection();
		
		try{
			
			String adminInsert = "select isAdmin from accounts " +
								"where username = ?";
			PreparedStatement ac = connect.prepareStatement(adminInsert);
			ac.setString(1, ADMINCHECK);
			ResultSet isAdmin = ac.executeQuery();
			
			isAdmin.next();
			
			if(isAdmin.getInt(1) != 1){
				response.sendRedirect("LoggedIn.jsp");
			}
			
			
		}catch(Exception e){
			out.println(e);
			response.sendRedirect("LoggedIn.jsp");
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
<br>	<form method="post" action="createRep.jsp" id="test">
		<table>
		<thead><tr><th>Create new Customer Rep</th></tr></thead>
	
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
	<%
		String totEarn = "select sum(price) from bought";
		PreparedStatement ps = connect.prepareStatement(totEarn);
		ResultSet totEarnRes = ps.executeQuery();
		float tot = 0;
		if(totEarnRes.next() == false){
			tot = 0;
		}else{
			tot= totEarnRes.getInt(1);
		}
		
		String topEarner = "select username, count(username) as count from bought group by username order by count desc";
		PreparedStatement ps2 = connect.prepareStatement(topEarner);
		ResultSet topEarners = ps2.executeQuery();
		String Earner1 = "1. N/A ";
		String Earner2 = "2. N/A ";
		String Earner3 = "3. N/A ";
		if(topEarners.next() == false){
			Earner1 = "1. N/A ";
			Earner2 = "2. N/A ";
			Earner3 = "3. N/A ";
		}else{
			topEarners.previous();
			for(int i = 0; i < 3; i++){
					if(topEarners.next() != false){
					if(i == 0){
					Earner1 = "1. " + topEarners.getString(1);
					}else if(i == 1){
					Earner2 = "2. " + topEarners.getString(1);
					}else if(i == 2){
					Earner3 = "3. " + topEarners.getString(1);
					}
					}
			}
			
		}

			String bestSell = "select name, count(name) as count from clothes group by name order by count desc";
			PreparedStatement ps3 = connect.prepareStatement(bestSell);
			ResultSet bestSellers = ps3.executeQuery();
			String seller1 = "1. N/A ";
			String seller2 = "2. N/A ";
			String seller3 = "3. N/A ";
			if(bestSellers.next() == false){
				seller1 = "1. N/A ";
				seller2 = "2. N/A ";
				seller3 = "3. N/A ";
			}else{
				bestSellers.previous();
				for(int i = 0; i < 3; i++){
						if(bestSellers.next() != false){
						if(i == 0){
						seller1 = "1. " + bestSellers.getString(1);
						}else if(i == 1){
						seller2 = "2. " + bestSellers.getString(1);
						}else if(i == 2){
						seller3 = "3. " + bestSellers.getString(1);
						}
						}
				}
				
			}
		
	%>
	<br>
	<br>
	<table style="border:1px solid black;border-collapse:collapse;">
		<thead>
			<tr>
				<th style="border:1px solid black;padding:5px; width:500px;">Sales Reports</th>
			</tr>
		</thead>
		<tr></tr>
		<tr style="border: 1px solid black">
			<td>Total Earnings: $<%=tot %></td>
		</tr>
		<tr style="border: 1px solid black">
			<td>Best Buyers: <%=Earner1 + " |  " +Earner2 + " |  " + Earner3%></td>
			
		</tr>
		<tr style="border: 1px solid black">
			<td>Best Selling Items: <%=seller1 + " |  " +seller2 + " |  " + seller3%></td>
		</tr>
	
	
	</table>
	
	<%
				String itemtot = "select name , sum(price) as total from clothes as c " +
						"inner join bought as b " +
						"where " +
						"b.itemID = c.itemID " +
						"group by name order by total desc";
				PreparedStatement ps4 = connect.prepareStatement(itemtot);
				ResultSet itemtotset = ps4.executeQuery();
	
	%><br>
	<br>
	<br>
	<table style="border:1px solid black;border-collapse:collapse;">
		<thead>
			<tr>
				<th colspan="2" style="border:1px solid black;padding:5px; width:500px;">Sales Report: Per Item</th>
			</tr>
			<tr>
					<th style="border:1px solid black;padding:5px; width: 400px">Item</th>
					<th style="border:1px solid black;padding:5px;">total Sales</th>
			</tr>
		</thead>
			<% if(itemtotset.next() == false){%>
			<tr>
				<td colspan="2" style="text-align: center;">None</td>
			</tr>
		<%}%>
			<%
			itemtotset.previous();
			while(itemtotset.next()){%>
				<tr style="border-bottom: 1px solid black">
					<td> <%= itemtotset.getString(1)%> </td>
					<td> $<%= itemtotset.getDouble(2)%></td>
				</tr>
					
			<%}%>
	</table>
	
		<%
				String cattot = "select category , sum(price) as total from clothes as c " +
						"inner join bought as b " +
						"where " +
						"b.itemID = c.itemID "+
						"group by c.category order by total desc";
				PreparedStatement ps5 = connect.prepareStatement(cattot);
				ResultSet cattotset = ps5.executeQuery();
	
	%><br>
	<br>
	<br>
	<table style="border:1px solid black;border-collapse:collapse;">
		<thead>
			<tr>
				<th colspan="2" style="border:1px solid black;padding:5px; width:500px;">Sales Report: Item-Type</th>
			</tr>
			<tr>
					<th style="border:1px solid black;padding:5px; width: 400px">Item-Type</th>
					<th style="border:1px solid black;padding:5px;">total Sales</th>
			</tr>
		</thead>
			<% if(cattotset.next() == false){%>
			<tr>
				<td colspan="2" style="text-align: center;">None</td>
			</tr>
		<%}%>
			<%
			cattotset.previous();
			while(cattotset.next()){%>
				<tr style="border-bottom: 1px solid black">
					<td> <%= cattotset.getString(1)%> </td>
					<td> $<%= cattotset.getDouble(2)%></td>
				</tr>
					
			<%}%>
	</table>

		<%
				String usr = "select a.username, sum(price) as price from auction as a inner join bought as b inner join sells as s " +
						"where a.aID = s.aID and b.itemID = s.itemID " +
						"group by a.username order by price desc";
				PreparedStatement ps6 = connect.prepareStatement(usr);
				ResultSet usrset = ps6.executeQuery();
	
	%><br>
	<br>
	<br>
	<table style="border:1px solid black;border-collapse:collapse;">
		<thead>
			<tr>
				<th colspan="2" style="border:1px solid black;padding:5px; width:500px;">Sales Report: Users-Earning</th>
			</tr>
			<tr>
					<th style="border:1px solid black;padding:5px; width: 400px">User</th>
					<th style="border:1px solid black;padding:5px;">Total Earnings</th>
			</tr>
		</thead>
			<% if(usrset.next() == false){%>
			<tr>
				<td colspan="2" style="text-align: center;">None</td>
			</tr>
		<%}%>
			<%
			usrset.previous();
			while(usrset.next()){%>
				<tr style="border-bottom: 1px solid black">
					<td> <%= usrset.getString(1)%> </td>
					<td> $<%= usrset.getDouble(2)%></td>
				</tr>
					
			<%}%>
	</table>
	
	
	
	






</body>
</html>