package com.MonitorHub.controller;

import com.MonitorHub.dao.MonitorDAO; // Import the DAO
import com.MonitorHub.model.Product;
import jakarta.servlet.RequestDispatcher;
// Removed ServletContext import as it's no longer used for the product list
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException; // Import SQLException
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level; // Import Level for logging
import java.util.logging.Logger;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProductServlet.class.getName());
    private MonitorDAO monitorDAO; // DAO instance

    @Override
    public void init() throws ServletException {
        monitorDAO = new MonitorDAO(); // Initialize DAO when servlet loads
        LOGGER.info("ProductServlet initialized and MonitorDAO created.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ProductServlet doGet called.");

        List<Product> productListToDisplay = Collections.emptyList(); // Default to empty list

        try {
            // Fetch products directly from DAO
            productListToDisplay = monitorDAO.getAllMonitorsWithPrimaryImage();
            LOGGER.info("Fetched " + productListToDisplay.size() + " products for user view from database.");

        } catch (SQLException e) {
            // Log the error and potentially show an error message to the user
            LOGGER.log(Level.SEVERE, "Database error fetching products for user view.", e);
            // Set an attribute so the JSP can display an error message if desired
            request.setAttribute("productFetchError", "Could not load products due to a database issue. Please try again later.");
            // productListToDisplay remains empty in case of error
        } catch (Exception e) {
            // Catch other potential exceptions during DAO interaction
             LOGGER.log(Level.SEVERE, "Unexpected error fetching products for user view.", e);
             request.setAttribute("productFetchError", "An unexpected error occurred while loading products.");
        }

        request.setAttribute("productList", productListToDisplay);
        // Future: Add filtering, sorting, pagination parameters here

        String jspPath = "/WEB-INF/pages/products.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For now, just delegate to doGet. If filters are submitted via POST, handle here.
        doGet(request, response);
    }

    @Override
    public void destroy() {
        // Optional: Clean up resources if DAO held any (like a connection pool)
        LOGGER.info("ProductServlet being destroyed.");
        super.destroy();
    }
}