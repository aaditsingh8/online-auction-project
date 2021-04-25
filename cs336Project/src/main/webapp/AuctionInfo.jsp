<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Auction Info: <%= request.getParameter("aID") %></title>
	</head>
	<body>
		<form action="LoggedIn.jsp">
			<input type="submit" value="back">
		</form>
		
		<h1>Buy Me</h1>
		<h4>Auction #<%= request.getParameter("aID") %></h4>
		
		<%
		
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String aID = request.getParameter("aID");

			String insert = "SELECT a.aID, c.name, a.initPrice, a.closeDateTime, b.username, b.price, " +
							"c.category, c.brand, c.material, c.color, c.size, a.isActive, a.username " +
							"FROM auction a " +
							"JOIN sells s USING (aID) " +
							"JOIN clothes c USING (itemID) " +
							"JOIN (SELECT t.aID aID, t.username username, t.price price " +
								  "FROM bids t " +
							      "WHERE t.price = (SELECT max(t2.price) " +
												   "FROM bids t2 " +
					                		       "WHERE t2.aID = t.aID " +
					                			   "GROUP BY t2.aID)) b USING (aID) " +
							"WHERE a.aID = ? " +
							"UNION " +
							"SELECT a.aID, c.name, a.initPrice, a.closeDateTime, 'No Bidder Yet' username, 'No Bid Yet' price, " +
							"c.category, c.brand, c.material, c.color, c.size, a.isActive, a.username " +
							"FROM auction a " +
							"JOIN sells s USING (aID) " +
							"JOIN clothes c USING (itemID) " +
							"WHERE a.aID = ? " +
							"AND a.aID NOT IN (SELECT DISTINCT aID FROM bids)";
			                                                                      
			PreparedStatement ps = connect.prepareStatement(insert);     
			ps.setString(1, aID);
			ps.setString(2, aID);
			
			ResultSet results = ps.executeQuery();
			
			boolean isActive = false;
			String buyer = "", price = "", category = "", seller = "";
			
			if(results.next()) {
				isActive = results.getBoolean(12);
				seller = results.getString(13);
				if(!isActive) {
					String insert2 = "SELECT b.username, b.price, a.aID " +
									"FROM bought b " +
									"JOIN sells s USING (itemID) " +
									"JOIN auction a USING (aID) " +
									 "WHERE aID = ? " +
									 "UNION " +
									 "SELECT 'No Buyer' username, 'Not Sold' price, aID " +
									 "FROM auction " +
									 "WHERE aID = ? " +
									 "AND aID NOT IN (SELECT DISTINCT aID FROM bought)";
					
					PreparedStatement ps2 = connect.prepareStatement(insert2);     
					ps2.setString(1, aID);
					ps2.setString(2, aID);
					
					ResultSet results2 = ps2.executeQuery();
					
					if(results2.next()) {
						buyer = results2.getString(1);
						price = results2.getString(2);
					} else {
						out.println("<h4>Error: Inactive auction not found.</h4>");
					}
					
					ps2.close();
					results2.close();
				}
			} else {
				out.println("<h4>Error: Auction not found.</h4>");
			}
			results.previous();
		%>
			<p>General Information:</p>
			<table>
				<% if (results.next()) { %>
					<tr>    
						<td style="font-weight: bold;">aID:</td>
						<td><%= results.getString(1) %></td>
					</tr>
					<tr>    
						<td style="font-weight: bold;">Name:</td>
						<td><%= results.getString(2) %></td>
					</tr>
					<tr>    
						<td style="font-weight: bold;">Initial Price:</td>
						<td><%= results.getString(3) %></td>
					</tr>
					<tr>    
						<td style="font-weight: bold;">Closing Time:</td>
						<td><%= results.getString(4) %></td>
					</tr>
					<tr>
						<% if(isActive) { %>    
							<td style="font-weight: bold;">Current Bidder:</td>
							<td><%= results.getString(5) %></td>
						<% } else { %>
							<td style="font-weight: bold;">Buyer:</td>
							<td><%= buyer %></td>
						<% } %>
					</tr>
					<tr>
						<% if(isActive) { %>    
							<td style="font-weight: bold;">Current Bid:</td>
							<td><%= results.getString(6) %></td>
						<% } else { %>
							<td style="font-weight: bold;">Selling Price:</td>
							<td><%= price %></td>
						<% } %>
					</tr>
				<% } else { %>
					<tr>
						<td colspan="2" style="text-align: center;">Invalid Auction</td>
					</tr>
				<% } %>
			</table>
			
			<p>Item Information:</p>
			<table>
				<% results.previous(); 
				if (results.next()) { %>
					<tr>    
						<td style="font-weight: bold;">Category:</td>
						<% category = results.getString(7);
						if (category != null) { %>
							<td><%= results.getString(7) %></td>
						<% } else { %>
							<td>Not Specified</td>
						<% } %>
					</tr>
					<tr>    
						<td style="font-weight: bold;">Brand:</td>
						<% if (results.getString(8) != null) { %>
							<td><%= results.getString(8) %></td>
						<% } else { %>
							<td>Not Specified</td>
						<% } %>
					</tr>
					<tr>    
						<td style="font-weight: bold;">Material:</td>
						<% if (results.getString(9) != null) { %>
							<td><%= results.getString(9) %></td>
						<% } else { %>
							<td>Not Specified</td>
						<% } %>
					</tr>
					<tr>    
						<td style="font-weight: bold;">Color:</td>
						<% if (results.getString(10) != null) { %>
							<td><%= results.getString(10) %></td>
						<% } else { %>
							<td>Not Specified</td>
						<% } %>
					</tr>
					<tr>    
						<td style="font-weight: bold;">Size:</td>
						<% if (results.getString(11) != null) { %>
							<td><%= results.getString(11) %></td>
						<% } else { %>
							<td>Not Specified</td>
						<% } %>
					</tr>
				<% } else { %>
					<tr>
						<td colspan="2" style="text-align: center;">Invalid Auction</td>
					</tr>
				<% }
				
				ps.close();
				results.close();
				
	// LISTING CATEGORY SPECIFIC FEATURES
	
				if (category.equalsIgnoreCase("hats")) {
					String insert_temp = "SELECT * " +
									   "FROM sells " +
									   "JOIN hats USING (itemID) " +
									   "WHERE aID = ?";
					
					PreparedStatement ps_temp = connect.prepareStatement(insert_temp);     
					ps_temp.setString(1, aID);
					
					ResultSet results_temp = ps_temp.executeQuery();
					ResultSetMetaData resultsMD = results_temp.getMetaData();
					int numCol = resultsMD.getColumnCount();
					
					if(results_temp.next()) {
						for(int i = 3; i <= numCol; i++) { %>
							<tr>    
								<td style="font-weight: bold;"><%= resultsMD.getColumnName(i) %>:</td>
								<% if (results_temp.getString(i) != null) { %>
									<td><%= results_temp.getString(i) %></td>
								<% } else { %>
									<td>Not Specified</td>
								<% } %>
							</tr>
				<% 		}
					}
					
					ps_temp.close();
					results_temp.close();

				} else if (category.equalsIgnoreCase("lowers")) {
					String insert_temp2 = "SELECT * " +
									   "FROM sells " +
									   "JOIN lowers USING (itemID) " +
									   "WHERE aID = ?";
					
					PreparedStatement ps_temp2 = connect.prepareStatement(insert_temp2);     
					ps_temp2.setString(1, aID);
					
					ResultSet results_temp2 = ps_temp2.executeQuery();
					ResultSetMetaData resultsMD2 = results_temp2.getMetaData();
					int numCol2 = resultsMD2.getColumnCount();
					
					if(results_temp2.next()) {
						for(int i = 3; i <= numCol2; i++) { %>
							<tr>    
								<td style="font-weight: bold;"><%= resultsMD2.getColumnName(i) %>:</td>
								<% if (results_temp2.getString(i) != null) { %>
									<td><%= results_temp2.getString(i) %></td>
								<% } else { %>
									<td>Not Specified</td>
								<% } %>
							</tr>
				<% 		}
					}
					
					ps_temp2.close();
					results_temp2.close();

				} else if (category.equalsIgnoreCase("shirts")) {
					String insert_temp3 = "SELECT * " +
									   "FROM sells " +
									   "JOIN shirts USING (itemID) " +
									   "WHERE aID = ?";
					
					PreparedStatement ps_temp3 = connect.prepareStatement(insert_temp3);     
					ps_temp3.setString(1, aID);
					
					ResultSet results_temp3 = ps_temp3.executeQuery();
					ResultSetMetaData resultsMD3 = results_temp3.getMetaData();
					int numCol3 = resultsMD3.getColumnCount();
					
					if(results_temp3.next()) {
						for(int i = 3; i <= numCol3; i++) { %>
							<tr>    
								<td style="font-weight: bold;"><%= resultsMD3.getColumnName(i) %>:</td>
								<% if (results_temp3.getString(i) != null) { %>
									<td><%= results_temp3.getString(i) %></td>
								<% } else { %>
									<td>Not Specified</td>
								<% } %>
							</tr>
				<% 		}
					}
					
					ps_temp3.close();
					results_temp3.close();

				} else if (category.equalsIgnoreCase("shoes")) {
					String insert_temp4 = "SELECT * " +
									   "FROM sells " +
									   "JOIN shoes USING (itemID) " +
									   "WHERE aID = ?";
					
					PreparedStatement ps_temp4 = connect.prepareStatement(insert_temp4);     
					ps_temp4.setString(1, aID);
					
					ResultSet results_temp4 = ps_temp4.executeQuery();
					ResultSetMetaData resultsMD4 = results_temp4.getMetaData();
					int numCol4 = resultsMD4.getColumnCount();
					
					if(results_temp4.next()) {
						for(int i = 3; i <= numCol4; i++) { %>
							<tr>    
								<td style="font-weight: bold;"><%= resultsMD4.getColumnName(i) %>:</td>
								<% if (results_temp4.getString(i) != null) { %>
									<td><%= results_temp4.getString(i) %></td>
								<% } else { %>
									<td>Not Specified</td>
								<% } %>
							</tr>
				<% 		}
					}
					
					ps_temp4.close();
					results_temp4.close();

				} else if (category.equalsIgnoreCase("socks")) {
					String insert_temp5 = "SELECT * " +
									   "FROM sells " +
									   "JOIN socks USING (itemID) " +
									   "WHERE aID = ?";
					
					PreparedStatement ps_temp5 = connect.prepareStatement(insert_temp5);     
					ps_temp5.setString(1, aID);
					
					ResultSet results_temp5 = ps_temp5.executeQuery();
					ResultSetMetaData resultsMD5 = results_temp5.getMetaData();
					int numCol5 = resultsMD5.getColumnCount();
					
					if(results_temp5.next()) {
						for(int i = 3; i <= numCol5; i++) { %>
							<tr>    
								<td style="font-weight: bold;"><%= resultsMD5.getColumnName(i) %>:</td>
								<% if (results_temp5.getString(i) != null) { %>
									<td><%= results_temp5.getString(i) %></td>
								<% } else { %>
									<td>Not Specified</td>
								<% } %>
							</tr>
				<% 		}
					}
					
					ps_temp5.close();
					results_temp5.close();
				}
				%>
			</table>
			
			<!-- View Bid History, Bid on this Item, View Similar Items -->
			<p>User Options:</p>
			<table>
				<tr>
					<% if (!seller.equals(session.getAttribute("user").toString())) { %>
						<td>
							<form action="IndividualAuctionWinner.jsp" method="post">
						        <input type="hidden" name="aID" value="<%= aID %>"/>
						        <input type="submit" value="Bid on Item" />
						    </form>
						</td>
					<% } %>
					<td>
						<form action="BidHistory.jsp" method="post">
					        <input type="hidden" name="aID" value="<%= aID %>"/>
					        <input type="submit" value="View Bid History" />
					    </form>
					</td>
					<td>
						<form action="SimilarItems.jsp" method="post">
					        <input type="hidden" name="aID" value="<%= aID %>"/>
					        <input type="submit" value="View Similar Items" />
					    </form>
					</td>
				</tr>
			</table>
		<%	
			connect.close();
			
		} catch (Exception e) {
			
			out.println(e);
			
		}
		%>
		
	</body>
</html>