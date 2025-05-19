<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - MonitorHub</title>

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

        @media (max-width: 768px) {
            body {
                padding-top: 0;
            }
        }

        .options-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            color: #495057;
            margin-top: -5px;
            margin-bottom: 10px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .options-row .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .options-row input[type="checkbox"] {
            width: 15px;
            height: 15px;
            cursor: pointer;
            accent-color: #9d4edd;
        }

        .options-row .checkbox-group label {
            font-weight: 400;
            margin-bottom: 0;
            cursor: pointer;
            font-size: 13px;
            color: #495057;
        }

        .forgot-password a {
            color: #9d4edd;
            font-weight: 500;
            text-decoration: none;
            transition: text-decoration 0.2s ease;
            font-size: 13px;
        }

        .forgot-password a:hover {
            text-decoration: underline;
        }

        @media (max-width: 576px) {
            .options-row,
            .options-row .checkbox-group label,
            .forgot-password a {
                font-size: 12px;
            }
            .options-row {
                margin-top: -8px;
            }
        }

        .status-message {
            padding: 10px 15px;
            margin-bottom: 15px;
            border-radius: 4px;
            font-size: 0.9em;
            border: 1px solid transparent;
        }

        .status-message.error {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }

        .status-message.success {
            background-color: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">
        <div class="main-auth-content">
            <div class="auth-container">
                <div id="signup-form-section" class="form-section is-active">
                    <div class="section-content">
                        <h1>Create Account</h1>
                        <p class="subtitle">Join MonitorHub today</p>

                        <c:if test="${not empty requestScope.signupError}">
                            <div class="status-message error">
                                <p><c:out value="${requestScope.signupError}"/></p>
                            </div>
                        </c:if>

                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="status-message success">
                                <p><c:out value="${sessionScope.successMessage}"/></p>
                            </div>
                            <% session.removeAttribute("successMessage"); %>
                        </c:if>

                        <div id="client-validation-error-message" class="status-message error" style="display: none;"></div>

                        <form id="signup-form" class="auth-form" action="${pageContext.request.contextPath}/signup-request" method="post" onsubmit="return validateClientSideForm();">
                             <div class="form-row">
                                <div class="input-group">
                                    <label for="first-name">First Name</label>
                                    <input type="text" id="first-name" name="firstName" required value="<c:out value='${requestScope.form_firstName}'/>">
                                </div>
                                <div class="input-group">
                                    <label for="last-name">Last Name</label>
                                    <input type="text" id="last-name" name="lastName" required value="<c:out value='${requestScope.form_lastName}'/>">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="input-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" required value="<c:out value='${requestScope.form_email}'/>">
                                </div>
                                <div class="input-group">
                                    <label for="phone">Phone Number (Optional)</label>
                                    <input type="tel" id="phone" name="phone" placeholder="+977 9810008000" value="<c:out value='${requestScope.form_phone}'/>">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="input-group">
                                    <label for="password">Password</label>
                                    <input type="password" id="password" name="password" required minlength="8">
                                </div>
                                <div class="input-group">
                                    <label for="confirm-password">Confirm Password</label>
                                    <input type="password" id="confirm-password" name="confirm_password" required minlength="8">
                                </div>
                            </div>
                            <div class="checkbox-group" style="margin-bottom: 15px; margin-top: 5px;">
                                <input type="checkbox" id="terms" name="terms" value="on" required> <%-- Value "on" is sent when checked --%>
                                <label for="terms">I agree to the <a href="${pageContext.request.contextPath}/terms-of-service">Terms of Service</a> and <a href="${pageContext.request.contextPath}/privacy-policy">Privacy Policy</a></label>
                            </div>
                            <button type="submit" id="create-account-btn" class="submit-btn">Create Account</button>
                        </form>
                        <p class="switch-link"> Already have an account? <a href="${pageContext.request.contextPath}/login">Log in</a> </p>
                    </div>
                </div>
            </div>
        </div> 
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
	     const clientValidationErrorDiv = document.getElementById('client-validation-error-message');

	     // --- Helper: Show Client-Side Error ---
	     function showClientError(message) {
	          if(clientValidationErrorDiv) {
	              clientValidationErrorDiv.innerHTML = '<p>' + message + '</p>'; // Use innerHTML to wrap in <p> like server errors
	              clientValidationErrorDiv.style.display = 'block';
	          }
	          // Hide server error message if a client one is now being shown
              const serverError = document.querySelector('.status-message.error:not(#client-validation-error-message)');
              if(serverError) serverError.style.display = 'none';
	     }
	     // --- Helper: Clear Client-Side Error & Input Styles ---
	     function clearClientErrorAndStyles() {
	          if(clientValidationErrorDiv) {
	              clientValidationErrorDiv.style.display = 'none';
	              clientValidationErrorDiv.innerHTML = '';
	          }
	          [firstNameInput, lastNameInput, emailInput, passwordInput, confirmPasswordInput].forEach(input => {
                  if(input) input.style.borderColor='';
              });
	          if(termsCheckbox) termsCheckbox.style.outline = '';
	     }

	     // --- Basic Client-Side Validation (called by onsubmit) ---
	     function validateClientSideForm() {
	         clearClientErrorAndStyles();
	         let isValid = true;
	         let errorMessage = null;

	         if (!firstNameInput.value.trim()) {
	             errorMessage = 'Please fill in your First Name.';
	             isValid = false; if(firstNameInput) firstNameInput.style.borderColor='red';
	         }
	         else if (!lastNameInput.value.trim()) {
	             errorMessage = 'Please fill in your Last Name.';
	             isValid = false; if(lastNameInput) lastNameInput.style.borderColor='red';
	         }
	         else if (!emailInput.value.trim()) {
	             errorMessage = 'Please enter your Email Address.';
	             isValid = false; if(emailInput) emailInput.style.borderColor='red';
	         }
	         else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailInput.value.trim())) {
	             errorMessage = 'Please enter a valid email address.';
	             isValid = false; if(emailInput) emailInput.style.borderColor = 'red';
	         }
             else if (!passwordInput.value) {
	             errorMessage = 'Please enter a Password.';
	             isValid = false; if(passwordInput) passwordInput.style.borderColor='red';
	         }
	         else if (passwordInput.value.length < 8) {
	             errorMessage = 'Password must be at least 8 characters long.';
	             isValid = false; if(passwordInput) passwordInput.style.borderColor = 'red';
	         }
	         else if (!confirmPasswordInput.value) {
	             errorMessage = 'Please confirm your Password.';
	             isValid = false; if(confirmPasswordInput) confirmPasswordInput.style.borderColor='red';
	         }
	         else if (passwordInput.value !== confirmPasswordInput.value) {
	             errorMessage = 'Passwords do not match.';
	             isValid = false;
	             if(passwordInput) passwordInput.style.borderColor = 'red';
	             if(confirmPasswordInput) confirmPasswordInput.style.borderColor = 'red';
	         }
	         else if (!termsCheckbox.checked) {
	             errorMessage = 'You must agree to the Terms of Service and Privacy Policy.';
	             isValid = false; if(termsCheckbox) termsCheckbox.style.outline = '2px solid red';
	         }

	         if (!isValid && errorMessage) {
	             showClientError(errorMessage);
	         } else if (isValid) {
                 if(createAccountBtn) {
                    createAccountBtn.disabled = true;
                    createAccountBtn.textContent = 'Creating Account...';
                 }
             }
	         return isValid;
	     }
	</script>

</body>
</html>