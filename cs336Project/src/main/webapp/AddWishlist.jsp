<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Add to Wishlist</title>
		<style>
			td, th {
				padding: 5px;
			}
		</style>
	</head>
	<body>
		<script>			
			function checkSearch(form){
				if((form.category.value === 'any' &
						form.name.value.length === 0 &
						form.brand.value.length === 0 &
						form.material.value.length === 0 &
						form.color.value.length === 0 &
						form.size.value.length === 0)){
					alert('There should be at least one input.')
					return false;
				} else {
					return true;
				}
			}
			
			function ifOther(form){
				if(!!(form.category.value === 'other' & form.categoryOther.value.length === 0)){
					alert('Please enter your custom category value in the "other" option or choose "any".')
					return false;
				} else {
					return true;
				}
			}
			
			function notOther(form){
				if(!!(form.category.value !== 'other' & form.categoryOther.value.length > 0)){
					alert('You cannot type your own category if you have preselected aother category.')
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<form action="Wishlist.jsp">
	        <input type="submit" value="back" />
	    </form>
		
		<h1>Buy Me</h1>
		<h4>Add to your But Me Wishlist</h4>
		
		<form method="post" action="WishlistRequest.jsp" onsubmit="return !!(checkSearch(this) & ifOther(this) & notOther(this));">
			
			Add to your wishlist an item with one or more of these attributes.<br>
			Names are generally specific and can be left blank.<br>
			Categories are generally kept in plural form.<br>
			So can other attributes.<br><br>
	    	
	    	<table>
				<tr>
					<td style="font-weight:bold">Category:</td>
					<td>
						<select name="category" required>
							<option>hats</option>
							<option>lowers</option>
							<option>shirts</option>
							<option>shoes</option>
							<option>socks</option>
							<option selected="selected">any</option>
							<option>other</option>
						</select>
					</td>
					<td>Other:</td>
					<td><input type="text" name="categoryOther" placeholder="custom..." size="20" /></td>
				</tr>
				<tr>
					<td style="font-weight:bold">Name:</td>
					<td colspan="3"><input type="text" name="name" placeholder="optional..." size="20" /></td>
				</tr>
				<tr>
					<td style="font-weight:bold">Brand:</td>
					<td colspan="3"><input type="text" name="brand" placeholder="optional..." size="20" /></td>
				</tr>
				<tr>
					<td style="font-weight:bold">Material:</td>
					<td colspan="3"><input type="text" name="material" placeholder="optional..." size="20" /></td>
				</tr>
				<tr>
					<td style="font-weight:bold">Color:</td>
					<td colspan="3"><input type="text" name="color" placeholder="optional..." size="20" /></td>
				</tr>
				<tr>
					<td style="font-weight:bold">Size:</td>
					<td colspan="3"><input type="text" name="size" placeholder="optional..." size="20" /></td>
				</tr>
				<tr>
					<td><input type="reset" value="reset" size="15" /></td>
					<td><input type="submit" value="add to wishlist" size="15" /></td>
				</tr>
			</table>			
	    </form>
				
	</body>
</html>