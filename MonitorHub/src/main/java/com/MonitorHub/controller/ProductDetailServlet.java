package com.MonitorHub.controller; // Change to your actual package

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Import your Product model and Service (replace with actual classes)
// import com.yourwebapp.model.Product;
// import com.yourwebapp.service.ProductService;

import java.io.IOException;
import java.math.BigDecimal; // For example price

// Placeholder Product class (replace with your actual model)
class Product {
    private long id;
    private String name;
    private String shortDescription;
    private String longDescription;
    private BigDecimal price;
    private BigDecimal oldPrice;
    private String imageUrl;
    private int stock;
    // Add constructors, getters, setters

    // Example Constructor
    public Product(long id, String name, String shortDescription, String longDescription, BigDecimal price, BigDecimal oldPrice, String imageUrl, int stock) {
        this.id = id;
        this.name = name;
        this.shortDescription = shortDescription;
        this.longDescription = longDescription;
        this.price = price;
        this.oldPrice = oldPrice;
        this.imageUrl = imageUrl;
        this.stock = stock;
    }
    // Add Getters for all fields...
    public long getId() { return id; }
    public String getName() { return name; }
    public String getShortDescription() { return shortDescription; }
    public String getLongDescription() { return longDescription; }
    public BigDecimal getPrice() { return price; }
    public BigDecimal getOldPrice() { return oldPrice; }
    public String getImageUrl() { return imageUrl; }
    public int getStock() { return stock; }
}


/**
 * Servlet responsible for displaying the product detail page.
 */
@WebServlet("/product-details") // Maps this servlet to the URL pattern "/product-details"
public class ProductDetailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Placeholder for a service layer - replace with your actual service
    // private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productIdParam = request.getParameter("id");
        Product product = null; // Initialize product as null

        if (productIdParam != null && !productIdParam.isEmpty()) {
            try {
                long productId = Long.parseLong(productIdParam);

                // --- Placeholder Data Fetching Logic ---
                // Replace this block with your actual call to a ProductService
                // Example: product = productService.findProductById(productId);

                // Dummy data based on ID for demonstration:
                if (productId == 1) { // Example ID
                    product = new Product(1,
                            "Samsung Odyssey G7 32\"",
                            "Experience immersive gaming with this stunning QHD curved monitor featuring a blazing fast refresh rate and response time...",
                            "Dive deeper into the world of high-fidelity gaming. This monitor boasts Quantum Dot technology for vibrant colors and deep contrasts. The 1000R curve matches the contour of the human eye for maximum immersion and reduced eye strain during long sessions. Adaptive-Sync technology ensures smooth, tear-free gameplay.",
                            new BigDecimal("599.99"),
                            new BigDecimal("699.99"),
                            "https://images.samsung.com/is/image/samsung/p6pim/hk_en/ls32bg750ncxxk/gallery/hk-en-odyssey-neo-g7-g75nb-ls32bg750ncxxk-thumb-532845951", // Use actual or placeholder image URL
                            15 // Example stock
                    );
                } else if (productId == 2) { // Example ID
                     product = new Product(2,
                            "LG UltraFine 27UP850-W 27\" 4K",
                            "Ideal for creative professionals, this 4K monitor offers superb color accuracy, USB-C connectivity, and HDR support.",
                            "Bring your creative visions to life with the LG UltraFine display. Featuring a 4K IPS panel with 95% DCI-P3 color gamut coverage, VESA DisplayHDR 400, and convenient USB-C connectivity with 96W power delivery to charge your laptop.",
                            new BigDecimal("449.99"),
                            null, // No old price for this example
                             "https://compujordan.com/image/cache/catalog/products/Monitor%20and%20Display/LG%20Monitors/27UP850-W/lg_27UP850-W_1-1200x1200.jpg",
                            25 // Example stock
                    );
                } // Add more else if blocks for other product IDs or use a proper service call

                // --- End Placeholder Data Fetching ---


            } catch (NumberFormatException e) {
                System.err.println("Invalid product ID format: " + productIdParam);
                // Optionally redirect to an error page or product list
                // response.sendRedirect(request.getContextPath() + "/products?error=invalidId");
                // return;
            }
        } else {
            System.err.println("Product ID parameter is missing.");
            // Optionally redirect
             // response.sendRedirect(request.getContextPath() + "/products?error=missingId");
             // return;
        }

        // Set the found product (or null if not found/error) as a request attribute
        request.setAttribute("product", product);

        // Define the path to the JSP file
        String jspPath = "/WEB-INF/pages/product_desc.jsp";

        // Forward the request to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }
}