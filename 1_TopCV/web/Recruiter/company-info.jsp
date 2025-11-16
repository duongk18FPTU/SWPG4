<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Recruiter" %>
<%
    Recruiter recruiter = (Recruiter) request.getAttribute("recruiter");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    
    // If no recruiter from request, try to get from session
    if (recruiter == null) {
        Recruiter sessionRecruiter = (Recruiter) session.getAttribute("recruiter");
        if (sessionRecruiter != null) {
            recruiter = sessionRecruiter;
        }
    }
    
    // Get user info for display
    String userName = (recruiter != null) ? recruiter.getContactPerson() : "User";
    
    // Debug info
    System.out.println("=== Company Info Page Debug ===");
    System.out.println("Recruiter from request: " + (request.getAttribute("recruiter") != null ? "Yes" : "No"));
    System.out.println("Recruiter from session: " + (session.getAttribute("recruiter") != null ? "Yes" : "No"));
    System.out.println("Final recruiter: " + (recruiter != null ? "Yes" : "No"));
    if (recruiter != null) {
        System.out.println("Recruiter name: " + recruiter.getContactPerson());
        System.out.println("Recruiter company: " + recruiter.getCompanyName());
        System.out.println("Recruiter.getImg(): " + recruiter.getImg());
        System.out.println("Recruiter.getCompanyLogoURL(): " + recruiter.getCompanyLogoURL());
    }
    System.out.println("=== End Company Info Page Debug ===");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông Tin Công Ty - Dashboard Tuyển Dụng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/styles.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body class="company-info-page">
        <!-- Recruiter Info Debug Section -->
        

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
                        <li><a href="${pageContext.request.contextPath}/listpostingjobs">Việc Làm</a></li>
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
                        <li><a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp" class="active">Công ty</a></li>
                    </ul>
                </div>
                <div class="nav-right">
                    <div class="nav-buttons">
                        <div class="dropdown">
                            <button class="btn btn-orange">
                                Đăng Tuyển Dụng <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/jobposting">Tạo tin tuyển dụng mới</a>
                                <a href="${pageContext.request.contextPath}/listpostingjobs">Quản lý tin đã đăng</a>
                            </div>
                        </div>
                        <button class="btn btn-blue" onclick="window.location.href='${pageContext.request.contextPath}/candidate-search'">Tìm Ứng Viên</button>
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
                                    <a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp" class="menu-item highlighted">
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
        <main class="account-main">
            <div class="account-container">
                <!-- Left Sidebar -->
                <aside class="account-sidebar">
                    <nav class="sidebar-nav">
                        <div class="nav-group">
                            <a href="account-management.html" class="nav-link">
                                <i class="fas fa-cog"></i>
                                <span>Quản lý tài khoản</span>
                            </a>
                        </div>

                        <div class="nav-group">
                            <div class="nav-item dropdown">
                                <a href="#" class="nav-link active">
                                    <i class="fas fa-building"></i>
                                    <span>Thông tin công ty</span>
                                    <i class="fas fa-chevron-down"></i>
                                </a>
                                <div class="dropdown-submenu">
                                    <a href="#" class="nav-link active">
                                        <i class="fas fa-user"></i>
                                        <span>Thông tin chung</span>
                                    </a>
                                    <a href="#" class="nav-link">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <span>Địa điểm làm việc</span>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="nav-group">
                            <div class="nav-item dropdown">
                                <a href="#" class="nav-link">
                                    <i class="fas fa-shield-alt"></i>
                                    <span>Quản lý quyền truy cập</span>
                                    <i class="fas fa-chevron-down"></i>
                                </a>
                                <div class="dropdown-submenu">
                                    <a href="#" class="nav-link">
                                        <i class="fas fa-users"></i>
                                        <span>Người dùng</span>
                                    </a>
                                    <a href="#" class="nav-link">
                                        <i class="fas fa-user-tag"></i>
                                        <span>Vai trò</span>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="nav-group">
                            <a href="#" class="nav-link">
                                <i class="fas fa-tasks"></i>
                                <span>Quản lý yêu cầu</span>
                            </a>
                            <a href="#" class="nav-link">
                                <i class="fas fa-history"></i>
                                <span>Lịch sử hoạt động</span>
                            </a>
                        </div>
                    </nav>
                </aside>

                <!-- Main Content Area -->
                <div class="account-content">
                    <div class="content-header">
                        <h1>Thông Tin Công Ty</h1>
                    </div>

                    <div class="company-form">
                        <!-- Success/Error Messages -->
                        <% if (success != null && success.equals("updated")) { %>
                        <div class="alert alert-success" id="successAlert">
                            <i class="fas fa-check-circle"></i>
                            Cập nhật thông tin công ty thành công!
                        </div>
                        <script>
                            console.log('Success message should be visible');
                            setTimeout(() => {
                                const alert = document.getElementById('successAlert');
                                if (alert) {
                                    alert.style.display = 'flex';
                                    alert.style.opacity = '1';
                                    console.log('Success alert displayed');
                                }
                            }, 100);
                        </script>
                        <% } %>

                        <% if (error != null) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <% if (error.equals("update_failed")) { %>
                            Cập nhật thông tin thất bại. Vui lòng thử lại.
                            <% } else if (error.equals("system_error")) { %>
                            Có lỗi hệ thống. Vui lòng thử lại sau.
                            <% } else { %>
                            <%= error %>
                            <% } %>
                        </div>
                        <% } %>

                        <form id="companyInfoForm" action="${pageContext.request.contextPath}/CompanyInfoServlet" method="POST" enctype="multipart/form-data">
                            <!-- Hidden fields to track removed images -->
                            <input type="hidden" id="removedLogo" name="removedLogo" value="">
                            <input type="hidden" id="removedImages" name="removedImages" value="">
                            <!-- Thông Tin Công Ty Section -->
                            <div class="form-section">
                                <h3>Thông Tin Công Ty</h3>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="company-name">Tên Công Ty <span class="required">*</span></label>
                                        <input type="text" id="company-name" name="companyName" 
                                               value="<%= recruiter != null && recruiter.getCompanyName() != null ? recruiter.getCompanyName() : "" %>"
                                               placeholder="Nhập tên công ty" required>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="phone">Điện Thoại <span class="required">*</span></label>
                                        <div class="input-with-validation">
                                            <input type="tel" id="phone" name="phone"  
                                                   value="<%= recruiter != null && recruiter.getPhone() != null ? recruiter.getPhone() : "" %>"
                                                   required>
                                            <div class="validation-feedback" id="phoneValidation">
                                                <i class="fas fa-spinner fa-spin validation-loading" style="display: none;"></i>
                                                <i class="fas fa-check-circle validation-success" style="display: none;"></i>
                                                <i class="fas fa-times-circle validation-error" style="display: none;"></i>
                                                <span class="validation-message"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="address">Địa Chỉ Công Ty</label>
                                        <input type="text" id="address" name="companyAddress" 
                                               value="<%= recruiter != null && recruiter.getCompanyAddress() != null ? recruiter.getCompanyAddress() : "" %>"
                                               placeholder="Nhập địa chỉ công ty">
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="company-size">Quy Mô Công Ty</label>
                                        <select id="company-size" name="companySize">
                                            <option value="">Vui lòng chọn</option>
                                            <option value="1-10" <%= recruiter != null && "1-10".equals(recruiter.getCompanySize()) ? "selected" : "" %>>1-10 nhân viên</option>
                                            <option value="11-50" <%= recruiter != null && "11-50".equals(recruiter.getCompanySize()) ? "selected" : "" %>>11-50 nhân viên</option>
                                            <option value="51-200" <%= recruiter != null && "51-200".equals(recruiter.getCompanySize()) ? "selected" : "" %>>51-200 nhân viên</option>
                                            <option value="201-500" <%= recruiter != null && "201-500".equals(recruiter.getCompanySize()) ? "selected" : "" %>>201-500 nhân viên</option>
                                            <option value="500+" <%= recruiter != null && "500+".equals(recruiter.getCompanySize()) ? "selected" : "" %>>500+ nhân viên</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="tax-code">Mã Số Thuế</label>
                                        <div class="input-with-validation">
                                            <input type="text" id="tax-code" name="taxCode" 
                                                   value="<%= recruiter != null && recruiter.getTaxcode() != null ? recruiter.getTaxcode() : "" %>"
                                                   placeholder="Nhập mã số thuế (10 số)">
                                            <div class="validation-feedback" id="taxCodeValidation">
                                                <i class="fas fa-spinner fa-spin validation-loading" style="display: none;"></i>
                                                <i class="fas fa-check-circle validation-success" style="display: none;"></i>
                                                <i class="fas fa-times-circle validation-error" style="display: none;"></i>
                                                <span class="validation-message"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="registration-cert">Giấy Phép Đăng Ký Kinh Doanh</label>
                                        <div class="file-upload">
                                            <div class="upload-area" id="registrationCertUploadArea" <%= recruiter != null && recruiter.getRegistrationCert() != null && !recruiter.getRegistrationCert().isEmpty() ? "style='display: none;'" : "" %>>
                                                <i class="fas fa-cloud-upload-alt"></i>
                                                <p>Kéo và thả file ở đây hoặc <span>Chọn file</span></p>
                                                <input type="file" id="registration-cert" name="registrationCert" accept=".pdf,.jpg,.jpeg,.png" style="display: none;">
                                            </div>
                                            <div id="registrationCertPreview" class="file-preview" <%= recruiter != null && recruiter.getRegistrationCert() != null && !recruiter.getRegistrationCert().isEmpty() ? "style='display: block;'" : "style='display: none;'" %>>
                                                <div class="file-image-preview" style="position: relative;">
                                                    <% if (recruiter != null && recruiter.getRegistrationCert() != null && !recruiter.getRegistrationCert().isEmpty()) { %>
                                                    <%
                                                        String fileName = recruiter.getRegistrationCert().split("/")[recruiter.getRegistrationCert().split("/").length - 1];
                                                        String fileExtension = fileName.split("\\.")[fileName.split("\\.").length - 1].toLowerCase();
                                                        boolean isImage = fileExtension.equals("jpg") || fileExtension.equals("jpeg") || fileExtension.equals("png");
                                                    %>
                                                    <% if (isImage) { %>
                                                    <img id="registrationCertImagePreview" 
                                                         src="<%= request.getContextPath() + "/" + recruiter.getRegistrationCert() %>" 
                                                         alt="Certificate Preview" 
                                                         style="max-width: 200px; max-height: 150px; border-radius: 4px;"
                                                         onerror="this.style.display='none';">
                                                    <% } else { %>
                                                    <img id="registrationCertImagePreview" src="" alt="Certificate Preview" style="display: none;">
                                                    <% } %>
                                                    <% } else { %>
                                                    <img id="registrationCertImagePreview" src="" alt="Certificate Preview" style="display: none;">
                                                    <% } %>
                                                    <button type="button" class="remove-file" onclick="removeRegistrationCert()" style="position: absolute; top: -8px; right: -8px; background: #dc3545; color: white; border: none; border-radius: 50%; width: 24px; height: 24px; cursor: pointer; display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <small class="upload-hint">(Tập tin PDF, JPG, PNG và kích thước <5MB)</small>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="contact-person">Người Liên Hệ</label>
                                        <input type="text" id="contact-person" name="contactPerson" 
                                               value="<%= recruiter != null && recruiter.getContactPerson() != null ? recruiter.getContactPerson() : "" %>"
                                               placeholder="Nhập tên người liên hệ">
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="website">Website</label>
                                        <input type="url" id="website" name="website" 
                                               value="<%= recruiter != null && recruiter.getWebsite() != null ? recruiter.getWebsite() : "" %>"
                                               placeholder="https://example.com">
                                    </div>
                                </div>
                            </div>

                            <!-- Phúc Lợi Từ Công Ty Section -->
                            <div class="form-section">
                                <h3>Phúc Lợi Từ Công Ty <span class="required">*</span></h3>

                                <div class="form-group">
                                    <textarea id="company-benefits" name="companyBenefits" 
                                              placeholder="Nhập các phúc lợi của công ty (mỗi phúc lợi trên một dòng)..."><%= recruiter != null && recruiter.getCompanyBenefits() != null ? recruiter.getCompanyBenefits() : "" %></textarea>
                                </div>
                            </div>

                            <!-- Sơ Lược Về Công Ty Section -->
                            <div class="form-section">
                                <h3>Sơ Lược Về Công Ty</h3>
                                <div class="form-group">
                                    <textarea id="company-overview" name="companyDescription" 
                                              placeholder="Nhập mô tả về công ty..."><%= recruiter != null && recruiter.getCompanyDescription() != null ? recruiter.getCompanyDescription() : "" %></textarea>
                                    <div class="char-counter">
                                        <span>Bạn còn có thể nhập <strong id="charCount">10000</strong> ký tự</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Logo Công Ty Section -->
                            <div class="form-section">
                                <h3>Logo Công Ty</h3>
                                <div class="file-upload">
                                    <div class="upload-area" id="logoUploadArea" <%= recruiter != null && recruiter.getCompanyLogoURL() != null && !recruiter.getCompanyLogoURL().isEmpty() ? "style='display: none;'" : "" %>>
                                        <i class="fas fa-cloud-upload-alt"></i>
                                        <p>Kéo và thả logo ở đây hoặc <span>Chọn file</span></p>
                                        <input type="file" id="companyLogo" name="companyLogo" accept="image/*" style="display: none;">
                                    </div>
                                    <div id="logoPreview" class="image-preview" <%= recruiter != null && recruiter.getCompanyLogoURL() != null && !recruiter.getCompanyLogoURL().isEmpty() ? "" : "style='display: none;'" %>>
                                        <% if (recruiter != null && recruiter.getCompanyLogoURL() != null && !recruiter.getCompanyLogoURL().isEmpty()) { %>
                                        <img id="logoPreviewImg" 
                                             src="<%= request.getContextPath() + recruiter.getCompanyLogoURL() %>" 
                                             alt="Logo Preview" 
                                             style="max-width: 200px; max-height: 150px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);"
                                             onerror="this.style.display='none'; document.getElementById('logoUploadArea').style.display='block'; document.getElementById('logoPreview').style.display='none';">
                                        <% } else { %>
                                        <img id="logoPreviewImg" src="" alt="Logo Preview" style="display: none;">
                                        <% } %>
                                        <button type="button" id="removeLogo" class="remove-image">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                    <small class="upload-hint">(Tập tin với phần mở rộng .jpg, .jpeg, .png, .gif và kích thước <1MB)</small>
                                </div>
                            </div>

                            <!-- Hình Ảnh Công Ty Section -->
                            <div class="form-section">
                                <h3>Hình Ảnh Công Ty</h3>
                                <p class="upload-limit">Tối đa 5 ảnh</p>
                                <div class="file-upload">
                                    <div class="upload-area" id="imagesUploadArea">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                        <p>Kéo và thả hình ảnh ở đây hoặc <span>Chọn file</span></p>
                                        <input type="file" id="companyImages" name="companyImages" accept="image/*" multiple style="display: none;">
                                    </div>
                                    <div id="imagesPreview" class="images-preview">
                                        <!-- Existing images from database -->
                                        <% if (recruiter != null && recruiter.getImg() != null && !recruiter.getImg().isEmpty()) { 
                                            String[] imagePaths = recruiter.getImg().split(",");
                                            String logoPath = recruiter.getCompanyLogoURL();
                                    
                                            for (String imagePath : imagePaths) {
                                                if (!imagePath.trim().isEmpty()) {
                                                    // Skip if this is the logo (avoid duplicate display)
                                                    boolean isLogo = false;
                                                    if (logoPath != null && !logoPath.isEmpty()) {
                                                        // Check if this image path contains logo directory or matches logo path
                                                        if (imagePath.trim().contains("/logos/") || 
                                                            imagePath.trim().equals(logoPath.trim())) {
                                                            isLogo = true;
                                                        }
                                                    }
                                            
                                                    if (!isLogo) { %>
                                        <div class="image-preview-item existing-image" style="position: relative; display: inline-block; margin: 5px;">
                                            <img src="<%= request.getContextPath() + imagePath.trim() %>" 
                                                 alt="Company Image" 
                                                 style="max-width: 150px; max-height: 100px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); object-fit: cover;"
                                                 onerror="this.parentElement.style.display='none';">
                                            <button type="button" class="remove-image" onclick="removeExistingImage(this, '<%= imagePath.trim() %>')" style="position: absolute; top: -8px; right: -8px; background: #dc3545; color: white; border: none; border-radius: 50%; width: 24px; height: 24px; cursor: pointer; display: flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                        <% }
                                    }
                                }
                            } %>
                                        <!-- Preview images will be added here -->
                                    </div>
                                    <small class="upload-hint">(Tập tin với phần mở rộng .jpg, .jpeg, .png, .gif và kích thước <1MB mỗi file)</small>
                                </div>
                            </div>

                            <!-- Video Công Ty Section -->
                            <div class="form-section">
                                <h3>Video Công Ty</h3>
                                <div class="form-group">
                                    <input type="url" id="company-video" name="companyVideoURL" 
                                           value="<%= recruiter != null && recruiter.getCompanyVideoURL() != null ? recruiter.getCompanyVideoURL() : "" %>"
                                           placeholder="Sao chép và dán từ liên kết Youtube của bạn vào đây">
                                </div>
                            </div>

                            <!-- Save Button -->
                            <div class="form-actions">
                                <button type="submit" class="save-btn">
                                    <i class="fas fa-save"></i>
                                    Lưu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <!-- Chat Widget -->
        <div class="chat-widget">
            <div class="chat-content">
                <i class="fas fa-comments"></i>
                <span>We're online, chat with us!</span>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>

        <script>
                                                // Phone Validation Script
                                                console.log('Phone validation script starting...');

                                                document.addEventListener('DOMContentLoaded', function () {
                                                    console.log('DOM loaded, initializing phone validation...');

                                                    // ========================================
                                                    // VARIABLES AND INITIALIZATION
                                                    // ========================================
                                                    let selectedCompanyImages = []; // Store selected files for company images

                                                    // Check for broken images and handle them
                                                    function handleBrokenImages() {
                                                        const images = document.querySelectorAll('img');
                                                        images.forEach(img => {
                                                            img.addEventListener('error', function () {
                                                                // Hide broken images
                                                                this.style.display = 'none';
                                                                // If it's a logo, show upload area
                                                                if (this.id === 'logoPreviewImg') {
                                                                    document.getElementById('logoUploadArea').style.display = 'block';
                                                                    document.getElementById('logoPreview').style.display = 'none';
                                                                }
                                                            });
                                                        });
                                                    }

                                                    // Initialize broken image handling
                                                    handleBrokenImages();

                                                    // Character counter elements
                                                    const companyOverview = document.getElementById('company-overview');
                                                    const charCount = document.getElementById('charCount');
                                                    const maxLength = 10000;

                                                    if (companyOverview && charCount) {
                                                        function updateCharCount() {
                                                            const remaining = maxLength - companyOverview.value.length;
                                                            charCount.textContent = remaining;
                                                            charCount.style.color = remaining < 100 ? 'red' : 'inherit';
                                                        }

                                                        companyOverview.addEventListener('input', updateCharCount);
                                                        updateCharCount(); // Initial count
                                                    }


                                                    // ========================================
                                                    // LOGO UPLOAD HANDLING
                                                    // ========================================
                                                    const logoElements = {
                                                        uploadArea: document.getElementById('logoUploadArea'),
                                                        input: document.getElementById('companyLogo'),
                                                        preview: document.getElementById('logoPreview'),
                                                        previewImg: document.getElementById('logoPreviewImg'),
                                                        removeBtn: document.getElementById('removeLogo')
                                                    };

                                                    if (logoElements.uploadArea && logoElements.input) {
                                                        setupLogoUpload();
                                                    }

                                                    function setupLogoUpload() {
                                                        // Click to upload
                                                        logoElements.uploadArea.addEventListener('click', () => logoElements.input.click());

                                                        // Drag and drop handlers
                                                        ['dragover', 'dragleave', 'drop'].forEach(eventType => {
                                                            logoElements.uploadArea.addEventListener(eventType, handleLogoDragEvent);
                                                        });

                                                        // File selection
                                                        logoElements.input.addEventListener('change', (e) => {
                                                            if (e.target.files.length > 0) {
                                                                handleLogoPreview(e.target.files[0]);
                                                            }
                                                        });

                                                        // Remove logo
                                                        if (logoElements.removeBtn) {
                                                            logoElements.removeBtn.addEventListener('click', removeLogo);
                                                        }
                                                    }

                                                    function handleLogoDragEvent(e) {
                                                        e.preventDefault();

                                                        if (e.type === 'dragover') {
                                                            logoElements.uploadArea.classList.add('drag-over');
                                                        } else if (e.type === 'dragleave') {
                                                            logoElements.uploadArea.classList.remove('drag-over');
                                                        } else if (e.type === 'drop') {
                                                            logoElements.uploadArea.classList.remove('drag-over');
                                                            const files = e.dataTransfer.files;
                                                            if (files.length > 0) {
                                                                logoElements.input.files = files;
                                                                handleLogoPreview(files[0]);
                                                            }
                                                        }
                                                    }

                                                    function removeLogo() {
                                                        const currentLogoSrc = logoElements.previewImg.src;
                                                        const contextPath = '<%= request.getContextPath() %>';

                                                        if (currentLogoSrc.includes(contextPath)) {
                                                            document.getElementById('removedLogo').value = 'true';
                                                        }

                                                        logoElements.input.value = '';
                                                        logoElements.preview.style.display = 'none';
                                                        logoElements.uploadArea.style.display = 'block';
                                                    }

                                                    // ========================================
                                                    // COMPANY IMAGES UPLOAD HANDLING
                                                    // ========================================
                                                    const imageElements = {
                                                        uploadArea: document.getElementById('imagesUploadArea'),
                                                        input: document.getElementById('companyImages'),
                                                        preview: document.getElementById('imagesPreview')
                                                    };

                                                    if (imageElements.uploadArea && imageElements.input) {
                                                        setupImageUpload();
                                                    }

                                                    function setupImageUpload() {
                                                        // Click to upload
                                                        imageElements.uploadArea.addEventListener('click', () => imageElements.input.click());

                                                        // Drag and drop handlers
                                                        ['dragover', 'dragleave', 'drop'].forEach(eventType => {
                                                            imageElements.uploadArea.addEventListener(eventType, handleImageDragEvent);
                                                        });

                                                        // File selection
                                                        imageElements.input.addEventListener('change', (e) => {
                                                            if (e.target.files.length > 0) {
                                                                addFilesToSelection(Array.from(e.target.files));
                                                            }
                                                        });
                                                    }



                                                    function handleImageDragEvent(e) {
                                                        e.preventDefault();

                                                        if (e.type === 'dragover') {
                                                            imageElements.uploadArea.classList.add('drag-over');
                                                        } else if (e.type === 'dragleave') {
                                                            imageElements.uploadArea.classList.remove('drag-over');
                                                        } else if (e.type === 'drop') {
                                                            imageElements.uploadArea.classList.remove('drag-over');
                                                            const files = e.dataTransfer.files;
                                                            if (files.length > 0) {
                                                                addFilesToSelection(Array.from(files));
                                                            }
                                                        }
                                                    }

                                                    function addFilesToSelection(newFiles) {
                                                        // Validate files first
                                                        const validFiles = validateImageFiles(newFiles);
                                                        if (validFiles.length === 0)
                                                            return;

                                                        // Add new files to existing list (avoid duplicates)
                                                        const actuallyNewFiles = [];
                                                        validFiles.forEach(file => {
                                                            if (!selectedCompanyImages.some(existingFile =>
                                                                existingFile.name === file.name && existingFile.size === file.size)) {
                                                                selectedCompanyImages.push(file);
                                                                actuallyNewFiles.push(file);
                                                            }
                                                        });

                                                        // Update preview and file input - only process the new files
                                                        if (actuallyNewFiles.length > 0) {
                                                            handleImagesPreview(actuallyNewFiles);
                                                        }
                                                        updateFileInput();
                                                    }

                                                    function validateImageFiles(files) {
                                                        // Chỉ trả về files để preview, validation sẽ được thực hiện ở server
                                                        return Array.from(files);
                                                    }

                                                    // ========================================
                                                    // HELPER FUNCTIONS
                                                    // ========================================

                                                    function handleLogoPreview(file) {
                                                        if (!file)
                                                            return;

                                                        // Validate file trước khi hiển thị preview
                                                        validateLogoFile(file);
                                                    }

                                                    function validateLogoFile(file) {
                                                        console.log('Validating logo file:', file.name);
                                                        console.log('Logo elements:', logoElements);

                                                        const formData = new FormData();
                                                        formData.append('fileType', 'logo');
                                                        formData.append('logoFile', file);

                                                        fetch('${pageContext.request.contextPath}/ImageValidationServlet', {
                                                            method: 'POST',
                                                            body: formData
                                                        })
                                                                .then(response => response.json())
                                                                .then(data => {
                                                                    console.log('Logo validation response:', data);
                                                                    if (data.valid) {
                                                                        // Hiển thị preview nếu validation thành công
                                                                        console.log('Logo validation successful, showing preview');
                                                                        console.log('Logo elements:', logoElements);

                                                                        const reader = new FileReader();
                                                                        reader.onload = (e) => {
                                                                            console.log('FileReader loaded, setting image src');
                                                                            console.log('Preview img element:', logoElements.previewImg);
                                                                            console.log('Preview div element:', logoElements.preview);

                                                                            logoElements.previewImg.src = e.target.result;
                                                                            logoElements.preview.style.display = 'block';
                                                                            logoElements.uploadArea.style.display = 'none';

                                                                            console.log('Logo preview should be visible now');
                                                                        };
                                                                        reader.readAsDataURL(file);
                                                                    } else {
                                                                        // Hiển thị lỗi và reset file input
                                                                        alert(data.error);
                                                                        logoElements.input.value = '';
                                                                    }
                                                                })
                                                                .catch(error => {
                                                                    console.error('Logo validation error:', error);
                                                                    alert('Lỗi kết nối, vui lòng thử lại');
                                                                    logoElements.input.value = '';
                                                                });
                                                    }

                                                    function handleImagesPreview(files) {
                                                        if (!imageElements.preview)
                                                            return;

                                                        // Validate files trước khi hiển thị preview
                                                        validateImagesFiles(files);
                                                    }

                                                    function validateImagesFiles(files) {
                                                        console.log('Validating images files:', files.length);

                                                        const formData = new FormData();
                                                        formData.append('fileType', 'images');

                                                        // Thêm tất cả files vào FormData
                                                        Array.from(files).forEach(file => {
                                                            formData.append('images', file);
                                                        });

                                                        fetch('${pageContext.request.contextPath}/ImageValidationServlet', {
                                                            method: 'POST',
                                                            body: formData
                                                        })
                                                                .then(response => response.json())
                                                                .then(data => {
                                                                    console.log('Images validation response:', data);
                                                                    if (data.valid) {
                                                                        // Hiển thị preview nếu validation thành công
                                                                        showImageUploadLoading();

                                                                        let processedCount = 0;
                                                                        files.forEach(file => {
                                                                            if (file?.type.startsWith('image/')) {
                                                                                createImagePreview(file, () => {
                                                                                    processedCount++;
                                                                                    if (processedCount === files.length) {
                                                                                        hideImageUploadLoading();
                                                                                    }
                                                                                });
                                                                            }
                                                                        });
                                                                    } else {
                                                                        // Hiển thị lỗi và reset file input
                                                                        alert(data.error);
                                                                        imageElements.input.value = '';
                                                                    }
                                                                })
                                                                .catch(error => {
                                                                    console.error('Images validation error:', error);
                                                                    alert('Lỗi kết nối, vui lòng thử lại');
                                                                    imageElements.input.value = '';
                                                                });
                                                    }

                                                    function showImageUploadLoading() {
                                                        const loadingDiv = document.createElement('div');
                                                        loadingDiv.id = 'imageUploadLoading';
                                                        loadingDiv.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý hình ảnh...';
                                                        loadingDiv.style.cssText = 'text-align: center; padding: 20px; color: #007bff; font-size: 14px;';
                                                        imageElements.preview.appendChild(loadingDiv);
                                                    }

                                                    function hideImageUploadLoading() {
                                                        const loadingDiv = document.getElementById('imageUploadLoading');
                                                        if (loadingDiv) {
                                                            loadingDiv.remove();
                                                        }
                                                    }

                                                    function createImagePreview(file, callback) {
                                                        const reader = new FileReader();
                                                        reader.onload = (e) => {
                                                            const previewDiv = document.createElement('div');
                                                            previewDiv.className = 'image-preview-item';
                                                            previewDiv.style.cssText = 'position: relative; display: inline-block; margin: 5px;';

                                                            const img = document.createElement('img');
                                                            img.src = e.target.result;
                                                            img.alt = 'Company Image';
                                                            img.style.cssText = 'max-width: 150px; max-height: 100px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); object-fit: cover;';

                                                            // Add file info tooltip
                                                            const fileInfo = document.createElement('div');
                                                            fileInfo.className = 'file-info';
                                                            fileInfo.style.cssText = 'position: absolute; bottom: -20px; left: 0; right: 0; font-size: 10px; color: #666; text-align: center;';
                                                            fileInfo.textContent = file.name + ' (' + (file.size / 1024).toFixed(1) + 'KB)';

                                                            const removeBtn = document.createElement('button');
                                                            removeBtn.type = 'button';
                                                            removeBtn.className = 'remove-image';
                                                            removeBtn.onclick = () => removeImagePreview(removeBtn);
                                                            removeBtn.style.cssText = 'position: absolute; top: -8px; right: -8px; background: #dc3545; color: white; border: none; border-radius: 50%; width: 24px; height: 24px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.2s;';
                                                            removeBtn.innerHTML = '<i class="fas fa-times"></i>';
                                                            removeBtn.onmouseover = () => removeBtn.style.transform = 'scale(1.1)';
                                                            removeBtn.onmouseout = () => removeBtn.style.transform = 'scale(1)';

                                                            previewDiv.appendChild(img);
                                                            previewDiv.appendChild(fileInfo);
                                                            previewDiv.appendChild(removeBtn);
                                                            imageElements.preview.appendChild(previewDiv);

                                                            // Update container display
                                                            imageElements.preview.style.cssText = 'display: flex; flex-wrap: wrap; gap: 15px; margin-top: 15px;';

                                                            // Call callback when done
                                                            if (callback)
                                                                callback();
                                                        };
                                                        reader.readAsDataURL(file);
                                                    }

                                                    function updateFileInput() {
                                                        const dataTransfer = new DataTransfer();
                                                        selectedCompanyImages.forEach(file => dataTransfer.items.add(file));
                                                        imageElements.input.files = dataTransfer.files;
                                                    }

                                                    // ========================================
                                                    // GLOBAL FUNCTIONS (called from HTML)
                                                    // ========================================

                                                    // Remove new image preview (not from database)
                                                    window.removeImagePreview = function (button) {
                                                        const previewDiv = button.parentElement;
                                                        const img = previewDiv.querySelector('img');
                                                        const fileInfo = previewDiv.querySelector('.file-info');

                                                        if (img?.src.startsWith('data:')) {
                                                            // Find and remove from selected files array
                                                            const fileName = fileInfo ? fileInfo.textContent.split(' (')[0] : '';
                                                            selectedCompanyImages = selectedCompanyImages.filter(file =>
                                                                file.name !== fileName
                                                            );
                                                            updateFileInput();
                                                        }

                                                        // Add fade out animation
                                                        previewDiv.style.transition = 'opacity 0.3s ease';
                                                        previewDiv.style.opacity = '0';
                                                        setTimeout(() => {
                                                            previewDiv.remove();
                                                        }, 300);
                                                    };

                                                    // Remove existing image from database
                                                    window.removeExistingImage = function (button, imagePath) {
                                                        const removedImagesField = document.getElementById('removedImages');
                                                        let currentRemoved = removedImagesField.value ? removedImagesField.value.trim() : '';
                                                        
                                                        // Debug log
                                                        console.log('Removing image:', imagePath);
                                                        console.log('Current removedImages value:', currentRemoved);
                                                        
                                                        // Normalize: remove empty values and trailing commas
                                                        if (currentRemoved) {
                                                            // Split, filter empty, and rejoin
                                                            const parts = currentRemoved.split(',').filter(p => p.trim() !== '');
                                                            currentRemoved = parts.join(',');
                                                        }
                                                        
                                                        // Add new image path
                                                        if (currentRemoved && currentRemoved.length > 0) {
                                                            removedImagesField.value = currentRemoved + ',' + imagePath;
                                                        } else {
                                                            removedImagesField.value = imagePath;
                                                        }
                                                        
                                                        console.log('Updated removedImages value:', removedImagesField.value);

                                                        // Add fade out animation
                                                        const previewDiv = button.parentElement;
                                                        previewDiv.style.transition = 'opacity 0.3s ease';
                                                        previewDiv.style.opacity = '0';
                                                        setTimeout(() => {
                                                            previewDiv.remove();
                                                        }, 300);
                                                    };

                                                                        // ========================================
                                                                        // TAX CODE VALIDATION
                                                                        // ========================================

                                                                        // Initialize tax code validation
                                                                        const taxCodeInput = document.getElementById('tax-code');
                                                                        if (taxCodeInput) {
                                                                            console.log('Tax code validation initialized');
                                                                            let taxCodeValidationTimeout;
                                                                            // Get original tax code value
                                                                            const originalTaxCode = taxCodeInput.value ? taxCodeInput.value.trim() : '';

                                                                            taxCodeInput.addEventListener('input', function () {
                                                                                const taxCode = this.value.trim();
                                                                                console.log('Tax code input changed:', taxCode);

                                                                                clearTimeout(taxCodeValidationTimeout);
                                                                                resetTaxCodeValidation();

                                                                                if (taxCode.length === 0) {
                                                                                    return; // Không bắt buộc
                                                                                }

                                                                                if (!isValidTaxCodeFormat(taxCode)) {
                                                                                    console.log('Tax code format invalid:', taxCode);
                                                                                    showTaxCodeValidation('error', 'Mã số thuế phải có đúng 10 số, không có khoảng cách và chữ cái');
                                                                                    return;
                                                                                }

                                                                                // If tax code hasn't changed, skip AJAX validation
                                                                                if (taxCode === originalTaxCode) {
                                                                                    console.log('Tax code unchanged, skipping validation');
                                                                                    showTaxCodeValidation('success', 'Mã số thuế hợp lệ');
                                                                                    return;
                                                                                }

                                                                                console.log('Tax code format valid, scheduling AJAX validation');
                                                                                taxCodeValidationTimeout = setTimeout(() => {
                                                                                    console.log('Executing AJAX validation for tax code:', taxCode);
                                                                                    validateTaxCodeExists(taxCode);
                                                                                }, 500);
                                                                            });

                                                                            taxCodeInput.addEventListener('blur', function () {
                                                                                const taxCode = this.value.trim();

                                                                                if (taxCode.length > 0 && isValidTaxCodeFormat(taxCode)) {
                                                                                    // If tax code hasn't changed, skip AJAX validation
                                                                                    if (taxCode === originalTaxCode) {
                                                                                        showTaxCodeValidation('success', 'Mã số thuế hợp lệ');
                                                                                        return;
                                                                                    }
                                                                                    validateTaxCodeExists(taxCode);
                                                                                }
                                                                            }

                                                                            );
                                                                        }

                                                                        // Initialize registration certificate upload
                                                                        const registrationCertInput = document.getElementById('registration-cert');
                                                                        const registrationCertUploadArea = document.getElementById('registrationCertUploadArea');
                                                                        const registrationCertPreview = document.getElementById('registrationCertPreview');

                                                                        if (registrationCertInput && registrationCertUploadArea) {
                                                                            setupRegistrationCertUpload();
                                                                        }

                                                                        function setupRegistrationCertUpload() {
                                                                            registrationCertUploadArea.addEventListener('click', () => registrationCertInput.click());

                                                                            ['dragover', 'dragleave', 'drop'].forEach(eventType => {
                                                                                registrationCertUploadArea.addEventListener(eventType, handleRegistrationCertDragEvent);
                                                                            });

                                                                            registrationCertInput.addEventListener('change', (e) => {
                                                                                if (e.target.files.length > 0) {
                                                                                    handleRegistrationCertPreview(e.target.files[0]);
                                                                                }
                                                                            });
                                                                        }

                                                                        function handleRegistrationCertDragEvent(e) {
                                                                            e.preventDefault();

                                                                            if (e.type === 'dragover') {
                                                                                registrationCertUploadArea.classList.add('drag-over');
                                                                            } else if (e.type === 'dragleave') {
                                                                                registrationCertUploadArea.classList.remove('drag-over');
                                                                            } else if (e.type === 'drop') {
                                                                                registrationCertUploadArea.classList.remove('drag-over');
                                                                                const files = e.dataTransfer.files;
                                                                                if (files.length > 0) {
                                                                                    handleRegistrationCertPreview(files[0]);
                                                                                }
                                                                            }
                                                                        }

                                                                        function handleRegistrationCertPreview(file) {
                                                                            if (!file)
                                                                                return;

                                                                            // Validate file trước khi hiển thị preview
                                                                            validateRegistrationCertFile(file);
                                                                        }

                                                                        function validateRegistrationCertFile(file) {
                                                                            console.log('Validating registration cert file:', file.name);
                                                                            console.log('Registration cert elements:', {registrationCertInput, registrationCertUploadArea, registrationCertPreview});

                                                                            const formData = new FormData();
                                                                            formData.append('fileType', 'registrationCert');
                                                                            formData.append('registrationCertFile', file);

                                                                            fetch('${pageContext.request.contextPath}/ImageValidationServlet', {
                                                                                method: 'POST',
                                                                                body: formData
                                                                            })
                                                                                    .then(response => response.json())
                                                                                    .then(data => {
                                                                                        console.log('Registration cert validation response:', data);
                                                                                        if (data.valid) {
                                                                                            // Hiển thị preview nếu validation thành công
                                                                                            const fileName = file.name;
                                                                                            const fileIcon = file.type === 'application/pdf' ? 'fas fa-file-pdf' : 'fas fa-file-image';

                                                                                            console.log('Setting preview for:', fileName);
                                                                                            console.log('Preview element:', registrationCertPreview);

                                                                                            // Hiển thị preview hình ảnh nếu là file hình ảnh
                                                                                            const imagePreview = document.getElementById('registrationCertImagePreview');
                                                                                            if (imagePreview && file.type.startsWith('image/')) {
                                                                                                const reader = new FileReader();
                                                                                                reader.onload = (e) => {
                                                                                                    imagePreview.src = e.target.result;
                                                                                                    imagePreview.style.display = 'block';
                                                                                                    console.log('Image preview loaded');
                                                                                                };
                                                                                                reader.readAsDataURL(file);
                                                                                            } else if (imagePreview) {
                                                                                                imagePreview.style.display = 'none';
                                                                                            }

                                                                                            registrationCertPreview.style.display = 'block';
                                                                                            registrationCertUploadArea.style.display = 'none';

                                                                                            console.log('Preview should be visible now');
                                                                                        } else {
                                                                                            // Hiển thị lỗi và reset file input
                                                                                            alert(data.error);
                                                                                            registrationCertInput.value = '';
                                                                                        }
                                                                                    })
                                                                                    .catch(error => {
                                                                                        console.error('Registration cert validation error:', error);
                                                                                        alert('Lỗi kết nối, vui lòng thử lại');
                                                                                        registrationCertInput.value = '';
                                                                                    });
                                                                        }

                                                                        window.removeRegistrationCert = function () {
                                                                            registrationCertInput.value = '';
                                                                            registrationCertPreview.style.display = 'none';
                                                                            registrationCertUploadArea.style.display = 'block';
                                                                        };

                                                                        // Test function for registration cert preview
                                                                        window.testRegistrationCertPreview = function () {
                                                                            console.log('Testing registration cert preview...');
                                                                            console.log('Preview element:', registrationCertPreview);
                                                                            console.log('Upload area element:', registrationCertUploadArea);

                                                                            if (registrationCertPreview) {
                                                                                const imagePreview = document.getElementById('registrationCertImagePreview');

                                                                                if (imagePreview) {
                                                                                    imagePreview.style.display = 'none'; // Hide image for PDF
                                                                                    console.log('Image preview hidden for PDF');
                                                                                }

                                                                                registrationCertPreview.style.display = 'block';
                                                                                registrationCertUploadArea.style.display = 'none';

                                                                                console.log('Test preview should be visible now');
                                                                            } else {
                                                                                console.error('Preview element not found!');
                                                                            }
                                                                        };

                                                                        // Test function for image preview
                                                                        window.testImagePreview = function () {
                                                                            console.log('Testing image preview...');

                                                                            if (registrationCertPreview) {
                                                                                const imagePreview = document.getElementById('registrationCertImagePreview');

                                                                                if (imagePreview) {
                                                                                    // Create a test image
                                                                                    imagePreview.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE1MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxNCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPkltYWdlIFByZXZpZXc8L3RleHQ+PC9zdmc+';
                                                                                    imagePreview.style.display = 'block';
                                                                                    console.log('Test image preview loaded');
                                                                                }

                                                                                registrationCertPreview.style.display = 'block';
                                                                                registrationCertUploadArea.style.display = 'none';

                                                                                console.log('Test image preview should be visible now');
                                                                            } else {
                                                                                console.error('Preview element not found!');
                                                                            }
                                                                        };

                                                                        function isValidTaxCodeFormat(taxCode) {
                                                                            // Kiểm tra định dạng: 10 số, không có khoảng cách và chữ cái
                                                                            const taxCodeRegex = /^[0-9]{10}$/;
                                                                            return taxCodeRegex.test(taxCode);
                                                                        }

                                                                        function validateTaxCodeExists(taxCode) {
                                                                            console.log('Starting tax code validation for:', taxCode);
                                                                            showTaxCodeValidation('loading', 'Đang kiểm tra...');

                                                                            const url = '${pageContext.request.contextPath}/RegistrationValidationServlet?check=taxCode&value=' + encodeURIComponent(taxCode);

                                                                            console.log('Tax code AJAX URL:', url);
                                                                            console.log('Tax code context path:', '${pageContext.request.contextPath}');

                                                                            fetch(url, {
                                                                                method: 'GET',
                                                                                headers: {
                                                                                    'Content-Type': 'application/json',
                                                                                }
                                                                            })
                                                                                    .then(response => {
                                                                                        if (!response.ok) {
                                                                                            throw new Error('Network response was not ok: ' + response.status);
                                                                                        }
                                                                                        return response.json();
                                                                                    })
                                                                                    .then(data => {
                                                                                        if (!data) {
                                                                                            showTaxCodeValidation('error', 'Kết quả không hợp lệ');
                                                                                            return;
                                                                                        }
                                                                                        if (data.valid === false) {
                                                                                            showTaxCodeValidation('error', 'Mã số thuế không đúng định dạng');
                                                                                            return;
                                                                                        }
                                                                                        if (data.valid === true && data.exists === true) {
                                                                                            showTaxCodeValidation('error', 'Mã số thuế này đã được sử dụng');
                                                                                            return;
                                                                                        }
                                                                                        if (data.valid === true && data.exists === false) {
                                                                                            showTaxCodeValidation('success', 'Mã số thuế hợp lệ');
                                                                                            return;
                                                                                        }
                                                                                        if (data.error) {
                                                                                            showTaxCodeValidation('error', 'Lỗi: ' + data.error);
                                                                                        } else {
                                                                                            showTaxCodeValidation('error', 'Kết quả không hợp lệ');
                                                                                        }
                                                                                    })
                                                                                    .catch(error => {
                                                                                        console.error('Validation error:', error);
                                                                                        showTaxCodeValidation('error', 'Lỗi kết nối, vui lòng thử lại');
                                                                                    });
                                                                        }

                                                                        function showTaxCodeValidation(type, message) {
                                                                            console.log('showTaxCodeValidation called:', type, message);
                                                                            const validationDiv = document.getElementById('taxCodeValidation');
                                                                            const taxCodeInput = document.getElementById('tax-code');

                                                                            console.log('Tax code validation div found:', !!validationDiv);
                                                                            console.log('Tax code input found:', !!taxCodeInput);

                                                                            if (!validationDiv || !taxCodeInput) {
                                                                                console.error('Tax code validation elements not found:', {validationDiv, taxCodeInput});
                                                                                return;
                                                                            }

                                                                            const icons = validationDiv.querySelectorAll('.validation-loading, .validation-success, .validation-error');
                                                                            console.log('Tax code found icons:', icons.length);
                                                                            icons.forEach(icon => {
                                                                                icon.style.display = 'none';
                                                                            });

                                                                            const messageSpan = validationDiv.querySelector('.validation-message');
                                                                            console.log('Tax code message span found:', !!messageSpan);
                                                                            if (messageSpan) {
                                                                                messageSpan.textContent = message;
                                                                                console.log('Tax code message set to:', message);
                                                                            }

                                                                            taxCodeInput.classList.remove('error', 'success');

                                                                            if (type === 'loading') {
                                                                                const loadingIcon = validationDiv.querySelector('.validation-loading');
                                                                                console.log('Tax code loading icon found:', !!loadingIcon);
                                                                                if (loadingIcon) {
                                                                                    loadingIcon.style.display = 'inline';
                                                                                    validationDiv.className = 'validation-feedback loading';
                                                                                }
                                                                            } else if (type === 'success') {
                                                                                const successIcon = validationDiv.querySelector('.validation-success');
                                                                                console.log('Tax code success icon found:', !!successIcon);
                                                                                if (successIcon) {
                                                                                    successIcon.style.display = 'inline';
                                                                                    validationDiv.className = 'validation-feedback success';
                                                                                    taxCodeInput.classList.add('success');
                                                                                }
                                                                            } else if (type === 'error') {
                                                                                const errorIcon = validationDiv.querySelector('.validation-error');
                                                                                console.log('Tax code error icon found:', !!errorIcon);
                                                                                if (errorIcon) {
                                                                                    errorIcon.style.display = 'inline';
                                                                                    validationDiv.className = 'validation-feedback error';
                                                                                    taxCodeInput.classList.add('error');
                                                                                }
                                                                            }
                                                                        }

                                                                        function resetTaxCodeValidation() {
                                                                            const validationDiv = document.getElementById('taxCodeValidation');
                                                                            const taxCodeInput = document.getElementById('tax-code');

                                                                            if (!validationDiv || !taxCodeInput)
                                                                                return;

                                                                            const icons = validationDiv.querySelectorAll('.validation-loading, .validation-success, .validation-error');
                                                                            icons.forEach(icon => {
                                                                                icon.style.display = 'none';
                                                                            });

                                                                            const messageSpan = validationDiv.querySelector('.validation-message');
                                                                            if (messageSpan) {
                                                                                messageSpan.textContent = '';
                                                                            }

                                                                            validationDiv.className = 'validation-feedback';
                                                                            taxCodeInput.classList.remove('error', 'success');
                                                                        }

                                                                        // ========================================
                                                                        // PHONE VALIDATION
                                                                        // ========================================

                                                                        // Initialize phone validation
                                                                        const phoneInput = document.getElementById('phone');
                                                                        if (phoneInput) {
                                                                            console.log('Phone validation initialized');
                                                                            let validationTimeout;
                                                                            // Get original phone value
                                                                            const originalPhone = phoneInput.value ? phoneInput.value.trim() : '';

                                                                            phoneInput.addEventListener('input', function () {
                                                                                const phone = this.value.trim();
                                                                                console.log('Phone input changed:', phone);

                                                                                clearTimeout(validationTimeout);
                                                                                resetPhoneValidation();

                                                                                if (phone.length === 0) {
                                                                                    return;
                                                                                }

                                                                                if (!isValidPhoneFormat(phone)) {
                                                                                    console.log('Phone format invalid:', phone);
                                                                                    showPhoneValidation('error', 'Số điện thoại không đúng định dạng');
                                                                                    return;
                                                                                }

                                                                                // If phone hasn't changed, skip AJAX validation
                                                                                if (phone === originalPhone) {
                                                                                    console.log('Phone unchanged, skipping validation');
                                                                                    showPhoneValidation('success', 'Số điện thoại có thể sử dụng');
                                                                                    return;
                                                                                }

                                                                                console.log('Phone format valid, scheduling AJAX validation');
                                                                                validationTimeout = setTimeout(() => {
                                                                                    console.log('Executing AJAX validation for:', phone);
                                                                                    validatePhoneExists(phone);
                                                                                }, 500);
                                                                            });

                                                                            phoneInput.addEventListener('blur', function () {
                                                                                const phone = this.value.trim();
                                                                                if (phone.length > 0 && isValidPhoneFormat(phone)) {
                                                                                    // If phone hasn't changed, skip AJAX validation
                                                                                    if (phone === originalPhone) {
                                                                                        showPhoneValidation('success', 'Số điện thoại có thể sử dụng');
                                                                                        return;
                                                                                    }
                                                                                    validatePhoneExists(phone);
                                                                                }
                                                                            });
                                                                        }

                                                                        function isValidPhoneFormat(phone) {
                                                                            // Kiểm tra định dạng: 10 số, bắt đầu bằng 03, 08, 09, không có khoảng cách
                                                                            const phoneRegex = /^(03|08|09)[0-9]{8}$/;
                                                                            return phoneRegex.test(phone);
                                                                        }

                                                                        function validatePhoneExists(phone) {
                                                                            console.log('Starting phone validation for:', phone);
                                                                            showPhoneValidation('loading', 'Đang kiểm tra...');

                                                                            const url = '${pageContext.request.contextPath}/RegistrationValidationServlet?check=phone&value=' + encodeURIComponent(phone);
                                                                            console.log('AJAX URL:', url);
                                                                            console.log('Context path:', '${pageContext.request.contextPath}');

                                                                            fetch(url, {
                                                                                method: 'GET',
                                                                                headers: {
                                                                                    'Content-Type': 'application/json',
                                                                                }
                                                                            })
                                                                                    .then(response => {
                                                                                        console.log('Response status:', response.status);
                                                                                        if (!response.ok) {
                                                                                            throw new Error('Network response was not ok: ' + response.status);
                                                                                        }
                                                                                        return response.json();
                                                                                    })
                                                                                    .then(data => {
                                                                                        console.log('Response data:', data);
                                                                                        console.log('Data type:', typeof data);
                                                                                        console.log('Data keys:', Object.keys(data));

                                                                                        if (data.error) {
                                                                                            console.log('Error case:', data.error);
                                                                                            showPhoneValidation('error', data.error);
                                                                                        } else if (data.valid === false) {
                                                                                            console.log('Invalid format case:', data.error);
                                                                                            showPhoneValidation('error', data.error || 'Số điện thoại không đúng định dạng');
                                                                                        } else if (data.exists) {
                                                                                            console.log('Exists case:', data.exists);
                                                                                            showPhoneValidation('error', 'Số điện thoại đã được sử dụng');
                                                                                        } else {
                                                                                            console.log('Success case:', data);
                                                                                            showPhoneValidation('success', 'Số điện thoại có thể sử dụng');
                                                                                        }
                                                                                    })
                                                                                    .catch(error => {
                                                                                        console.error('Phone validation error:', error);
                                                                                        showPhoneValidation('error', 'Lỗi kết nối, vui lòng thử lại');
                                                                                    });
                                                                        }

                                                                        function showPhoneValidation(type, message) {
                                                                            console.log('showPhoneValidation called:', type, message);
                                                                            const validationDiv = document.getElementById('phoneValidation');
                                                                            const phoneInput = document.getElementById('phone');

                                                                            console.log('Validation div found:', !!validationDiv);
                                                                            console.log('Phone input found:', !!phoneInput);

                                                                            if (!validationDiv || !phoneInput) {
                                                                                console.error('Validation elements not found:', {validationDiv, phoneInput});
                                                                                return;
                                                                            }

                                                                            const icons = validationDiv.querySelectorAll('.validation-loading, .validation-success, .validation-error');
                                                                            console.log('Found icons:', icons.length);
                                                                            icons.forEach(icon => {
                                                                                icon.style.display = 'none';
                                                                            });

                                                                            const messageSpan = validationDiv.querySelector('.validation-message');
                                                                            console.log('Message span found:', !!messageSpan);
                                                                            if (messageSpan) {
                                                                                messageSpan.textContent = message;
                                                                                console.log('Message set to:', message);
                                                                            }

                                                                            phoneInput.classList.remove('error', 'success');

                                                                            if (type === 'loading') {
                                                                                const loadingIcon = validationDiv.querySelector('.validation-loading');
                                                                                console.log('Loading icon found:', !!loadingIcon);
                                                                                if (loadingIcon) {
                                                                                    loadingIcon.style.display = 'inline';
                                                                                    validationDiv.className = 'validation-feedback loading';
                                                                                }
                                                                            } else if (type === 'success') {
                                                                                const successIcon = validationDiv.querySelector('.validation-success');
                                                                                console.log('Success icon found:', !!successIcon);
                                                                                if (successIcon) {
                                                                                    successIcon.style.display = 'inline';
                                                                                    validationDiv.className = 'validation-feedback success';
                                                                                    phoneInput.classList.add('success');
                                                                                }
                                                                            } else if (type === 'error') {
                                                                                const errorIcon = validationDiv.querySelector('.validation-error');
                                                                                console.log('Error icon found:', !!errorIcon);
                                                                                if (errorIcon) {
                                                                                    errorIcon.style.display = 'inline';
                                                                                    validationDiv.className = 'validation-feedback error';
                                                                                    phoneInput.classList.add('error');
                                                                                }
                                                                            }
                                                                        }

                                                                        function resetPhoneValidation() {
                                                                            const validationDiv = document.getElementById('phoneValidation');
                                                                            const phoneInput = document.getElementById('phone');

                                                                            if (!validationDiv || !phoneInput)
                                                                                return;

                                                                            validationDiv.querySelectorAll('.validation-loading, .validation-success, .validation-error').forEach(icon => {
                                                                                icon.style.display = 'none';
                                                                            });

                                                                            const messageSpan = validationDiv.querySelector('.validation-message');
                                                                            if (messageSpan) {
                                                                                messageSpan.textContent = '';
                                                                            }

                                                                            validationDiv.className = 'validation-feedback';
                                                                            phoneInput.classList.remove('error', 'success');
                                                                        }

                                                                        // Test function
                                                                        window.testPhoneValidation = function () {
                                                                            console.log('Test button clicked');
                                                                            const phoneInput = document.getElementById('phone');
                                                                            if (phoneInput) {
                                                                                phoneInput.value = '0123456789';
                                                                                phoneInput.dispatchEvent(new Event('input'));
                                                                            }
                                                                        };

                                                                    });
        </script>

        <style>
            /* Alert Messages */
            .alert {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
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

            /* Upload Areas */
            .upload-area {
                border: 2px dashed #ddd;
                border-radius: 8px;
                padding: 40px 20px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
            }
            .upload-area:hover,
            .upload-area.drag-over {
                border-color: #007bff;
                background-color: #f8f9fa;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,123,255,0.15);
            }
            .upload-area span {
                color: #007bff;
                font-weight: bold;
            }
            .upload-area i {
                font-size: 2rem;
                color: #007bff;
                margin-bottom: 10px;
            }

            /* Image Previews */
            .image-preview {
                margin-top: 15px;
                position: relative;
                display: inline-block;
            }
            .image-preview img {
                max-width: 200px;
                max-height: 150px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .images-preview {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-top: 15px;
                min-height: 50px;
            }

            /* Upload limit warning */
            .upload-limit {
                color: #ff6b35;
                font-size: 14px;
                margin: 5px 0 15px 0;
                font-weight: 500;
                background: #fff3cd;
                padding: 8px 12px;
                border-radius: 4px;
                border-left: 4px solid #ff6b35;
            }

            .image-preview-item {
                position: relative;
                display: inline-block;
                transition: all 0.3s ease;
            }
            .image-preview-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }
            .image-preview-item img {
                max-width: 150px;
                max-height: 100px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
            }
            .file-info {
                position: absolute;
                bottom: -20px;
                left: 0;
                right: 0;
                font-size: 10px;
                color: #666;
                text-align: center;
                background: rgba(255,255,255,0.9);
                padding: 2px 4px;
                border-radius: 4px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            /* Remove Buttons */
            .remove-image {
                position: absolute;
                top: -8px;
                right: -8px;
                background: #dc3545;
                color: white;
                border: none;
                border-radius: 50%;
                width: 24px;
                height: 24px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s ease;
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            }
            .remove-image:hover {
                background: #c82333;
                transform: scale(1.1);
                box-shadow: 0 4px 8px rgba(0,0,0,0.3);
            }

            /* Character Counter */
            .char-counter {
                text-align: right;
                margin-top: 5px;
                font-size: 12px;
                color: #666;
            }

            /* Phone Validation Styles */
            .input-with-validation {
                position: relative;
            }

            .validation-feedback {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-top: 5px;
                font-size: 12px;
                transition: all 0.3s ease;
            }

            .validation-feedback.loading {
                color: #007bff;
            }

            .validation-feedback.success {
                color: #28a745;
            }

            .validation-feedback.error {
                color: #dc3545;
            }

            .validation-feedback i {
                font-size: 14px;
            }

            .validation-message {
                font-weight: 500;
            }

            /* Input styling when validation is active */
            .input-with-validation input:focus {
                border-color: #007bff;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }

            .input-with-validation input.error {
                border-color: #dc3545;
                box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
            }

            .input-with-validation input.success {
                border-color: #28a745;
                box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
            }

            /* File Upload Styles */
            .file-upload {
                margin-top: 5px;
            }

            .upload-area {
                border: 2px dashed #ddd;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                background: #fafafa;
            }

            .upload-area:hover {
                border-color: #007bff;
                background: #f0f8ff;
            }

            .upload-area.drag-over {
                border-color: #007bff;
                background: #e3f2fd;
            }

            .upload-area i {
                font-size: 24px;
                color: #007bff;
                margin-bottom: 10px;
            }

            .upload-area p {
                margin: 0;
                color: #666;
            }

            .upload-area span {
                color: #007bff;
                font-weight: 500;
            }

            .file-preview {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 10px;
                background: #f9f9f9;
            }

            .file-info {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .file-info i {
                font-size: 20px;
                color: #dc3545;
            }

            .file-name {
                flex: 1;
                font-weight: 500;
            }

            .remove-file {
                background: #dc3545;
                color: white;
                border: none;
                border-radius: 50%;
                width: 24px;
                height: 24px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s ease;
            }

            .remove-file:hover {
                background: #c82333;
                transform: scale(1.1);
            }

            .upload-hint {
                color: #666;
                font-size: 12px;
                margin-top: 5px;
                display: block;
            }
        </style>

