package com.MonitorHub.controller;// Adjust package name as needed

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AboutUsServlet
 * Handles requests for the About Us page.
 */
@WebServlet("/about") // Maps this servlet to the URL pattern /about
public class AboutUsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AboutUsServlet() {
        super();
    }

    /**
     * Handles GET requests by forwarding to the aboutus.jsp page.
     *
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Define the path to the JSP file within WEB-INF
        String jspPath = "/WEB-INF/pages/aboutus.jsp";

        // Get the RequestDispatcher object
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);

        // Forward the request and response objects to the JSP page
        dispatcher.forward(request, response);
    }

    /**
     * Optionally handle POST requests, perhaps redirecting to GET or showing an error.
     * For a simple static page like About Us, often POST isn't needed.
     * Here, we just forward to doGet to treat GET and POST the same way.
     *
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Delegate POST requests to the doGet method for this simple page
        doGet(request, response);
    }
}