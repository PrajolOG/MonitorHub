package com.MonitorHub.controller; // Adjust package name as needed

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
// Import HttpSession if you want to use session for success message after redirect
// import jakarta.servlet.http.HttpSession;


/**
 * Servlet implementation class ContactServlet
 * Handles displaying the contact form (GET) and processing submissions (POST).
 */
@WebServlet("/contact") // Maps GET and POST requests for /contact
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ContactServlet.class.getName());

    // Define the path to the contact JSP inside WEB-INF
    private static final String CONTACT_VIEW_PATH = "/WEB-INF/pages/contact.jsp";

    /**
     * Handles GET requests: Displays the contact form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ContactServlet handling GET - forwarding to contact page.");
        try {
            // Clear any previous submission status messages if using request scope
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

    /**
     * Handles POST requests: Processes the contact form submission.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ContactServlet handling POST - processing contact form submission.");

        // 1. Retrieve Form Data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Basic server-side validation (can be more sophisticated)
        boolean isValid = true;
        String errorMessage = null;

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            subject == null || subject.trim().isEmpty() ||
            message == null || message.trim().isEmpty())
        {
            isValid = false;
            errorMessage = "Please fill in all required fields.";
            LOGGER.warning("Contact form submission failed: Missing required fields.");
        } else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) { // Basic email format check
             isValid = false;
             errorMessage = "Please enter a valid email address.";
             LOGGER.warning("Contact form submission failed: Invalid email format.");
        }

        if (!isValid) {
            // Forward back to the form with error message and retain data
            request.setAttribute("contactError", errorMessage);
            request.setAttribute("formName", name); // Retain values
            request.setAttribute("formEmail", email);
            request.setAttribute("formSubject", subject);
            request.setAttribute("formMessage", message);
            request.getRequestDispatcher(CONTACT_VIEW_PATH).forward(request, response);
            return;
        }

        // 2. Process the Data (Replace with your actual logic)
        LOGGER.info("Received Contact Form Submission:");
        LOGGER.log(Level.INFO, "Name: {0}", name);
        LOGGER.log(Level.INFO, "Email: {0}", email);
        LOGGER.log(Level.INFO, "Subject: {0}", subject);
        LOGGER.log(Level.INFO, "Message: {0}", message);

        // --- !!! ---
        // TODO: Implement your actual logic here:
        // 1. Send an email notification to yourself/support team.
        // 2. Save the message to a database.
        // 3. Integrate with a ticketing system.
        // --- !!! ---

        // Example: Simulate success for now
        boolean processingSuccess = true; // Change this based on your actual logic's result

        // 3. Provide Feedback to User (Forward back to the same JSP)
        if (processingSuccess) {
             LOGGER.info("Contact form processed successfully.");
             request.setAttribute("contactSuccess", "Thank you for your message! We'll get back to you if needed.");
             // Optionally clear form fields by *not* setting retained value attributes
        } else {
             LOGGER.warning("Contact form processing failed (simulated or actual).");
             request.setAttribute("contactError", "Sorry, there was an error sending your message. Please try again later.");
             // Retain values on error
             request.setAttribute("formName", name);
             request.setAttribute("formEmail", email);
             request.setAttribute("formSubject", subject);
             request.setAttribute("formMessage", message);
        }

        // Forward back to the contact page to display the message
        request.getRequestDispatcher(CONTACT_VIEW_PATH).forward(request, response);

        /* --- Alternative: Redirect after POST (Post/Redirect/Get Pattern) ---
           If you want to prevent form resubmission on refresh after success,
           use redirect instead of forward for the success case.

        if (processingSuccess) {
            LOGGER.info("Contact form processed successfully. Redirecting with success message.");
            HttpSession session = request.getSession();
            session.setAttribute("contactSuccessMessage", "Thank you for your message! We'll get back to you if needed.");
            response.sendRedirect(request.getContextPath() + "/contact"); // Redirect to the GET handler
        } else {
            LOGGER.warning("Contact form processing failed. Forwarding back with error.");
            request.setAttribute("contactError", "Sorry, there was an error sending your message. Please try again later.");
            // Retain values
            request.setAttribute("formName", name);
            request.setAttribute("formEmail", email);
            request.setAttribute("formSubject", subject);
            request.setAttribute("formMessage", message);
            request.getRequestDispatcher(CONTACT_VIEW_PATH).forward(request, response);
        }
        */

    }
}