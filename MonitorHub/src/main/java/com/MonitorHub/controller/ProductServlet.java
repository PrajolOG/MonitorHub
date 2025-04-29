package com.MonitorHub.controller; // Change to your actual package

import jakarta.servlet.RequestDispatcher; // Or javax.servlet.*
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Import data models and service classes as needed
// import com.yourwebapp.model.Product;
// import com.yourwebapp.service.ProductService;
// import java.util.List;

import java.io.IOException;

/**
 * Servlet responsible for displaying the product listing page.
 * Handles filtering, sorting, and pagination parameters.
 */
@WebServlet("/products") // Maps this servlet to the URL pattern "/products"
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // In a real app, you'd inject or instantiate a service to get product data
    // private ProductService productService = new ProductService();

    /**
     * Handles GET requests to /products.
     * Retrieves filter/sort/page parameters, fetches relevant product data,
     * and forwards to the products JSP page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Extract parameters for filtering, sorting, pagination
        String category = request.getParameter("category");
        String brand = request.getParameter("brand");
        String sortBy = request.getParameter("sort"); // e.g., "price_asc", "price_desc"
        String pageParam = request.getParameter("page");

        int currentPage = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                // Log error or default to page 1
                System.err.println("Invalid page number format: " + pageParam);
                currentPage = 1;
            }
        }

        // 2. Fetch data from a service/database based on parameters
        //    (This is where your business logic goes)
        // Example (replace with actual logic):
        /*
        int productsPerPage = 12; // Or get from config
        List<Product> productList = productService.findProducts(category, brand, sortBy, currentPage, productsPerPage);
        int totalProducts = productService.countProducts(category, brand);
        int totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);
        */

        // 3. Set data as request attributes for the JSP
        // Example (replace with actual data):
        /*
        request.setAttribute("productList", productList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        // Also set filter parameters back to retain selection in dropdowns
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedBrand", brand);
        request.setAttribute("selectedSort", sortBy);
        */

        // 4. Define the path to the JSP file
        // Make sure this path matches where you place products.jsp
        String jspPath = "/WEB-INF/pages/products.jsp";

        // 5. Get the RequestDispatcher and forward
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    /**
     * Handles POST requests. Typically, for a product listing page,
     * filters are submitted via GET. If POST is used, often redirects to GET.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirecting to GET after POST is a common pattern (Post-Redirect-Get)
        // Or simply handle like GET if no state change occurs.
        doGet(request, response);
    }
}