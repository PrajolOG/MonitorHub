package com.MonitorHub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet implementation class HomeServlet
 * Handles requests for the home page (e.g., / or /home)
 * and forwards to the home.jsp view inside WEB-INF.
 */
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

        LOGGER.log(Level.INFO, "HomeServlet handling GET request for URI: {0}", request.getRequestURI());

        String viewPath = "/WEB-INF/pages/home.jsp";

        try {
            LOGGER.log(Level.INFO, "Attempting to forward request to JSP: {0}", viewPath);
            request.getRequestDispatcher(viewPath).forward(request, response);
            LOGGER.log(Level.INFO, "Successfully forwarded request to {0}", viewPath);
        } catch (ServletException | IOException e) {
            LOGGER.log(Level.SEVERE, "Error forwarding request to " + viewPath, e);

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
        LOGGER.info("HomeServlet handling POST request, delegating to doGet.");
        doGet(request, response);
    }

}