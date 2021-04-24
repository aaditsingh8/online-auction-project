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
		<script>			
			function ifOther(form){
				var flag = true;
				if(!!(form.category.value === 'other' & form.categoryOther.value.length === 0)){
					alert('Please enter your custom category value in the "other" option or choose "any".')
					flag = false;
				}
				if(!!(form.brand.value === 'other' & form.brandOther.value.length === 0)){
					alert('Please enter your custom brand value in the "other" option or choose "any".')
					flag = false;
				} 
				if(!!(form.material.value === 'other' & form.materialOther.value.length === 0)){
					alert('Please enter your custom material value in the "other" option or choose "any".')
					flag = false;
				}
				if(!!(form.color.value === 'other' & form.colorOther.value.length === 0)){
					alert('Please enter your custom color value in the "other" option or choose "any".')
					flag = false;
				}
				if(!!(form.size.value === 'other' & form.sizeOther.value.length === 0)){
					alert('Please enter your custom size value in the "other" option or choose "any".')
					flag = false;
				}
				return flag;
			}
			
			function notOther(form){
				var flag = true;
				if(!!(form.category.value !== 'other' & form.categoryOther.value.length > 0)){
					alert('You cannot type your own category if you have preselected aother category.')
					flag = false;
				}
				if(!!(form.brand.value !== 'other' & form.brandOther.value.length > 0)){
					alert('You cannot type your own brand if you have selected "any" brand.')
					flag = false;
				}
				if(!!(form.material.value !== 'other' & form.materialOther.value.length > 0)){
					alert('You cannot type your own material if you have selected "any" material.')
					flag = false;
				}
				if(!!(form.color.value !== 'other' & form.colorOther.value.length > 0)){
					alert('You cannot type your own color if you have selected "any" color.')
					flag = false;
				}
				if(!!(form.size.value !== 'other' & form.sizeOther.value.length > 0)){
					alert('You cannot type your own size if you have selected "any" size.')
					flag = false;
				}
				return flag;
			}
		</script>
		
		<form action="LoggedIn.jsp">
	        <input type="submit" value="back" />
	    </form>
		
		<h1>Buy Me</h1>
		<form method="post" action="Result.jsp" onsubmit="return !!(ifOther(this) & notOther(this));">
			<table>
				<tr>
					<td>Find:</td>
					<td colspan="2">
						<% if(request.getParameter("search") != null) { %>
							<input type="search" name="search" placeholder="browse auctions..." size="100" value="<%= request.getParameter("search") %>" />
						<% } else { %>
							<input type="search" name="search" placeholder="browse auctions..." size="100" />
						<% } %>
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="text-align: right;">
						<input type="reset" value="reset" size="15"/>
						<input type="submit" value="search" size="15"/>
					</td>
				</tr>
			</table>
			
			Use Buy Me's advanced browsing methods to find the items of your choice.<br>
			Search with keywords separated by spaces ' ' to find auctions with the desired keywords.<br>
			The following parameters are set to "any" by default, you can customize those to specialize your searches.<br>
			You can leave the search bar empty to search based on the parameters below only.<br><br>
			
	    	<table>
	    		<thead>
	    			<tr>
	    				<th colspan="3">Category</th>
	    			</tr>
	    		</thead>
				<tr>
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
					<td>Other:</td> <td><input type="text" name="categoryOther" placeholder="custom..." size="20" /></td>
				</tr>
			</table>
			
			<br>
			
	    	
			<table>
	    		<thead>
	    			<tr>
	    				<th colspan="3">Brand</th>
	    			</tr>
	    		</thead>
				<tr>
					<td>
						<select name="brand" required>
							<option selected="selected">any</option>
							<option>other</option>
						</select>
					</td>
					<td>Other:</td> <td><input type="text" name="brandOther" placeholder="custom..." size="20" /></td>
				</tr>
			</table>
			
			<br>
			
	    		
			<table>
	    		<thead>
	    			<tr>
	    				<th colspan="3">Material</th>
	    			</tr>
	    		</thead>
				<tr>
					<td>
						<select name="material" required>
							<option selected="selected">any</option>
							<option>other</option>
						</select>
					</td>
					<td>Other:</td> <td><input type="text" name="materialOther" placeholder="custom..." size="20" /></td>
				</tr>
			</table>
			
			<br>
			
	    	
			<table>
	    		<thead>
	    			<tr>
	    				<th colspan="3">Color</th>
	    			</tr>
	    		</thead>
				<tr>
					<td>
						<select name="color" required>
							<option selected="selected">any</option>
							<option>other</option>
						</select>
					</td>
					<td>Other:</td> <td><input type="text" name="colorOther" placeholder="custom..." size="20" /></td>
				</tr>
			</table>
			
			<br>
			
	    	
			<table>
	    		<thead>
	    			<tr>
	    				<th colspan="3">Size</th>
	    			</tr>
	    		</thead>
				<tr>
					<td>
						<select name="size" required>
							<option selected="selected">any</option>
							<option>other</option>
						</select>
					</td>
					<td>Other:</td> <td><input type="text" name="sizeOther" placeholder="custom..." size="20" /></td>
				</tr>
			</table>
	    </form>
				
	</body>
</html>