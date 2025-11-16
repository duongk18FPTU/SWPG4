package controller.recuiter;

import dal.RecruiterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Recruiter;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@WebServlet(name = "CompanyInfoServlet", urlPatterns = {"/CompanyInfoServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class CompanyInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Recruiter recruiter = (Recruiter) session.getAttribute("user");
        
        if (recruiter == null) {
            response.sendRedirect(request.getContextPath() + "/Recruiter/recruiter-login.jsp");
            return;
        }
        
        // Load company info from database
        RecruiterDAO recruiterDAO = new RecruiterDAO();
        Recruiter fullRecruiter = recruiterDAO.getRecruiterById(recruiter.getRecruiterID());
        
        
        if (fullRecruiter != null) {
            // Clean up company images - remove any logo paths that might be mixed in
            if (fullRecruiter.getImg() != null && !fullRecruiter.getImg().isEmpty()) {
                String cleanedImages = cleanCompanyImages(fullRecruiter.getImg());
                if (!cleanedImages.equals(fullRecruiter.getImg())) {
                    // Update database if cleanup was needed
                    recruiterDAO.updateCompanyImages(fullRecruiter.getRecruiterID(), cleanedImages);
                    fullRecruiter.setImg(cleanedImages);
                }
            }
            
            // Cập nhật session với dữ liệu mới nhất từ database - đảm bảo cả hai keys đều được cập nhật
            // Debug: Log loaded data
            System.out.println("=== DEBUG: doGet - Loaded from database ===");
            System.out.println("fullRecruiter.getImg(): " + fullRecruiter.getImg());
            System.out.println("fullRecruiter.getCompanyLogoURL(): " + fullRecruiter.getCompanyLogoURL());
            System.out.println("=== END DEBUG ===");
            
            session.setAttribute("user", fullRecruiter);
            session.setAttribute("recruiter", fullRecruiter);
            
            request.setAttribute("recruiter", fullRecruiter);
        }
        
        request.getRequestDispatcher("/Recruiter/company-info.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Recruiter recruiter = (Recruiter) session.getAttribute("user");
        if (recruiter == null) {
            response.sendRedirect(request.getContextPath() + "/Recruiter/recruiter-login.jsp");
            return;
        }
        
        try {
            // Get form data
            String companyName = request.getParameter("companyName");
            String phone = request.getParameter("phone");
            String companyAddress = request.getParameter("companyAddress");
            String companySize = request.getParameter("companySize");
            String contactPerson = request.getParameter("contactPerson");
            String companyBenefits = request.getParameter("companyBenefits");
            String companyDescription = request.getParameter("companyDescription");
            String companyVideoURL = request.getParameter("companyVideoURL");
            String website = request.getParameter("website");
            String taxCode = request.getParameter("taxCode");
            
            // Get removal flags
            String removedLogo = request.getParameter("removedLogo");
            String removedImages = request.getParameter("removedImages");
            
            // ========================================
            // VALIDATION BEFORE PROCESSING
            // ========================================
            
            // Validate phone number
            if (phone != null && !phone.trim().isEmpty()) {
                if (!isValidPhoneFormat(phone.trim())) {
                    response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=phone_format_invalid");
                    return;
                }
                
                // Only check if phone exists for other recruiters if the phone number has changed
                String trimmedPhone = phone.trim();
                String currentPhone = recruiter.getPhone() != null ? recruiter.getPhone().trim() : "";
                if (!trimmedPhone.equals(currentPhone)) {
                    // Check if phone already exists for other recruiters
                    RecruiterDAO recruiterDAO = new RecruiterDAO();
                    if (recruiterDAO.isPhoneExistsForOtherRecruiter(trimmedPhone, recruiter.getRecruiterID())) {
                        response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=phone_exists");
                        return;
                    }
                }
            }
            
            // Validate tax code
            if (taxCode != null && !taxCode.trim().isEmpty()) {
                if (!isValidTaxCodeFormat(taxCode.trim())) {
                    response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=taxcode_format_invalid");
                    return;
                }
                
                // Only check if tax code exists for other recruiters if the tax code has changed
                String trimmedTaxCode = taxCode.trim();
                String currentTaxCode = recruiter.getTaxcode() != null ? recruiter.getTaxcode().trim() : "";
                if (!trimmedTaxCode.equals(currentTaxCode)) {
                    // Check if tax code already exists for other recruiters
                    RecruiterDAO recruiterDAO = new RecruiterDAO();
                    if (recruiterDAO.isTaxCodeExistsForOtherRecruiter(trimmedTaxCode, recruiter.getRecruiterID())) {
                        response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=taxcode_exists");
                        return;
                    }
                }
            }
            
            // Validate uploaded files
            String fileValidationError = validateUploadedFiles(request);
            if (fileValidationError != null) {
                response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=" + fileValidationError);
                return;
            }
            
            // ========================================
            // FILE PROCESSING
            // ========================================
            
            // Handle logo upload (single file)
            String logoPath = handleLogoUpload(request, recruiter.getRecruiterID());
            
            // Handle company images upload (multiple files)
            String companyImagesPath = handleCompanyImagesUpload(request, recruiter.getRecruiterID());
            
            // Handle registration certificate upload
            String registrationCertPath = handleRegistrationCertUpload(request, recruiter.getRecruiterID());
            
            // Handle image removal
            handleImageRemoval(request, removedLogo, removedImages);
            
            // Determine final logo and images paths
            String finalLogoPath = logoPath;
            String finalImagesPath = companyImagesPath;
            
            // If no new logo uploaded but logo was removed, set to null
            if (logoPath == null && "true".equals(removedLogo)) {
                finalLogoPath = null;
            }
            // If no new logo uploaded and logo not removed, keep existing
            else if (logoPath == null && !"true".equals(removedLogo)) {
                finalLogoPath = recruiter.getCompanyLogoURL();
            }
            
            // Normalize finalLogoPath: convert empty string to null, trim whitespace
            if (finalLogoPath != null) {
                finalLogoPath = finalLogoPath.trim();
                if (finalLogoPath.isEmpty()) {
                    finalLogoPath = null;
                }
            }
            
            // Normalize removedImages: trim and check if it has valid content
            String normalizedRemovedImages = null;
            if (removedImages != null && !removedImages.trim().isEmpty()) {
                // Check if removedImages contains any non-empty values after splitting
                String[] removedArray = removedImages.split(",");
                StringBuilder validRemoved = new StringBuilder();
                for (String removed : removedArray) {
                    String trimmed = removed.trim();
                    if (!trimmed.isEmpty()) {
                        if (validRemoved.length() > 0) {
                            validRemoved.append(",");
                        }
                        validRemoved.append(trimmed);
                    }
                }
                if (validRemoved.length() > 0) {
                    normalizedRemovedImages = validRemoved.toString();
                }
            }
            
            // Handle company images - merge existing and new images
            if (companyImagesPath != null) {
                // If new images uploaded, merge with existing images
                String existingImages = recruiter.getImg();
                if (existingImages != null && !existingImages.isEmpty()) {
                    // Remove images that were marked for deletion
                    if (normalizedRemovedImages != null) {
                        existingImages = removeImagesFromExisting(existingImages, normalizedRemovedImages);
                    }
                    // Merge existing and new images
                    if (existingImages != null && !existingImages.isEmpty()) {
                        finalImagesPath = existingImages + "," + companyImagesPath;
                    } else {
                        finalImagesPath = companyImagesPath;
                    }
                } else {
                    // No existing images, use only new images
                    finalImagesPath = companyImagesPath;
                }
            } else if (normalizedRemovedImages != null) {
                // Only removal, no new uploads
                finalImagesPath = removeImagesFromExisting(recruiter.getImg(), normalizedRemovedImages);
            } else {
                // No changes to images
                finalImagesPath = recruiter.getImg();
            }
            
            // Normalize finalImagesPath: convert empty string to null, trim whitespace
            if (finalImagesPath != null) {
                finalImagesPath = finalImagesPath.trim();
                if (finalImagesPath.isEmpty()) {
                    finalImagesPath = null;
                }
            }
            
            // Debug: Log image paths before saving
            System.out.println("=== DEBUG: Before saving to database ===");
            System.out.println("removedLogo: " + removedLogo);
            System.out.println("removedImages (raw): " + removedImages);
            System.out.println("normalizedRemovedImages: " + normalizedRemovedImages);
            System.out.println("finalLogoPath: " + finalLogoPath);
            System.out.println("finalImagesPath: " + finalImagesPath);
            System.out.println("Current recruiter.getImg(): " + recruiter.getImg());
            System.out.println("=== END DEBUG ===");
            
            // Validate path length before saving to database
            if (finalImagesPath != null && finalImagesPath.length() > 500) {
                // Keep only first 5 images if path is too long
                String[] images = finalImagesPath.split(",");
                if (images.length > 5) {
                    StringBuilder truncated = new StringBuilder();
                    for (int i = 0; i < 5 && i < images.length; i++) {
                        if (truncated.length() > 0) {
                            truncated.append(",");
                        }
                        truncated.append(images[i].trim());
                    }
                    finalImagesPath = truncated.toString();
                }
            }
            
            // Update recruiter info
            RecruiterDAO recruiterDAO = new RecruiterDAO();
            
            boolean success = recruiterDAO.updateCompanyInfoWithTaxAndCert(
                recruiter.getRecruiterID(),
                companyName,
                phone,
                companyAddress,
                companySize,
                contactPerson,
                companyBenefits,
                companyDescription,
                companyVideoURL,
                website,
                finalLogoPath,
                finalImagesPath,
                taxCode,
                registrationCertPath
            );
            
            if (success) {
                // Update session with new data - cập nhật cả hai keys để đảm bảo tất cả trang đều thấy dữ liệu mới
                Recruiter updatedRecruiter = recruiterDAO.getRecruiterById(recruiter.getRecruiterID());
                if (updatedRecruiter != null) {
                    // Debug: Log session update
                    System.out.println("=== DEBUG: Updating session ===");
                    System.out.println("Updated recruiter.getImg(): " + updatedRecruiter.getImg());
                    System.out.println("Updated recruiter.getCompanyLogoURL(): " + updatedRecruiter.getCompanyLogoURL());
                    System.out.println("=== END DEBUG ===");
                    
                    session.setAttribute("user", updatedRecruiter);
                    session.setAttribute("recruiter", updatedRecruiter); // Cập nhật cả key "recruiter" để job-posting.jsp có thể đọc được
                }
                
                response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=update_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/CompanyInfoServlet?error=system_error");
        }
    }
    
    private String handleLogoUpload(HttpServletRequest request, int recruiterId) throws IOException, ServletException {
        Part logoPart = request.getPart("companyLogo");
        
        if (logoPart != null && logoPart.getSize() > 0) {
            String fileName = getFileName(logoPart);
            if (fileName != null && !fileName.isEmpty()) {
                // Create upload directory if not exists
                String uploadDir = getServletContext().getRealPath("/uploads/logos");
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Generate shorter unique filename
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "l" + recruiterId + "_" + System.currentTimeMillis() + fileExtension;
                
                // Save file
                File file = new File(uploadDir, uniqueFileName);
                try (InputStream input = logoPart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                
                String logoPath = "/uploads/logos/" + uniqueFileName;
                
                return logoPath;
            }
        }
        
        return null;
    }
    
    private String handleCompanyImagesUpload(HttpServletRequest request, int recruiterId) throws IOException, ServletException {
        StringBuilder imagePaths = new StringBuilder();
        int maxImages = 5; // Limit to 5 images
        int imageCount = 0;
        
        for (Part part : request.getParts()) {
            if (part.getName().equals("companyImages") && part.getSize() > 0 && imageCount < maxImages) {
                String fileName = getFileName(part);
                if (fileName != null && !fileName.isEmpty()) {
                    // Create upload directory if not exists
                    String uploadDir = getServletContext().getRealPath("/uploads/company-images");
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        uploadDirFile.mkdirs();
                    }
                    
                    // Generate shorter unique filename to save space
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = "c" + recruiterId + "_" + System.currentTimeMillis() + "_" + (imageCount + 1) + fileExtension;
                    
                    // Save file
                    File file = new File(uploadDir, uniqueFileName);
                    try (InputStream input = part.getInputStream()) {
                        Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }
                    
                    String imagePath = "/uploads/company-images/" + uniqueFileName;
                    
                    if (imagePaths.length() > 0) {
                        imagePaths.append(",");
                    }
                    imagePaths.append(imagePath);
                    imageCount++;
                }
            }
        }
        
        String result = imagePaths.length() > 0 ? imagePaths.toString() : null;
        return result;
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf("=") + 2, token.length() - 1);
                }
            }
        }
        return null;
    }
    
    private void handleImageRemoval(HttpServletRequest request, String removedLogo, String removedImages) {
        // Handle logo removal
        if ("true".equals(removedLogo)) {
            // Remove logo file from server
            try {
                String logoPath = getServletContext().getRealPath("/uploads/logos");
                File logoDir = new File(logoPath);
                if (logoDir.exists()) {
                    File[] logoFiles = logoDir.listFiles((dir, name) -> name.startsWith("logo_"));
                    if (logoFiles != null) {
                        for (File logoFile : logoFiles) {
                            logoFile.delete();
                        }
                    }
                }
            } catch (Exception e) {
                // Error removing logo
            }
        }
        
        // Handle company images removal
        if (removedImages != null && !removedImages.isEmpty()) {
            String[] imagesToRemove = removedImages.split(",");
            for (String imagePath : imagesToRemove) {
                if (!imagePath.trim().isEmpty()) {
                    try {
                        String fullPath = getServletContext().getRealPath(imagePath.trim());
                        File file = new File(fullPath);
                        if (file.exists()) {
                            file.delete();
                        }
                    } catch (Exception e) {
                        // Error removing image
                    }
                }
            }
        }
    }
    
    private String removeImagesFromExisting(String existingImages, String removedImages) {
        if (existingImages == null || existingImages.isEmpty()) {
            return null;
        }
        
        if (removedImages == null || removedImages.isEmpty()) {
            return existingImages;
        }
        
        String[] existingArray = existingImages.split(",");
        String[] removedArray = removedImages.split(",");
        
        StringBuilder result = new StringBuilder();
        
        for (String existing : existingArray) {
            String trimmedExisting = existing.trim();
            boolean shouldRemove = false;
            
            // Check if this image should be removed
            for (String removed : removedArray) {
                if (trimmedExisting.equals(removed.trim())) {
                    shouldRemove = true;
                    break;
                }
            }
            
            // Also filter out logo images from company images
            if (!shouldRemove && trimmedExisting.contains("/logos/")) {
                shouldRemove = true;
            }
            
            if (!shouldRemove) {
                if (result.length() > 0) {
                    result.append(",");
                }
                result.append(trimmedExisting);
            }
        }
        
        return result.length() > 0 ? result.toString() : null;
    }
    
    private String cleanCompanyImages(String companyImages) {
        if (companyImages == null || companyImages.isEmpty()) {
            return null;
        }
        
        String[] imagePaths = companyImages.split(",");
        StringBuilder result = new StringBuilder();
        
        for (String imagePath : imagePaths) {
            String trimmedPath = imagePath.trim();
            if (!trimmedPath.isEmpty() && !trimmedPath.contains("/logos/")) {
                if (result.length() > 0) {
                    result.append(",");
                }
                result.append(trimmedPath);
            }
        }
        
        return result.length() > 0 ? result.toString() : null;
    }
    
    // ========================================
    // VALIDATION METHODS
    // ========================================
    
    /**
     * Kiểm tra định dạng số điện thoại Việt Nam
     * Phải có 10 số, bắt đầu bằng 03, 08, 09 và không có khoảng cách
     */
    private boolean isValidPhoneFormat(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        
        // Loại bỏ tất cả khoảng trắng
        String cleanPhone = phone.replaceAll("\\s+", "");
        
        // Kiểm tra định dạng: 10 số, bắt đầu bằng 03, 08, 09
        return cleanPhone.matches("^(03|08|09)[0-9]{8}$");
    }
    
    /**
     * Kiểm tra định dạng mã số thuế
     * Phải có 10 số, không có khoảng cách và chữ cái
     */
    private boolean isValidTaxCodeFormat(String taxCode) {
        if (taxCode == null || taxCode.trim().isEmpty()) {
            return false;
        }
        
        // Loại bỏ tất cả khoảng trắng
        String cleanTaxCode = taxCode.replaceAll("\\s+", "");
        
        // Kiểm tra định dạng: 10 số
        return cleanTaxCode.matches("^[0-9]{10}$");
    }
    
    /**
     * Validate tất cả files được upload
     */
    private String validateUploadedFiles(HttpServletRequest request) throws ServletException, IOException {
        // Validate logo file
        Part logoPart = request.getPart("companyLogo");
        if (logoPart != null && logoPart.getSize() > 0) {
            String logoError = validateSingleFile(logoPart, "logo");
            if (logoError != null) {
                return logoError;
            }
        }
        
        // Validate company images
        int imageCount = 0;
        for (Part part : request.getParts()) {
            if (part.getName().equals("companyImages") && part.getSize() > 0) {
                imageCount++;
                if (imageCount > 5) {
                    return "max_images_exceeded";
                }
                String imageError = validateSingleFile(part, "image");
                if (imageError != null) {
                    return imageError;
                }
            }
        }
        
        // Validate registration certificate
        Part certPart = request.getPart("registrationCert");
        if (certPart != null && certPart.getSize() > 0) {
            String certError = validateSingleFile(certPart, "certificate");
            if (certError != null) {
                return certError;
            }
        }
        
        return null; // No errors
    }
    
    /**
     * Validate một file đơn lẻ
     */
    private String validateSingleFile(Part filePart, String fileType) {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        String contentType = filePart.getContentType();
        long fileSize = filePart.getSize();
        
        switch (fileType) {
            case "logo":
                if (!isValidImageType(contentType)) {
                    return "logo_invalid_type";
                }
                if (fileSize > 1024 * 1024) { // 1MB
                    return "logo_too_large";
                }
                break;
                
            case "image":
                if (!isValidImageType(contentType)) {
                    return "image_invalid_type";
                }
                if (fileSize > 1024 * 1024) { // 1MB
                    return "image_too_large";
                }
                break;
                
            case "certificate":
                if (!isValidDocumentType(contentType)) {
                    return "cert_invalid_type";
                }
                if (fileSize > 5 * 1024 * 1024) { // 5MB
                    return "cert_too_large";
                }
                break;
        }
        
        return null; // No errors
    }
    
    /**
     * Kiểm tra loại file hình ảnh hợp lệ
     */
    private boolean isValidImageType(String contentType) {
        return "image/jpeg".equals(contentType) || 
               "image/jpg".equals(contentType) || 
               "image/png".equals(contentType) || 
               "image/gif".equals(contentType);
    }
    
    /**
     * Kiểm tra loại file tài liệu hợp lệ
     */
    private boolean isValidDocumentType(String contentType) {
        return "application/pdf".equals(contentType) || 
               "image/jpeg".equals(contentType) || 
               "image/jpg".equals(contentType) || 
               "image/png".equals(contentType);
    }
    
    /**
     * Handle registration certificate upload
     */
    private String handleRegistrationCertUpload(HttpServletRequest request, int recruiterId) throws IOException, ServletException {
        Part certPart = request.getPart("registrationCert");
        
        if (certPart != null && certPart.getSize() > 0) {
            String fileName = getFileName(certPart);
            if (fileName != null && !fileName.isEmpty()) {
                // Create upload directory if not exists
                String uploadDir = getServletContext().getRealPath("/uploads/certificates");
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Generate unique filename
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "cert_" + recruiterId + "_" + System.currentTimeMillis() + fileExtension;
                
                // Save file
                File file = new File(uploadDir, uniqueFileName);
                try (InputStream input = certPart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                
                String certPath = "/uploads/certificates/" + uniqueFileName;
                return certPath;
            }
        }
        
        return null;
    }
}
