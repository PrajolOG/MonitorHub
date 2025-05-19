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
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProductServlet.class.getName());
    private MonitorDAO monitorDAO; // DAO instance

    @Override
    public void init() throws ServletException {
        monitorDAO = new MonitorDAO();
        LOGGER.info("ProductServlet initialized and MonitorDAO created.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ProductServlet doGet called.");

        List<Product> productListToDisplay = Collections.emptyList(); 

        try {
            productListToDisplay = monitorDAO.getAllMonitorsWithPrimaryImage();
            LOGGER.info("Fetched " + productListToDisplay.size() + " products for user view from database.");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error fetching products for user view.", e);
            request.setAttribute("productFetchError", "Could not load products due to a database issue. Please try again later.");
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Unexpected error fetching products for user view.", e);
             request.setAttribute("productFetchError", "An unexpected error occurred while loading products.");
        }

        request.setAttribute("productList", productListToDisplay);

        String jspPath = "/WEB-INF/pages/products.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public void destroy() {
        LOGGER.info("ProductServlet being destroyed.");
        super.destroy();
    }
}