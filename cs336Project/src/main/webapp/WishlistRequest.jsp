<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Wishlist Request</title>

	</head>
	<body>
	<% 
		try{
			
			ApplicationDB database = new ApplicationDB();
			Connection connect = database.getConnection();
			
			String username = session.getAttribute("user").toString();
			
			// GATHERING WISHLIST ITEM DATA
			
			String[] params = {"", "", "", "", "", ""};
			String[] names = {"category", "name", "brand", "material", "color", "size"};
			
			if(request.getParameter("category").equalsIgnoreCase("other")) {
				params[0] = request.getParameter("categoryOther").toString();
			} else if (request.getParameter("category").equalsIgnoreCase("any")){
				params[0] = null;
			} else {
				params[0] = request.getParameter("category").toString();
			}
			
			for(int i = 1; i < 6; i++) {
				if (request.getParameter(names[i]).equalsIgnoreCase("")){
					params[i] = null;
				} else {
					params[i] = request.getParameter(names[i]).toString();
				}
			}
			
			// FINDING ITEM NUMBER
			
			String query = "SELECT username, max(itemNum) FROM wishlist WHERE username = '" + username + "' GROUP BY username";
			
			PreparedStatement ps = connect.prepareStatement(query);
			ResultSet results = ps.executeQuery();
			
			int itemNum = 0;
			if(results.next()) {
				itemNum = Integer.parseInt(results.getString(2));
			}
			itemNum++;
			
			ps.close();
			results.close();
			
			// CREATING STRING FOR QUERY
			
			String insert = "INSERT INTO wishlist ";
			String names_list = "(username, itemNum";
			String values_list = "('" + username + "', " + itemNum;
			
			for(int i = 0; i < 6; i++) {
				if(params[i] != null) {
					names_list += ", " + names[i];
					values_list += ", '" + params[i] + "'";
				}
			}
			names_list += ")";
			values_list += ")";
			
			insert += names_list + " VALUES " + values_list;
			
			PreparedStatement stmt = connect.prepareStatement(insert);
			stmt.executeUpdate();

			stmt.close();
			connect.close();
			
			response.sendRedirect("Wishlist.jsp");
			
		} catch (Exception e){
			
			out.println(e);
			
		}
	%>			
	</body>
</html>