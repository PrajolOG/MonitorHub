<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Manage Users'} - Admin</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/userAdmin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
	    /* --- Base Styles (Keep as they are) --- */
	    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
	    :root {
	        --primary-purple: #9d4edd; --secondary-purple: #c77dff;
	        --gradient: linear-gradient(90deg, var(--primary-purple) 0%, var(--secondary-purple) 100%);
	        --bg-light-start: #f5f7fa; --bg-light-end: #c3cfe2;
	        --bg-body-gradient: linear-gradient(135deg, var(--bg-light-start) 0%, var(--bg-light-end) 100%);
	        --sidebar-bg: rgba(255, 255, 255, 0.5); --sidebar-border: rgba(255, 255, 255, 0.25);
	        --card-bg: rgba(255, 255, 255, 0.75); --text-dark: #2d3748; --text-medium: #4a5568;
	        --text-light: #718096; --white: #ffffff; --hover-bg: rgba(157, 78, 221, 0.1);
	        --border-light: #e2e8f0; --border-medium: #cbd5e0;
	        --danger-red: #e53e3e; --danger-red-light: #fed7d7;
	        --info-blue: #3182ce; --info-blue-light: #bee3f8;
	        --success-green: #38a169; --success-green-light: #c6f6d5;
	        --warning-orange: #dd6b20; --warning-orange-light: #feebc8;
	    }
	    body {
	        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
	        background-color: var(--bg-light-start); background-image: var(--bg-body-gradient);
	        color: var(--text-dark); margin: 0; display: flex; min-height: 100vh;
	        background-attachment: fixed;
	    }
	    .dashboard-container { display: flex; width: 100%; }
	    .main-content { flex-grow: 1; padding: 30px; overflow-y: auto; }
	    .main-content > h1 { font-size: 28px; margin-bottom: 20px; color: var(--text-dark); }
	     .status-message { padding: 12px 18px; border-radius: 6px; margin: 0 0 20px 0; font-size: 14px; font-weight: 500; border: 1px solid transparent; }
	     .status-message.success { background-color: var(--success-green-light, #c6f6d5); border-color: var(--success-green, #38a169); color: #2f6f4a; }
	     .status-message.error { background-color: var(--danger-red-light, #fed7d7); border-color: var(--danger-red, #e53e3e); color: #a11c1c; }
         .status-message.info { background-color: var(--info-blue-light, #bee3f8); border-color: var(--info-blue, #3182ce); color: #2c5282; }
         .status-message i { margin-right: 8px; }

	     @media (max-width: 768px) {
	         body { flex-direction: column; }
	         .dashboard-container { flex-direction: column; }
	         .main-content { height: auto; padding: 20px; overflow-y: visible; }
	         .main-content > h1 { font-size: 24px; }
	     }

         /* --- START: Internal CSS for Delete Confirmation Modal --- */
        .delete-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1050; /* Ensure it's above other content */
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0s linear 0.3s;
             /* Apply backdrop blur - use variables if defined, otherwise direct values */
            -webkit-backdrop-filter: blur(4px);
            backdrop-filter: blur(4px);
        }

        .delete-modal-overlay.visible {
            opacity: 1;
            visibility: visible;
            transition: opacity 0.3s ease;
        }

        .delete-modal-content {
            background-color: var(--white, #ffffff);
            padding: 25px 30px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 400px;
            text-align: center;
            transform: scale(0.9);
            transition: transform 0.3s ease;
        }

        .delete-modal-overlay.visible .delete-modal-content {
            transform: scale(1);
        }

        .delete-modal-content h4 { /* Use h4 for modal title */
            font-size: 1.3rem;
            color: var(--text-dark, #2d3748);
            margin-top: 0;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .delete-modal-content p {
            font-size: 1rem;
            color: var(--text-medium, #4a5568);
            line-height: 1.5;
            margin-bottom: 25px;
        }
         /* Style for the username within the modal message */
        .delete-modal-content p strong {
            color: var(--danger-red, #e53e3e);
            font-weight: 600;
        }

        .delete-modal-actions {
            display: flex;
            justify-content: center; /* Center buttons */
            gap: 15px; /* Space between buttons */
        }

        .delete-modal-btn {
            padding: 9px 20px;
            border: none;
            border-radius: 5px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease, box-shadow 0.2s ease, transform 0.1s ease;
            min-width: 80px;
        }
         .delete-modal-btn:active {
             transform: scale(0.96);
         }

        .modal-cancel-btn {
            background-color: #f1f5f9; /* Light grey */
            color: var(--text-medium, #4a5568);
            border: 1px solid var(--border-medium, #cbd5e0);
        }
        .modal-cancel-btn:hover {
             background-color: #e2e8f0;
        }

        .modal-confirm-btn {
            background-color: var(--danger-red, #e53e3e);
            color: var(--white, #ffffff);
        }
         .modal-confirm-btn:hover {
             background-color: #c53030; /* Darker red */
             box-shadow: 0 2px 5px rgba(229, 62, 62, 0.3);
         }
         /* --- END: Internal CSS for Delete Confirmation Modal --- */
    </style>
</head>
<body>
    <div class="dashboard-container">

        <jsp:include page="/WEB-INF/includes/adminNav.jsp" />

        <main class="main-content">
            <h1>${not empty pageTitle ? pageTitle : 'Manage Users'}</h1>

            <%-- Display messages from redirects or errors --%>
             <c:if test="${not empty param.success}">
                <div class="status-message success"><i class="fas fa-check-circle"></i> <c:out value="${param.success}"/></div>
             </c:if>
             <c:if test="${not empty param.error}">
                 <div class="status-message error"><i class="fas fa-exclamation-triangle"></i> <c:out value="${param.error}"/></div>
             </c:if>
             <c:if test="${not empty param.message}">
                <div class="status-message info"><i class="fas fa-info-circle"></i> <c:out value="${param.message}"/></div>
            </c:if>
             <c:if test="${not empty requestScope.dbError}">
                <div class="status-message error"><i class="fas fa-database"></i> <c:out value="${requestScope.dbError}"/></div>
            </c:if>

            <div class="users-main-container">
                <div class="users-header">
                    <h2>All Users</h2>
                </div>

                <div class="table-wrapper">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Contact</th>
                                <th>Role</th>
                                <th>Joined</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty userList}">
                                    <c:forEach var="user" items="${userList}">
                                        <tr>
                                            <td data-label="ID:"><span class="user-id">${user.userid}</span></td>
                                            <td data-label="User:">
                                                <div class="user-details-cell">
                                                    <img class="profile-img-sm"
                                                         src="${not empty user.imageUrl ? user.imageUrl : pageContext.request.contextPath.concat('/images/defaultuserprofile.jpg')}"
                                                         alt="Profile image for ${user.firstname}"
                                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/defaultuserprofile.jpg';">
                                                    <div class="user-name-email">
                                                        <span class="user-name"><c:out value="${user.firstname} ${user.lastname}"/></span>
                                                        <span class="user-email"><c:out value="${user.email}"/></span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td data-label="Contact:"><c:out value="${not empty user.phone ? user.phone : 'N/A'}"/></td>
                                            <td data-label="Role:">
                                                 <c:set var="roleClass" value="unknown"/>
                                                 <c:if test="${not empty user.roleName}">
                                                     <c:choose>
                                                         <c:when test="${user.roleName == 'Admin'}"><c:set var="roleClass" value="admin"/></c:when>
                                                         <c:when test="${user.roleName == 'Customer'}"><c:set var="roleClass" value="customer"/></c:when>
                                                     </c:choose>
                                                 </c:if>
                                                 <span class="user-role ${roleClass}">
                                                    <c:out value="${not empty user.roleName ? user.roleName : 'Unknown'}"/>
                                                 </span>
                                            </td>
                                            <td data-label="Joined:">
                                                <c:choose>
                                                    <c:when test="${not empty user.createdAt}">
                                                         <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="actions-cell">
                                                 <%-- UNIQUE FORM ID NEEDED for JS targeting --%>
                                                 <form id="deleteForm_${user.userid}" action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;">
                                                     <input type="hidden" name="action" value="delete">
                                                     <input type="hidden" name="userId" value="${user.userid}">

                                                     <%-- CHANGE: Button type is now "button", removed onsubmit, added onclick, added data-username --%>
                                                     <button type="button" class="action-btn delete-btn"
                                                             title="Delete User ${user.userid}"
                                                             data-username="<c:out value='${user.firstname} ${user.lastname}'/>"
                                                             data-formid="deleteForm_${user.userid}"
                                                             onclick="showDeleteConfirmModal(this.dataset.formid, this.dataset.username)"
                                                             <c:if test="${sessionScope.user.userid == user.userid}">disabled title="Cannot delete own account"</c:if> >
                                                         <i class="fas fa-trash-alt"></i> Delete
                                                     </button>
                                                 </form>
                                                 <%-- <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userid}" class="action-btn edit-btn">Edit</a> --%>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="no-data-message">No users found in the database.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div> <%-- End table-wrapper --%>

            </div> <%-- End users-main-container --%>
        </main> <%-- End main-content --%>
    </div> <%-- End dashboard-container --%>

    <%-- Delete Confirmation Modal HTML --%>
    <div id="deleteConfirmModalOverlay" class="delete-modal-overlay">
        <div class="delete-modal-content">
            <h4>Confirm Deletion</h4>
            <p>Are you sure you want to delete user <strong id="deleteConfirmUserName"></strong>? This action cannot be undone.</p>
            <div class="delete-modal-actions">
                <button id="deleteCancelButton" type="button" class="delete-modal-btn modal-cancel-btn">Cancel</button>
                <button id="deleteConfirmButton" type="button" class="delete-modal-btn modal-confirm-btn">Yes, Delete</button>
            </div>
        </div>
    </div>

    <%-- JavaScript for Delete Confirmation Modal --%>
    <script>
        let deleteModalOverlay = null;
        let deleteConfirmUserNameEl = null;
        let deleteConfirmButton = null;
        let deleteCancelButton = null;
        let formToSubmit = null; // Variable to hold the form that needs submitting

        document.addEventListener('DOMContentLoaded', () => {
            // Initialize modal elements
            deleteModalOverlay = document.getElementById('deleteConfirmModalOverlay');
            deleteConfirmUserNameEl = document.getElementById('deleteConfirmUserName');
            deleteConfirmButton = document.getElementById('deleteConfirmButton');
            deleteCancelButton = document.getElementById('deleteCancelButton');

            if (!deleteModalOverlay || !deleteConfirmUserNameEl || !deleteConfirmButton || !deleteCancelButton) {
                console.error("One or more delete confirmation modal elements not found!");
                return; // Stop if modal elements are missing
            }

            // Event listener for the "Yes, Delete" button in the modal
            deleteConfirmButton.addEventListener('click', () => {
                if (formToSubmit) {
                    console.log("Submitting delete form:", formToSubmit.id);
                    formToSubmit.submit(); // Submit the stored form
                } else {
                    console.error("No form reference stored for submission.");
                }
                hideDeleteConfirmModal(); // Hide modal after action
            });

            // Event listeners for closing the modal
            deleteCancelButton.addEventListener('click', hideDeleteConfirmModal);
            deleteModalOverlay.addEventListener('click', (event) => {
                if (event.target === deleteModalOverlay) {
                    hideDeleteConfirmModal();
                }
            });

            // --- The Delete buttons in the table are now handled by their inline onclick ---
            // No need for querySelectorAll('.delete-btn').addEventListener here anymore
        });

        // Function to show the delete confirmation modal
        function showDeleteConfirmModal(formId, userName) {
            formToSubmit = document.getElementById(formId); // Get the specific form by its ID
            if (!formToSubmit) {
                console.error("Could not find form with ID:", formId);
                alert("Error: Could not initiate delete action."); // Fallback
                return;
            }

            if (deleteConfirmUserNameEl && deleteModalOverlay) {
                deleteConfirmUserNameEl.textContent = userName || 'this user'; // Set the username in the message
                deleteModalOverlay.style.display = 'flex';
                 // Force reflow for transition
                void deleteModalOverlay.offsetWidth;
                deleteModalOverlay.classList.add('visible');
            } else {
                // Fallback if modal elements aren't ready - use standard confirm
                console.warn("Delete modal elements not ready, using standard confirm.");
                if (confirm('Are you sure you want to delete user ' + (userName || 'this user') + '?')) {
                    formToSubmit.submit();
                } else {
                     formToSubmit = null; // Clear if cancelled
                }
            }
        }

        // Function to hide the delete confirmation modal
        function hideDeleteConfirmModal() {
            formToSubmit = null; // Clear the form reference when modal is hidden
            if (deleteModalOverlay) {
                deleteModalOverlay.classList.remove('visible');
                setTimeout(() => {
                    if (deleteModalOverlay && !deleteModalOverlay.classList.contains('visible')) {
                        deleteModalOverlay.style.display = 'none';
                    }
                }, 300); // Match CSS transition duration
            }
        }
    </script>
</body>
</html>