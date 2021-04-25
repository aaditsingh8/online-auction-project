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
	PreparedStatement psSell = null;
	PreparedStatement pslow = null;
	PreparedStatement pshirt = null;
	PreparedStatement pshoes = null;
	PreparedStatement psocks = null;
	ResultSet rs = null;
	
	float initPrice;
	float minPrice;
	float minIncrement;
	//int lowers_length;
	
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		conn = DriverManager.getConnection(url, "root", "Daniel123909@");
		
		// Get the parameters from the clothes request
		String name = request.getParameter("name");
		//String category = request.getParameter("category");
		String brand = request.getParameter("brand");
		String size = request.getParameter("size");		
		String material = request.getParameter("material");
		String color = request.getParameter("color");
		//float minPrice = Float.parseFloat(request.getParameter("min_price"));
		//float startingPrice = Float.parseFloat(request.getParameter("starting_price"));
		//String endDate = request.getParameter("end_datetime");
		
		// for auction table
		initPrice = Float.parseFloat(request.getParameter("initPrice"));
		minPrice = Float.parseFloat(request.getParameter("minPrice"));
		minIncrement = Float.parseFloat(request.getParameter("minIncrement"));
		String close = request.getParameter("date");
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
		java.util.Date date = sdf.parse(close);
		java.sql.Date closeDate = new java.sql.Date(date.getTime());
		String username = session.getAttribute("user").toString();
		
		//subcats
		String hats_type = "";
		if(request.getParameter("hats_type").equalsIgnoreCase("") || request.getParameter("hats_type")==null) {
			hats_type = "NULL";
		}  else {
			hats_type = "'" + request.getParameter("hats_type") + "'" ;
		}
		String lowers_length = "";
		if(request.getParameter("lowers_length").equalsIgnoreCase("") || request.getParameter("lowers_length")==null) {
		      lowers_length = "NULL";
		}  else {
		      lowers_length = "'" + request.getParameter("lowers_length") + "'";
		}
		String shirts_neckline = "";
		if(request.getParameter("shirts_neckline").equalsIgnoreCase("") || request.getParameter("shirts_neckline")==null) {
			shirts_neckline = "NULL";
		}  else {
			shirts_neckline = "'" +  request.getParameter("shirts_neckline") + "'";
		}
		String shirts_buttons = "";
		if(request.getParameter("shirts_buttons").equalsIgnoreCase("") || request.getParameter("shirts_buttons")==null) {
			shirts_buttons = "NULL";
		}  else {
			shirts_buttons = "'" + request.getParameter("shirts_buttons") + "'";
		}
		String shirts_sleeves = "";
		if(request.getParameter("shirts_sleeves").equalsIgnoreCase("") || request.getParameter("shirts_sleeves")==null) {
			shirts_sleeves = "NULL";
		}  else {
			shirts_sleeves = "'" + request.getParameter("shirts_sleeves") + "'";
		}
		String shoes_laces = "";
		if(request.getParameter("shoes_laces").equalsIgnoreCase("") || request.getParameter("shoes_laces")==null) {
			shoes_laces = "NULL";
		}  else {
			shoes_laces = "'" + request.getParameter("shoes_laces") + "'";
		}
		String shoes_heels = "";
		if(request.getParameter("shoes_heels").equalsIgnoreCase("") || request.getParameter("shoes_heels")==null) {
			shoes_heels = "NULL";
		}  else {
			shoes_heels = "'" + request.getParameter("shoes_heels") + "'";
		}
		String socks_length = "";
		if(request.getParameter("socks_length").equalsIgnoreCase("") || request.getParameter("socks_length")==null) {
			socks_length = "NULL";
		}  else {
			socks_length = "'" + request.getParameter("socks_length") + "'";
		}
		String category = "";
        if(request.getParameter("category").equalsIgnoreCase("other")) {
            category = "'" + request.getParameter("other_category").toString() + "'";
        }  else {
            category = "'" + request.getParameter("category").toString() + "'";
        }
		
		
		// Make sure all the fields are entered
		if(category != null  && !category.isEmpty()
				&& brand != null && !brand.isEmpty() 
				
				
			
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
			ps1.setFloat(1, initPrice);
			ps1.setFloat(2, minIncrement);
			ps1.setDate(3, closeDate);
			ps1.setInt(4, 1);
			ps1.setFloat(5, minPrice);
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
	        	
	        	//sells table
	        	String sells = "INSERT INTO Sells (aID, itemID)"
						+ "VALUES(?,?)";
	        	psSell = conn.prepareStatement(sells, Statement.RETURN_GENERATED_KEYS);
	        	
	        	psSell.setInt(1, aID);
	        	psSell.setInt(2, itemID);
	        	
	        	int result2 = 0;
	        	result2 = psSell.executeUpdate();
	        	
	        	if (category.equalsIgnoreCase("hats")) { 
	        		//System.out.println(hats_type);
	        		String hats = "INSERT INTO Hats VALUES (" + itemID + ", " + hats_type + ")";
							
	        		pslow = conn.prepareStatement(hats, Statement.RETURN_GENERATED_KEYS);
	        		
	        		pslow.executeUpdate();
	        		
	        	} else if (category.equalsIgnoreCase("lowers")) {
                    
                    String pants = "INSERT INTO lowers VALUES (" + itemID + ", " + lowers_length + ")";
                    pshat = conn.prepareStatement(pants, Statement.RETURN_GENERATED_KEYS);
                    
                   pshat.executeUpdate();
                   
				} else if (category.equalsIgnoreCase("shirts")) {
                    
                    String shirts = "INSERT INTO shirts VALUES (" + itemID + ", " + shirts_neckline + ", " + shirts_buttons + ", " + shirts_sleeves + ")";
                    pshirt = conn.prepareStatement(shirts, Statement.RETURN_GENERATED_KEYS);
                    
                   pshirt.executeUpdate();
                   
				} else if (category.equalsIgnoreCase("shoes")) {
                    
                    String shoes = "INSERT INTO shoes VALUES (" + itemID + ", " + shoes_laces + ", " + shoes_heels + ")";
                    pshoes = conn.prepareStatement(shoes, Statement.RETURN_GENERATED_KEYS);
                    
                   pshoes.executeUpdate();
				} else if (category.equalsIgnoreCase("socks")) {
                    
                    String socks = "INSERT INTO socks VALUES (" + itemID + ", " + socks_length + ")";
                    psocks = conn.prepareStatement(socks, Statement.RETURN_GENERATED_KEYS);
                    
                   psocks.executeUpdate();
				}
	        	
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