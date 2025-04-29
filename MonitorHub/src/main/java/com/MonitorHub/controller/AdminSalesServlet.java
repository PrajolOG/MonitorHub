package com.MonitorHub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
// import jakarta.servlet.http.HttpSession; // Keep for later auth check
// import com.MonitorHub.model.User;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.MonitorHub.model.User;

@WebServlet("/admin/sales")
public class AdminSalesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminSalesServlet.class.getName());
    private static final String VIEW = "/WEB-INF/pages/adminSales.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("AdminSalesServlet doGet called.");

        // --- Authentication & Authorization Check (Placeholder) ---
        
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (loggedInUser == null || !"Admin".equalsIgnoreCase(loggedInUser.getRoleName())) {
            LOGGER.warning("Unauthorized access attempt to /admin/sales.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // --- End Auth Check ---

        // --- Placeholder Sales Data Generation ---
        List<Map<String, Object>> salesData = generatePlaceholderSales(request.getContextPath()); // Pass context path
        request.setAttribute("salesData", salesData);
        LOGGER.log(Level.INFO, "Generated {0} placeholder sales records.", salesData.size());

        // --- Placeholder Summary Metrics Calculation ---
        Map<String, Object> summaryMetrics = calculateSummaryMetrics(salesData);
        request.setAttribute("summaryMetrics", summaryMetrics);
        LOGGER.log(Level.INFO, "Calculated summary metrics: {0}", summaryMetrics);


        // Forward to the JSP view
        try {
            request.getRequestDispatcher(VIEW).forward(request, response);
            LOGGER.info("Forwarding to view: " + VIEW);
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error forwarding to view: " + VIEW, e);
             if (!response.isCommitted()) {
                  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not display the sales page.");
             }
        }
    }

    // --- Helper to Generate Placeholder Sales (Added customerImageUrl) ---
    private List<Map<String, Object>> generatePlaceholderSales(String contextPath) {
        List<Map<String, Object>> sales = new ArrayList<>();
        ZoneId defaultZoneId = ZoneId.systemDefault();
        String defaultUserImage = contextPath + "/images/defaultuserprofile.jpg";

        // Sale 1
        Map<String, Object> sale1 = new HashMap<>();
        sale1.put("saleId", 5001);
        sale1.put("customerId", 102); // Example customer ID
        sale1.put("customerName", "Bob Customer");
        sale1.put("customerImageUrl", defaultUserImage); // Placeholder URL
        sale1.put("productName", "Dell UltraSharp U2723QE");
        sale1.put("saleDate", Date.from(LocalDateTime.now().minusDays(1).minusHours(3).atZone(defaultZoneId).toInstant()));
        sale1.put("quantity", 1);
        sale1.put("pricePerItem", new BigDecimal("599.99"));
        sale1.put("totalAmount", new BigDecimal("599.99"));
        sales.add(sale1);

        // Sale 2
        Map<String, Object> sale2 = new HashMap<>();
        sale2.put("saleId", 5002);
        sale2.put("customerId", 103);
        sale2.put("customerName", "Charlie Another");
        sale2.put("customerImageUrl", defaultUserImage); // Placeholder URL
        sale2.put("productName", "Samsung Odyssey G9 49\"");
        sale2.put("saleDate", Date.from(LocalDateTime.now().minusDays(2).plusHours(1).atZone(defaultZoneId).toInstant()));
        sale2.put("quantity", 1);
        sale2.put("pricePerItem", new BigDecimal("1199.00"));
        sale2.put("totalAmount", new BigDecimal("1199.00"));
        sales.add(sale2);

        // Sale 3 (Multiple quantity)
        Map<String, Object> sale3 = new HashMap<>();
        sale3.put("saleId", 5003);
        sale3.put("customerId", 102);
        sale3.put("customerName", "Bob Customer");
        sale3.put("customerImageUrl", defaultUserImage); // Placeholder URL
        sale3.put("productName", "LG 34WN80C-B UltraWide");
        sale3.put("saleDate", Date.from(LocalDateTime.now().minusHours(5).atZone(defaultZoneId).toInstant()));
        sale3.put("quantity", 2);
        sale3.put("pricePerItem", new BigDecimal("549.99"));
        sale3.put("totalAmount", new BigDecimal("549.99").multiply(new BigDecimal(2)));
        sales.add(sale3);

         // Sale 4
        Map<String, Object> sale4 = new HashMap<>();
        sale4.put("saleId", 5004);
        sale4.put("customerId", 101);
        sale4.put("customerName", "Alice Admin");
        sale4.put("customerImageUrl", defaultUserImage); // Placeholder URL for Admin too?
        sale4.put("productName", "Dell UltraSharp U2723QE");
        sale4.put("saleDate", Date.from(LocalDateTime.now().minusDays(5).atZone(defaultZoneId).toInstant()));
        sale4.put("quantity", 1);
        sale4.put("pricePerItem", new BigDecimal("610.00"));
        sale4.put("totalAmount", new BigDecimal("610.00"));
        sales.add(sale4);

        return sales;
    }

    // --- Helper to Calculate Summary Metrics (REVISED - Only Revenue and Count) ---
    private Map<String, Object> calculateSummaryMetrics(List<Map<String, Object>> salesData) {
        BigDecimal totalRevenue = BigDecimal.ZERO;
        int numberOfSales = salesData.size();

        for (Map<String, Object> sale : salesData) {
             totalRevenue = totalRevenue.add((BigDecimal) sale.get("totalAmount"));
        }

        Map<String, Object> metrics = new HashMap<>();
        metrics.put("totalRevenue", totalRevenue);
        metrics.put("numberOfSales", numberOfSales);

        return metrics;
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.warning("AdminSalesServlet doPost called - currently not implemented.");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported for this URL.");
    }
}