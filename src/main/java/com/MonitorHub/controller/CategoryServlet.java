package com.MonitorHub.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests to /categories.
     * Forwards the request to the category JSP page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String jspPath = "/WEB-INF/pages/category.jsp";

        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);

        dispatcher.forward(request, response);
    }

    /**
     * Handles POST requests. By default, can simply call doGet or handle differently.
     * For displaying a page, GET is typically used.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}