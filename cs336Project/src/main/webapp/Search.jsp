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
			function checkSearch(form){
				if(form.search.value.length < 1){
					alert('Input should be at least one character.')
					return false;
				} else {
					return true;
				}
			}
			
			function ifOther(form){
				if(!!(form.category.value === 'other' & form.categoryOther.value.length === 0)){
					alert('Please enter your custom category value in the "other" option.')
					return false;
				} else if(!!(form.brand.value === 'other' & form.brandOther.value.length === 0)){
					alert('Please enter your custom brand value in the "other" option.')
					return false;
				} else if(!!(form.material.value === 'other' & form.materialOther.value.length === 0)){
					alert('Please enter your custom material value in the "other" option.')
					return false;
				} else if(!!(form.color.value === 'other' & form.colorOther.value.length === 0)){
					alert('Please enter your custom color value in the "other" option.')
					return false;
				} else if(!!(form.size.value === 'other' & form.sizeOther.value.length === 0)){
					alert('Please enter your custom size value in the "other" option.')
					return false;
				} else {
					return true;
				}
			}
			
			function notOther(form){
				if(!!(form.category.value !== 'other' & form.categoryOther.value.length > 0)){
					alert('You cannot type your own category if you have preselected aother category.')
					return false;
				} else if(!!(form.brand.value !== 'other' & form.brandOther.value.length > 0)){
					alert('You cannot type your own brand if you have selected "any" brand.')
					return false;
				} else if(!!(form.material.value !== 'other' & form.materialOther.value.length > 0)){
					alert('You cannot type your own material if you have selected "any" material.')
					return false;
				} else if(!!(form.color.value !== 'other' & form.colorOther.value.length > 0)){
					alert('You cannot type your own color if you have selected "any" color.')
					return false;
				} else if(!!(form.size.value !== 'other' & form.sizeOther.value.length > 0)){
					alert('You cannot type your own size if you have selected "any" size.')
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<form action="LoggedIn.jsp">
	        <input type="submit" value="back" />
	    </form>
		
		<h1>Buy Me</h1>
		<form method="post" action="Result.jsp" onsubmit="return !!(checkSearch(this) & ifOther(this) & notOther(this));">
			<table>
				<tr>
					<td>Find:</td>
					<td colspan="2"><input type="search" name="search" placeholder="browse auctions..." size="100" required /></td>
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
			The following parameters are set to "any" by default, you can customize those to specialize your searches.<br>
			Tune the parameters according to your wish and click on "search."<br><br>
			
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