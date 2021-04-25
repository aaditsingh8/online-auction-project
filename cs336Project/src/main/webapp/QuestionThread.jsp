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
		<form action="BuyMeForum.jsp">
			<input type="submit" value="back">
		</form>
	<h1> Discussion Board</h1>
	
	<%
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			/*try{
				String ans = request.getParameter("ans");
				String qID = request.getParameter("qID");
				if(ans != null){
					if(!ans.isBlank()){
						String insert = "insert into answers (QID, username,A) values (? , ? , ? )";
						PreparedStatement ps = connect.prepareStatement(insert);
						ps.setString(1, qID);
						ps.setString(2, session.getAttribute("user").toString());
						ps.setString(3, ans);
						ps.executeUpdate();
					}
				}
				
			}catch (Exception e){
				
				out.println(e);
				
			}*/
			
			String insert = "select Q,A " +
							"from answers as a inner join questions as s " +
							"where a.QID = ? and s.QID = a.QID";
			PreparedStatement ps = connect.prepareStatement(insert);
			ps.setString(1, request.getParameter("qID"));
			ResultSet results = ps.executeQuery(); 
			String Question = "";
			if(results.next() == false){
				String insert2 = "select Q from questions where QID = ?";
				PreparedStatement ps2 = connect.prepareStatement(insert2);
				ps2.setString(1, request.getParameter("qID"));
				ResultSet results2 = ps2.executeQuery();
				results2.next();
				Question = results2.getString(1);
			}else{
				Question = results.getString(1);
				results.previous();
			}
			
			%>
	
	<table style="border:1px solid black;border-collapse:collapse;">
		<thead>
			<tr><% results.next(); %>
				<th style="border:1px solid black;padding:20px"><%= Question %> </th>
			</tr>
		</thead>
		<%  results.previous(); 
			while(results.next()){
		%>
			<tr>
				<td>
					<%=results.getString(2) %>
				</td>
			</tr>
		<%}%>
	</table>
	<% 
	/*<form method = "post" action="QuestionThread.jsp">
	<input size="70" type="text" id="ans" name="ans">
	<input size="20" type="hidden" id="qID" name="qID" value= = .getParameter("qID")>
	<input type="submit" value="post">
	</form>*/ %>
	
	
</body>
</html>