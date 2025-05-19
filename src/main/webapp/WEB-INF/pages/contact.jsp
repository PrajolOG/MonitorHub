<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - MonitorHub</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/contact.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/auth.css">

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
            overflow-x: hidden;
        }
         .main-content {
             width: 100%;
             margin: 0 auto;
             flex-grow: 1;
             display: flex;
             justify-content: center;
             align-items: center;
             padding: 40px 20px;
        }
        @media (max-width: 768px) {
             body { padding-top: 0; }
             .main-content { padding: 30px 15px; }
        }
        @media (max-width: 576px) {
             .main-content { padding: 20px 10px; align-items: flex-start; }
        }

         .contact-container {
             animation: fadeIn 0.6s ease-in-out;
         }

         @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">
        <div class="contact-container">
            <h1>Contact Us</h1>
            <p class="subtitle">We'd love to hear from you! Please fill out the form below.</p>

            <form class="contact-form" id="contactForm" action="${pageContext.request.contextPath}/contact" method="post" novalidate>
                <div class="input-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required placeholder="Enter your full name">
                </div>
                <div class="input-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required placeholder="Enter your email address">
                </div>
                <div class="input-group">
                    <label for="subject">Subject</label>
                    <input type="text" id="subject" name="subject" required placeholder="What is the subject of your message?">
                </div>
                <div class="input-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" required placeholder="Enter your message here..."></textarea>
                </div>
                <button type="submit" class="submit-btn">Send Message</button>
            </form>
        </div>
    </main>

    <div class="popup-overlay" id="successPopupOverlay">
        <div class="popup-box">
            <h2>Message Sent!</h2>
            <p>We received your form and will reach out to you as soon as possible.</p>
            <button class="popup-close-btn" id="closeSuccessPopup">Okay</button>
        </div>
    </div>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const contactForm = document.getElementById('contactForm');
            const successPopupOverlay = document.getElementById('successPopupOverlay');
            const closeSuccessPopupButton = document.getElementById('closeSuccessPopup');

            const nameInput = document.getElementById('name');
            const emailInput = document.getElementById('email');
            const subjectInput = document.getElementById('subject');
            const messageInput = document.getElementById('message');

            const inputsToValidate = [nameInput, emailInput, subjectInput, messageInput];

            function validateEmail(email) {
                const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return re.test(String(email).toLowerCase());
            }

            function displayError(inputElement, message) {
                clearError(inputElement);
                const errorSpan = document.createElement('span');
                errorSpan.className = 'error-text';
                errorSpan.textContent = message;
                inputElement.parentNode.insertBefore(errorSpan, inputElement.nextSibling);
                inputElement.classList.add('input-error-state');
            }

            function clearError(inputElement) {
                inputElement.classList.remove('input-error-state');
                const nextSibling = inputElement.nextElementSibling;
                if (nextSibling && nextSibling.classList.contains('error-text')) {
                    nextSibling.remove();
                }
            }

            if (contactForm) {
                contactForm.addEventListener('submit', function(event) {
                    event.preventDefault();
                    let isValid = true;

                    inputsToValidate.forEach(clearError);

                    if (nameInput.value.trim() === '') {
                        displayError(nameInput, 'Full name is required.');
                        isValid = false;
                    }

                    if (emailInput.value.trim() === '') {
                        displayError(emailInput, 'Email is required.');
                        isValid = false;
                    } else if (!validateEmail(emailInput.value.trim())) {
                        displayError(emailInput, 'Please enter a valid email address.');
                        isValid = false;
                    }

                    if (subjectInput.value.trim() === '') {
                        displayError(subjectInput, 'Subject is required.');
                        isValid = false;
                    }

                    if (messageInput.value.trim() === '') {
                        displayError(messageInput, 'Message is required.');
                        isValid = false;
                    }

                    if (isValid) {
                        if (successPopupOverlay) {
                            successPopupOverlay.classList.add('visible');
                        }
                        contactForm.reset();
                        inputsToValidate.forEach(clearError);
                    }
                });
            }

            if (closeSuccessPopupButton && successPopupOverlay) {
                closeSuccessPopupButton.addEventListener('click', function() {
                    successPopupOverlay.classList.remove('visible');
                });
            }

            if (successPopupOverlay) {
                successPopupOverlay.addEventListener('click', function(event) {
                    if (event.target === successPopupOverlay) {
                        successPopupOverlay.classList.remove('visible');
                    }
                });
            }

            inputsToValidate.forEach(input => {
                if (input) {
                    input.addEventListener('input', () => clearError(input));
                    input.addEventListener('blur', () => { // Optional: validate on blur as well
                        if (input.value.trim() === '' && input.required) {
                           // displayError(input, `${input.labels[0].textContent} is required.`); // Basic blur validation
                        } else if (input === emailInput && input.value.trim() !== '' && !validateEmail(input.value.trim())) {
                           // displayError(emailInput, 'Please enter a valid email address.');
                        } else {
                            clearError(input);
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>