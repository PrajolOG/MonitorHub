package com.MonitorHub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
// import jakarta.servlet.http.HttpSession; // Keep for later auth check
// import com.MonitorHub.model.User;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.MonitorHub.model.User;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminProductServlet.class.getName());
    private static final String VIEW = "/WEB-INF/pages/adminProducts.jsp"; // Correct path

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("AdminProductServlet doGet called.");

        // --- Authentication & Authorization Check (Placeholder - uncomment later) ---
        
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null || !"Admin".equalsIgnoreCase(loggedInUser.getRoleName())) {
            LOGGER.warning("Unauthorized access attempt to /admin/products.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // --- End Auth Check ---

        // --- Placeholder Data ---
        List<Map<String, Object>> products = new ArrayList<>();
        String defaultImageUrl = request.getContextPath() + "/images/defaultmonitor.png"; // Default image path

        // Sample Product 1
        Map<String, Object> product1 = new HashMap<>();
        product1.put("id", 101);
        // Using a real image URL placeholder for variety
        product1.put("imageUrl", "https://onlineit.com.np/wp-content/uploads/2024/02/1-13.jpg");
        product1.put("name", "Dell UltraSharp U2723QE");
        product1.put("brand", "Dell");
        product1.put("model", "U2723QE");
        product1.put("price", 599.99);
        product1.put("stock", 45);
        products.add(product1);

        // Sample Product 2
        Map<String, Object> product2 = new HashMap<>();
        product2.put("id", 102);
        product2.put("imageUrl", "https://i5.walmartimages.com/seo/SAMSUNG-49-Odyssey-G9-DQHD-240Hz-1ms-GtG-DisplayHDR-1000-Gaming-Monitor-LS49CG954ENXZA_7c9193fe-563e-4d44-90a8-dabc4d23171a.d7aae19d9f57bfa3922da3829921c456.jpeg"); // Another placeholder
        product2.put("name", "Samsung Odyssey G9 49\"");
        product2.put("brand", "Samsung");
        product2.put("model", "LC49G95T"); // Simplified model
        product2.put("price", 1199.00);
        product2.put("stock", 12);
        products.add(product2);

         // Sample Product 3 - Out of Stock (Using default image)
        Map<String, Object> product3 = new HashMap<>();
        product3.put("id", 103);
        product3.put("imageUrl", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjDxGsQUGtbGxG7x1dH6wnXvRoC0XOrNWsRw&s"); // Use default
        product3.put("name", "ASUS ROG Swift PG279QM");
        product3.put("brand", "ASUS");
        product3.put("model", "PG279QM");
        product3.put("price", 749.00);
        product3.put("stock", 0);
        products.add(product3);

         // Sample Product 4
         Map<String, Object> product4 = new HashMap<>();
         product4.put("id", 104);
         // Placeholder without a specific image URL, will trigger onerror in JSP
         product4.put("imageUrl", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6SW9RWAjMxBtA2_YUR3bR9o5Gt2ddO_kNmA&s"); // Example specific path
         product4.put("name", "LG 34WN80C-B UltraWide");
         product4.put("brand", "LG");
         product4.put("model", "34WN80C-B");
         product4.put("price", 549.99);
         product4.put("stock", 30);
         products.add(product4);

        // Set the product list as a request attribute
        request.setAttribute("products", products);
        LOGGER.log(Level.INFO, "Set {0} placeholder products in request attribute.", products.size());

        // Forward to the JSP view
        try {
            request.getRequestDispatcher(VIEW).forward(request, response);
            LOGGER.info("Forwarded request to " + VIEW);
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error forwarding to view: " + VIEW, e);
             if (!response.isCommitted()) {
                  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display the products page.");
             }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests later (e.g., for adding/deleting products)
        LOGGER.warning("AdminProductServlet doPost called - currently not implemented.");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported yet.");
    }
}