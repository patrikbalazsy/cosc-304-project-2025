<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	
    out.println("<h1>Your shopping cart is empty!</h1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h1>Your Shopping Cart</h1>");

    // UPDATED: Used 'order-table' class instead of inline pink background and border
	out.print("<table class='order-table'>");
    out.print("<tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th></tr>");

	double total = 0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
        // UPDATED: Removed 'align' attributes. CSS handles the padding/alignment now.
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		out.print("<td>"+product.get(3)+"</td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		

		out.print("<td>"+currFormat.format(pr)+"</td>");
		out.print("<td>"+currFormat.format(pr*qty)+"</td></tr>");
		total = total + pr*qty;
	}
    
    // UPDATED: Footer row for the total
	out.println("<tr><td colspan='4' style='text-align:right;'><b>Order Total</b></td>"
			+"<td>"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

    // The CSS automatically turns these links into buttons because they are inside <h2>
	out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
}
%>

<h2><a href="home.jsp">Continue Shopping</a></h2>

</body>
</html>