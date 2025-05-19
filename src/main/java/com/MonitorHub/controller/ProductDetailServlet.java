package com.MonitorHub.controller;

import com.MonitorHub.dao.MonitorDAO;
import com.MonitorHub.model.Product;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProductDetailServlet.class.getName());
    private MonitorDAO monitorDAO; // DAO instance

    @Override
    public void init() throws ServletException {
        monitorDAO = new MonitorDAO(); // Initialize DAO
        LOGGER.info("ProductDetailServlet initialized and MonitorDAO created.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ProductDetailServlet doGet called.");

        String productIdParam = request.getParameter("id");
        Product product = null;
        String errorMessage = null; // Variable to hold potential errors

        if (productIdParam != null && !productIdParam.trim().isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdParam);
                LOGGER.log(Level.INFO, "Fetching details for product ID: {0}", productId);

                // --- Fetch product directly from DAO ---
                product = monitorDAO.getMonitorById(productId);

                if (product == null) {
                    LOGGER.log(Level.WARNING, "Product with ID {0} not found in database.", productId);
                    errorMessage = "The product you are looking for could not be found.";
                } else {
                    LOGGER.log(Level.INFO, "Product found: {0}", product.getName());
                }
                // --- End Fetch ---

            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid product ID format: {0}", productIdParam);
                errorMessage = "Invalid product ID provided.";
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Database error fetching product details for ID: " + productIdParam, e);
                errorMessage = "A database error occurred while retrieving product details.";
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Unexpected error fetching product details for ID: " + productIdParam, e);
                errorMessage = "An unexpected error occurred.";
            }
        } else {
            LOGGER.log(Level.WARNING, "Product ID parameter is missing.");
            errorMessage = "No product ID specified.";
        }

        // Set attributes for the JSP
        request.setAttribute("product", product); // Will be null if not found or error
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage); // Pass error message to JSP
        }

        String jspPath = "/WEB-INF/pages/product_desc.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    @Override
    public void destroy() {
        LOGGER.info("ProductDetailServlet being destroyed.");
        super.destroy();
    }
}