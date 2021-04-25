<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import = "java.util.Date,java.text.SimpleDateFormat,java.text.ParseException"%>

<%
	String url = "jdbc:mysql://localhost:3306/auctionproject";
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	float bid;
	float minIncrement=0.0f;
	
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		conn = DriverManager.getConnection(url, "root", "Daniel123909@");
		
		// Get the parameters from the manualbid request
		bid = Float.parseFloat(request.getParameter("bid"));
		String aID = request.getParameter("aID");
		
		//get minincrement
		String min = "SELECT a.aID, a.minIncrement FROM auction a WHERE a.aID = ?;";
		PreparedStatement ps1 = conn.prepareStatement(min);    
		ps1.setString(1,aID);
		ResultSet results1 = ps1.executeQuery();
		if(results1.next()) {
			minIncrement = results1.getFloat(2);
			//System.out.println(minIncrement);
		}
		else {
			out.println("error");
		}
		
		ps1.close();
		results1.close();
		
		//get highest bid
		String insert = "select max(b.price) from bids b join auction a on b.aid = a.aid where b.aid = ?;";
		PreparedStatement ps2 = conn.prepareStatement(insert);    
		ps2.setString(1,aID);
		ResultSet results = ps2.executeQuery();
		float highestBid = 0; 
		if(results.next()) {
			highestBid = results.getFloat(1);		
			//System.out.println(highestBid)
		}
		else {
			out.println("<h4>Error: Inactive auction not found.</h4>");
		}
		ps2.close();
		results.close();
		
		
		
		if (bid <= highestBid){
			%>
			<p>Please enter a bid higher than <%=highestBid%></p>
			<form action="BidOnAuction.jsp">
					<input type="hidden" name="aID" value="<%= aID%>"/>
					<input type="submit" value="Re-enter values">
				</form>	
			<%
		} else if (bid < minIncrement) {
			%>
			<p>Please enter a bid higher than the Minimum price Increment: <%=minIncrement%></p>
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
				ps = conn.prepareStatement(bidVal, Statement.RETURN_GENERATED_KEYS);
				
			
				// Add parameters to query
				ps.setString(1, aID);
				ps.setString(2, (String)session.getAttribute("user"));
				ps.setFloat(3, bid);
				ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
				
				
				
				int result = 0;
				
		        result = ps.executeUpdate();
		        if (result < 1) {
		        	out.println("Error: Bid failed.");
		        } else {
		        	//rs = ps.getGeneratedKeys();
		        	//rs.next();
		        	//int itemID = rs.getInt(1);
		        	
		        	

					
		        	response.sendRedirect("AuctionInfo.jsp?aID=" + aID); //success
		        	return;
		        }
		}
		
		
		
		
	} catch(Exception e) {
        response.sendRedirect("---.jsp"); // MySql error such as Start Date before End Date
        e.printStackTrace();
    } finally {
        try { ps.close(); } catch (Exception e) {}
        try { conn.close(); } catch (Exception e) {}
    }
%>