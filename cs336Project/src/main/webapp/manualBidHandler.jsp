<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import = "java.util.Date,java.text.SimpleDateFormat,java.text.ParseException"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>

<%

	String url = "jdbc:mysql://localhost:3306/auctionproject";
	PreparedStatement ps = null;
	ResultSet rs = null;
	int bid;
	int minIncrement=0;
	int highestBid = 0; 
	try {
		ApplicationDB database = new ApplicationDB();
		Connection connect = database.getConnection();
		
		// Get the parameters from the manualbid request
		bid = Integer.parseInt(request.getParameter("bid"));
		String aID = request.getParameter("aID");
		
		//get minincrement
		String min = "SELECT a.aID, a.minIncrement FROM auction a WHERE a.aID = ?;";
		PreparedStatement ps1 = connect.prepareStatement(min);    
		ps1.setString(1,aID);
		ResultSet results1 = ps1.executeQuery();
		if(results1.next()) {
			minIncrement = results1.getInt(2);
			//System.out.println(minIncrement);
		}
		else {
			out.println("error");
		}
		
		ps1.close();
		results1.close();
		
		//get highest bid
		String insert = "select max(b.price) from bids b join auction a on b.aid = a.aid where b.aid = ?;";
		PreparedStatement ps2 = connect.prepareStatement(insert);    
		ps2.setString(1,aID);
		ResultSet results = ps2.executeQuery();
		
		if(results.next()) {
			highestBid = results.getInt(1);		
			//System.out.println(highestBid)
		}
		else {
			out.println("<h4>Error: Inactive auction not found.</h4>");
		}
		ps2.close();

		
		
		
		if (bid <= highestBid){
			%>
			<p>Please enter a bid higher than <%=highestBid%></p>
			<form action="BidOnAuction.jsp">
					<input type="hidden" name="aID" value="<%= aID%>"/>
					<input type="submit" value="Re-enter values">
				</form>	
			<%
		} else if (bid < minIncrement+highestBid) {
			%>
			<p>Please enter a bid higher than the minimum price increment: <%=minIncrement%></p>
			<form action="BidOnAuction.jsp">
					<input type="hidden" name="aID" value="<%= aID%>"/>
					<input type="submit" value="Re-enter values">
				</form>	
			<%
		}
		else {
			// Make sure all the fields are entered
			
			// Build the SQL query with placeholders for parameters
				String bidVal = "INSERT INTO Bids (aID, username, price, timestamp)"
						+ "VALUES (?, ?, ?, ?)";
				ps = connect.prepareStatement(bidVal, Statement.RETURN_GENERATED_KEYS);
				
			
				// Add parameters to query
				ps.setString(1, aID);
				ps.setString(2, (String)session.getAttribute("user"));
				ps.setInt(3, bid);
				ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
				
				
				
				int result = 0;
				
		        result = ps.executeUpdate();
				results.close();
				
		        if (result < 1) {
		        	out.println("Error: Bid failed.");
		        } else {
		        	//rs = ps.getGeneratedKeys();
		        	//rs.next();
		        	//int itemID = rs.getInt(1);
		        	
			        AutoBids.updateAutoBids(database, connect, aID, bid, false);

		        	response.sendRedirect("AuctionInfo.jsp?aID=" + aID); //success

		        	return;
		        }
		}
		
	} catch(Exception e) {
		e.printStackTrace(); 
    }
%>