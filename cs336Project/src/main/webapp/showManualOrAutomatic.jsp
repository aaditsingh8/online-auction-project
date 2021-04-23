<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("command");
			/*
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT * FROM " + entity;
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);	*/
			
		%>
			<h1>Create a <%if (entity.equals("Manual"))
						out.print("Manual");
					else
						out.print("Automatic");
					%> bid</td>
					
		<%
			if (entity.equals("Automatic")){
				int upperLimit = 0; 
				int bidIncrement = 0; 
				

				
				//Insert into DB
				String aID = request.getParameter("aID");
				String insert = "select max(b.price) from bids b join auction a on b.aid = a.aid where b.aid = ?;";
				PreparedStatement ps = connect.prepareStatement(insert);    
				ps.setString(1,aID);
				ResultSet results = ps.executeQuery();
				
				
			}
		%>
		
					
		<%} catch (Exception e) {
			out.print(e);
		}%>
		

	</body>
</html>
		