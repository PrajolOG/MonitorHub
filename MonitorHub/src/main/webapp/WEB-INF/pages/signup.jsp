<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - MonitorHub</title>

    <%-- Link External CSS Files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/signup.css">

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #eef2f7;
            background-image: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            padding-top: 105px;
            margin: 0;
        }
        .main-content {
             width: 100%;
             margin: 0 auto;
             flex-grow: 1;
             display: flex; 
        }
        @media (max-width: 768px) { body { padding-top: 0; } }

        .options-row { display: flex; justify-content: space-between; align-items: center; font-size: 13px; /* Slightly smaller */ color: #495057; margin-top: -5px; /* Pull up slightly */ margin-bottom: 10px; flex-wrap: wrap; gap: 10px; }
        .options-row .checkbox-group { display: flex; align-items: center; gap: 8px; } /* Re-apply if needed */
        .options-row input[type="checkbox"] { width: 15px; height: 15px; cursor: pointer; accent-color: #9d4edd; }
        .options-row .checkbox-group label { font-weight: 400; margin-bottom: 0; cursor: pointer; font-size: 13px; color: #495057; }
        .forgot-password a { color: #9d4edd; font-weight: 500; text-decoration: none; transition: text-decoration 0.2s ease; font-size: 13px; }
        .forgot-password a:hover { text-decoration: underline; }

         @media (max-width: 576px) {
            .options-row, .options-row .checkbox-group label, .forgot-password a { font-size: 12px; } /* Even smaller */
            .options-row { margin-top: -8px; }
         }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">
        <div class="main-auth-content">
            <div class="auth-container">


                <div id="signup-form-section" class="form-section is-active"> <%-- Always active now --%>
                    <div class="section-content">
                        <h1>Create Account</h1>
                        <p class="subtitle">Join MonitorHub today</p>

                        <%-- Display validation or save errors from the servlet (via JSON response handled by JS) --%>
                        <div id="signup-error-message" class="status-message error" style="display: none;"></div>
                         <%-- Display potential non-JS errors or success messages if forwarded back (less likely now with JSON response) --%>
                        <c:if test="${not empty requestScope.signupError}"><div class="error-message"><p><c:out value="${requestScope.signupError}"/></p></div></c:if>
                        <c:if test="${not empty sessionScope.message}"><div class="status-message success"><p><c:out value="${sessionScope.message}"/></p></div> <% session.removeAttribute("message"); %></c:if>

                        <%-- Action="#" because JS still handles submission via fetch --%>
                        <form id="signup-form" class="auth-form" action="#" method="post">
                             <div class="form-row">
                                <div class="input-group">
                                    <label for="first-name">First Name</label>
                                    <input type="text" id="first-name" name="firstName" required >
                                </div>
                                <div class="input-group">
                                    <label for="last-name">Last Name</label>
                                    <input type="text" id="last-name" name="lastName" required >
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="input-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" required >
                                </div>
                                <div class="input-group">
                                    <label for="phone">Phone Number (Optional)</label>
                                    <input type="tel" id="phone" name="phone" placeholder="+977 9810008000">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="input-group">
                                    <label for="password">Password</label>
                                    <input type="password" id="password" name="password" required>
                                </div>
                                <div class="input-group">
                                    <label for="confirm-password">Confirm Password</label>
                                    <input type="password" id="confirm-password" name="confirm_password" required>
                                </div>
                            </div>
                            <div class="checkbox-group">
                                <input type="checkbox" id="terms" name="terms" required> <%-- Make terms required? --%>
                                <label for="terms">I agree to the <a href="${pageContext.request.contextPath}">Terms of Service</a> and <a href="${pageContext.request.contextPath}">Privacy Policy</a></label>
                            </div>
                            <%-- Button type="button" prevents default form submission, handled by JS --%>
                            <button type="button" id="create-account-btn" class="submit-btn">Create Account</button>
                        </form>
                        <p class="switch-link"> Already have an account? <a href="${pageContext.request.contextPath}/login">Log in</a> </p>
                    </div>
                </div>
            </div><!-- End Auth Container -->
        </div> <%-- End Main Auth Content --%>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />

	<script>
	     // --- Element References ---
	     const signupForm = document.getElementById('signup-form');
	     const createAccountBtn = document.getElementById('create-account-btn');
	     const emailInput = document.getElementById('email');
	     const passwordInput = document.getElementById('password');
	     const confirmPasswordInput = document.getElementById('confirm-password');
	     const firstNameInput = document.getElementById('first-name');
	     const lastNameInput = document.getElementById('last-name');
	     const termsCheckbox = document.getElementById('terms');
	     const signupErrorDiv = document.getElementById('signup-error-message');
	
	     // --- Helper: Show Error ---
	     function showError(message) {
	          if(signupErrorDiv) {
	              signupErrorDiv.textContent = message;
	              signupErrorDiv.style.display = 'block';
	          }
	     }
	     // --- Helper: Clear Error ---
	     function clearError() {
	          if(signupErrorDiv) {
	              signupErrorDiv.style.display = 'none';
	              signupErrorDiv.textContent = '';
	          }
	          [firstNameInput, lastNameInput, emailInput, passwordInput, confirmPasswordInput].forEach(input => { if(input) input.style.borderColor=''; });
	          if(termsCheckbox) termsCheckbox.style.outline = '';
	     }
	
	     // --- Basic Client-Side Validation ---
	     function validateForm() {
	         clearError();
	         let isValid = true;
	         let errorMessage = null;
	
	         // Check required fields
	         if (!firstNameInput.value.trim() || !lastNameInput.value.trim() || !emailInput.value.trim() || !passwordInput.value || !confirmPasswordInput.value) {
	             errorMessage = 'Please fill in all required fields.';
	             isValid = false;
	             [firstNameInput, lastNameInput, emailInput, passwordInput, confirmPasswordInput].forEach(input => { if(input && !input.value.trim() && input.required) input.style.borderColor='red'; });
	         }
	         // Check email format
	         else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailInput.value.trim())) {
	             errorMessage = 'Please enter a valid email address.';
	             isValid = false;
	              if(emailInput) emailInput.style.borderColor = 'red';
	         }
	         // Check passwords match
	         else if (passwordInput.value !== confirmPasswordInput.value) {
	             errorMessage = 'Passwords do not match.';
	             isValid = false;
	              if(passwordInput) passwordInput.style.borderColor = 'red';
	              if(confirmPasswordInput) confirmPasswordInput.style.borderColor = 'red';
	         }
	          // Check terms checkbox
	          else if (!termsCheckbox.checked) {
	               errorMessage = 'You must agree to the Terms and Privacy Policy.';
	               isValid = false;
	                if(termsCheckbox) termsCheckbox.style.outline = '1px solid red';
	          }
	
	
	         if (!isValid && errorMessage) {
	             showError(errorMessage);
	         }
	         return isValid;
	     }
	
	      // --- Event Listener for Signup Button ---
	      if (createAccountBtn) {
	          createAccountBtn.addEventListener('click', async () => {
	              if (validateForm()) { // Perform client-side validation first
	                  createAccountBtn.disabled = true;
	                  createAccountBtn.textContent = 'Creating...';
	                  clearError(); // Clear error div before sending
	
	                  const formData = new FormData(signupForm);
	
	                  try {
	                      const response = await fetch('${pageContext.request.contextPath}/signup-request', {
	                          method: 'POST',
	                          body: new URLSearchParams(formData)
	                      });
	                      const result = await response.json();
	
	                      if (response.ok && result.success) {
	                          // SUCCESS from server -> Redirect
	                          if (result.redirectUrl) {
	                              window.location.href = result.redirectUrl;
	                          } else {
	                              // Fallback redirect if URL missing
	                              window.location.href = '${pageContext.request.contextPath}/login';
	                          }
	                      } else {
	                          // FAILURE from server -> Show server message
	                          showError(result.message || 'An unknown error occurred during signup.');
	                          createAccountBtn.disabled = false; // Re-enable button on error
	                          createAccountBtn.textContent = 'Create Account';
	                      }
	                  } catch (error) {
	                      console.error('Signup fetch error:', error);
	                      showError('A network error occurred. Please try again.');
	                      createAccountBtn.disabled = false;
	                      createAccountBtn.textContent = 'Create Account';
	                  }
	              }
	          });
	      } else {
	          console.error("Signup button not found.");
	      }
	
	</script>

</body>
</html>