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
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(SearchServlet.class.getName());
    private transient MonitorDAO monitorDAO;

    @Override
    public void init() throws ServletException {
        monitorDAO = new MonitorDAO();
        LOGGER.info("SearchServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("query");
        List<Product> searchResults = Collections.emptyList();
        String pageErrorMessage = null; // For user-facing errors

        LOGGER.fine("SearchServlet doGet called. Query: '" + query + "'");

        if (query != null && !query.trim().isEmpty()) {
            query = query.trim();
            try {
                // Fetch a reasonable number of results for a dedicated page
                searchResults = monitorDAO.searchMonitorsByNameBrandModel(query, 25); // up to 25 results
                if (searchResults.isEmpty()) {
                    request.setAttribute("userMessage", "No monitors found matching your search for: \"" + query + "\".");
                }
                LOGGER.info("Search for query '" + query + "' returned " + searchResults.size() + " products.");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Database error during search for query: " + query, e);
                pageErrorMessage = "An error occurred while searching. Please try again later.";
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Unexpected error during search for query: " + query, e);
                pageErrorMessage = "An unexpected error occurred. Please try again.";
            }
        } else {
            request.setAttribute("userMessage", "Please enter a search term to find monitors.");
        }

        request.setAttribute("searchQuery", query); // To display what was searched for
        request.setAttribute("searchResults", searchResults);
        if (pageErrorMessage != null) {
            request.setAttribute("pageErrorMessage", pageErrorMessage);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/searchResults.jsp");
        dispatcher.forward(request, response);
    }
}