<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Recruiter" %>
<%@ page import="model.Job" %>
<%@ page import="dal.TypeDAO" %>
<%@ page import="dal.LocationDAO" %>
<%@ page import="dal.CategoryDAO" %>
<%@ page import="model.Type" %>
<%@ page import="model.Location" %>
<%@ page import="model.Category" %>
<%
    Recruiter recruiter = (Recruiter) session.getAttribute("recruiter");
    String userName = (recruiter != null) ? recruiter.getContactPerson() : "User";
    
    // Nếu attributes null (truy cập trực tiếp JSP), tự load dữ liệu
    if (request.getAttribute("jobLevels") == null) {
        try {
            TypeDAO typeDAO = new TypeDAO();
            LocationDAO locationDAO = new LocationDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            List<Type> jobLevels = typeDAO.getJobLevels();
            List<Type> jobTypes = typeDAO.getJobTypes();
            List<Type> certificates = typeDAO.getTypesByCategory("Certificate");
            List<Location> locations = locationDAO.getAllLocations();
            List<Category> parentCategories = categoryDAO.getParentCategories();
            List<Category> allCategories = categoryDAO.getAllCategories();
            
            request.setAttribute("jobLevels", jobLevels != null ? jobLevels : new java.util.ArrayList());
            request.setAttribute("jobTypes", jobTypes != null ? jobTypes : new java.util.ArrayList());
            request.setAttribute("certificates", certificates != null ? certificates : new java.util.ArrayList());
            request.setAttribute("locations", locations != null ? locations : new java.util.ArrayList());
            request.setAttribute("parentCategories", parentCategories != null ? parentCategories : new java.util.ArrayList());
            request.setAttribute("allCategories", allCategories != null ? allCategories : new java.util.ArrayList());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("jobLevels", new java.util.ArrayList());
            request.setAttribute("jobTypes", new java.util.ArrayList());
            request.setAttribute("certificates", new java.util.ArrayList());
            request.setAttribute("locations", new java.util.ArrayList());
            request.setAttribute("parentCategories", new java.util.ArrayList());
            request.setAttribute("allCategories", new java.util.ArrayList());
        }
    }
    // Nếu trang bị mở trực tiếp (không qua /jobposting) thì các attribute như allowFeatured sẽ null
    // Chuyển hướng về servlet để nạp đầy đủ dữ liệu và quyền từ gói
    if (request.getAttribute("allowFeatured") == null) {
        response.sendRedirect(request.getContextPath() + "/jobposting");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Tuyển Dụng - Dashboard Tuyển Dụng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/css/job-posting.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body class="job-posting-page">
    <!-- Top Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-left">
                <div class="logo">
                    <i class="fas fa-briefcase"></i>
                    <span>RecruitPro</span>
                </div>
                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/Recruiter/index.jsp">Dashboard</a></li>
                    <li><a href="#">Việc Làm</a></li>
                    <li class="dropdown">
                        <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/candidate-management">Quản lý theo việc đăng tuyển</a>
                            <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html">Quản lý theo thư mục và thẻ</a>
                        </div>
                    </li>
                    <li class="dropdown">
                        <a href="#">Onboarding <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="#">Quy trình onboarding</a>
                            <a href="#">Tài liệu hướng dẫn</a>
                        </div>
                    </li>
                    <li class="dropdown">
                        <a href="#">Đơn hàng <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="#">Quản lý đơn hàng</a>
                            <a href="${pageContext.request.contextPath}/recruiter/purchase-history">Lịch sử mua</a>
                        </div>
                    </li>
                    <li><a href="#">Báo cáo</a></li>
                    <li><a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp" class="company-link">Công ty</a></li>
                </ul>
            </div>
            <div class="nav-right">
                <div class="nav-buttons">
                    <div class="dropdown">
                        <button class="btn btn-orange active">
                            ĐĂNG TUYỂN DỤNG <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/jobposting" class="active">Tạo tin tuyển dụng mới</a>
                            <a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp">Quản lý tin đã đăng</a>
                        </div>
                    </div>
                        <button class="btn btn-blue" onclick="window.location.href='${pageContext.request.contextPath}/candidate-search'">TÌM ỨNG VIÊN</button>
                    <button class="btn btn-white" onclick="window.location.href='${pageContext.request.contextPath}/Recruiter/job-package.jsp'">Mua</button>
                </div>
                <div class="nav-icons">
                    <i class="fas fa-shopping-cart"></i>
                    <div class="dropdown user-dropdown">
                        <div class="user-avatar">
                            <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                        </div>
                        <div class="dropdown-content user-menu">
                            <div class="user-header">
                                <i class="fas fa-user-circle"></i>
                                <div class="user-info">
                                    <div class="user-name">Nguyen Phuoc</div>
                                </div>
                                <i class="fas fa-times close-menu"></i>
                            </div>
                            
                            <div class="menu-section">
                                <div class="section-title">Thành viên</div>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-users"></i>
                                    <span>Thành viên</span>
                                </a>
                            </div>
                            
                            <div class="menu-section">
                                <div class="section-title">Thiết lập tài khoản</div>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-cog"></i>
                                    <span>Quản lý tài khoản</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp" class="menu-item">
                                    <i class="fas fa-building"></i>
                                    <span>Thông tin công ty</span>
                                </a>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-shield-alt"></i>
                                    <span>Quản lý quyền truy cập</span>
                                </a>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-tasks"></i>
                                    <span>Quản lý yêu cầu</span>
                                </a>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-history"></i>
                                    <span>Lịch sử hoạt động</span>
                                </a>
                            </div>
                            
                            <div class="menu-section">
                                <div class="section-title">Liên hệ mua</div>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-phone"></i>
                                    <span>Liên hệ mua</span>
                                </a>
                            </div>
                            
                            <div class="menu-section">
                                <div class="section-title">Hỏi đáp</div>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-question-circle"></i>
                                    <span>Hỏi đáp</span>
                                </a>
                            </div>
                            
                            <div class="menu-footer">
                                <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-item">
                                    <i class="fas fa-sign-out-alt"></i>
                                    <span>Thoát</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="job-posting-main">
        <div class="job-posting-container">
            <!-- Success/Error Messages -->
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <%
                // Kiểm tra chế độ chỉnh sửa
                Boolean isEditMode = (Boolean) request.getAttribute("isEditMode");
                Job editingJob = (Job) request.getAttribute("editingJob");
                Boolean disableDraftButton = (Boolean) request.getAttribute("disableDraftButton");
                if (isEditMode == null) isEditMode = false;
                if (disableDraftButton == null) disableDraftButton = false;
            %>
            <form action="${pageContext.request.contextPath}/jobposting" method="POST" id="job-posting-form">
            <% if (isEditMode && editingJob != null) { %>
                <input type="hidden" name="jobID" value="<%= editingJob.getJobID() %>">
            <% } %>
            <!-- Job Description Section -->
            <div class="form-section">
                <div class="section-header">
                    <h2>Mô tả công việc</h2>
                </div>
                
                <div class="form-group">
                    <label for="job-title">Chức danh <span class="required">*</span></label>
                    <input type="text" id="job-title" name="job-title" placeholder="Eg. Senior UX Designer" 
                           value="<%= (isEditMode && editingJob != null && editingJob.getJobTitle() != null) ? editingJob.getJobTitle() : "" %>" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="job-level">Cấp bậc <span class="required">*</span></label>
                        <select id="job-level" name="job-level" required>
                            <option value="">Vui lòng chọn</option>
                            <% 
                            try {
                                if (request.getAttribute("jobLevels") != null) { 
                                    List<model.Type> jobLevels = (List<model.Type>) request.getAttribute("jobLevels");
                                    int selectedJobLevelID = (isEditMode && editingJob != null) ? editingJob.getJobLevelID() : 0;
                                    if (jobLevels != null && !jobLevels.isEmpty()) {
                                        for (model.Type level : jobLevels) { %>
                                            <option value="<%= level.getTypeID() %>" <%= (level.getTypeID() == selectedJobLevelID) ? "selected" : "" %>><%= level.getTypeName() %></option>
                                        <% }
                                    }
                                } else {
                                    // Debug: Hiển thị nếu không có dữ liệu
                                    System.out.println("DEBUG: jobLevels attribute is null");
                                }
                            } catch (Exception e) {
                                System.out.println("DEBUG Error in jobLevels: " + e.getMessage());
                                e.printStackTrace();
                            }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="job-type">Loại việc làm</label>
                        <select id="job-type" name="job-type">
                            <option value="">Vui lòng chọn</option>
                            <% 
                            try {
                                if (request.getAttribute("jobTypes") != null) { 
                                    List<model.Type> jobTypes = (List<model.Type>) request.getAttribute("jobTypes");
                                    int selectedJobTypeID = (isEditMode && editingJob != null) ? editingJob.getJobTypeID() : 0;
                                    if (jobTypes != null && !jobTypes.isEmpty()) {
                                        for (model.Type type : jobTypes) { %>
                                            <option value="<%= type.getTypeID() %>" <%= (type.getTypeID() == selectedJobTypeID) ? "selected" : "" %>><%= type.getTypeName() %></option>
                                        <% }
                                    }
                                } else {
                                    // Debug: Hiển thị nếu không có dữ liệu
                                    System.out.println("DEBUG: jobTypes attribute is null");
                                }
                            } catch (Exception e) {
                                System.out.println("DEBUG Error in jobTypes: " + e.getMessage());
                                e.printStackTrace();
                            }
                            %>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="profession">Ngành nghề chi tiết <span class="required">*</span> (Chọn 1 ngành nghề) <i class="fas fa-question-circle"></i></label>
                    <div class="simple-custom-dropdown">
                        <input type="hidden" id="profession" name="profession" required 
                               value="<%= (isEditMode && editingJob != null && editingJob.getCategoryID() > 0) ? editingJob.getCategoryID() : "" %>">
                        <div class="dropdown-input" id="profession-input" onclick="toggleProfessionDropdown()">
                            <%
                            String categoryName = (String) request.getAttribute("editingJobCategoryName");
                            String displayText = (categoryName != null && !categoryName.isEmpty()) ? categoryName : "Vui lòng chọn ngành nghề";
                            String textColor = (categoryName != null && !categoryName.isEmpty()) ? "#374151" : "";
                            %>
                            <span class="dropdown-text" id="profession-text" style="color: <%= textColor %>"><%= displayText %></span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="dropdown-list" id="profession-list" style="display: none;">
                            <%
                            try {
                                List<Category> parentCategories = (List<Category>) request.getAttribute("parentCategories");
                                List<Category> allCategories = (List<Category>) request.getAttribute("allCategories");
                                
                                if (parentCategories != null && !parentCategories.isEmpty()) {
                                    for (Category parent : parentCategories) {
                            %>
                            <div class="category-parent-item" onclick="toggleParentCategory(this, event)">
                                <i class="fas fa-chevron-right category-arrow"></i>
                                <strong><%= parent.getCategoryName() %></strong>
                            </div>
                            <div class="category-children-list" style="display: none;" data-parent-id="<%= parent.getCategoryID() %>">
                                <%
                                if (allCategories != null) {
                                    for (Category sub : allCategories) {
                                        if (sub.getParentCategoryID() != null && sub.getParentCategoryID() == parent.getCategoryID()) {
                                %>
                                <div class="category-child-item" data-category-id="<%= sub.getCategoryID() %>" data-category-name="<%= sub.getCategoryName() %>" onclick="selectProfession(this)"
                                     <% 
                                     Integer editingJobCategoryID = (Integer) request.getAttribute("editingJobCategoryID");
                                     if (editingJobCategoryID != null && sub.getCategoryID() == editingJobCategoryID) {
                                         out.print("data-selected=\"true\"");
                                     }
                                     %>>
                                    <%= sub.getCategoryName() %>
                                </div>
                                <%
                                        }
                                    }
                                }
                                %>
                            </div>
                            <%
                                    }
                                }
                            } catch (Exception e) {
                                System.out.println("DEBUG Error in profession dropdown: " + e.getMessage());
                                e.printStackTrace();
                            }
                            %>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="location-id">Khu vực <span class="required">*</span></label>
                    <select id="location-id" name="location-id" required>
                        <option value="">Vui lòng chọn khu vực</option>
                        <% 
                        try {
                            if (request.getAttribute("locations") != null) { 
                                List<Location> locationsList = (List<Location>) request.getAttribute("locations");
                                int selectedLocationID = (isEditMode && editingJob != null) ? editingJob.getLocationID() : 0;
                                if (locationsList != null && !locationsList.isEmpty()) {
                                    for (Location location : locationsList) { %>
                                        <option value="<%= location.getLocationID() %>" <%= (location.getLocationID() == selectedLocationID) ? "selected" : "" %>><%= location.getLocationName() %></option>
                                    <% }
                                }
                            }
                        } catch (Exception e) {
                            System.out.println("DEBUG Error in locations: " + e.getMessage());
                            e.printStackTrace();
                        }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="job-description">Mô tả <span class="required">*</span></label>
                    <div class="rich-text-editor">
                        <div class="editor-toolbar">
                            <button type="button" class="toolbar-btn"><i class="fas fa-bold"></i></button>
                            <button type="button" class="toolbar-btn"><i class="fas fa-italic"></i></button>
                        </div>
                        <textarea id="job-description" name="job-description" rows="10" placeholder="Nhập mô tả công việc" required><%= (isEditMode && editingJob != null && editingJob.getDescription() != null) ? editingJob.getDescription() : "" %></textarea>
                        <div class="editor-footer">
                            <a href="#" class="sample-link">Xem mô tả công việc mẫu</a>
                            <div class="char-counter">(14500/14500 ký tự)</div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="job-requirements">Yêu cầu công việc <span class="required">*</span></label>
                    <div class="rich-text-editor">
                        <div class="editor-toolbar">
                            <button type="button" class="toolbar-btn"><i class="fas fa-bold"></i></button>
                            <button type="button" class="toolbar-btn"><i class="fas fa-italic"></i></button>
                        </div>
                        <textarea id="job-requirements" name="job-requirements" rows="10" placeholder="Nhập yêu cầu công việc" required><%= (isEditMode && editingJob != null && editingJob.getRequirements() != null) ? editingJob.getRequirements() : "" %></textarea>
                        <div class="editor-footer">
                            <a href="#" class="sample-link">Xem yêu cầu công việc mẫu</a>
                            <div class="char-counter">(14500/14500 ký tự)</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Salary and Contact Section -->
            <div class="form-section">
                <%
                    // Parse salary range for edit mode - format: "23-24 triệu" or "23 triệu"
                    String salaryMin = "";
                    String salaryMax = "";
                    if (isEditMode && editingJob != null && editingJob.getSalaryRange() != null) {
                        String salaryRange = editingJob.getSalaryRange();
                        // Remove "triệu" and trim
                        salaryRange = salaryRange.replace("triệu", "").trim();
                        // Split by "-"
                        String[] parts = salaryRange.split("-");
                        if (parts.length >= 2) {
                            salaryMin = parts[0].trim();
                            salaryMax = parts[1].trim();
                        } else if (parts.length == 1 && !parts[0].trim().isEmpty()) {
                            salaryMin = parts[0].trim();
                        }
                    }
                %>
                <div class="form-group">
                    <label for="salary">Mức lương <span class="required">*</span> (triệu VNĐ)</label>
                    <div class="salary-input-group">
                        <input type="number" id="salary-min" name="salary-min" placeholder="Tối thiểu" value="<%= salaryMin %>">
                        <span class="dash">-</span>
                        <input type="number" id="salary-max" name="salary-max" placeholder="Tối đa" value="<%= salaryMax %>">
                        <span style="margin-left: 8px; color: #6b7280;">triệu</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="hiring-count">Số lượng tuyển dụng</label>
                    <div class="counter-input">
                        <button type="button" class="counter-btn minus">-</button>
                        <input type="number" id="hiring-count" name="hiring-count" value="<%= (isEditMode && editingJob != null) ? editingJob.getHiringCount() : 1 %>" min="1">
                        <button type="button" class="counter-btn plus">+</button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="contact-person">Người liên hệ <span class="required">*</span></label>
                    <input type="text" id="contact-person" name="contact-person" value="<%= (isEditMode && editingJob != null && editingJob.getContactPerson() != null) ? editingJob.getContactPerson() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="application-email">Địa chỉ email nhận hồ sơ <span class="required">*</span></label>
                    <input type="email" id="application-email" name="application-email" value="<%= (isEditMode && editingJob != null && editingJob.getApplicationEmail() != null) ? editingJob.getApplicationEmail() : "" %>" required>
                    <small class="hint">(Địa chỉ email sẽ được ẩn với người tìm việc. Bạn có thể nhập nhiều địa chỉ cách nhau bằng dấu "," và dấu ";".)</small>
                </div> 

                <!-- Removed 'Đăng tin nổi bật' and debug info -->

            </div>

            <!-- Candidate Expectations Section -->
            <div class="form-section collapsible">
                <div class="section-header collapsible-header">
                    <h2><i class="fas fa-user"></i> Kỳ vọng về ứng viên</h2>
                    <i class="fas fa-chevron-up toggle-icon"></i>
                </div>
                <div class="collapsible-content">
                    <div class="form-group">
                        <label for="keywords">Kỹ năng <span class="required">*</span></label>
                        <div class="tag-input" id="skills-tag-input">
                            <div class="selected-tags" id="selected-skills-tags">
                                <!-- Tags will be added here dynamically -->
                            </div>
                            <input type="text" id="skill-input" placeholder="Nhập kỹ năng và nhấn Enter...">
                        </div>
                        <input type="hidden" id="skills" name="skills" value="">
                        <small class="hint">(Tối đa 5 kỹ năng, nhấn Enter để thêm)</small>
                    </div>

                    <div class="form-group">
                        <label for="min-experience">Năm kinh nghiệm tối thiểu</label>
                        <div class="counter-input">
                            <button type="button" class="counter-btn minus">-</button>
                            <input type="number" id="min-experience" name="min-experience" value="<%= (isEditMode && editingJob != null && editingJob.getMinExperience() != null) ? editingJob.getMinExperience() : 1 %>" min="0">
                            <button type="button" class="counter-btn plus">+</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="certificates-id">Bằng cấp tối thiểu</label>
                        <select id="certificates-id" name="certificates-id">
                            <option value="">Bất kỳ</option>
                            <% 
                            try {
                                if (request.getAttribute("certificates") != null) { 
                                    List<Type> certificatesList = (List<Type>) request.getAttribute("certificates");
                                    Integer selectedCertID = (isEditMode && editingJob != null) ? editingJob.getCertificatesID() : null;
                                    if (certificatesList != null && !certificatesList.isEmpty()) {
                                        for (Type certificate : certificatesList) { %>
                                            <option value="<%= certificate.getTypeID() %>" <%= (selectedCertID != null && certificate.getTypeID() == selectedCertID) ? "selected" : "" %>><%= certificate.getTypeName() %></option>
                                        <% }
                                    }
                                }
                            } catch (Exception e) {
                                System.out.println("DEBUG Error in certificates: " + e.getMessage());
                                e.printStackTrace();
                            }
                            %>
                        </select>
                    </div>

                    <%
                        String selectedNationality = (isEditMode && editingJob != null && editingJob.getNationality() != null) ? editingJob.getNationality() : "any";
                        String selectedGender = (isEditMode && editingJob != null && editingJob.getGender() != null) ? editingJob.getGender() : "any";
                        String selectedMaritalStatus = (isEditMode && editingJob != null && editingJob.getMaritalStatus() != null) ? editingJob.getMaritalStatus() : "any";
                        int ageMin = (isEditMode && editingJob != null && editingJob.getAgeMin() != null) ? editingJob.getAgeMin() : 15;
                        int ageMax = (isEditMode && editingJob != null && editingJob.getAgeMax() != null) ? editingJob.getAgeMax() : 60;
                    %>
                    <div class="form-group">
                        <label>Quốc tịch</label>
                        <div class="radio-group">
                            <label class="radio-label">
                                <input type="radio" name="nationality" value="any" <%= "any".equals(selectedNationality) ? "checked" : "" %>>
                                <span class="radio-custom"></span>
                                Bất kỳ
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="nationality" value="vietnamese" <%= "vietnamese".equals(selectedNationality) ? "checked" : "" %>>
                                <span class="radio-custom"></span>
                                Người Việt Nam
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="nationality" value="foreigner" <%= "foreigner".equals(selectedNationality) ? "checked" : "" %>>
                                <span class="radio-custom"></span>
                                Người nước ngoài
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Giới tính</label>
                        <div class="radio-group">
                            <label class="radio-label">
                                <input type="radio" name="gender" value="any" <%= "any".equals(selectedGender) ? "checked" : "" %>>
                                <span class="radio-custom"></span>
                                Bất kỳ
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="gender" value="male" <%= "male".equals(selectedGender) ? "checked" : "" %>>
                                <span class="radio-custom"></span>
                                Nam
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="gender" value="female" <%= "female".equals(selectedGender) ? "checked" : "" %>>
                                <span class="radio-custom"></span>
                                Nữ
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Tình trạng hôn nhân</label>
                        <div class="radio-group">
                            <label class="radio-label">
                                <input type="radio" name="marital-status" value="any" <%= "any".equals(selectedMaritalStatus) ? "checked" : "" %>>
                                <span class="radio-custom"></span>
                                Bất kỳ
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="marital-status" value="single" <%= "single".equals(selectedMaritalStatus) ? "checked" : "" %>>
                                <span class="radio-custom"></span>
                                Độc thân
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="marital-status" value="married" <%= "married".equals(selectedMaritalStatus) ? "checked" : "" %>>
                                <span class="radio-custom"></span>
                                Đã kết hôn
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="age-range">Độ tuổi mong muốn</label>
                        <div class="age-range-inputs">
                            <input type="number" id="age-min" name="age-min" value="<%= ageMin %>" min="15" max="65">
                            <span class="dash">-</span>
                            <input type="number" id="age-max" name="age-max" value="<%= ageMax %>" min="15" max="65">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Company Information Section -->
            <div class="form-section collapsible">
                <div class="section-header collapsible-header">
                    <h2><i class="fas fa-building"></i> Thông tin Công Ty</h2>
                    <i class="fas fa-chevron-up toggle-icon"></i>
                </div>
                <div class="collapsible-content">
                    <% if (recruiter != null) { %>
                    <div class="info-note" style="background-color: #e3f2fd; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #2196f3;">
                        <i class="fas fa-info-circle"></i>
                        <strong>Thông tin công ty được lấy từ hồ sơ của bạn và không thể chỉnh sửa tại đây.</strong>
                        <p style="margin: 5px 0 0 0; font-size: 14px;">Nếu cần thay đổi, vui lòng cập nhật trong mục "Thông tin công ty".</p>
                    </div>
                    
                    <div class="form-group">
                        <label for="company-name">Tên công ty <span class="required">*</span></label>
                        <input type="text" id="company-name" value="<%= recruiter.getCompanyName() != null ? recruiter.getCompanyName() : "" %>" readonly style="background-color: #f5f5f5; cursor: not-allowed;">
                    </div>

                    <div class="form-group">
                        <label for="company-address">Địa chỉ công ty</label>
                        <input type="text" id="company-address" value="<%= recruiter.getCompanyAddress() != null ? recruiter.getCompanyAddress() : "" %>" readonly style="background-color: #f5f5f5; cursor: not-allowed;">
                    </div>

                    <div class="form-group">
                        <label for="company-size">Quy mô công ty</label>
                        <select id="company-size" disabled style="background-color: #f5f5f5; cursor: not-allowed;">
                            <option value="">Vui lòng chọn</option>
                            <option value="1-10" <%= "1-10".equals(recruiter.getCompanySize()) ? "selected" : "" %>>1-10 nhân viên</option>
                            <option value="11-50" <%= "11-50".equals(recruiter.getCompanySize()) ? "selected" : "" %>>11-50 nhân viên</option>
                            <option value="51-200" <%= "51-200".equals(recruiter.getCompanySize()) ? "selected" : "" %>>51-200 nhân viên</option>
                            <option value="201-500" <%= "201-500".equals(recruiter.getCompanySize()) ? "selected" : "" %>>201-500 nhân viên</option>
                            <option value="500+" <%= "500+".equals(recruiter.getCompanySize()) ? "selected" : "" %>>Trên 500 nhân viên</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="company-info">Thông tin công ty <span class="required">*</span></label>
                        <textarea id="company-info" rows="6" readonly style="background-color: #f5f5f5; cursor: not-allowed;"><%= recruiter.getCompanyDescription() != null ? recruiter.getCompanyDescription() : "" %></textarea>
                        <div class="char-counter">
                            <% 
                            String desc = recruiter.getCompanyDescription() != null ? recruiter.getCompanyDescription() : "";
                            int descLength = desc.length();
                            %>
                            <%= descLength %>/10000 ký tự
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="company-benefits">Phúc lợi từ công ty <span class="required">*</span></label>
                        <textarea id="company-benefits" name="company-benefits" rows="6" readonly style="background-color: #f5f5f5; cursor: not-allowed;"><%= recruiter.getCompanyBenefits() != null ? recruiter.getCompanyBenefits() : "" %></textarea>
                    </div>

                    <div class="form-group">
                        <label>Logo công ty</label>
                        <% if (recruiter.getCompanyLogoURL() != null && !recruiter.getCompanyLogoURL().isEmpty()) { %>
                            <div style="margin-bottom: 10px;">
                                <img src="<%= request.getContextPath() + recruiter.getCompanyLogoURL() %>" alt="Company Logo" style="max-width: 200px; max-height: 200px; border: 1px solid #ddd; padding: 5px; border-radius: 5px;" onerror="this.onerror=null; this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgZmlsbD0iI2Y1ZjVmNSIvPjx0ZXh0IHg9IjUwJSIgeT0iNTAlIiBmb250LWZhbWlseT0iQXJpYWwiIGZvbnQtc2l6ZT0iMTQiIGZpbGw9IiM5OTkiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGR5PSIuM2VtIj5Lb2h0aCBjw7MgbG9nbyBjb25nIHR5PC90ZXh0Pjwvc3ZnPg==';">
                            </div>
                        <% } else { %>
                            <div style="padding: 10px; background-color: #f5f5f5; border-radius: 5px; color: #999;">
                                <i class="fas fa-image"></i> Chưa có logo công ty
                            </div>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label>Hình ảnh công ty</label>
                        <% if (recruiter.getImg() != null && !recruiter.getImg().isEmpty()) { %>
                            <div style="margin-bottom: 10px;">
                                <img src="<%= request.getContextPath() + recruiter.getImg() %>" alt="Company Image" style="max-width: 300px; max-height: 300px; border: 1px solid #ddd; padding: 5px; border-radius: 5px;" onerror="this.onerror=null; this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgZmlsbD0iI2Y1ZjVmNSIvPjx0ZXh0IHg9IjUwJSIgeT0iNTAlIiBmb250LWZhbWlseT0iQXJpYWwiIGZvbnQtc2l6ZT0iMTQiIGZpbGw9IiM5OTkiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGR5PSIuM2VtIj5Lb2h0aCBjw7MgacOqbmgg4bqldCBjb25nIHR5PC90ZXh0Pjwvc3ZnPg==';">
                            </div>
                        <% } else { %>
                            <div style="padding: 10px; background-color: #f5f5f5; border-radius: 5px; color: #999;">
                                <i class="fas fa-image"></i> Chưa có hình ảnh công ty
                            </div>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label for="company-video">Video công ty</label>
                        <input type="url" id="company-video" value="<%= recruiter.getCompanyVideoURL() != null ? recruiter.getCompanyVideoURL() : "" %>" readonly style="background-color: #f5f5f5; cursor: not-allowed;" placeholder="Chưa có video công ty">
                        <% if (recruiter.getCompanyVideoURL() != null && !recruiter.getCompanyVideoURL().isEmpty()) { %>
                            <div style="margin-top: 10px;">
                                <a href="<%= recruiter.getCompanyVideoURL() %>" target="_blank" class="btn btn-secondary" style="display: inline-block; padding: 5px 15px; text-decoration: none;">
                                    <i class="fas fa-external-link-alt"></i> Xem video
                                </a>
                            </div>
                        <% } %>
                    </div>
                    <% } else { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        Không tìm thấy thông tin công ty. Vui lòng đăng nhập lại.
                    </div>
                    <% } %>
                </div>
            </div>

            <% if (request.getAttribute("postingRecruiterPackageID") != null) { %>
                <input type="hidden" name="posting-recruiter-package-id" value="<%= request.getAttribute("postingRecruiterPackageID") %>">
            <% } %>
            <% if (request.getAttribute("packageWarning") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("packageWarning") %>
                </div>
            <% } %>
            <div class="form-actions">
                <button type="submit" name="action" value="draft" class="btn btn-secondary" <%= disableDraftButton ? "disabled" : "" %>>Lưu nháp</button>
                <button type="submit" name="action" value="post" class="btn btn-primary" <%= (request.getAttribute("postingDisabled") != null && (Boolean)request.getAttribute("postingDisabled")) ? "disabled" : "" %>>Đăng tin</button>
            </div>
            </form>
        </div>
    </main>

    <!-- Chat Widget -->
    <div class="chat-widget">
        <div class="chat-content">
            <i class="fas fa-comments"></i>
            <span>Chat</span>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>
    <script>
        // Validation trước khi submit: mức lương, độ tuổi, năm kinh nghiệm tối thiểu
        (function() {
            const form = document.getElementById('job-posting-form');
            if (!form) return;
            form.addEventListener('submit', function(e) {
                const errs = [];
                const sMin = document.getElementById('salary-min');
                const sMax = document.getElementById('salary-max');
                const aMin = document.getElementById('age-min');
                const aMax = document.getElementById('age-max');
                const minExp = document.getElementById('min-experience');

                const toNum = (el) => {
                    if (!el || el.value === '') return null;
                    const n = Number(el.value);
                    return Number.isFinite(n) ? n : NaN;
                };

                const svMin = toNum(sMin);
                const svMax = toNum(sMax);
                if (svMin != null && svMax != null) {
                    if (isNaN(svMin) || isNaN(svMax) || svMin < 0 || svMax < 0) {
                        errs.push('Mức lương phải là số không âm.');
                    } else if (svMin > svMax) {
                        errs.push('Mức lương tối thiểu không được lớn hơn mức lương tối đa.');
                    }
                }

                const avMin = toNum(aMin);
                const avMax = toNum(aMax);
                if (avMin != null && avMax != null) {
                    if (isNaN(avMin) || isNaN(avMax)) {
                        errs.push('Độ tuổi phải là số.');
                    } else {
                        if (avMin < 15 || avMin > 65 || avMax < 15 || avMax > 65) {
                            errs.push('Độ tuổi phải nằm trong khoảng 15 - 65.');
                        }
                        if (avMin > avMax) {
                            errs.push('Độ tuổi tối thiểu không được lớn hơn độ tuổi tối đa.');
                        }
                    }
                }

                const mx = toNum(minExp);
                if (mx != null) {
                    if (isNaN(mx) || mx < 0 || mx > 60) {
                        errs.push('Năm kinh nghiệm tối thiểu phải là số trong khoảng 0 - 60.');
                    }
                }

                if (errs.length) {
                    e.preventDefault();
                    alert(errs.join('\n'));
                }
            });
        })();
        // Removed debug logging for featured toggle

        // Simple Custom Dropdown cho Ngành nghề chi tiết
        let professionDropdownOpen = false;
        
        function toggleProfessionDropdown() {
            const dropdown = document.getElementById('profession-list');
            const input = document.getElementById('profession-input');
            
            if (dropdown) {
                if (dropdown.style.display === 'none') {
                    dropdown.style.display = 'block';
                    input.classList.add('active');
                    professionDropdownOpen = true;
                } else {
                    dropdown.style.display = 'none';
                    input.classList.remove('active');
                    professionDropdownOpen = false;
                }
            }
        }
        
        function toggleParentCategory(element, event) {
            if (event) {
                event.stopPropagation(); // Ngăn đóng dropdown khi click vào parent
            }
            const childrenList = element.nextElementSibling;
            const arrow = element.querySelector('.category-arrow');
            
            if (childrenList && childrenList.classList.contains('category-children-list')) {
                if (childrenList.style.display === 'none') {
                    childrenList.style.display = 'block';
                    element.classList.add('active');
                } else {
                    childrenList.style.display = 'none';
                    element.classList.remove('active');
                }
            }
        }
        
        function selectProfession(element) {
            const categoryId = element.getAttribute('data-category-id');
            const categoryName = element.getAttribute('data-category-name') || element.textContent.trim();
            
            // Update hidden input
            const hiddenInput = document.getElementById('profession');
            if (hiddenInput) {
                hiddenInput.value = categoryId;
            }
            
            // Update display text
            const textSpan = document.getElementById('profession-text');
            const input = document.getElementById('profession-input');
            if (textSpan && input) {
                textSpan.textContent = categoryName;
                textSpan.style.color = '#374151';
                input.classList.add('selected');
            }
            
            // Remove previous selection
            document.querySelectorAll('.category-child-item.selected').forEach(item => {
                item.classList.remove('selected');
            });
            
            // Add selection
            element.classList.add('selected');
            
            // Close dropdown
            const dropdown = document.getElementById('profession-list');
            if (dropdown) {
                dropdown.style.display = 'none';
                document.getElementById('profession-input').classList.remove('active');
                professionDropdownOpen = false;
            }
        }
        
        // Đóng dropdown khi click bên ngoài
        document.addEventListener('click', function(e) {
            const dropdown = document.querySelector('.simple-custom-dropdown');
            if (dropdown && !dropdown.contains(e.target) && professionDropdownOpen) {
                document.getElementById('profession-list').style.display = 'none';
                document.getElementById('profession-input').classList.remove('active');
                professionDropdownOpen = false;
            }
        });
        
        // Skills tag management
        let skillsArray = [];
        const maxSkills = 5;
        const skillInput = document.getElementById('skill-input');
        const selectedTagsContainer = document.getElementById('selected-skills-tags');
        const skillsHiddenInput = document.getElementById('skills');
        
        function addSkillTag(skillName) {
            if (skillsArray.length >= maxSkills) {
                alert('Bạn chỉ có thể thêm tối đa ' + maxSkills + ' kỹ năng!');
                return;
            }
            
            skillName = skillName.trim();
            if (!skillName) return;
            
            // Kiểm tra xem skill đã tồn tại chưa (case-insensitive)
            const skillLower = skillName.toLowerCase();
            if (skillsArray.some(s => s.toLowerCase() === skillLower)) {
                alert('Kỹ năng "' + skillName + '" đã được thêm!');
                return;
            }
            
            skillsArray.push(skillName);
            updateSkillsDisplay();
            skillInput.value = '';
        }
        
        function removeSkillTag(skillName) {
            skillsArray = skillsArray.filter(s => s !== skillName);
            updateSkillsDisplay();
        }
        
        function updateSkillsDisplay() {
            selectedTagsContainer.innerHTML = '';
            skillsArray.forEach(skill => {
                const tag = document.createElement('span');
                tag.className = 'tag';
                tag.innerHTML = skill + ' <i class="fas fa-times"></i>';
                tag.querySelector('i').addEventListener('click', function(e) {
                    e.stopPropagation();
                    removeSkillTag(skill);
                });
                selectedTagsContainer.appendChild(tag);
            });
            
            // Update hidden input với danh sách skills (comma-separated)
            skillsHiddenInput.value = skillsArray.join(',');
        }
        
        skillInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                addSkillTag(skillInput.value);
            }
        });
        
        skillInput.addEventListener('blur', function(e) {
            if (skillInput.value.trim()) {
                addSkillTag(skillInput.value);
            }
        });
        
        // Initialize category and skills in edit mode
        <% 
        System.out.println("========== DEBUG: JSP SCRIPT START ==========");
        Integer editingJobCategoryID = (Integer) request.getAttribute("editingJobCategoryID");
        java.util.List<String> editingJobSkills = (java.util.List<String>) request.getAttribute("editingJobSkills");
        System.out.println("DEBUG JSP: editingJobCategoryID = " + editingJobCategoryID);
        System.out.println("DEBUG JSP: editingJobSkills = " + editingJobSkills);
        System.out.println("DEBUG JSP: editingJobSkills size = " + (editingJobSkills != null ? editingJobSkills.size() : "null"));
        %>
        console.log('========== DEBUG: JavaScript Initialization START ==========');
        console.log('DEBUG JS: editingJobCategoryID = <%= editingJobCategoryID != null ? editingJobCategoryID : "null" %>');
        console.log('DEBUG JS: editingJobSkills = <%= editingJobSkills != null ? editingJobSkills : "null" %>');
        console.log('DEBUG JS: editingJobSkills size = <%= editingJobSkills != null ? editingJobSkills.size() : "null" %>');
        
        // Initialize category selection - mark as selected in dropdown
        <% 
        if (editingJobCategoryID != null) { 
        %>
        console.log('DEBUG JS: CategoryID is NOT null, marking category as selected...');
        (function() {
            function initCategory() {
                console.log('DEBUG JS: initCategory() called');
                console.log('DEBUG JS: Looking for category with ID: <%= editingJobCategoryID %>');
                const categoryItem = document.querySelector('.category-child-item[data-category-id="<%= editingJobCategoryID %>"]');
                console.log('DEBUG JS: categoryItem found: ' + (categoryItem ? 'YES' : 'NO'));
                if (categoryItem) {
                    console.log('DEBUG JS: Found category item for ID: <%= editingJobCategoryID %>');
                    // Mark as selected visually
                    categoryItem.classList.add('selected');
                    // Expand parent category if needed
                    const childrenList = categoryItem.closest('.category-children-list');
                    if (childrenList) {
                        const parentItem = childrenList.previousElementSibling;
                        if (parentItem && parentItem.classList.contains('category-parent-item')) {
                            // Expand the parent
                            childrenList.style.display = 'block';
                            const arrow = parentItem.querySelector('.category-arrow');
                            if (arrow) {
                                arrow.classList.remove('fa-chevron-right');
                                arrow.classList.add('fa-chevron-down');
                            }
                            parentItem.classList.add('expanded');
                        }
                    }
                    // Ensure hidden input has the value
                    const hiddenInput = document.getElementById('profession');
                    if (hiddenInput) {
                        hiddenInput.value = '<%= editingJobCategoryID %>';
                    }
                    // Mark dropdown as selected
                    const dropdownInput = document.getElementById('profession-input');
                    if (dropdownInput) {
                        dropdownInput.classList.add('selected');
                    }
                    console.log('DEBUG JS: Category marked as selected');
                } else {
                    console.log('DEBUG JS: Category item not found for ID: <%= editingJobCategoryID %>');
                    // Retry after a short delay
                    setTimeout(initCategory, 100);
                }
            }
            
            console.log('DEBUG JS: Document readyState: ' + document.readyState);
            if (document.readyState === 'loading') {
                console.log('DEBUG JS: Adding DOMContentLoaded listener');
                document.addEventListener('DOMContentLoaded', initCategory);
            } else {
                console.log('DEBUG JS: DOM already loaded, calling initCategory directly');
                setTimeout(initCategory, 100);
            }
        })();
        <% } else { %>
        console.log('DEBUG JS: CategoryID is NULL, skipping category initialization');
        <% } %>
        
        // Initialize skills
        <% 
        java.util.List<String> editingJobSkillsList = (java.util.List<String>) request.getAttribute("editingJobSkills");
        System.out.println("DEBUG JSP: Checking skills list...");
        if (editingJobSkillsList != null && !editingJobSkillsList.isEmpty()) { 
            System.out.println("DEBUG JSP: Skills list is NOT empty, size = " + editingJobSkillsList.size());
        %>
        console.log('DEBUG JS: Skills list is NOT empty, initializing...');
        (function() {
            function initSkills() {
                console.log('DEBUG JS: initSkills() called');
                console.log('DEBUG JS: Initializing skills, count: <%= editingJobSkillsList.size() %>');
                <% for (String skillName : editingJobSkillsList) { 
                    // Escape single quotes and backslashes for JavaScript
                    String escapedSkillName = skillName.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");
                %>
                skillsArray.push('<%= escapedSkillName %>');
                <% } %>
                updateSkillsDisplay();
                console.log('DEBUG JS: Skills initialized:', skillsArray);
                console.log('DEBUG JS: skillsHiddenInput.value =', document.getElementById('skills').value);
            }
            
            console.log('DEBUG JS: Document readyState for skills: ' + document.readyState);
            if (document.readyState === 'loading') {
                console.log('DEBUG JS: Adding DOMContentLoaded listener for skills');
                document.addEventListener('DOMContentLoaded', initSkills);
            } else {
                console.log('DEBUG JS: DOM already loaded, calling initSkills directly');
                // DOM already loaded
                setTimeout(initSkills, 100);
            }
        })();
        <% } else { 
            System.out.println("DEBUG JSP: Skills list is NULL or EMPTY");
        %>
        console.log('DEBUG JS: No skills to initialize (editingJobSkills is null or empty)');
        <% } %>
        console.log('========== DEBUG: JavaScript Initialization END ==========');
        System.out.println("========== DEBUG: JSP SCRIPT END ==========");
    </script>
</body>
</html>


