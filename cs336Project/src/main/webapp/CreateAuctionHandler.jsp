<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
import java.sql.Date;
<%@ page import = "java.util.Date,java.text.SimpleDateFormat,java.text.ParseException"%>

<%
	String url = "jdbc:mysql://localhost:3306/auctionproject";
	Connection conn = null;
	PreparedStatement ps = null;
	PreparedStatement ps1 = null;
	PreparedStatement pshat = null;
	ResultSet rs = null;
	ResultSet rs1 = null;
	ResultSet rshat = null;
	
	int initPrice;
	int minPrice;
	int minIncrement;
	
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		conn = DriverManager.getConnection(url, "root", "Daniel123909@");
		
		// Get the parameters from the clothes request
		String name = request.getParameter("name");
		String category = request.getParameter("category");
		String brand = request.getParameter("brand");
		String size = request.getParameter("size");		
		String material = request.getParameter("material");
		String color = request.getParameter("color");
		//float minPrice = Float.parseFloat(request.getParameter("min_price"));
		//float startingPrice = Float.parseFloat(request.getParameter("starting_price"));
		//String endDate = request.getParameter("end_datetime");
		
		// for auction table
		initPrice = Integer.parseInt(request.getParameter("initPrice"));
		minPrice = Integer.parseInt(request.getParameter("minPrice"));
		minIncrement = Integer.parseInt(request.getParameter("minIncrement"));
		String close = request.getParameter("date");
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
		java.util.Date date = sdf.parse(close);
		java.sql.Date closeDate = new java.sql.Date(date.getTime());
		String username = session.getAttribute("user").toString();
		
		String hats_type = request.getParameter("hats_type");
		
		
		
		// Make sure all the fields are entered
		if(category != null  && !category.isEmpty()
				&& brand != null && !brand.isEmpty() 
				&& size != null && !size.isEmpty()
				&& material != null && !material.isEmpty()
				&& color != null && !color.isEmpty() 
				&& initPrice != 0
				&& minPrice != 0
				&& minIncrement != 0){
			
		// Build the SQL query with placeholders for parameters
			String item = "INSERT INTO Clothes (name, category, brand, material, size, color)"
					+ "VALUES(?, ?, ?, ?, ?, ?)";
			ps = conn.prepareStatement(item, Statement.RETURN_GENERATED_KEYS);
			
			//auction
			String auction = "INSERT INTO Auction (initPrice, minIncrement, closeDateTime, isActive, minPrice, username)"
					+ "VALUES(?,?,?,?,?,?)";
			ps1 = conn.prepareStatement(auction, Statement.RETURN_GENERATED_KEYS);
		
			// Add parameters to query
			ps.setString(1, name);
			ps.setString(2, category);
			ps.setString(3, brand);
			ps.setString(4, material);
			ps.setString(5, size);
			ps.setString(6, color);			
			
			//auction
			ps1.setInt(1, initPrice);
			ps1.setInt(2, minIncrement);
			ps1.setDate(3, closeDate);
			ps1.setInt(4, 1);
			ps1.setInt(5, minPrice);
			ps1.setString(6, username);
			
			
			int result = 0;
			int result1 = 0;
	        result = ps.executeUpdate();
	        result1 = ps1.executeUpdate();
	        if (result < 1 && result1 < 1) {
	        	out.println("Error: Auction creation failed.");
	        } else {
	        	rs = ps.getGeneratedKeys();
	        	rs.next();
	        	int itemID = rs.getInt(1);
	        	int aID = itemID;
	        	

				
	        	response.sendRedirect("AuctionInfo.jsp?aID=" + aID); //success
	        	return;
	        }
		} else {
			response.sendRedirect("createAuctionError.jsp"); //error
			return;
		}
	} catch(Exception e) {
        response.sendRedirect("createAuctionError.jsp"); // MySql error such as Start Date before End Date
        e.printStackTrace();
    } finally {
        try { ps.close(); } catch (Exception e) {}
        try { ps1.close(); } catch (Exception e) {}
        try { conn.close(); } catch (Exception e) {}
    }
%>