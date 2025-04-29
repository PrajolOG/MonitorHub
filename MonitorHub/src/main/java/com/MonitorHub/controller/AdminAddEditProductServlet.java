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
import java.math.BigDecimal; // For prices
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.MonitorHub.model.User;

// Map both add and edit URLs to this servlet
@WebServlet(urlPatterns = {"/admin/products/add", "/admin/products/edit"})
public class AdminAddEditProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminAddEditProductServlet.class.getName());
    private static final String VIEW = "/WEB-INF/pages/adminAddEditProduct.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Authentication & Authorization Check (Placeholder) ---
        
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (loggedInUser == null || !"Admin".equalsIgnoreCase(loggedInUser.getRoleName())) {
            LOGGER.warning("Unauthorized access attempt to /admin/products/add or /edit.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // --- End Auth Check ---

        String servletPath = request.getServletPath();
        String mode = "add"; // Default mode
        String pageTitle = "Add New Product";
        Map<String, Object> productData = null; // To hold product data for editing

        if ("/admin/products/edit".equals(servletPath)) {
            mode = "edit";
            pageTitle = "Edit Product";
            String productIdStr = request.getParameter("id");
            LOGGER.log(Level.INFO, "Edit mode requested for product ID: {0}", productIdStr);

            if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                try {
                    int productId = Integer.parseInt(productIdStr);
                    // --- Database Fetch Placeholder ---
                    // Replace this with actual DB call to get product by ID
                    productData = getPlaceholderProductData(productId, request.getContextPath());
                    if (productData == null) {
                        LOGGER.log(Level.WARNING, "Product not found for ID: {0}", productId);
                        request.setAttribute("errorMessage", "Product with ID " + productId + " not found.");
                        // Redirect or show error - redirecting back to list for now
                        response.sendRedirect(request.getContextPath() + "/admin/products");
                        return;
                    }
                    LOGGER.log(Level.INFO, "Loaded data for product: {0}", productData.get("name"));
                    request.setAttribute("product", productData); // Set fetched data for JSP
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid product ID format: {0}", productIdStr);
                    request.setAttribute("errorMessage", "Invalid product ID provided.");
                    response.sendRedirect(request.getContextPath() + "/admin/products");
                    return;
                }
                // --- End DB Fetch Placeholder ---
            } else {
                LOGGER.warning("Edit mode requested but no product ID provided.");
                request.setAttribute("errorMessage", "Product ID is required for editing.");
                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            }
        } else {
             LOGGER.info("Add mode requested.");
             // For add mode, productData remains null
        }

        // Set attributes for the JSP
        request.setAttribute("formMode", mode); // "add" or "edit"
        request.setAttribute("pageTitle", pageTitle);

        // Forward to the JSP
        try {
            request.getRequestDispatcher(VIEW).forward(request, response);
            LOGGER.info("Forwarding to view: " + VIEW);
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error forwarding to view: " + VIEW, e);
             if (!response.isCommitted()) {
                  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display the add/edit product page.");
             }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // --- Authentication & Authorization Check (Placeholder) ---

        LOGGER.info("doPost received for saving product.");
        // Read parameters (name, brand, model, desc, type, prices, stock, image, delivery...)
        String mode = request.getParameter("formMode"); // "add" or "edit"
        String productIdStr = request.getParameter("productId"); // Will be present in edit mode
        String name = request.getParameter("monitorName");
        // ... get other parameters ...
        String imageUrl = request.getParameter("imageUrl");


        // --- Validation (Add Server-Side Validation Here) ---
        LOGGER.info("Received data: Name=" + name + ", Mode=" + mode + ", ID=" + productIdStr + ", Image=" + imageUrl);


        // --- Database Interaction Placeholder ---
        boolean success = true; // Assume success for now
        LOGGER.warning("Database save/update logic not implemented yet.");
        // If 'add' mode: Insert into Monitors table, maybe Images and MonitorImages
        // If 'edit' mode: Update Monitors table where monitorid = productIdStr
        // --- End Database Interaction ---


        if (success) {
            LOGGER.info("Product save/update simulation successful. Redirecting to product list.");
             request.getSession().setAttribute("successMessage", "Product " + ("edit".equals(mode) ? "updated" : "added") + " successfully!");
             response.sendRedirect(request.getContextPath() + "/admin/products");
        } else {
            LOGGER.warning("Product save/update simulation failed.");
            // Repopulate form data and forward back to the JSP with error message
             request.setAttribute("errorMessage", "Failed to save product. Please try again.");
             request.setAttribute("formMode", mode);
             request.setAttribute("pageTitle", ("edit".equals(mode) ? "Edit Product" : "Add New Product"));
             // You'd need to re-set all the form parameters back into the request
             // request.setAttribute("product", mapWithSubmittedData); // Need to reconstruct
             try {
                 request.getRequestDispatcher(VIEW).forward(request, response);
             } catch (Exception e) {
                  LOGGER.log(Level.SEVERE, "Error forwarding back to view after failed save: " + VIEW, e);
             }
        }
    }

     // --- Helper Method for Placeholder Data ---
     private Map<String, Object> getPlaceholderProductData(int productId, String contextPath) {
         // Simulate fetching data for a specific product ID
         if (productId == 101) { // Example: Edit the Dell monitor
             Map<String, Object> product = new HashMap<>();
             product.put("id", 101);
             product.put("imageUrl", "https://m.media-amazon.com/images/I/71EokqNdrCL._AC_SL1500_.jpg");
             product.put("name", "Dell UltraSharp U2723QE");
             product.put("brand", "Dell");
             product.put("model", "U2723QE");
             product.put("description", "A high-quality 4K USB-C Hub monitor ideal for professionals.");
             product.put("type", "IPS");
             product.put("original_price", new BigDecimal("649.99")); // Example original price
             product.put("discounted_price", new BigDecimal("599.99"));
             product.put("stock_quantity", 45);
             product.put("delivery_info", "Ships in 1-2 business days");
             return product;
         } else if (productId == 102) {
             Map<String, Object> product = new HashMap<>();
             product.put("id", 102);
            product.put("imageUrl", "https://m.media-amazon.com/images/I/61SqR-3MAhL._AC_SL1500_.jpg");
            product.put("name", "Samsung Odyssey G9 49\"");
            product.put("brand", "Samsung");
            product.put("model", "LC49G95T"); // Simplified model
             product.put("description", "Super ultrawide curved gaming monitor with high refresh rate.");
             product.put("type", "QLED");
             product.put("original_price", new BigDecimal("1199.00"));
             product.put("discounted_price", null); // No discount
             product.put("stock_quantity", 12);
             product.put("delivery_info", "Check availability");
             return product;
         }
         // Return null if product ID doesn't match placeholder
         return null;
     }
}