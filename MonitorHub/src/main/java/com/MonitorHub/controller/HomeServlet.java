package com.MonitorHub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level; // Import Level for logging levels
import java.util.logging.Logger;

/**
 * Servlet implementation class HomeServlet
 * Handles requests for the home page (e.g., / or /home)
 * and forwards to the home.jsp view inside WEB-INF.
 */
// Map this servlet to handle requests for the application root and /home
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // It's good practice to get a logger specific to the class
    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());

    /**
     * Handles GET requests for the home page.
     * Forwards the request to the home.jsp view.
     *
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Log that the servlet is handling the request and which URI was requested
        LOGGER.log(Level.INFO, "HomeServlet handling GET request for URI: {0}", request.getRequestURI());

        // Optional: Add logic here to fetch data needed for the home page
        // For example, fetching featured products from a DAO:
        // ProductDAO productDAO = new ProductDAO(); // Assuming you have a DAO
        // List<Product> featuredProducts = productDAO.getFeaturedProducts();
        // request.setAttribute("featuredProducts", featuredProducts);
        // LOGGER.info("Fetched featured products for home page.");

        // Define the path to the actual JSP file within WEB-INF
        // THIS PATH MUST BE CORRECT and start with "/"
        String viewPath = "/WEB-INF/pages/home.jsp";

        try {
            // Forward the request and response objects to the JSP
            LOGGER.log(Level.INFO, "Attempting to forward request to JSP: {0}", viewPath);
            request.getRequestDispatcher(viewPath).forward(request, response);
            LOGGER.log(Level.INFO, "Successfully forwarded request to {0}", viewPath);
        } catch (ServletException | IOException e) {
            // Log the specific error if forwarding fails
            LOGGER.log(Level.SEVERE, "Error forwarding request to " + viewPath, e);

            // Send an error response to the client if the response hasn't been committed yet
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to display the home page due to an internal error.");
            }
        }
    }

    /**
     * Handles POST requests by delegating to doGet.
     * Usually, the home page doesn't process POST data directly.
     *
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Delegate POST requests to the doGet method for simplicity in this case
        LOGGER.info("HomeServlet handling POST request, delegating to doGet.");
        doGet(request, response);
    }

}