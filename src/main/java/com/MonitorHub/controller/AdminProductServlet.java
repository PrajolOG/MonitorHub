package com.MonitorHub.controller;

import com.MonitorHub.dao.MonitorDAO;
import com.MonitorHub.model.Product;
import com.MonitorHub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/admin/products", "/admin/products/add", "/admin/products/edit", "/admin/products/save", "/admin/products/delete"})
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminProductServlet.class.getName());
    private MonitorDAO monitorDAO; 

    @Override
    public void init() throws ServletException {
        monitorDAO = new MonitorDAO(); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("AdminProductServlet doGet called for path: " + request.getServletPath());

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (loggedInUser == null) {
            LOGGER.warning("Unauthorized access attempt to admin products. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getServletPath();
        String view = "/WEB-INF/pages/adminProducts.jsp"; // Default view
        String pageTitle = "Manage Products";

        try {
            if ("/admin/products/add".equals(action)) {
                view = "/WEB-INF/pages/adminAddEditProduct.jsp";
                pageTitle = "Add New Product";
                request.setAttribute("formMode", "add");
                request.setAttribute("product", new Product()); // Empty product for the form
            } else if ("/admin/products/edit".equals(action)) {
                view = "/WEB-INF/pages/adminAddEditProduct.jsp";
                pageTitle = "Edit Product";
                handleEditGet(request, response); // Pass request/response only
            } else {
                List<Product> products = monitorDAO.getAllMonitorsWithPrimaryImage();
                request.setAttribute("products", products);
            }
        } catch (SQLException e) {
             LOGGER.log(Level.SEVERE, "Database error processing action " + action, e);
             request.getSession().setAttribute("errorMessage", "Database error occurred: " + e.getMessage());
             response.sendRedirect(request.getContextPath() + "/admin/products"); // Redirect on DB error
             return; // Stop further processing
        } catch (Exception e) { // Catch other potential errors
             LOGGER.log(Level.SEVERE, "Error processing GET action " + action, e);
             request.getSession().setAttribute("errorMessage", "An unexpected error occurred.");
             response.sendRedirect(request.getContextPath() + "/admin/products"); // Redirect on generic error
             return;
        }

        request.setAttribute("pageTitle", pageTitle);
        request.getRequestDispatcher(view).forward(request, response);
    }

    private void handleEditGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID is required for editing.");
            return;
        }
        try {
            int productId = Integer.parseInt(idParam);
            Product productToEdit = monitorDAO.getMonitorById(productId); // Fetch from DAO

            if (productToEdit != null) {
                request.setAttribute("formMode", "edit");
                request.setAttribute("product", productToEdit);
                // View is set in doGet, just set attributes here
            } else {
                request.getSession().setAttribute("errorMessage", "Product with ID " + productId + " not found.");
                response.sendRedirect(request.getContextPath() + "/admin/products");
                // Throwing an exception might be cleaner if redirect doesn't work within this flow
                throw new ServletException("Product not found, redirecting.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Product ID format.");
        }
        // SQLException is declared to be thrown, will be caught by doGet
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("AdminProductServlet doPost called for path: " + request.getServletPath());

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (loggedInUser == null /* || !"Admin".equalsIgnoreCase(loggedInUser.getRoleName()) */ ) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to perform this action.");
            return;
        }

        String action = request.getServletPath();
        String actionParam = request.getParameter("action");

        if ("/admin/products/save".equals(action)) {
            handleSavePost(request, response);
        } else if ("/admin/products/delete".equals(action) || "delete".equals(actionParam)) {
            handleDeletePost(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported for " + action);
        }
    }

    // Handles Add/Edit submissions
    private void handleSavePost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
         String formMode = request.getParameter("formMode");
         String productIdStr = request.getParameter("productId"); // For edit mode

         Product productData = new Product();
         StringBuilder errorMessages = new StringBuilder();

         // --- Populate and Validate Product Data (same as before) ---
         productData.setName(request.getParameter("monitorName"));
         if (productData.getName() == null || productData.getName().trim().isEmpty()) {
             errorMessages.append("Monitor Name is required. ");
         }
         productData.setBrand(request.getParameter("brand"));
         productData.setModel(request.getParameter("model"));
         productData.setImageUrl(request.getParameter("imageUrl")); // Primary Image URL
          if (productData.getImageUrl() == null || productData.getImageUrl().trim().isEmpty()) {
             errorMessages.append("Primary Image URL is required. ");
         }
         productData.setDescription(request.getParameter("description"));
         productData.setType(request.getParameter("type"));
         productData.setDelivery_info(request.getParameter("deliveryInfo"));

         try {
             int stock = Integer.parseInt(request.getParameter("stockQuantity"));
             if (stock < 0) errorMessages.append("Stock quantity cannot be negative. ");
             else productData.setStock_quantity(stock);
         } catch (NumberFormatException e) { errorMessages.append("Invalid stock quantity. "); productData.setStock_quantity(0); }

         try {
             BigDecimal originalPrice = new BigDecimal(request.getParameter("originalPrice"));
             if (originalPrice.compareTo(BigDecimal.ZERO) < 0) errorMessages.append("Original price cannot be negative. ");
             else productData.setOriginal_price(originalPrice);
         } catch (Exception e) { errorMessages.append("Invalid original price. "); productData.setOriginal_price(BigDecimal.ZERO); }

         String discountedPriceStr = request.getParameter("discountedPrice");
         if (discountedPriceStr != null && !discountedPriceStr.trim().isEmpty()) {
             try {
                 BigDecimal discountedPrice = new BigDecimal(discountedPriceStr);
                 if (discountedPrice.compareTo(BigDecimal.ZERO) < 0) { errorMessages.append("Discounted price cannot be negative. "); }
                 else if (productData.getOriginal_price() != null && discountedPrice.compareTo(productData.getOriginal_price()) >= 0) { errorMessages.append("Discounted price must be less than original price. "); }
                 else { productData.setDiscounted_price(discountedPrice); }
             } catch (NumberFormatException e) { errorMessages.append("Invalid discounted price. "); }
         } else { productData.setDiscounted_price(null); }
         // --- End Populate/Validate ---


         if (errorMessages.length() > 0) {
             request.setAttribute("errorMessage", errorMessages.toString());
             request.setAttribute("product", productData);
             request.setAttribute("formMode", formMode);
             request.setAttribute("pageTitle", "add".equals(formMode) ? "Add New Product" : "Edit Product");
             if ("edit".equals(formMode) && productIdStr != null && !productIdStr.isEmpty()) {
                 try { productData.setId(Integer.parseInt(productIdStr)); } catch (NumberFormatException e) { /* ignore bad id */ }
             }
             request.getRequestDispatcher("/WEB-INF/pages/adminAddEditProduct.jsp").forward(request, response);
             return;
         }

         // --- Save or Update using DAO ---
         String successMessage = "";
         String errorMessage = "";
         try {
             if ("add".equals(formMode)) {
                 int newId = monitorDAO.addMonitor(productData);
                 successMessage = "Product '" + productData.getName() + "' (ID: " + newId + ") added successfully!";
                 LOGGER.info(successMessage);
             } else if ("edit".equals(formMode)) {
                 int productId = Integer.parseInt(productIdStr);
                 productData.setId(productId); // Set ID for update
                 boolean updated = monitorDAO.updateMonitor(productData);
                 if (updated) {
                     successMessage = "Product '" + productData.getName() + "' (ID: " + productId + ") updated successfully!";
                     LOGGER.info(successMessage);
                 } else {
                     errorMessage = "Product with ID " + productId + " not found for update.";
                     LOGGER.warning(errorMessage);
                 }
             }
             if (!successMessage.isEmpty()) {
                 request.getSession().setAttribute("successMessage", successMessage);
             }
             if (!errorMessage.isEmpty()) {
                  request.getSession().setAttribute("errorMessage", errorMessage);
             }
         } catch (SQLException e) {
             LOGGER.log(Level.SEVERE, "Database error saving/updating product", e);
             request.getSession().setAttribute("errorMessage", "Database error: " + e.getMessage());
         } catch (NumberFormatException e) {
              LOGGER.log(Level.WARNING, "Invalid product ID for update: " + productIdStr, e);
              request.getSession().setAttribute("errorMessage", "Invalid Product ID for update.");
         }

         // Redirect back to the product list page
         response.sendRedirect(request.getContextPath() + "/admin/products");
    }

     // Handles Delete submissions
    private void handleDeletePost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String productIdStr = request.getParameter("productId"); // Get ID from form
        String successMessage = "";
        String errorMessage = "";

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
             errorMessage = "Product ID is required for deletion.";
        } else {
            try {
                int productId = Integer.parseInt(productIdStr);
                LOGGER.info("Attempting to delete product with ID: " + productId);
                boolean deleted = monitorDAO.deleteMonitor(productId);

                if (deleted) {
                    successMessage = "Product (ID: " + productId + ") deleted successfully.";
                    LOGGER.info(successMessage);
                } else {
                    errorMessage = "Product (ID: " + productId + ") not found or could not be deleted (check related sales).";
                    LOGGER.warning(errorMessage);
                }
            } catch (NumberFormatException e) {
                 errorMessage = "Invalid Product ID format for deletion: " + productIdStr;
                 LOGGER.warning(errorMessage);
            } catch (SQLException e) {
                errorMessage = "Database error occurred during deletion: " + e.getMessage();
                LOGGER.log(Level.SEVERE, "Database error deleting product ID: " + productIdStr, e);
            }
        }

        if (!successMessage.isEmpty()) {
             request.getSession().setAttribute("successMessage", successMessage);
        }
        if (!errorMessage.isEmpty()) {
             request.getSession().setAttribute("errorMessage", errorMessage);
        }
         response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}