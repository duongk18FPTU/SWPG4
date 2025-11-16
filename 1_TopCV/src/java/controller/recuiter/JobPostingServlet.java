/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.recuiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import dal.JobDAO;
import dal.TypeDAO;
import dal.LocationDAO;
import dal.CategoryDAO;
import dal.RecruiterPackagesDAO;
import dal.JobPackagesDAO;
import dal.JobFeatureMappingsDAO;
import model.Job;
import util.JobCodeGenerator;
import model.Type;
import model.Location;
import model.Category;
import java.util.List;
import model.Recruiter;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 *
 * @author Admin
 */
@WebServlet(name = "JobPostingServlet", urlPatterns = {"/jobposting"})
public class JobPostingServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
     
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet JopPostingServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet JopPostingServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG: JobPostingServlet doGet() called"); // Gọi khi tải trang đăng tin (GET)
        try {
            // Kiểm tra xem có jobID không (chế độ chỉnh sửa)
            String jobIDStr = request.getParameter("jobID");
            System.out.println("========== DEBUG: JobPostingServlet.doGet() START ==========");
            System.out.println("DEBUG: jobID parameter = " + jobIDStr);
            Job existingJob = null;
            boolean isEditMode = false;
            
            if (jobIDStr != null && !jobIDStr.trim().isEmpty()) {
                try {
                    int jobID = Integer.parseInt(jobIDStr);
                    System.out.println("DEBUG: Parsed jobID = " + jobID);
                    JobDAO jobDAO = new JobDAO();
                    existingJob = jobDAO.getJobById(jobID);
                    System.out.println("DEBUG: existingJob retrieved: " + (existingJob != null ? "NOT NULL" : "NULL"));
                    
                    // Kiểm tra quyền: job phải thuộc về recruiter hiện tại
                    model.Recruiter recruiter = (model.Recruiter) request.getSession().getAttribute("recruiter");
                    System.out.println("DEBUG: recruiter from session: " + (recruiter != null ? "NOT NULL (ID: " + recruiter.getRecruiterID() + ")" : "NULL"));
                    if (existingJob != null) {
                        System.out.println("DEBUG: existingJob.getRecruiterID() = " + existingJob.getRecruiterID());
                    }
                    
                    if (existingJob != null && recruiter != null && existingJob.getRecruiterID() == recruiter.getRecruiterID()) {
                        isEditMode = true;
                        request.setAttribute("editingJob", existingJob);
                        request.setAttribute("isEditMode", true);
                        System.out.println("DEBUG: ===== ENTERING EDIT MODE =====");
                        System.out.println("DEBUG: Edit mode - JobID: " + jobID + ", Status: " + existingJob.getStatus());
                        
                        // Load job's category ID from Category table
                        int categoryID = existingJob.getCategoryID();
                        System.out.println("DEBUG: ===== LOADING CATEGORY =====");
                        System.out.println("DEBUG: existingJob.getCategoryID() = " + categoryID);
                        if (categoryID > 0) {
                            // Get category directly from Category table by CategoryID
                            CategoryDAO categoryDAO = new CategoryDAO();
                            System.out.println("DEBUG: Calling categoryDAO.getCategoryById(" + categoryID + ")");
                            Category category = categoryDAO.getCategoryById(categoryID);
                            if (category != null) {
                                System.out.println("DEBUG: Category found in database: ID=" + category.getCategoryID() + ", Name=" + category.getCategoryName() + ", ParentID=" + category.getParentCategoryID());
                                
                                // Set both ID and Name for direct display
                                request.setAttribute("editingJobCategoryID", categoryID);
                                request.setAttribute("editingJobCategoryName", category.getCategoryName());
                                System.out.println("DEBUG: Set attribute 'editingJobCategoryID' = " + categoryID);
                                System.out.println("DEBUG: Set attribute 'editingJobCategoryName' = " + category.getCategoryName());
                            } else {
                                System.out.println("DEBUG: WARNING: Category not found in Category table for ID: " + categoryID);
                            }
                        } else {
                            System.out.println("DEBUG: No CategoryID in job (categoryID <= 0)");
                        }
                        
                        // Load job's skills from Skill table through JobSkillMappings
                        System.out.println("DEBUG: ===== LOADING SKILLS =====");
                        dal.JobSkillMappingDAO jobSkillMappingDAO = new dal.JobSkillMappingDAO();
                        System.out.println("DEBUG: Calling jobSkillMappingDAO.getSkillIDsByJobID(" + jobID + ")");
                        java.util.List<Integer> skillIDs = jobSkillMappingDAO.getSkillIDsByJobID(jobID);
                        System.out.println("DEBUG: SkillIDs from JobSkillMapping: " + skillIDs);
                        System.out.println("DEBUG: SkillIDs size: " + (skillIDs != null ? skillIDs.size() : "null"));
                        
                        dal.SkillDAO skillDAO = new dal.SkillDAO();
                        java.util.List<String> skillNames = new java.util.ArrayList<>();
                        
                        if (skillIDs != null && !skillIDs.isEmpty()) {
                            System.out.println("DEBUG: Processing " + skillIDs.size() + " skill IDs");
                            for (Integer skillID : skillIDs) {
                                System.out.println("DEBUG: Getting skill for ID: " + skillID);
                                model.Skill skill = skillDAO.getSkillById(skillID);
                                if (skill != null && skill.getSkillName() != null) {
                                    skillNames.add(skill.getSkillName());
                                    System.out.println("DEBUG: Skill loaded successfully: " + skill.getSkillName() + " (ID: " + skillID + ")");
                                } else {
                                    System.out.println("DEBUG: WARNING: Skill not found in Skill table for ID: " + skillID);
                                }
                            }
                        } else {
                            System.out.println("DEBUG: No skills found in JobSkillMapping for JobID: " + jobID);
                        }
                        
                        // Always set the attribute, even if empty
                        request.setAttribute("editingJobSkills", skillNames);
                        System.out.println("DEBUG: Set attribute 'editingJobSkills' = " + skillNames);
                        System.out.println("DEBUG: editingJobSkills size: " + skillNames.size());
                        System.out.println("DEBUG: ===== EDIT MODE DATA LOADED =====");
                    } else {
                        request.setAttribute("error", "Không tìm thấy tin tuyển dụng hoặc bạn không có quyền chỉnh sửa!");
                        existingJob = null;
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG: Invalid jobID: " + jobIDStr);
                }
            }
            
            TypeDAO typeDAO = new TypeDAO(); // Khởi tạo DAO để lấy dữ liệu Type
            System.out.println("DEBUG: TypeDAO created"); // Log debug
            
            LocationDAO locationDAO = new LocationDAO(); // DAO địa điểm
            CategoryDAO categoryDAO = new CategoryDAO(); // DAO ngành nghề
            
            System.out.println("DEBUG: Calling getJobLevels()"); // Lấy danh sách cấp bậc công việc
            List<Type> jobLevels = typeDAO.getJobLevels(); // Danh sách cấp bậc
            System.out.println("DEBUG: getJobLevels() returned: " + (jobLevels != null ? jobLevels.size() + " items" : "null"));
            
            System.out.println("DEBUG: Calling getJobTypes()"); // Lấy danh sách loại việc
            List<Type> jobTypes = typeDAO.getJobTypes(); // Danh sách loại việc
            System.out.println("DEBUG: getJobTypes() returned: " + (jobTypes != null ? jobTypes.size() + " items" : "null"));
            
            System.out.println("DEBUG: Calling getTypesByCategory('Certificate')"); // Lấy danh sách bằng cấp
            List<Type> certificates = typeDAO.getTypesByCategory("Certificate"); // Danh sách bằng cấp
            System.out.println("DEBUG: getTypesByCategory('Certificate') returned: " + (certificates != null ? certificates.size() + " items" : "null"));
            
            List<Location> locations = locationDAO.getAllLocations(); // Danh sách địa điểm
            
            // Lấy parent categories và all categories để hiển thị dropdown phân cấp
            List<Category> parentCategories = categoryDAO.getParentCategories(); // Danh mục cha
            List<Category> allCategories = categoryDAO.getAllCategories(); // Tất cả danh mục (để lọc con theo cha)
            
            // Đảm bảo không set null - nếu null thì set empty list
            if (jobLevels == null) {
                jobLevels = new java.util.ArrayList<>(); // Tránh null gây lỗi JSP
                System.out.println("DEBUG: jobLevels was null, setting to empty list");
            }
            if (jobTypes == null) {
                jobTypes = new java.util.ArrayList<>(); // Tránh null gây lỗi JSP
                System.out.println("DEBUG: jobTypes was null, setting to empty list");
            }
            if (certificates == null) {
                certificates = new java.util.ArrayList<>(); // Tránh null gây lỗi JSP
                System.out.println("DEBUG: certificates was null, setting to empty list");
            }
            if (locations == null) {
                locations = new java.util.ArrayList<>(); // Tránh null
                System.out.println("DEBUG: locations was null, setting to empty list");
            }
            if (parentCategories == null) {
                parentCategories = new java.util.ArrayList<>(); // Tránh null
            }
            if (allCategories == null) {
                allCategories = new java.util.ArrayList<>(); // Tránh null
            }
            
            request.setAttribute("jobLevels", jobLevels); // Đẩy cấp bậc sang JSP
            request.setAttribute("jobTypes", jobTypes); // Đẩy loại việc sang JSP
            request.setAttribute("certificates", certificates); // Đẩy bằng cấp sang JSP
            request.setAttribute("locations", locations); // Đẩy địa điểm sang JSP
            request.setAttribute("parentCategories", parentCategories); // Danh mục cha sang JSP
            request.setAttribute("allCategories", allCategories); // Tất cả danh mục sang JSP
            
            System.out.println("DEBUG: Attributes set - jobLevels size: " + jobLevels.size() + ", jobTypes size: " + jobTypes.size());
            
            // Lấy recruiter từ session (JSP đã có nhưng cần đảm bảo có sẵn)
            model.Recruiter recruiter = (model.Recruiter) request.getSession().getAttribute("recruiter"); // Người tuyển dụng hiện tại
            request.setAttribute("recruiter", recruiter); // Đẩy recruiter sang JSP (địa chỉ công ty, logo, ...)
            // DEBUG: xuất recruiterId
            request.setAttribute("debugRecruiterId", recruiter != null ? recruiter.getRecruiterID() : null);

            // Quy tắc mới: NHẤT ĐỊNH dùng gói ĐĂNG_TUYỂN mua GẦN NHẤT
            // - Nếu gói gần nhất đã hết hạn → hiển thị cảnh báo và vô hiệu hoá nổi bật & nút "Đăng tin"
            // - Nếu gói gần nhất còn hạn nhưng hết lượt → hiển thị cảnh báo và vô hiệu hoá nổi bật & nút "Đăng tin"
            // - Nếu gói gần nhất hợp lệ và còn lượt → cho phép nổi bật phụ thuộc vào features của gói
            boolean allowFeatured = false; // Cho phép bật checkbox "Đăng tin nổi bật" hay không
            Integer selectedRecruiterPackageID = null;
            Integer selectedPackageDuration = null;
            boolean postingDisabled = false; // Nếu true, nút "Đăng tin" sẽ bị disabled
            String packageWarning = null; // Thông báo về gói (hết hạn/hết lượt)
            try {
                if (recruiter != null) {
                    RecruiterPackagesDAO rpDAO = new RecruiterPackagesDAO(); // DAO gói nhà tuyển dụng
                    List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> history = rpDAO.getPurchaseHistoryWithDetails(recruiter.getRecruiterID()); // Lịch sử mua (mới nhất trước)
                    // DEBUG: số lượng bản ghi lịch sử
                    request.setAttribute("debugHistoryCount", history != null ? history.size() : null);
                    if (history != null && !history.isEmpty()) {
                        RecruiterPackagesDAO.RecruiterPackagesWithDetails latest = null;
                        for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : history) {
                            if (pkg.packageType != null && pkg.packageType.equalsIgnoreCase("DANG_TUYEN")) { // Chỉ xét gói ĐĂNG_TUYỂN
                                latest = pkg; // Lấy gói gần nhất (history đã DESC theo ngày mua)
                                break;
                            }
                        }
                        if (latest != null) {
                            selectedRecruiterPackageID = latest.recruiterPackageID; // ID bản ghi gói gần nhất
                            selectedPackageDuration = latest.duration; // Thời hạn gói (ngày)
                            boolean isExpired = latest.expiryDate == null || !latest.expiryDate.isAfter(java.time.LocalDateTime.now()); // Hết hạn?
                            // Tính lượt còn lại dựa trên features.posts (mặc định 1 nếu không có)
                            int postsPerPackage = 1;
                            try {
                                JobPackagesDAO tmpDao = new JobPackagesDAO();
                                model.JobPackages tmpPkg = tmpDao.getPackageById(latest.packageID);
                                if (tmpPkg != null && tmpPkg.getFeatures() != null) {
                                    try {
                                        com.google.gson.JsonObject obj = new com.google.gson.Gson().fromJson(tmpPkg.getFeatures(), com.google.gson.JsonObject.class);
                                        if (obj != null && obj.has("posts")) {
                                            postsPerPackage = obj.get("posts").getAsInt();
                                        }
                                    } catch (Exception ignore) {}
                                }
                            } catch (Exception ignore) {}
                            int remainingPosts = (latest.quantity * postsPerPackage) - latest.usedQuantity;
                            boolean outOfPosts = remainingPosts <= 0; // Hết lượt?
                            if (isExpired) {
                                postingDisabled = true; // Cấm bấm Đăng tin
                                packageWarning = "Gói đăng tuyển gần nhất đã hết hạn. Vui lòng gia hạn hoặc mua gói mới."; // Thông báo hết hạn
                            } else if (outOfPosts) {
                                postingDisabled = true; // Cấm bấm Đăng tin
                                packageWarning = "Gói đăng tuyển gần nhất đã hết lượt đăng tin. Vui lòng mua thêm lượt."; // Thông báo hết lượt
                            } else {
                                try {
                                    JobPackagesDAO jpDAO = new JobPackagesDAO(); // DAO đọc chi tiết gói (features JSON)
                                    model.JobPackages jp = jpDAO.getPackageById(latest.packageID); // Gói gốc
                                    if (jp != null && jp.getFeatures() != null) {
                                        String features = jp.getFeatures(); // Chuỗi JSON tính năng của gói
                                        try {
                                            Gson gson = new Gson(); // Dùng Gson parse JSON
                                            JsonObject obj = gson.fromJson(features, JsonObject.class); // Parse chuỗi -> JSON
                                            boolean webPriority = obj.has("web_priority") && obj.get("web_priority").getAsBoolean(); // Quyền ưu tiên web
                                            boolean featured = obj.has("featured") && obj.get("featured").getAsBoolean(); // Quyền tin nổi bật
                                            allowFeatured = webPriority || featured; // Cho phép bật nếu một trong hai là true
                                        } catch (Exception jsonEx) {
                                            String lower = features.toLowerCase(); // Fallback nếu JSON lỗi
                                            allowFeatured = lower.contains("\"web_priority\": true") || lower.contains("\"featured\": true"); // Dò chuỗi
                                        }
                                    }
                                } catch (Exception ignore) {}
                            }
                        }
                    }
                } else {
                    // Không có recruiter → disable đăng tin và ghi chú
                    postingDisabled = true;
                    packageWarning = "Vui lòng đăng nhập để sử dụng gói đăng tuyển.";
                }
            } catch (Exception ex) {
                System.out.println("DEBUG: Error determining latest package/featured allowance: " + ex.getMessage()); // Lỗi xác định gói/feature
            }

            request.setAttribute("allowFeatured", allowFeatured); // Cho phép/khóa checkbox "Đăng tin nổi bật"
            request.setAttribute("postingRecruiterPackageID", selectedRecruiterPackageID); // ID gói gần nhất
            request.setAttribute("postingPackageDuration", selectedPackageDuration); // Thời hạn gói
            request.setAttribute("postingDisabled", postingDisabled); // true -> disable nút Đăng tin
            request.setAttribute("packageWarning", packageWarning); // Thông báo hiển thị trên form
            // DEBUG: kết quả cuối cùng
            request.setAttribute("debugAllowFeatured", allowFeatured);
            request.setAttribute("debugPostingDisabled", postingDisabled);
            // DEBUG: thêm postsPerPackage và remaining nếu có thể
            try {
                if (selectedRecruiterPackageID != null) {
                    RecruiterPackagesDAO rpDAO2 = new RecruiterPackagesDAO();
                    java.util.List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> hist2 = rpDAO2.getPurchaseHistoryWithDetails(((model.Recruiter)request.getSession().getAttribute("recruiter")).getRecruiterID());
                    for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : hist2) {
                        if (pkg.recruiterPackageID == selectedRecruiterPackageID) {
                            int postsPerPackage = 1;
                            try {
                                JobPackagesDAO tmpDao = new JobPackagesDAO();
                                model.JobPackages tmpPkg = tmpDao.getPackageById(pkg.packageID);
                                if (tmpPkg != null && tmpPkg.getFeatures() != null) {
                                    com.google.gson.JsonObject obj = new com.google.gson.Gson().fromJson(tmpPkg.getFeatures(), com.google.gson.JsonObject.class);
                                    if (obj != null && obj.has("posts")) postsPerPackage = obj.get("posts").getAsInt();
                                }
                            } catch (Exception ignore) {}
                            int remainingPosts = (pkg.quantity * postsPerPackage) - pkg.usedQuantity;
                            request.setAttribute("debugPostsPerPackage", postsPerPackage);
                            request.setAttribute("debugRemainingPosts", remainingPosts);
                            break;
                        }
                    }
                }
            } catch (Exception ignore) {            }
            
            // Nếu là chế độ chỉnh sửa và job đã Published, vô hiệu hóa nút "Lưu nháp"
            if (isEditMode && existingJob != null && "Published".equals(existingJob.getStatus())) {
                request.setAttribute("disableDraftButton", true);
                System.out.println("DEBUG: Disabling draft button for Published job");
            }
            
            System.out.println("DEBUG: Forwarding to JSP...");
            System.out.println("DEBUG: editingJobCategoryID attribute = " + request.getAttribute("editingJobCategoryID"));
            System.out.println("DEBUG: editingJobSkills attribute = " + request.getAttribute("editingJobSkills"));
            System.out.println("========== DEBUG: JobPostingServlet.doGet() END ==========");
            request.getRequestDispatcher("Recruiter/job-posting.jsp").forward(request, response); // Forward sang JSP hiển thị form
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in doGet: " + e.getMessage()); // Log lỗi tổng quát
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage()); // Gửi thông báo lỗi ra JSP
            request.getRequestDispatcher("Recruiter/job-posting.jsp").forward(request, response); // Quay lại trang form
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=========================================="); // Log phân cách
        System.out.println("DEBUG: JobPostingServlet doPost() called!"); // Gọi khi submit form (POST)
        System.out.println("DEBUG: Request Method: " + request.getMethod()); // Phương thức
        System.out.println("DEBUG: Context Path: " + request.getContextPath()); // Context path
        System.out.println("DEBUG: Request URI: " + request.getRequestURI()); // URI
        System.out.println("=========================================="); // Log phân cách
        try {
            // Kiểm tra xem có jobID không (chế độ chỉnh sửa)
            String jobIDStr = request.getParameter("jobID");
            Integer editingJobID = null;
            Job existingJob = null;
            boolean isEditMode = false;
            String originalStatus = null;
            
            if (jobIDStr != null && !jobIDStr.trim().isEmpty()) {
                try {
                    editingJobID = Integer.parseInt(jobIDStr);
                    JobDAO jobDAO = new JobDAO();
                    existingJob = jobDAO.getJobById(editingJobID);
                    
                    // Kiểm tra quyền
                    model.Recruiter recruiter = (model.Recruiter) request.getSession().getAttribute("recruiter");
                    if (existingJob != null && recruiter != null && existingJob.getRecruiterID() == recruiter.getRecruiterID()) {
                        isEditMode = true;
                        originalStatus = existingJob.getStatus();
                        System.out.println("DEBUG: Edit mode - JobID: " + editingJobID + ", Original Status: " + originalStatus);
                    } else {
                        request.setAttribute("error", "Không tìm thấy tin tuyển dụng hoặc bạn không có quyền chỉnh sửa!");
                        doGet(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG: Invalid jobID: " + jobIDStr);
                }
            }
            
            String jobTitle = request.getParameter("job-title"); // Tiêu đề công việc
            String description = request.getParameter("job-description"); // Mô tả công việc
            String requirements = request.getParameter("job-requirements"); // Yêu cầu công việc
            int jobLevelID = Integer.parseInt(request.getParameter("job-level")); // Cấp bậc
            String salaryMinStr = request.getParameter("salary-min");
            String salaryMaxStr = request.getParameter("salary-max");
            String salaryRange = "";
            if (salaryMinStr != null && !salaryMinStr.trim().isEmpty() && salaryMaxStr != null && !salaryMaxStr.trim().isEmpty()) {
                salaryRange = salaryMinStr.trim() + "-" + salaryMaxStr.trim() + " triệu"; // Dải lương "min-max triệu"
            } else if (salaryMinStr != null && !salaryMinStr.trim().isEmpty()) {
                salaryRange = salaryMinStr.trim() + " triệu";
            } else if (salaryMaxStr != null && !salaryMaxStr.trim().isEmpty()) {
                salaryRange = salaryMaxStr.trim() + " triệu";
            }
            String expirationDateStr = request.getParameter("expiration-date"); // Hạn bài (nếu có)
            int ageRequirement = 0; // Giá trị mặc định (field cũ đã bỏ)
            int jobTypeID = Integer.parseInt(request.getParameter("job-type")); // Loại việc
            int hiringCount = Integer.parseInt(request.getParameter("hiring-count")); // Số lượng cần tuyển
            String action = request.getParameter("action"); // draft | post (2 nút submit)
            // Chú thích: action đến từ nút Lưu nháp hoặc Đăng tin
            
            // Nếu đang chỉnh sửa job đã Published, không cho phép lưu nháp
            if (isEditMode && "Published".equals(originalStatus) && "draft".equalsIgnoreCase(action)) {
                request.setAttribute("error", "Không thể lưu nháp tin đã đăng. Chỉ có thể cập nhật và đăng lại.");
                doGet(request, response);
                return;
            }
            
            String featuredParam = request.getParameter("featured"); // Checkbox nổi bật
            boolean featuredSelected = "1".equals(featuredParam) || "on".equalsIgnoreCase(featuredParam); // true nếu người dùng tick
            // Chú thích: nếu gói không cho phép nổi bật, checkbox sẽ bị disabled trên UI
            
            // Lấy recruiter từ session
            model.Recruiter recruiter = (model.Recruiter) request.getSession().getAttribute("recruiter"); // Lấy recruiter từ session
            if (recruiter == null) {
                request.setAttribute("error", "Vui lòng đăng nhập để đăng tin tuyển dụng!"); // Chưa đăng nhập → chặn
                doGet(request, response);
                return;
            }
            
            // Lấy categoryID từ form parameter "profession"
            int categoryID = 0;
            String professionParam = request.getParameter("profession");
            System.out.println("DEBUG: profession parameter from form = " + professionParam);
            if (professionParam != null && !professionParam.trim().isEmpty()) {
                try {
                    categoryID = Integer.parseInt(professionParam.trim());
                    System.out.println("DEBUG: Parsed categoryID from form = " + categoryID);
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG: WARNING - Invalid profession parameter: " + professionParam);
                    request.setAttribute("error", "Ngành nghề chi tiết không hợp lệ!");
                    doGet(request, response);
                    return;
                }
            } else {
                System.out.println("DEBUG: WARNING - profession parameter is null or empty");
                request.setAttribute("error", "Vui lòng chọn ngành nghề chi tiết!");
                doGet(request, response);
                return;
            }
            
            // Tạo Job object
            Job job;
            if (isEditMode && existingJob != null) {
                job = existingJob; // Sử dụng job hiện có
            } else {
                job = new Job(); // Tạo đối tượng Job mới
            }
            job.setRecruiterID(recruiter.getRecruiterID()); // Gán RecruiterID
            if (isEditMode) {
                job.setJobID(editingJobID); // Gán JobID cho chế độ chỉnh sửa
            }
            job.setJobTitle(jobTitle); // Tiêu đề
            job.setDescription(description); // Mô tả
            job.setRequirements(requirements); // Yêu cầu
            job.setJobLevelID(jobLevelID); // Cấp bậc
            job.setSalaryRange(salaryRange); // Dải lương
            
            // Validate mức lương hợp lệ (>=0, min <= max)
            try {
                if (salaryMinStr != null && !salaryMinStr.isEmpty() && salaryMaxStr != null && !salaryMaxStr.isEmpty()) {
                    long smin = Long.parseLong(salaryMinStr);
                    long smax = Long.parseLong(salaryMaxStr);
                    if (smin < 0 || smax < 0 || smin > smax) {
                        request.setAttribute("error", "Mức lương không hợp lệ (phải ≥0 và tối thiểu ≤ tối đa).");
                        doGet(request, response);
                        return;
                    }
                }
            } catch (NumberFormatException nfe) {
                request.setAttribute("error", "Mức lương phải là số hợp lệ.");
                doGet(request, response);
                return;
            }

            // Parse expiration date
            if ("draft".equalsIgnoreCase(action)) {
                // Lưu nháp: dùng ngày hết hạn từ form (nếu có)
                if (expirationDateStr != null && !expirationDateStr.isEmpty()) {
                    LocalDateTime expirationDate = LocalDateTime.parse(expirationDateStr + "T23:59:59");
                    job.setExpirationDate(expirationDate);
                } else if (isEditMode && existingJob != null && existingJob.getExpirationDate() != null) {
                    // Giữ nguyên ngày hết hạn hiện tại
                    job.setExpirationDate(existingJob.getExpirationDate());
                }
            } else {
                // Khi đăng tin (post), tìm gói và lấy ngày hết hạn
                RecruiterPackagesDAO rpDAO = new RecruiterPackagesDAO();
                List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> history = rpDAO.getPurchaseHistoryWithDetails(recruiter.getRecruiterID());
                RecruiterPackagesDAO.RecruiterPackagesWithDetails chosen = null;
                if (history != null && !history.isEmpty()) {
                    for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : history) {
                        if (pkg.packageType != null && pkg.packageType.equalsIgnoreCase("DANG_TUYEN")) {
                            chosen = pkg; // Chọn gói gần nhất
                            break;
                        }
                    }
                }
                if (chosen != null && chosen.expiryDate != null) {
                    // Đặt ngày hết hạn của job trùng với ngày hết hạn của gói
                    job.setExpirationDate(chosen.expiryDate);
                    System.out.println("DEBUG: Set job expiration date to package expiry date: " + chosen.expiryDate);
                } else if (isEditMode && existingJob != null && existingJob.getExpirationDate() != null) {
                    // Nếu không tìm thấy gói (chỉnh sửa Published job), giữ nguyên ngày hết hạn
                    job.setExpirationDate(existingJob.getExpirationDate());
                }
            }
            
            // Set PostingDate - chỉ set khi tạo mới, chỉnh sửa thì giữ nguyên
            if (!isEditMode) {
                job.setPostingDate(LocalDateTime.now()); // Ngày đăng (thời điểm tạo)
            } else if (existingJob != null && existingJob.getPostingDate() != null) {
                job.setPostingDate(existingJob.getPostingDate()); // Giữ nguyên ngày đăng ban đầu
            }
            
            job.setCategoryID(categoryID);
            job.setAgeRequirement(ageRequirement);
            // Ghi chú (VI): trạng thái việc làm sẽ theo action người dùng chọn
            job.setStatus("draft".equalsIgnoreCase(action) ? "Draft" : "Published"); // Lưu nháp → Draft, Đăng tin → Published
            job.setJobTypeID(jobTypeID);
            job.setHiringCount(hiringCount);
            
            // Set default values
            if (!isEditMode) {
                job.setViewCount(0); // Khởi tạo lượt xem
            } else if (existingJob != null) {
                job.setViewCount(existingJob.getViewCount()); // Giữ nguyên lượt xem
            }
            job.setIsUrgent(false); // Không gấp mặc định
            job.setIsPriority(featuredSelected); // Lưu trạng thái nổi bật (1/0)
            
            // Generate job code - chỉ khi tạo mới
            if (!isEditMode) {
                job.setJobCode(JobCodeGenerator.generateJobCode()); // Sinh mã công việc
            } else if (existingJob != null && existingJob.getJobCode() != null) {
                job.setJobCode(existingJob.getJobCode()); // Giữ nguyên mã công việc
            }
            
            // Get and set contact person and application email
            String contactPerson = request.getParameter("contact-person"); // Người liên hệ
            String applicationEmail = request.getParameter("application-email"); // Email nhận hồ sơ
            job.setContactPerson(contactPerson != null ? contactPerson : ""); // Gán người liên hệ
            job.setApplicationEmail(applicationEmail != null ? applicationEmail : ""); // Gán email nhận hồ sơ
            
            // Get and set min experience
            String minExpStr = request.getParameter("min-experience");
            if (minExpStr != null && !minExpStr.trim().isEmpty()) {
                try {
                    int mx = Integer.parseInt(minExpStr);
                    if (mx < 0 || mx > 60) {
                        request.setAttribute("error", "Năm kinh nghiệm tối thiểu phải từ 0 đến 60.");
                        doGet(request, response);
                        return;
                    }
                    job.setMinExperience(mx);
                } catch (NumberFormatException e) {
                    job.setMinExperience(null);
                }
            }
            
            // Get and set certificates ID (bằng cấp tối thiểu)
            String certificatesIDStr = request.getParameter("certificates-id");
            if (certificatesIDStr != null && !certificatesIDStr.trim().isEmpty()) {
                try {
                    int certID = Integer.parseInt(certificatesIDStr);
                    job.setCertificatesID(certID);
                } catch (NumberFormatException e) {
                    job.setCertificatesID(null);
                }
            } else {
                job.setCertificatesID(null);
            }
            
            // Get and set location ID (khu vực)
            String locationIDStr = request.getParameter("location-id");
            if (locationIDStr != null && !locationIDStr.trim().isEmpty()) {
                try {
                    int locID = Integer.parseInt(locationIDStr);
                    job.setLocationID(locID);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Khu vực không hợp lệ.");
                    doGet(request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "Vui lòng chọn khu vực.");
                doGet(request, response);
                return;
            }
            
            // Get and set nationality
            String nationality = request.getParameter("nationality");
            job.setNationality(nationality != null ? nationality : "any");
            
            // Get and set gender
            String gender = request.getParameter("gender");
            job.setGender(gender != null ? gender : "any");
            
            // Get and set marital status
            String maritalStatus = request.getParameter("marital-status");
            job.setMaritalStatus(maritalStatus != null ? maritalStatus : "any");
            
            // Get and set age min/max
            String ageMinStr = request.getParameter("age-min");
            String ageMaxStr = request.getParameter("age-max");
            if (ageMinStr != null && !ageMinStr.trim().isEmpty()) {
                try {
                    job.setAgeMin(Integer.parseInt(ageMinStr));
                } catch (NumberFormatException e) {
                    job.setAgeMin(null);
                }
            }
            if (ageMaxStr != null && !ageMaxStr.trim().isEmpty()) {
                try {
                    job.setAgeMax(Integer.parseInt(ageMaxStr));
                } catch (NumberFormatException e) {
                    job.setAgeMax(null);
                }
            }
            // Validate độ tuổi trong khoảng 15-65 và min <= max (nếu cả hai có)
            if (job.getAgeMin() != null && job.getAgeMax() != null) {
                if (job.getAgeMin() < 15 || job.getAgeMin() > 65 || job.getAgeMax() < 15 || job.getAgeMax() > 65 || job.getAgeMin() > job.getAgeMax()) {
                    request.setAttribute("error", "Độ tuổi không hợp lệ (15-65) và tối thiểu ≤ tối đa.");
                    doGet(request, response);
                    return;
                }
            }
            
            System.out.println("DEBUG: Starting to " + (isEditMode ? "update" : "save") + " job...");
            JobDAO jobDAO = new JobDAO();
            int jobID;
            boolean success;
            
            if (isEditMode) {
                // Cập nhật job hiện có
                success = jobDAO.updateJob(job);
                jobID = editingJobID;
                System.out.println("DEBUG: Job updated - ID: " + jobID + ", Success: " + success);
            } else {
                // Tạo job mới
                jobID = jobDAO.addJob(job);
                success = (jobID > 0);
                System.out.println("DEBUG: Job saved with ID: " + jobID);
            }
            
            if (success && jobID > 0) {
                // Xử lý skills
                String skillsParam = request.getParameter("skills");
                System.out.println("DEBUG: Skills parameter: " + skillsParam);
                
                dal.SkillDAO skillDAO = new dal.SkillDAO();
                dal.JobSkillMappingDAO jobSkillMappingDAO = new dal.JobSkillMappingDAO();
                
                // Nếu là chế độ chỉnh sửa, xóa tất cả mapping cũ trước
                if (isEditMode) {
                    boolean deleted = jobSkillMappingDAO.deleteMappingsByJobID(jobID);
                    System.out.println("DEBUG: Deleted old skill mappings for JobID " + jobID + ": " + deleted);
                }
                
                if (skillsParam != null && !skillsParam.trim().isEmpty()) {
                    // Split skills bằng dấu phẩy (tạo skill nếu chưa có và map vào Job)
                    String[] skillNames = skillsParam.split(",");
                    System.out.println("DEBUG: Processing " + skillNames.length + " skills");
                    
                    for (String skillName : skillNames) {
                        skillName = skillName.trim();
                        if (!skillName.isEmpty()) {
                            try {
                                // Kiểm tra và thêm skill nếu chưa tồn tại
                                int skillID = skillDAO.addSkill(skillName);
                                System.out.println("DEBUG: Skill '" + skillName + "' -> SkillID: " + skillID);
                                
                                if (skillID > 0) {
                                    // Thêm mapping giữa Job và Skill
                                    boolean mappingAdded = jobSkillMappingDAO.addMapping(jobID, skillID);
                                    if (mappingAdded) {
                                        System.out.println("DEBUG: Successfully added mapping - JobID: " + jobID + ", SkillID: " + skillID);
                                    } else {
                                        System.out.println("DEBUG: WARNING - Failed to add mapping - JobID: " + jobID + ", SkillID: " + skillID);
                                    }
                                } else {
                                    System.out.println("DEBUG: WARNING - Invalid SkillID returned for skill: " + skillName);
                                }
                            } catch (Exception ex) {
                                System.out.println("DEBUG: Error processing skill '" + skillName + "': " + ex.getMessage());
                                ex.printStackTrace();
                                // Tiếp tục xử lý skill tiếp theo, không dừng lại
                            }
                        }
                    }
                } else {
                    System.out.println("DEBUG: No skills provided, skipping skill mapping");
                }
                
                if ("post".equalsIgnoreCase(action)) {
                    // Kiểm tra xem có cần trừ lượt không
                    // - Nếu chỉnh sửa job đã Published: KHÔNG trừ lượt
                    // - Nếu chỉnh sửa job Draft/Expired hoặc tạo mới: CÓ trừ lượt
                    boolean shouldDeductPackage = true;
                    if (isEditMode && "Published".equals(originalStatus)) {
                        shouldDeductPackage = false;
                        System.out.println("DEBUG: Editing Published job - will NOT deduct package usage");
                    } else {
                        System.out.println("DEBUG: New job or editing Draft/Expired job - will deduct package usage");
                    }
                    
                    // Nhánh Đăng tin：Tìm gói ĐĂNG_TUYỂN mua gần nhất (để lấy ngày hết hạn và trừ lượt nếu cần)
                    RecruiterPackagesDAO rpDAO = new RecruiterPackagesDAO();
                    List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> history = rpDAO.getPurchaseHistoryWithDetails(recruiter.getRecruiterID());
                    RecruiterPackagesDAO.RecruiterPackagesWithDetails chosen = null;
                    if (history != null && !history.isEmpty()) {
                        for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : history) {
                            if (pkg.packageType != null && pkg.packageType.equalsIgnoreCase("DANG_TUYEN")) {
                                chosen = pkg; // Chọn gói gần nhất (PurchaseDate DESC)
                                break;
                            }
                        }
                    }
                    
                    // Nếu cần trừ lượt nhưng không tìm thấy gói → lỗi
                    if (shouldDeductPackage && chosen == null) {
                        request.setAttribute("error", "Không tìm thấy gói ĐĂNG_TUYỂN gần nhất. Vui lòng mua gói trước khi đăng."); // Không có gói để dùng
                        doGet(request, response);
                        return;
                    }
                    
                    // Cập nhật ngày hết hạn từ gói (nếu có gói)
                    if (chosen != null && chosen.expiryDate != null) {
                        job.setExpirationDate(chosen.expiryDate);
                        System.out.println("DEBUG: Updated job expiration date to package expiry date: " + chosen.expiryDate);
                    }
                    // Chỉ kiểm tra gói nếu cần trừ lượt
                    if (shouldDeductPackage && chosen != null) {
                        boolean isExpired = chosen.expiryDate == null || !chosen.expiryDate.isAfter(java.time.LocalDateTime.now()); // Hết hạn?
                        // Tính lượt còn lại = Quantity * postsPerPackage - UsedQuantity
                        int postsPerPackage = 1;
                        try {
                            JobPackagesDAO tmpDao = new JobPackagesDAO();
                            model.JobPackages tmpPkg = tmpDao.getPackageById(chosen.packageID);
                            if (tmpPkg != null && tmpPkg.getFeatures() != null) {
                                try {
                                    com.google.gson.JsonObject obj = new com.google.gson.Gson().fromJson(tmpPkg.getFeatures(), com.google.gson.JsonObject.class);
                                    if (obj != null && obj.has("posts")) {
                                        postsPerPackage = obj.get("posts").getAsInt();
                                    }
                                } catch (Exception ignore) {}
                            }
                        } catch (Exception ignore) {}
                        int remainingPosts = (chosen.quantity * postsPerPackage) - chosen.usedQuantity;
                        boolean outOfPosts = remainingPosts <= 0; // Hết lượt?
                        if (isExpired) {
                            request.setAttribute("error", "Gói đăng tuyển gần nhất đã hết hạn. Vui lòng gia hạn hoặc mua gói mới."); // Cảnh báo hết hạn
                            doGet(request, response);
                            return;
                        }
                        if (outOfPosts) {
                            request.setAttribute("error", "Gói đăng tuyển gần nhất đã hết lượt đăng tin. Vui lòng mua thêm lượt."); // Cảnh báo hết lượt
                            doGet(request, response);
                            return;
                        }
                    }

                    // Bước 2: Kiểm tra quyền nổi bật (web_priority/featured trong features JSON) - chỉ khi có gói
                    boolean allowFeatured = false;
                    if (chosen != null) {
                        try {
                            JobPackagesDAO jpDAO = new JobPackagesDAO();
                            model.JobPackages jp = jpDAO.getPackageById(chosen.packageID);
                            if (jp != null && jp.getFeatures() != null) {
                                try {
                                    Gson gson = new Gson();
                                    JsonObject obj = gson.fromJson(jp.getFeatures(), JsonObject.class);
                                    boolean webPriority = obj.has("web_priority") && obj.get("web_priority").getAsBoolean();
                                    boolean featuredFlag = obj.has("featured") && obj.get("featured").getAsBoolean();
                                    allowFeatured = webPriority || featuredFlag;
                                } catch (Exception je) {
                                    String lower = jp.getFeatures().toLowerCase();
                                    allowFeatured = lower.contains("\"web_priority\": true") || lower.contains("\"featured\": true");
                                }
                            }
                        } catch (Exception ex) {
                            System.out.println("DEBUG: features check error: " + ex.getMessage()); // Lỗi đọc features gói
                        }
                    }
                    if (!allowFeatured && featuredSelected) {
                        // Nếu không được phép nổi bật nhưng người dùng tick → bỏ chọn (không set trái phép)
                        job.setIsPriority(false);
                        jobDAO.updateJob(job); // Cập nhật lại job với isPriority = false
                    }

                    // Bước 3: Trừ lượt của gói (chỉ khi cần)
                    if (shouldDeductPackage && chosen != null) {
                        // Đã tự kiểm tra remainingPosts dựa trên features.posts → tăng UsedQuantity trực tiếp
                        boolean pkgUpdated = rpDAO.incrementUsedQuantityForce(chosen.recruiterPackageID);
                        if (!pkgUpdated) {
                            request.setAttribute("error", "Không thể trừ lượt từ gói đăng tuyển. Vui lòng thử lại."); // Không trừ được lượt → lỗi
                            doGet(request, response);
                            return;
                        }

                        // Bước 4: Lưu lịch sử sử dụng gói vào JobFeatureMappings (để theo dõi hiệu lực)
                        JobFeatureMappingsDAO mappingDAO = new JobFeatureMappingsDAO();
                        model.JobFeatureMappings mapping = new model.JobFeatureMappings();
                        mapping.setJobID(jobID); // Gán JobID
                        mapping.setRecruiterPackageID(chosen.recruiterPackageID); // Gán ID gói
                        mapping.setFeatureType("DANG_TUYEN"); // Loại tính năng/nhóm gói
                        mapping.setAppliedDate(LocalDateTime.now()); // Ngày áp dụng
                        if (chosen.duration > 0) {
                            mapping.setExpireDate(LocalDateTime.now().plusDays(chosen.duration)); // Hết hạn = hôm nay + duration
                        }
                        boolean mappingOk = mappingDAO.addJobFeatureMapping(mapping);
                        if (!mappingOk) {
                            request.setAttribute("error", "Không thể lưu lịch sử sử dụng gói."); // Lưu lịch sử thất bại
                            doGet(request, response);
                            return;
                        }
                    } else {
                        System.out.println("DEBUG: Skipping package deduction for Published job edit");
                    }

                    // Thành công
                    request.getSession().setAttribute("successMessage", "Đăng tuyển dụng thành công! Tin của bạn đang chờ duyệt."); // Thông báo thành công
                    response.sendRedirect(request.getContextPath() + "/Recruiter/index.jsp"); // Quay về dashboard
                } else {
                    // Nhánh Lưu nháp：không trừ lượt và không ghi lịch sử sử dụng gói
                    request.setAttribute("success", "Đã lưu nháp tin tuyển dụng."); // Thông báo lưu nháp
                    doGet(request, response);
                }
            } else {
                System.out.println("DEBUG: Failed to save job!"); // Lưu Job thất bại
                request.setAttribute("error", "Có lỗi xảy ra khi lưu tin tuyển dụng!"); // Báo lỗi cho người dùng
                request.getRequestDispatcher("/Recruiter/job-posting.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in doPost: " + e.getMessage()); // Log lỗi tổng quát
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage()); // Thông báo lỗi ra JSP
            try {
                request.getRequestDispatcher("/Recruiter/job-posting.jsp").forward(request, response); // Quay lại trang form
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
