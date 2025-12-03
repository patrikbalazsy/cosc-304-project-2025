<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Get the current list of products from session safely
    Object sessionCart = session.getAttribute("productList");
    HashMap<String, ArrayList<Object>> productList = null;

    // Check if the existing cart is the correct type (HashMap). 
    // If it's null OR an old ArrayList version, create a new HashMap.
    if (sessionCart instanceof HashMap) {
        productList = (HashMap<String, ArrayList<Object>>) sessionCart;
    } else {
        productList = new HashMap<String, ArrayList<Object>>();
    }

    // Get product information from URL parameters
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String price = request.getParameter("price");
    
    // Default quantity is 1
    Integer quantity = 1;

    // Check if product already exists in the cart
    if (productList.containsKey(id)) {
        // Product exists: Retrieve it and increment quantity
        ArrayList<Object> product = productList.get(id);
        
        // Quantity is at index 3
        int curAmount = (Integer) product.get(3);
        product.set(3, curAmount + 1);
    } else {
        // New product: Create list and add to map
        ArrayList<Object> product = new ArrayList<Object>();
        product.add(id);        // Index 0
        product.add(name);      // Index 1
        product.add(price);     // Index 2
        product.add(quantity);  // Index 3
        
        productList.put(id, product);
    }

    // Save updated list back to session
    session.setAttribute("productList", productList);

    // Redirect to cart
    response.sendRedirect("showcart.jsp");
%>