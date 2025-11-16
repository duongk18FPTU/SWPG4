<%-- 
    Document   : shop-cart
    Created on : Oct 23, 2025, 11:52:44 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giỏ hàng & Thanh toán - VietnamWorks</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f7fa;
                color: #333;
                line-height: 1.6;
            }

            /* Navigation Bar */
            :root {
                --bg-dark-1: #031428;   /* Very dark left */
                --bg-dark-2: #062446;   /* Mid */
                --bg-bright: #0a67ff;   /* Bright right */
            }

            .navbar {
                background: linear-gradient(110deg, var(--bg-dark-1) 0%, var(--bg-dark-2) 40%, #083d9a 70%, var(--bg-bright) 100%);
                color: white;
                padding: 0;
                box-shadow: 0 4px 20px rgba(0,0,0,0.15);
                position: sticky;
                top: 0;
                z-index: 1000;
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }

            .nav-container {
                max-width: 1400px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 25px;
                height: 70px;
            }

            .nav-left {
                display: flex;
                align-items: center;
                gap: 15px;
                flex: 1;
            }

            .logo {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 24px;
                font-weight: 700;
                text-shadow: 0 2px 4px rgba(0,0,0,0.3);
                transition: transform 0.3s ease;
            }

            .logo:hover {
                transform: scale(1.05);
            }

            .logo i {
                font-size: 24px;
                background: linear-gradient(45deg, #0a67ff, #ffffff);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
            }

            .nav-menu {
                display: flex;
                list-style: none;
                gap: 12px;
                align-items: center;
                flex-wrap: nowrap;
            }

            .nav-menu a {
                color: white;
                text-decoration: none;
                padding: 8px 12px;
                border-radius: 4px;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
                font-weight: 500;
                position: relative;
                overflow: hidden;
                white-space: nowrap;
                font-size: 13px;
            }

            .nav-menu a::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .nav-menu a:hover::before {
                left: 100%;
            }

            .nav-menu a:hover,
            .nav-menu a.active {
                background: rgba(255,255,255,0.15);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            }

            /* Dropdown */
            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-content {
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                width: 280px !important;
                box-shadow: 0 10px 30px rgba(0,0,0,0.15);
                border-radius: 12px;
                padding: 12px 0;
                margin-top: 8px;
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                z-index: 1001;
                border: 1px solid #e5e7eb;
                backdrop-filter: blur(10px);
                animation: dropdownFadeIn 0.3s ease;
            }

            @keyframes dropdownFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .dropdown:hover .dropdown-content {
                display: block;
            }

            .dropdown-content a {
                color: #374151;
                padding: 14px 20px;
                text-decoration: none;
                display: block;
                border-radius: 0;
                background: none;
                font-weight: 500;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                font-size: 14px;
                white-space: nowrap;
                border: none;
                margin: 0 8px;
                border-radius: 8px;
            }

            .dropdown-content a:hover {
                background: #f8fafc;
                color: #0a67ff;
                transform: translateX(4px);
                box-shadow: 0 2px 8px rgba(10, 103, 255, 0.1);
            }

            .dropdown-content a.highlighted {
                background: #fef3c7;
                color: #92400e;
                font-weight: 600;
                border: 1px solid #fde68a;
            }

            /* Navigation Right */
            .nav-right {
                display: flex;
                align-items: center;
                gap: 12px;
                flex-shrink: 0;
            }

            .nav-buttons {
                display: flex;
                gap: 8px;
                align-items: center;
            }

            .btn {
                padding: 8px 14px;
                border: none;
                border-radius: 4px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
                position: relative;
                overflow: hidden;
                text-transform: uppercase;
                letter-spacing: 0.2px;
                font-size: 11px;
                white-space: nowrap;
            }

            .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn:hover::before {
                left: 100%;
            }

            .btn-orange {
                background: linear-gradient(135deg, #ff6b35, #f7931e);
                color: white;
                box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
            }

            .btn-orange:hover {
                background: linear-gradient(135deg, #e55a2b, #e8821a);
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(255, 107, 53, 0.4);
            }

            .btn-blue {
                background: linear-gradient(135deg, #4a90e2, #357abd);
                color: white;
                box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
            }

            .btn-blue:hover {
                background: linear-gradient(135deg, #357abd, #2c5aa0);
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(74, 144, 226, 0.4);
            }

            .btn-white {
                background: white;
                color: #333;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .btn-white:hover {
                background: #f8f9fa;
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
            }

            .nav-icons {
                display: flex;
                gap: 12px;
                cursor: pointer;
                align-items: center;
            }

            .nav-icons > i {
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                transition: all 0.3s ease;
                color: white;
                font-size: 16px;
            }

            .nav-icons > i:hover {
                background: rgba(255, 255, 255, 0.2);
                transform: scale(1.1);
            }

            .user-dropdown {
                position: relative;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                overflow: hidden;
                cursor: pointer;
                transition: all 0.3s ease;
                border: 2px solid rgba(255, 255, 255, 0.2);
            }

            .user-avatar:hover {
                border-color: rgba(255, 255, 255, 0.5);
                transform: scale(1.05);
            }

            .avatar-img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .user-menu {
                width: 320px !important;
                right: 0;
                left: auto;
            }

            .user-header {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 16px 20px;
                border-bottom: 1px solid #e5e7eb;
                background: #f8fafc;
            }

            .user-header i:first-child {
                font-size: 20px;
                color: #6b7280;
            }

            .user-info {
                flex: 1;
            }

            .user-name {
                font-weight: 600;
                color: #374151;
                font-size: 14px;
            }

            .close-menu {
                color: #9ca3af;
                cursor: pointer;
                font-size: 16px;
            }

            .menu-section {
                padding: 8px 0;
            }

            .section-title {
                padding: 8px 20px 4px;
                font-size: 11px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .menu-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 20px;
                color: #374151;
                text-decoration: none;
                transition: all 0.3s ease;
                font-size: 14px;
                font-weight: 500;
            }

            .menu-item:hover {
                background: #f8fafc;
                color: #0a67ff;
                transform: translateX(4px);
            }

            .menu-item i {
                width: 16px;
                text-align: center;
                color: #6b7280;
                font-size: 14px;
            }

            .menu-item.highlighted {
                background: #fef3c7;
                color: #92400e;
                font-weight: 600;
            }

            .menu-footer {
                border-top: 1px solid #e5e7eb;
                padding: 8px 0;
            }

            .logout-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 20px;
                color: #dc2626;
                text-decoration: none;
                transition: all 0.3s ease;
                font-size: 14px;
                font-weight: 500;
            }

            .logout-item:hover {
                background: #fef2f2;
                color: #b91c1c;
            }

            /* Main Content */
            .main-container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 30px 25px;
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 40px;
            }

            .cart-section {
                background: white;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            }

            .cart-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
            }

            .cart-title {
                font-size: 28px;
                font-weight: 700;
                color: #2c3e50;
            }

            .cart-actions {
                display: flex;
                gap: 20px;
            }

            .action-link {
                color: #0a67ff;
                text-decoration: none;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 8px 12px;
                border-radius: 6px;
                transition: background-color 0.3s ease;
            }

            .action-link:hover {
                background-color: #f0f7ff;
            }

            .cart-table {
                width: 100%;
                border-collapse: collapse;
            }

            .cart-table th {
                text-align: left;
                padding: 15px 0;
                border-bottom: 2px solid #e9ecef;
                font-weight: 600;
                color: #495057;
                font-size: 14px;
            }

            .cart-table td {
                padding: 20px 0;
                border-bottom: 1px dashed #dee2e6;
            }

            .product-info {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .product-name {
                font-size: 16px;
                font-weight: 600;
                color: #2c3e50;
            }

            .product-description {
                color: #0a67ff;
                text-decoration: none;
                font-size: 14px;
            }

            .product-description:hover {
                text-decoration: underline;
            }

            .product-price {
                font-size: 18px;
                font-weight: 600;
                color: #2c3e50;
            }

            .quantity-controls {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .quantity-btn {
                width: 32px;
                height: 32px;
                border: 1px solid #dee2e6;
                background: white;
                border-radius: 6px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-size: 16px;
                color: #6c757d;
                transition: all 0.3s ease;
            }

            .quantity-btn:hover {
                border-color: #0a67ff;
                color: #0a67ff;
            }

            .quantity-input {
                width: 60px;
                height: 32px;
                border: 1px solid #dee2e6;
                border-radius: 6px;
                text-align: center;
                font-size: 14px;
                font-weight: 600;
            }

            .remove-btn {
                color: #dc3545;
                cursor: pointer;
                font-size: 18px;
                padding: 8px;
                border-radius: 6px;
                transition: background-color 0.3s ease;
            }

            .remove-btn:hover {
                background-color: #f8d7da;
            }

            /* Summary Section */
            .summary-section {
                background: white;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                height: fit-content;
            }

            .discount-section {
                margin-bottom: 25px;
            }

            .discount-input {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }

            .discount-input input {
                flex: 1;
                padding: 12px 15px;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                font-size: 14px;
            }

            .update-btn {
                background-color: #ff6b35;
                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .update-btn:hover {
                background-color: #e55a2b;
            }

            .order-totals {
                margin-bottom: 25px;
            }

            .total-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                font-size: 16px;
            }

            .total-row.final {
                font-size: 18px;
                font-weight: 700;
                color: #dc3545;
                padding-top: 15px;
                border-top: 1px solid #dee2e6;
            }

            .payment-method {
                margin-bottom: 25px;
            }

            .payment-title {
                font-size: 18px;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 15px;
            }

            .payment-options {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }

            .payment-option {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .payment-option:hover {
                border-color: #0a67ff;
                background-color: #f0f7ff;
            }

            .payment-option.selected {
                border-color: #0a67ff;
                background-color: #f0f7ff;
            }

            .payment-option input[type="radio"] {
                width: 18px;
                height: 18px;
                accent-color: #0a67ff;
            }

            .payment-option label {
                font-weight: 600;
                cursor: pointer;
                flex: 1;
            }

            .card-logos {
                display: flex;
                gap: 10px;
                margin-top: 10px;
            }

            .card-logo {
                width: 40px;
                height: 25px;
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                font-weight: 600;
            }

            .pay-btn {
                width: 100%;
                background: linear-gradient(135deg, #ff6b35, #e55a2b);
                color: white;
                border: none;
                padding: 15px 20px;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 700;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                margin-bottom: 20px;
                transition: all 0.3s ease;
            }

            .pay-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(255, 107, 53, 0.3);
            }

            .security-info {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 15px;
                font-size: 14px;
                color: #6c757d;
            }

            .security-logos {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
            }

            .security-logo {
                height: 30px;
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                padding: 5px 10px;
                display: flex;
                align-items: center;
                font-size: 12px;
                font-weight: 600;
            }

            .terms {
                font-size: 12px;
                color: #6c757d;
                margin-bottom: 15px;
                line-height: 1.5;
            }

            .terms a {
                color: #0a67ff;
                text-decoration: none;
            }

            .terms a:hover {
                text-decoration: underline;
            }

            .contact-info {
                font-size: 12px;
                color: #6c757d;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .contact-info a {
                color: #0a67ff;
                text-decoration: none;
            }

            .contact-info a:hover {
                text-decoration: underline;
            }

            /* Footer */
            .footer {
                background: linear-gradient(110deg, #031428 0%, #062446 40%, #083d9a 70%, #0a67ff 100%);
                height: 60px;
                margin-top: 50px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-container {
                    grid-template-columns: 1fr;
                    gap: 20px;
                    padding: 20px 15px;
                }

                .nav-menu {
                    display: none;
                }

                .cart-table {
                    font-size: 14px;
                }

                .cart-table th,
                .cart-table td {
                    padding: 10px 5px;
                }
            }
        </style>
    </head>
    <body>
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
                        <li><a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp">Công ty</a></li>
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
                        <i class="fas fa-star"></i>
                        <i class="fas fa-bell"></i>
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
        <div class="main-container">
            <!-- Cart Section -->
            <div class="cart-section">
                <div class="cart-header">
                    <h2 class="cart-title">Xem giỏ hàng & Thanh toán</h2>
                    <div class="cart-actions">
                        <a href="#" class="action-link" onclick="testSessionStorage()">
                            <i class="fas fa-bug"></i>
                            Test SessionStorage
                        </a>
                        <a href="#" class="action-link">
                            <i class="fas fa-dollar-sign"></i>
                            Hiển thị giá USD tham khảo
                        </a>
                        <a href="#" class="action-link">
                            <i class="fas fa-trash"></i>
                            Xóa toàn bộ
                        </a>
                    </div>
                                </div>

                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Thành tiền</th>
                            <th>Số lượng</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="cartItems">
                    <!-- Cart items will be populated by JavaScript -->
                    </tbody>
                </table>
                                </div>

            <!-- Summary Section -->
            <div class="summary-section">
                <div class="discount-section">
                    <div class="discount-input">
                        <input type="text" placeholder="Nhập mã giảm giá">
                        <button class="update-btn">Cập nhật</button>
                                </div>
                                </div>

                <div class="order-totals">
                    <div class="total-row">
                        <span>Tổng cộng (chưa gồm VAT)</span>
                        <span id="subtotal">0 VND</span>
                    </div>
                    <div class="total-row final">
                        <span>Tổng cộng (đã gồm VAT)</span>
                        <span id="total">0 VND</span>
                            </div>
                        </div>

                <div class="payment-method">
                    <h3 class="payment-title">Phương pháp thanh toán</h3>
                    <div class="payment-options">
                        <div class="payment-option selected" onclick="selectPayment(1)">
                            <input type="radio" name="payment" value="credit" id="credit" checked>
                            <label for="credit">Thẻ tín dụng</label>
                            <div class="card-logos">
                                <div class="card-logo" style="background: linear-gradient(45deg, #eb001b, #f79e1b); color: white;">MC</div>
                                <div class="card-logo" style="background: #1a1f71; color: white;">VISA</div>
                                <div class="card-logo" style="background: #006fcf; color: white;">AE</div>
                    </div>
                        </div>
                        <div class="payment-option" onclick="selectPayment(2)">
                            <input type="radio" name="payment" value="atm" id="atm">
                            <label for="atm">Thẻ ATM</label>
                        </div>
                        <div class="payment-option" onclick="selectPayment(3)">
                            <input type="radio" name="payment" value="transfer" id="transfer">
                            <label for="transfer">Chuyển khoản</label>
                        </div>
                    </div>
                </div>

                <button class="pay-btn" onclick="processPayment()">
                    <i class="fas fa-lock"></i>
                    Thanh toán bằng thẻ tín dụng
                        </button>

                <div class="security-info">
                    <i class="fas fa-lock"></i>
                    <span>Giao dịch được bảo mật với 256-bit SSL</span>
                </div>

                <div class="security-logos">
                    <div class="security-logo">Norton Secured</div>
                    <div class="security-logo">OnePAY</div>
                                </div>

                <div class="terms">
                    Khi gửi đơn hàng Quý khách được xem rằng đã đồng ý với 
                    <a href="#">Chính sách bảo mật</a> và 
                    <a href="#">Điều khoản dịch vụ</a>
                                </div>

                <div class="contact-info">
                    <span>Liên hệ với chúng tôi: (84 28) 3925 8456 hoặc Email:</span>
                    <a href="mailto:support@vietnamworks.com">support@vietnamworks.com</a>
                    <i class="fas fa-ellipsis-h"></i>
                </div>
                </div>
            </div>

        <!-- Footer -->
        <footer class="footer"></footer>

        <script>
            // Cart data from sessionStorage
            let cart = [];
            let subtotal = 0;
            let vat = 0;
            let total = 0;

            // Initialize page
            document.addEventListener('DOMContentLoaded', function() {
                console.log('=== DEBUG: shop-cart page loaded ===');
                
                // Get cart data from sessionStorage
                const cartData = sessionStorage.getItem('cartData');
                const cartSubtotal = sessionStorage.getItem('cartSubtotal');
                const cartVAT = sessionStorage.getItem('cartVAT');
                const cartTotal = sessionStorage.getItem('cartTotal');
                
                console.log('Cart data from sessionStorage:', cartData);
                console.log('Subtotal:', cartSubtotal);
                console.log('VAT:', cartVAT);
                console.log('Total:', cartTotal);
                
                // Debug: Check all sessionStorage keys
                console.log('All sessionStorage keys:', Object.keys(sessionStorage));
                for (let i = 0; i < sessionStorage.length; i++) {
                    const key = sessionStorage.key(i);
                    console.log('SessionStorage key:', key, 'value:', sessionStorage.getItem(key));
                }
                
                if (cartData) {
                    try {
                        cart = JSON.parse(cartData);
                        subtotal = parseFloat(cartSubtotal) || 0;
                        vat = parseFloat(cartVAT) || 0;
                        total = parseFloat(cartTotal) || 0;
                        
                        console.log('Parsed cart:', cart);
                        console.log('Cart length:', cart.length);
                        console.log('Calculated values - Subtotal:', subtotal, 'VAT:', vat, 'Total:', total);
                    } catch (e) {
                        console.error('Error parsing cart data:', e);
                        cart = [];
                    }
                } else {
                    console.log('No cart data found in sessionStorage');
                    cart = [];
                }
                
                console.log('About to call renderCart with cart:', cart);
                renderCart();
                updateSummary();
            });

            function renderCart() {
                const cartItems = document.getElementById('cartItems');
                console.log('=== DEBUG: renderCart() ===');
                console.log('Cart items element:', cartItems);
                console.log('Cart array:', cart);
                console.log('Cart length:', cart.length);
                console.log('Cart type:', typeof cart);

                if (cart.length === 0) {
                    console.log('Cart is empty, showing empty cart message');
                    cartItems.innerHTML = 
                        '<tr>' +
                            '<td colspan="4" style="text-align: center; padding: 40px; color: #6c757d;">' +
                                '<i class="fas fa-shopping-cart" style="font-size: 48px; margin-bottom: 20px; display: block;"></i>' +
                                '<h3>Giỏ hàng trống</h3>' +
                                '<p>Bạn chưa chọn gói dịch vụ nào. Hãy quay lại trang gói dịch vụ để chọn.</p>' +
                                '<button class="btn btn-primary" onclick="window.location.href=\'job-packages.jsp\'" style="margin-top: 15px; padding: 10px 20px; background: #0a67ff; color: white; border: none; border-radius: 6px; cursor: pointer;">' +
                                    '<i class="fas fa-shopping-bag"></i> Chọn gói dịch vụ' +
                                '</button>' +
                            '</td>' +
                        '</tr>';
                    return;
                }

                console.log('Cart has items, rendering cart items');
                const cartHTML = cart.map((item, index) => {
                    console.log('Rendering item', index, ':', item);
                    console.log('Item title:', item.title);
                    console.log('Item price:', item.price);
                    console.log('Item quantity:', item.quantity);
                    
                    const itemHTML = 
                        '<tr>' +
                            '<td>' +
                                '<div class="product-info">' +
                                    '<div class="product-name">' + item.title + '</div>' +
                                    '<a href="#" class="product-description">Xem miêu tả</a>' +
                                '</div>' +
                            '</td>' +
                            '<td>' +
                                '<div class="product-price">' + formatVietnameseNumber(item.price) + ' VND</div>' +
                            '</td>' +
                            '<td>' +
                                '<div class="quantity-controls">' +
                                    '<button class="quantity-btn" onclick="updateQuantity(' + index + ', ' + (item.quantity - 1) + ')" ' + (item.quantity <= 1 ? 'disabled' : '') + '>-</button>' +
                                    '<input type="number" class="quantity-input" value="' + item.quantity + '" min="1" id="quantity-' + index + '" readonly>' +
                                    '<button class="quantity-btn" onclick="updateQuantity(' + index + ', ' + (item.quantity + 1) + ')">+</button>' +
                                '</div>' +
                            '</td>' +
                            '<td>' +
                                '<i class="fas fa-trash remove-btn" onclick="removeItem(' + index + ')"></i>' +
                            '</td>' +
                        '</tr>';
                    
                    console.log('Generated HTML for item', index, ':', itemHTML);
                    return itemHTML;
                }).join('');
                
                console.log('Final cart HTML:', cartHTML);
                cartItems.innerHTML = cartHTML;
            }

            function updateQuantity(index, newQuantity) {
                console.log('UpdateQuantity called:', index, newQuantity);
                if (newQuantity < 1) {
                    removeItem(index);
                    return;
                }
                cart[index].quantity = newQuantity;
                
                // Update sessionStorage
                sessionStorage.setItem('cartData', JSON.stringify(cart));
                
                // Recalculate and update totals
                const newSubtotal = cart.reduce((sum, item) => {
                    let price = 0;
                    if (typeof item.price === 'number') {
                        price = item.price;
                    } else if (typeof item.price === 'string') {
                        const priceStr = item.price.replace(/[^\d]/g, '');
                        price = parseInt(priceStr) || 0;
                    }
                    return sum + (price * item.quantity);
                }, 0);
                
                const newVAT = Math.round(newSubtotal * 0.08);
                const newTotal = newSubtotal + newVAT;
                
                sessionStorage.setItem('cartSubtotal', newSubtotal.toString());
                sessionStorage.setItem('cartVAT', newVAT.toString());
                sessionStorage.setItem('cartTotal', newTotal.toString());
                
                console.log('Updated quantities and totals:', newSubtotal, newVAT, newTotal);
                
                renderCart();
                updateSummary();
            }

            function removeItem(index) {
                console.log('RemoveItem called:', index);
                cart.splice(index, 1);
                
                // Update sessionStorage
                sessionStorage.setItem('cartData', JSON.stringify(cart));
                
                // Recalculate and update totals
                const newSubtotal = cart.reduce((sum, item) => {
                    let price = 0;
                    if (typeof item.price === 'number') {
                        price = item.price;
                    } else if (typeof item.price === 'string') {
                        const priceStr = item.price.replace(/[^\d]/g, '');
                        price = parseInt(priceStr) || 0;
                    }
                    return sum + (price * item.quantity);
                }, 0);
                
                const newVAT = Math.round(newSubtotal * 0.08);
                const newTotal = newSubtotal + newVAT;
                
                sessionStorage.setItem('cartSubtotal', newSubtotal.toString());
                sessionStorage.setItem('cartVAT', newVAT.toString());
                sessionStorage.setItem('cartTotal', newTotal.toString());
                
                console.log('Removed item and updated totals:', newSubtotal, newVAT, newTotal);
                
                    renderCart();
                    updateSummary();
            }

            function updateSummary() {
                // Recalculate totals from cart data
                const calculatedSubtotal = cart.reduce((sum, item) => {
                    let price = 0;
                    if (typeof item.price === 'number') {
                        price = item.price;
                    } else if (typeof item.price === 'string') {
                        const priceStr = item.price.replace(/[^\d]/g, '');
                        price = parseInt(priceStr) || 0;
                    }
                    return sum + (price * item.quantity);
                }, 0);

                const calculatedVAT = Math.round(calculatedSubtotal * 0.08);
                const calculatedTotal = calculatedSubtotal + calculatedVAT;
                
                console.log('UpdateSummary - Calculated subtotal:', calculatedSubtotal);
                console.log('UpdateSummary - Calculated VAT:', calculatedVAT);
                console.log('UpdateSummary - Calculated total:', calculatedTotal);

                document.getElementById('subtotal').textContent = formatVietnameseNumber(calculatedSubtotal) + ' VND';
                document.getElementById('total').textContent = formatVietnameseNumber(calculatedTotal) + ' VND';
            }
            
            // Function to format Vietnamese number
            function formatVietnameseNumber(num) {
                if (num < 1000) {
                    return num.toString();
                }
                return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
            }

            function selectPayment(paymentId) {
                // Bỏ chọn tất cả
                document.querySelectorAll('.payment-option').forEach(option => {
                    option.classList.remove('selected');
                });

                // Chọn phương thức thanh toán được click
                event.currentTarget.classList.add('selected');

                // Cập nhật radio button
                const radioButtons = document.querySelectorAll('input[name="payment"]');
                radioButtons[paymentId - 1].checked = true;

                // Cập nhật text button
                const payBtn = document.querySelector('.pay-btn');
                const paymentMethods = ['Thẻ tín dụng', 'Thẻ ATM', 'Chuyển khoản'];
                payBtn.innerHTML = '<i class="fas fa-lock"></i> Thanh toán bằng ' + paymentMethods[paymentId - 1];
            }

            function processPayment() {
                if (cart.length === 0) {
                    alert('Giỏ hàng trống! Vui lòng chọn ít nhất một gói dịch vụ.');
                    return;
                }

                const selectedPayment = document.querySelector('input[name="payment"]:checked').value;
                
                if (selectedPayment === 'credit' || selectedPayment === 'atm') {
                    // Process VNPay payment
                    processVNPayPayment();
                } else {
                    // Process bank transfer
                    alert('Chức năng chuyển khoản đang được phát triển!');
                }
            }
            
            function processVNPayPayment() {
                // Get cart data from sessionStorage
                const cartData = sessionStorage.getItem('cartData');
                const cartSubtotal = sessionStorage.getItem('cartSubtotal');
                const cartVAT = sessionStorage.getItem('cartVAT');
                const cartTotal = sessionStorage.getItem('cartTotal');
                
                if (!cartData) {
                    alert('Lỗi: Không có dữ liệu giỏ hàng!');
                    return;
                }
                
                // Create form and submit to PaymentServlet
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/payment';
                
                // Add cart data
                const cartDataInput = document.createElement('input');
                cartDataInput.type = 'hidden';
                cartDataInput.name = 'cartData';
                cartDataInput.value = cartData;
                form.appendChild(cartDataInput);
                
                const subtotalInput = document.createElement('input');
                subtotalInput.type = 'hidden';
                subtotalInput.name = 'cartSubtotal';
                subtotalInput.value = cartSubtotal;
                form.appendChild(subtotalInput);
                
                const vatInput = document.createElement('input');
                vatInput.type = 'hidden';
                vatInput.name = 'cartVAT';
                vatInput.value = cartVAT;
                form.appendChild(vatInput);
                
                const totalInput = document.createElement('input');
                totalInput.type = 'hidden';
                totalInput.name = 'cartTotal';
                totalInput.value = cartTotal;
                form.appendChild(totalInput);
                
                // Add form to page and submit
                document.body.appendChild(form);
                form.submit();
            }
            
            function testSessionStorage() {
                console.log('=== TEST SESSIONSTORAGE ===');
                console.log('SessionStorage length:', sessionStorage.length);
                
                for (let i = 0; i < sessionStorage.length; i++) {
                    const key = sessionStorage.key(i);
                    const value = sessionStorage.getItem(key);
                    console.log('Key:', key, 'Value:', value);
                }
                
                const cartData = sessionStorage.getItem('cartData');
                console.log('Cart data:', cartData);
                
                if (cartData) {
                    try {
                        const parsedCart = JSON.parse(cartData);
                        console.log('Parsed cart:', parsedCart);
                        console.log('Cart length:', parsedCart.length);
                    } catch (e) {
                        console.error('Error parsing cart:', e);
                    }
                } else {
                    console.log('No cart data found');
                }
                
                alert('Check console for sessionStorage details');
            }
        </script>
    </body>
</html>
