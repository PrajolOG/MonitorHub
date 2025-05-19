package com.MonitorHub.controller;

import com.MonitorHub.dao.UserDAO;
import com.MonitorHub.model.User;
import com.MonitorHub.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/signup-request", "/signup"})
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(SignupServlet.class.getName());
    private static final String SIGNUP_VIEW_PATH = "/WEB-INF/pages/signup.jsp";
    private static final String DEFAULT_ROLE = "Customer";

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestedPath = request.getServletPath();
        if ("/signup".equals(requestedPath)) {
            LOGGER.info("SignupServlet handling GET for /signup - forwarding to signup page.");
            clearFormAttributes(request); // Clear any lingering form values if user navigates back
            request.getRequestDispatcher(SIGNUP_VIEW_PATH).forward(request, response);
        } else {
             LOGGER.warning("GET request received for /signup-request - Method Not Allowed.");
             response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported for this URL.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestedPath = request.getServletPath();
        if (!"/signup-request".equals(requestedPath)) {
             LOGGER.warning("POST request received for unexpected path: " + requestedPath);
             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request path for POST.");
             return;
        }

        LOGGER.info("SignupServlet handling POST for /signup-request - processing traditional signup.");

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String terms = request.getParameter("terms");

        // --- Server-Side Validation ---
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            setErrorAndForward(request, response, "Please fill in all required fields.", firstName, lastName, email, phone);
            return;
        }

        firstName = firstName.trim();
        lastName = lastName.trim();
        email = email.trim();
        phone = (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null;

        if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            setErrorAndForward(request, response, "Invalid email format.", firstName, lastName, email, phone);
            return;
        }
        
        if (password.length() < 8) {
             setErrorAndForward(request, response, "Password must be at least 8 characters long.", firstName, lastName, email, phone);
             return;
        }

        if (!password.equals(confirmPassword)) {
            setErrorAndForward(request, response, "Passwords do not match.", firstName, lastName, email, phone);
            return;
        }

        if (terms == null) { // Checkbox value is "on" if checked, null if not
            setErrorAndForward(request, response, "You must agree to the Terms of Service and Privacy Policy.", firstName, lastName, email, phone);
            return;
        }

        try {
            if (userDAO.checkEmailExists(email)) {
                setErrorAndForward(request, response, "Email address is already registered.", firstName, lastName, email, phone);
                return;
            }

            String hashedPassword = PasswordUtil.hashPassword(password);
            if (hashedPassword == null) {
                 LOGGER.severe("Password hashing returned null for email: " + email);
                 setErrorAndForward(request, response, "Password processing failed. Please try again.", firstName, lastName, email, phone);
                 return;
            }

            User userToSave = new User();
            userToSave.setFirstname(firstName);
            userToSave.setLastname(lastName);
            userToSave.setEmail(email);
            userToSave.setPhone(phone);
            userToSave.setPasswordHash(hashedPassword);

            LOGGER.info("Attempting to save user via UserDAO...");
            Integer savedUserId = userDAO.createUserWithRole(userToSave, DEFAULT_ROLE);

            if (savedUserId != null) {
                LOGGER.log(Level.INFO, "User {0} saved to database successfully (UserID: {1}).", new Object[]{email, savedUserId});
                
                User loggedInUser = new User(
                    savedUserId, firstName, lastName, email, phone, 
                    null, // createdAt - not immediately needed in session after signup
                    DEFAULT_ROLE, 
                    null 
                );

                HttpSession session = request.getSession(true);
                session.setAttribute("user", loggedInUser);
                session.setAttribute("successMessage", "Account created successfully! Welcome to MonitorHub.");
                LOGGER.log(Level.INFO, "User object placed in session for auto-login. Session ID: {0}", session.getId());

                String redirectURL = request.getContextPath() + "/home";
                 if ("Admin".equalsIgnoreCase(loggedInUser.getRoleName())) {
                      redirectURL = request.getContextPath() + "/admin/dashboard";
                 }
                response.sendRedirect(redirectURL);

            } else {
                LOGGER.log(Level.SEVERE, "Failed to save user {0} to database (UserDAO.createUserWithRole returned null).", email);
                setErrorAndForward(request, response, "Failed to create your account due to a server error. Please try again later.", firstName, lastName, email, phone);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error during signup process for " + email, e);
            setErrorAndForward(request, response, "A database error occurred. Please try again.", firstName, lastName, email, phone);
        } catch (Exception e) { 
            LOGGER.log(Level.SEVERE, "Unexpected error during signup process for " + email, e);
            setErrorAndForward(request, response, "An internal server error occurred. Please try again.", firstName, lastName, email, phone);
        }
    } 
    
    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response, String message,
                                    String firstName, String lastName, String email, String phone) 
                                    throws ServletException, IOException {
        request.setAttribute("signupError", message);
        request.setAttribute("form_firstName", firstName);
        request.setAttribute("form_lastName", lastName);
        request.setAttribute("form_email", email);
        request.setAttribute("form_phone", phone);
        request.getRequestDispatcher(SIGNUP_VIEW_PATH).forward(request, response);
    }

    private void clearFormAttributes(HttpServletRequest request) {
        request.removeAttribute("signupError");
        request.removeAttribute("form_firstName");
        request.removeAttribute("form_lastName");
        request.removeAttribute("form_email");
        request.removeAttribute("form_phone");
    }
}