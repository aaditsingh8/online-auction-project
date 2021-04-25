<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
	<head lang="en">
		<meta charset="ISO-8859-1">
	</head>
<body>
		<form action="LoggedIn.jsp">
			<input type="submit" value="back">
		</form>
	<h1> BuyMe Forum </h1>
		<form method="post" action="BuyMeForum.jsp">
			<table>
				<tr>
					<th colspan = "1"> Search by Keyword </th>
				</tr>
				<tr>
					<td><input type="text" name="keyword" size="40"><td><input type= "submit" value="Search"></td>
				</tr>
			</table>
		
		</form>
		<%
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			if(request.getParameter("newQuestion") !=null && !request.getParameter("newQuestion").isBlank()){
				String newQ = "insert into questions (username,Q) values (? , ? )";
				PreparedStatement ps = connect.prepareStatement(newQ);
				ps.setString(1, session.getAttribute("user").toString());
				ps.setString(2, request.getParameter("newQuestion"));
				ps.executeUpdate();
			}
			
			String s1 = request.getParameter("keyword");
			ResultSet results = null;
			if(s1 != null){
				if(!s1.isBlank()){
					String s2 = "%";
					String finalKeyword = s2 + s1 + s2;
					String insert = "select Q, QID " +
									"from questions " + 
									"where(Q like ?)";
					
					
					PreparedStatement ps = connect.prepareStatement(insert);
					ps.setString(1, finalKeyword);
					results = ps.executeQuery();
					
				}else{
					String insert = "select Q,QID from questions";
					PreparedStatement ps = connect.prepareStatement(insert);
					results = ps.executeQuery();
				}
			}else{
				
				String insert = "select Q,QID from questions";
				PreparedStatement ps = connect.prepareStatement(insert);
				results = ps.executeQuery();
			}

		%>
	<table style="border:1px solid black;border-collapse:collapse;">
		<thead>
			<tr>
				<th style="border:1px solid black;padding:3px"> Questions </th>
			</tr>
		</thead>
		<%
			if (results.next() == false) {
		%>
			<tr>
				<td colspan="9" style="text-align: center;">None</td>
			</tr>
		<%}
		
		results.previous();
		while(results.next()){
		%>
			<tr>
				<td><form method="post" action="QuestionThread.jsp">
					<label for="qID"><%=results.getString(1) %></label>
					<input type="hidden" id="qID" name="qID" value=<%=results.getInt(2)%>>
					<input type="submit">
				</form></td>
				<td></td>
			</tr>
		
		<%} %>
		
	</table>
	<form method="post" action="BuyMeForum.jsp">
		<textarea name="newQuestion" rows="4" cols="50"></textarea>
		<input type="submit">
	</form>
	
		
	
</body>
</html>