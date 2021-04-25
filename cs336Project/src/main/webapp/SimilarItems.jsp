<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Similar Items</title>
		<style>
			td, th {
				padding: 5px;
			}
		</style>
	</head>
	<body>
		<form action="AuctionInfo.jsp">
			<input type="hidden" name="aID" value="<%= request.getParameter("aID") %>" />
	        <input type="submit" value="back" />
	    </form>
		
		<h1>Buy Me</h1>
		<h4>Auctions similar to aID #<%= request.getParameter("aID") %> from the past 30 days</h4>
		<% 
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String aID = request.getParameter("aID");
			
			Timestamp today = new Timestamp((new java.util.Date()).getTime());
			// out.println(today + "<br><br>");
			
			// FINDING AUCTION INFO
			
			String auction = "SELECT c.name, c.category, c.brand, c.color, c.size, c.material " +
						  "FROM clothes c " +
						  "JOIN sells s USING (itemID) " +
						  "JOIN auction a USING (aID) " +
						  "WHERE aID = " + aID;
			
			PreparedStatement ps_auction = connect.prepareStatement(auction);
			ResultSet results_auction = ps_auction.executeQuery();
			results_auction.next();
			
			String[] params_values = {"", results_auction.getString(1),
									  results_auction.getString(2),
									  results_auction.getString(3),
									  results_auction.getString(4),
									  results_auction.getString(5),
									  results_auction.getString(6)};
			
			
			
			ps_auction.close();
			results_auction.close();
			
		%>
			<table style="border:1px solid black;border-collapse:collapse;">
				<caption>Similarity Criteria</caption>
				<thead style="border:1px solid black;border-collapse:collapse;">
					<tr>
						<th> Name </th>			<!-- 1 -->
						<th> Category </th>		<!-- 2 -->
						<th> Brand </th>		<!-- 3 -->
						<th> Color </th>		<!-- 4 -->
						<th> Size </th>			<!-- 5 -->
						<th> Material </th>		<!-- 6 -->
					</tr>
				</thead>
				<tr>    
					<%
						for(int i = 1; i <= 6; i++) {
							if(params_values[i] == null) {
								out.println("<td> Not Specified </td>");
							} else {
								out.println("<td>" + params_values[i] + "</td>");
							}
						}
					%>
				</tr>
			</table><br>
		<%
			// CREATING WHERE CLAUSE FOR QUERY
		
			String[] params = {"", "name", "category", "brand", "color", "size", "material"};
			
			String name_state = "", category_state = "", params_state = "";
			
			name_state += "WHERE (" + params[1] + " LIKE '%" + params_values[1] + "%') ";
			category_state += "WHERE (" + params[2] + " LIKE '%" + params_values[2] + "%') ";
			
			if(params_values[3] != null) {
				params_state += "WHERE ((" + params[3] + " LIKE '%" + params_values[3] + "%') ";
			} else {
				params_state += "WHERE (((" + params[3] + " LIKE '%') OR (" + params[3] + " IS NULL)) ";
			}
			
			for(int i = 4; i <= 6; i++) {
				if(params_values[i] != null) {
					params_state += "OR (" + params[i] + " LIKE '%" + params_values[i] + "%') ";
				} else {
					params_state += "OR ((" + params[i] + " LIKE '%') OR (" + params[i] + " IS NULL)) ";
				}
			}
			
			params_state += ") ";
			
			// CREATING FINAL STRING FOR QUERY
			
			String insert= "";
			
			String base = "SELECT a.aID, c.name, c.category, c.brand, c.color, c.size, c.material, a.initPrice, a.closeDateTime, a.username, a.startDateTime " +
						  "FROM clothes c " +
						  "JOIN sells s USING (itemID) " +
						  "JOIN auction a USING (aID) ";
			
			insert = base + name_state +
					 "UNION " + base + category_state +
					 "UNION " + base + params_state;
			
			out.println(insert + "<br><br>");
			
			PreparedStatement ps = connect.prepareStatement(insert);
			ResultSet results = ps.executeQuery();
		%>
			
			<table style="border:1px solid black;border-collapse:collapse;">
				<caption>Similar Auctions</caption>
				<thead style="border:1px solid black;border-collapse:collapse;">
					<tr>    
						<th> aID </th>			<!-- 1  -->
						<th> Name </th>			<!-- 2  -->
						<th> Category </th>		<!-- 3  -->
						<th> Brand </th>		<!-- 4  -->
						<th> Color </th>		<!-- 5  -->
						<th> Size </th>			<!-- 6  -->
						<th> Material </th>		<!-- 7  -->
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
							if(results.getString(1).equalsIgnoreCase(aID)) {
								continue;
							}
						
							String closeDateTime = results.getString(11);
							java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
							java.util.Date date = sdf.parse(closeDateTime);
							Timestamp startDate = new Timestamp(date.getTime());
							
							for(int i=0; i<30; i++) {
								startDate = new Timestamp(startDate.getTime() + (long)(1000*3600*24));
							}
							
							if(startDate.before(today)) {
								continue;
							}
							
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