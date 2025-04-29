package com.MonitorHub.controller; // Change to your actual package structure

import jakarta.servlet.RequestDispatcher; // Or javax.servlet.* if using older API
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet responsible for displaying the main categories page.
 */
@WebServlet("/categories") // Maps this servlet to the URL pattern "/categories"
public class CategoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L; // Optional but good practice

    /**
     * Handles GET requests to /categories.
     * Forwards the request to the category JSP page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // In a more complex scenario, you might fetch category data here
        // and set it as request attributes before forwarding.
        // Example:
        // List<Category> categories = categoryService.getAllCategories();
        // request.setAttribute("categoryList", categories);

        // Define the path to the JSP file (relative to the web application root)
        String jspPath = "/WEB-INF/pages/category.jsp";

        // Get the RequestDispatcher object
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);

        // Forward the request and response objects to the JSP
        dispatcher.forward(request, response);
    }

    /**
     * Handles POST requests. By default, can simply call doGet or handle differently.
     * For displaying a page, GET is typically used.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Often, POST requests might be for actions (like filtering categories).
        // For simply showing the page, redirecting to GET or handling like GET is common.
        doGet(request, response);
    }
}