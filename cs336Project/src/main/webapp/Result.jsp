<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Search</title>
		<style>
			td, th {
				padding: 5px;
			}
		</style>
	</head>
	<body>
		<form action="Search.jsp">
			<input type="hidden" name="search" value="<%= request.getParameter("search") %>" />
	        <input type="submit" value="back" />
	    </form>
		
		<h1>Buy Me</h1>
		<% 
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			boolean keyword_search = true, parameters = true;
			
			String[] keywords = {};
			
			// CREATING STRING FOR QUERY
			
			String insert= "", initial = "", middle = "", end = "";
			
			String base = "SELECT a.aID, c.name, c.category, c.brand, c.material, c.color, c.size, a.initPrice, a.closeDateTime, a.username " +
						  "FROM clothes c " +
						  "JOIN sells s USING (itemID) " +
						  "JOIN auction a USING (aID) ";
			
			// CREATING WHERE CLAUSE FOR PARAMETERS
			
			String[] params_options = {request.getParameter("category").toString(), 
									  request.getParameter("brand").toString(),
									  request.getParameter("material").toString(),
									  request.getParameter("color").toString(),
									  request.getParameter("size").toString()};
			
			Object[] params_values = {request.getParameter("categoryOther"), 
								  	 request.getParameter("brandOther"),
								   	 request.getParameter("materialOther"),
								  	 request.getParameter("colorOther"),
								  	 request.getParameter("sizeOther")};
			
			String[] params = {"category", "brand", "material", "color", "size"};
			
			String params_state = "";
	
			if(params_options[0].equalsIgnoreCase("any")) {
				params_state += "((c." + params[0] + " LIKE '%') ";
			} else if(params_options[0].equalsIgnoreCase("other")){
				params_state += "((c." + params[0] + " = '" + params_values[0] + "') ";
			} else {
				params_state += "((c." + params[0] + " = '" + params_options[0] + "') ";
			}
			
			for(int i = 1; i < 5; i++) {
				if(params_options[i].equalsIgnoreCase("any")) {
					params_state += "AND ((c." + params[i] + " LIKE '%') OR (c." + params[i] + " IS NULL)) ";
				} else {
					params_state += "AND (c." + params[i] + " = '" + params_values[i] + "') ";
				}
			}
			
			params_state += ") ";
			
			// out.println(params_state);
			
			// CREATING WHERE CLAUSE FOR KEYWORDS
			
			if (request.getParameter("search").toString().length() == 0) {
				
				keyword_search = false;
					
			} else {
				
				keywords = request.getParameter("search").toString().split(" ");
				
				initial = "WHERE ((c.name = '" + keywords[0] + "') ";
				middle = "WHERE ((c.name LIKE '" + keywords[0] + "%') ";
				end = "WHERE ((c.name LIKE '%" + keywords[0] + "%') ";
				
				for(int i = 1; i < keywords.length; i++) {
					initial += "OR (c.name = '" + keywords[i] + "') ";
					middle += "OR (c.name LIKE '" + keywords[i] + "%') ";
					end += "OR (c.name LIKE '%" + keywords[i] + "%') ";
				}
				
				initial += ") ";
				middle += ") ";
				end += ") ";
				
				// insert = base + initial + "UNION " + base + middle + "UNION " + base + end; 
				
				//out.println("<br>" + insert);
				%>
					<p>Keywords searched: 
						<% out.print(keywords[0]);
							for(int i = 1; i < keywords.length; i++) {
								out.print(", " + keywords[i]);
							}
						%>
					</p>
				<%

			}
			
			if(keyword_search){
				
				insert = base + initial + "AND " + params_state +
						"UNION " + base + middle + "AND " + params_state +
						"UNION " + base + end + "AND " + params_state;
				
			} else {
				
				insert = base + "WHERE " + params_state;
				
			}
			
			// out.println(insert + "<br><br>");
			
			PreparedStatement ps = connect.prepareStatement(insert);
			
			ResultSet results = ps.executeQuery();
		%>
			
			<table style="border:1px solid black;border-collapse:collapse;">
				<caption>Auction Matches</caption>
				<thead>
					<tr>    
						<th> aID </th>			<!-- 1  -->
						<th> Name </th>			<!-- 2  -->
						<th> Category </th>		<!-- 3  -->
						<th> Brand </th>		<!-- 4  -->
						<th> Material </th>		<!-- 5  -->
						<th> Color </th>		<!-- 6  -->
						<th> Size </th>			<!-- 7  -->
						<th> Init Price </th>	<!-- 8  -->
						<th> Closing Time </th>	<!-- 9  -->
						<th> Seller </th>		<!-- 10 -->
						<th> Options </th>		<!-- 11 -->
					</tr>
				</thead>
				<% if (results.next() == false) { %>
					<tr>
						<td colspan="11" style="text-align: center;">No Matches Found</td>
					</tr>
				<% }
				results.previous();
				while (results.next()) { %>
					<tr>    
						<%
							for(int i = 1; i <= 10; i++) {
								if(results.getString(i) == null) {
									out.println("<td> Not Specified </td>");
								} else {
									out.println("<td>" + results.getString(i) + "</td>");
								}
							}
						%>
						<td>
							<form action="AuctionInfo.jsp" method="post">
						        <input type="hidden" name="aID" value="<%= results.getString(1) %>"/>
						        <input type="submit" value="View Info" />
						    </form>
						</td>
					</tr>
				<% } %>
			</table>
			
		<%	
			ps.close();
			results.close();
			connect.close();
			
		} catch (Exception e){
			
			out.println(e);
			
		}
		%>
		
				
	</body>
</html>