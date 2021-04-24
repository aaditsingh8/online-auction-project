<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BuyMe - Create Auction</title>
<link rel="stylesheet" href="style.css?v=1.0" />
</head>
<body>
	<% if(session.getAttribute("user") == null) {
    	 	response.sendRedirect("LoginPage.jsp");
        } else { %>
	<%@ include file="NavBar.jsp"%>
	<div class="content">
		<form action="CreateAuctionHandler.jsp" method="POST">
			<h2>Auction Info</h2>
			<label for="name">Name</label>
			<input type="text" name="name" id="name" placeholder="Enter name" required> <br>
			<table>
				<tr><td>Enter closing date :</td> <td><input type = "datetime" name = "date" placeholder = "dd-MM-yyyy hh:mm:ss" required></td><tr>
			</table>
			<label for="minPrice">Minimum Price (hidden from bidders)</label>
			<input type="number" step="0.01" name="minPrice" placeholder="0.00" min="0.00" required> <br>	
			<label for="initPrice">Initial Bid Price</label>
			<input type="number" step="0.01" name="initPrice" placeholder="0.00" min="0.00" required> <br>
			<label for="minIncrement">Minimum Price Increment</label>
			<input type="number" step="0.01" name="minIncrement" placeholder="0.00" min="0.00" required> <br>	
			<h2>Item Info</h2>
			
	    	
			<label for="Brand">Brand</label>
			<input type="text" name="brand" id="brand" placeholder="Enter brand name" required> <br>
			
			<br> 
			<label for="Size">Size</label>
			<input type="text" name="size" id="size" placeholder="Enter size" required> <br>
			<br>
			 
			<label for="Material">Material</label>
			<input type="text" name="material" id="material" placeholder="Enter material name" required> <br>
			
			<br>
			<label for="Color">Color</label>
			<input type="text" name="color" id="color" placeholder="Enter color name" required> <br>
			<br>
			
				<table>
					<thead>
						<tr>
							<th colspan="2"><input type="radio" name="category" value="hats"/>Hats</th>
							<th colspan="2"><input type="radio" name="category" value="lower"/>Lowers</th>
							<th colspan="2"><input type="radio" name="category" value="shirt"/>Shirts</th>
							<th colspan="2"><input type="radio" name="category" value="shoes"/>Shoes</th>
							<th colspan="2"><input type="radio" name="category" value="socks"/>Socks</th>
							<th colspan="2"><input type="radio" name="category" value="other"/>Other</th>
						</tr>
					</thead>
					<tr>
						<td>Type:</td>
						<td><input type="text" name="hats_type" size="15"/></td>
						<td>Length:</td>
						<td><input type="text" name="lowers_length" size="15"/></td>
						<td>Neckline:</td>
						<td><input type="text" name="shirts_neckline" size="15"/></td>
						<td>Laces:</td>
						<td><input type="text" name="shoes_laces" size="15"/></td>
						<td>Length:</td>
						<td><input type="text" name="socks_length" size="15"/></td>
						<td>Category:</td>
						<td><input type="text" name="other_category" size="15"/></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td>Buttons:</td>
						<td><input type="text" name="shirts_buttons" size="15"/></td>
						<td>Heels:</td>
						<td><input type="text" name="shoes_heels" size="15"/></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td>Sleeves:</td>
						<td><input type="text" name="shirts_sleeves" size="15"/></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</table>

			<input type="submit" value="Submit">
		</form>
	</div>
	<% } %>
</body>
</html>