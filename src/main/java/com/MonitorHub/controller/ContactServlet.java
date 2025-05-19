package com.MonitorHub.controller;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ContactServlet.class.getName());

    private static final String CONTACT_VIEW_PATH = "/WEB-INF/pages/contact.jsp";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ContactServlet handling GET - forwarding to contact page.");
        try {
             request.removeAttribute("contactSuccess");
             request.removeAttribute("contactError");
            request.getRequestDispatcher(CONTACT_VIEW_PATH).forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error forwarding to contact page: " + CONTACT_VIEW_PATH, e);
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display contact page.");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ContactServlet handling POST - forwarding to contact page for client-side processing.");
        try {
            request.getRequestDispatcher(CONTACT_VIEW_PATH).forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error forwarding to contact page after POST: " + CONTACT_VIEW_PATH, e);
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display contact page.");
            }
        }
    }
}