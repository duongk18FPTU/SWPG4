-- ========================================
-- Script Database hoàn chỉnh cho TopCV
-- Bao gồm tất cả bảng và dữ liệu mẫu
-- ========================================

CREATE DATABASE topcvplus3;
USE topcvplus3;

-- =======================================
-- 1. Bảng tham chiếu chung (Lookup tables)
-- =======================================

CREATE TABLE Locations (
    LocationID INT PRIMARY KEY IDENTITY(1,1),
    LocationName NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Skills (
    SkillID INT PRIMARY KEY IDENTITY(1,1),
    SkillName NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    ParentCategoryID INT NULL,
    FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Types (
    TypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeCategory NVARCHAR(50) NOT NULL,
    TypeName NVARCHAR(100) NOT NULL,
    UNIQUE (TypeCategory, TypeName)
);

-- ========================================
-- Bảng JobPackages để lưu các gói đăng tin
-- ========================================



-- =======================================
-- 2. Bảng người dùng (Users & Profiles)
-- =======================================

-- Người tìm việc (gồm thông tin đăng nhập và hồ sơ)
CREATE TABLE JobSeeker (
    JobSeekerID INT PRIMARY KEY IDENTITY(1,1),
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NULL,
    Gender NVARCHAR(10) NULL,
    Headline NVARCHAR(200),
    ContactInfo NVARCHAR(255),
    Address NVARCHAR(255),
    LocationID INT,
    Img NVARCHAR(250),
    CurrentLevelID INT,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Active',
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
    FOREIGN KEY (CurrentLevelID) REFERENCES Types(TypeID)
);

-- Nhà tuyển dụng (gồm thông tin đăng nhập và hồ sơ công ty)
CREATE TABLE Recruiter (
    RecruiterID INT PRIMARY KEY IDENTITY(1,1),
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NULL,
    CompanyName NVARCHAR(200) NOT NULL,
    CompanyDescription NVARCHAR(MAX),
    CompanyLogoURL NVARCHAR(255),
    Website NVARCHAR(255),
    Img NVARCHAR(250),
    CategoryID INT NOT NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Active',
    CompanyAddress NVARCHAR(255),
    CompanySize NVARCHAR(50),
    ContactPerson NVARCHAR(100),
    CompanyBenefits NVARCHAR(MAX),
    CompanyVideoURL NVARCHAR(255),
    Taxcode VARCHAR(50),
    RegistrationCert NVARCHAR(250),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Quản trị viên (có thể tạo các tài khoản Staff và gán Roles)
CREATE TABLE Admins (
    AdminID INT PRIMARY KEY IDENTITY(1,1),
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    AvatarURL NVARCHAR(255) NULL,
    Phone NVARCHAR(20) NULL,
    Gender NVARCHAR(10) NULL,
    Address NVARCHAR(255) NULL,
    DateOfBirth DATE NULL,
    Bio NVARCHAR(500) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) NOT NULL DEFAULT 'Active'
);

-- Bảng Roles (Định nghĩa các vai trò)
CREATE TABLE Roles (
    RoleId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE
);

-- Bảng trung gian Role_Staff (Phân quyền cho Staff)
CREATE TABLE Role_Staff (
    RoleStaffId INT PRIMARY KEY IDENTITY(1,1),
    RoleId INT NOT NULL,
    AdminId INT NOT NULL,
    FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),
    FOREIGN KEY (AdminId) REFERENCES Admins(AdminID),
    UNIQUE (RoleId, AdminId)
);

-- =======================================
-- 3. Jobs & CVs
-- =======================================

-- Tin tuyển dụng
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY IDENTITY(1,1),
    RecruiterID INT NOT NULL,
    JobTitle NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    Requirements NVARCHAR(MAX),
    JobLevelID INT NOT NULL,
    SalaryRange NVARCHAR(50),
    PostingDate DATETIME DEFAULT GETDATE(),
    ExpirationDate DATETIME NOT NULL,
    CategoryID INT NOT NULL,
    AgeRequirement INT NOT NULL,
    JobTypeID INT NOT NULL,
    HiringCount INT DEFAULT 1,
    ViewCount INT NOT NULL DEFAULT 0,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Published',
    -- Các trường cho job posting
    IsUrgent BIT DEFAULT 0,
    IsPriority BIT DEFAULT 0,
    PriorityExpiryDate DATETIME NULL,
    ContactPerson NVARCHAR(100) NULL,
    ApplicationEmail NVARCHAR(100) NULL,
    MinExperience INT DEFAULT 0,
    Nationality NVARCHAR(50) NULL,
    Gender NVARCHAR(10) NULL,
    MaritalStatus NVARCHAR(20) NULL,
    AgeMin INT DEFAULT 18,
    AgeMax INT DEFAULT 65,
    JobCode NVARCHAR(50) NOT NULL,
    CertificatesID INT NULL,
    LocationID INT NULL,
    -- Foreign Keys
    FOREIGN KEY (RecruiterID) REFERENCES Recruiter(RecruiterID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (JobLevelID) REFERENCES Types(TypeID),
    FOREIGN KEY (JobTypeID) REFERENCES Types(TypeID),
    FOREIGN KEY (CertificatesID) REFERENCES Types(TypeID),
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- CV
CREATE TABLE CVs (
    CVID INT PRIMARY KEY IDENTITY(1,1),
    JobSeekerID INT NOT NULL,
    CVTitle NVARCHAR(200) NOT NULL,
    CVContent NVARCHAR(MAX),
    CVURL NVARCHAR(255),
    IsActive BIT,
    CreationDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (JobSeekerID) REFERENCES JobSeeker(JobSeekerID)
);

-- Ứng tuyển
CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY IDENTITY(1,1),
    JobID INT NOT NULL,
    CVID INT NOT NULL,
    ApplicationDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) NOT NULL,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (CVID) REFERENCES CVs(CVID)
);

-- Kỹ năng trong hồ sơ JobSeeker
CREATE TABLE ProfileSkills (
    JobSeekerID INT NOT NULL,
    SkillID INT NOT NULL,
    PRIMARY KEY (JobSeekerID, SkillID),
    FOREIGN KEY (JobSeekerID) REFERENCES JobSeeker(JobSeekerID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

-- Kỹ năng yêu cầu trong công việc
CREATE TABLE JobSkillMappings (
    JobID INT NOT NULL,
    SkillID INT NOT NULL,
    PRIMARY KEY (JobID, SkillID),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

-- =======================================
-- 5. Các bảng khác
-- =======================================

CREATE TABLE Token (
    id INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    userType NVARCHAR(50) NOT NULL,
    isUsed BIT NOT NULL DEFAULT 0,
    token NVARCHAR(255) NOT NULL,
    expiryTime DATETIME2 NOT NULL,
    CONSTRAINT UK_Token_User UNIQUE (userId, userType)
);

-- Saved Jobs (Chức năng Lưu việc làm)
CREATE TABLE SavedJobs (
    SavedJobID INT PRIMARY KEY IDENTITY(1,1),
    JobSeekerID INT NOT NULL,
    JobID INT NOT NULL,
    SavedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (JobSeekerID) REFERENCES JobSeeker(JobSeekerID),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    UNIQUE (JobSeekerID, JobID) -- Không lưu trùng cùng 1 job
);

--them bang cho staff 
--marketing staff
CREATE TABLE Campaigns (
    CampaignID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignName NVARCHAR(200) NOT NULL,
    TargetType NVARCHAR(50) CHECK (TargetType IN ('JobSeeker', 'Recruiter')) NOT NULL, -- Đối tượng chiến dịch
    Platform NVARCHAR(100),             -- Facebook, Google, Email, LinkedIn,...
    Budget DECIMAL(18,2),
    StartDate DATE,
    EndDate DATE,
    Status NVARCHAR(50) CHECK (Status IN ('Planned', 'Running', 'Completed', 'Paused')),
    Description NVARCHAR(MAX),
    CreatedBy INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Admins(AdminID)
);


CREATE TABLE CampaignResults (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignID INT NOT NULL,
    NewJobSeekers INT DEFAULT 0,
    NewRecruiters INT DEFAULT 0,
    JobViews INT DEFAULT 0,
    Applications INT DEFAULT 0,
    Cost DECIMAL(18,2) DEFAULT 0,
    Revenue DECIMAL(18,2) DEFAULT 0,
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CampaignID) REFERENCES Campaigns(CampaignID)
);

CREATE TABLE MarketingContents (
    ContentID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignID INT NOT NULL,
    Title NVARCHAR(255),
    ContentText NVARCHAR(MAX),
    MediaURL NVARCHAR(500),
    PostDate DATETIME DEFAULT GETDATE(),
    Platform NVARCHAR(100),
    Status NVARCHAR(50) CHECK (Status IN ('Draft', 'Published', 'Archived')),
    CreatedBy INT,
    FOREIGN KEY (CampaignID) REFERENCES Campaigns(CampaignID),
    FOREIGN KEY (CreatedBy) REFERENCES Admins(AdminID)
);

--sale
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10,2) NOT NULL,
    DurationDays INT NOT NULL, -- thời gian sử dụng dịch vụ
    Status NVARCHAR(20) DEFAULT 'Active' -- Active / Inactive
);

CREATE TABLE ServiceOrders (
    ServiceOrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL, -- Recruiter mua dịch vụ
    ServiceID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus NVARCHAR(20) DEFAULT 'Pending', -- Pending / Paid / Cancelled
    FOREIGN KEY (UserID) REFERENCES Recruiter(RecruiterID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

CREATE TABLE RevenueReports (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    ReportDate DATE DEFAULT GETDATE(),
    TotalOrders INT,
    TotalRevenue DECIMAL(15,2),
    GeneratedBy INT NULL, -- ID của nhân viên tạo (Admin hoặc Staff)
    FOREIGN KEY (GeneratedBy) REFERENCES Admins(AdminID)
);

--chat
CREATE TABLE ChatSessions (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    AdminID INT NOT NULL,
    UserRole NVARCHAR(20) NOT NULL CHECK (UserRole IN ('Recruiter', 'JobSeeker')),
    UserID INT NOT NULL,
    StartedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AdminID) REFERENCES Admins(AdminID)
);

CREATE TABLE ChatMessages (
    MessageID INT PRIMARY KEY IDENTITY(1,1),
    SessionID INT NOT NULL,
    SenderRole NVARCHAR(20) NOT NULL CHECK (SenderRole IN ('Admin', 'Recruiter', 'JobSeeker')),
    SenderID INT NOT NULL,
    MessageText NVARCHAR(MAX) NOT NULL,
    SentTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SessionID) REFERENCES ChatSessions(SessionID)
);

-- ========================================
-- 1️⃣ Bảng JobPackages (danh mục gói)
-- ========================================
CREATE TABLE JobPackages (
    PackageID INT PRIMARY KEY IDENTITY(1,1),
    PackageName NVARCHAR(200) NOT NULL,
    PackageType NVARCHAR(50) NOT NULL,      -- 'DANG_TUYEN', 'TIM_HO_SO', 'AI_PREMIUM', ...
    Description NVARCHAR(MAX) NULL,
    Price DECIMAL(15,2) NOT NULL,
    Duration INT NULL,                      -- Số ngày hiệu lực
    Points INT NULL,                        -- Dành cho gói tìm hồ sơ
    Features NVARCHAR(MAX) NULL,            -- JSON string mô tả tính năng
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- ========================================
-- 2️⃣ Bảng RecruiterPackages (gói mà nhà tuyển dụng đã mua)
-- ========================================
CREATE TABLE RecruiterPackages (
    RecruiterPackageID INT PRIMARY KEY IDENTITY(1,1),
    RecruiterID INT NOT NULL,               -- Khóa ngoại (Recruiter)
    PackageID INT NOT NULL,                 -- Khóa ngoại (JobPackages)
    Quantity INT DEFAULT 1,                 -- Số lượng quyền sử dụng
    UsedQuantity INT DEFAULT 0,             -- Đã dùng bao nhiêu
    PurchaseDate DATETIME DEFAULT GETDATE(),
    ExpiryDate DATETIME NULL,               -- Ngày hết hạn
    IsUsed BIT DEFAULT 0,                   -- Gói đã dùng hết chưa
    FOREIGN KEY (PackageID) REFERENCES JobPackages(PackageID),
    FOREIGN KEY (RecruiterID) REFERENCES Recruiter(RecruiterID)
);

-- ========================================
-- 3️⃣ Bảng Payments (thanh toán)
-- ========================================
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),       -- Mã thanh toán (tự tăng)
    RecruiterID INT NOT NULL,                    -- Khóa ngoại: Gói dịch vụ
    Amount DECIMAL(15,2) NOT NULL,                 -- Số tiền thanh toán
    PaymentMethod NVARCHAR(50) NOT NULL,           -- Phương thức: 'Bank', 'VNPAY', 'MoMo', ...
    PaymentStatus NVARCHAR(50) DEFAULT N'Pending', -- Trạng thái: Pending, Completed, Failed, Refunded
    TransactionCode NVARCHAR(100) NULL,            -- Mã giao dịch (nếu có)
    PaymentDate DATETIME DEFAULT GETDATE(),        -- Ngày thanh toán
    Notes NVARCHAR(255) NULL,                      -- Ghi chú thêm

    CONSTRAINT FK_Payments_Recruiter 
        FOREIGN KEY (RecruiterID) REFERENCES Recruiter(RecruiterID),

);

-- ========================================
-- 4️⃣ Bảng PaymentDetails (thanh toán nhiều gói trong 1 giao dịch)
-- ========================================
CREATE TABLE PaymentDetails (
    PaymentDetailID INT PRIMARY KEY IDENTITY(1,1),
    PaymentID INT NOT NULL,                 -- FK: Payments
    PackageID INT NOT NULL,                 -- FK: JobPackages
    Quantity INT DEFAULT 1,                 -- Số lượng mua
    UnitPrice DECIMAL(15,2) NULL,           -- Giá 1 đơn vị gói tại thời điểm mua
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID),
    FOREIGN KEY (PackageID) REFERENCES JobPackages(PackageID)
);

-- ========================================
-- 5️⃣ Bảng PaymentTransactions (lịch sử thao tác: charge, refund, error, ...)
-- ========================================
CREATE TABLE PaymentTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    PaymentID INT NOT NULL,                 -- FK: Payments
    TransactionType NVARCHAR(50) NOT NULL,  -- 'Charge', 'Refund', 'Error', ...
    Amount DECIMAL(15,2) NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(255) NULL,
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID)
);

-- ========================================
-- 6️⃣ Bảng JobFeatureMappings (áp dụng gói lên tin đăng)
-- ========================================
CREATE TABLE JobFeatureMappings (
    JobFeatureMapID INT IDENTITY PRIMARY KEY,
    JobID INT NOT NULL,                     -- FK: Jobs
    RecruiterPackageID INT NOT NULL,        -- FK: RecruiterPackages
    FeatureType NVARCHAR(50) NOT NULL,      -- 'POST', 'HIGHLIGHT', 'SEARCHBOOST'
    AppliedDate DATETIME DEFAULT GETDATE(),
    ExpireDate DATETIME NULL,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (RecruiterPackageID) REFERENCES RecruiterPackages(RecruiterPackageID)
);

-- Bảng thông báo Jobseeker
CREATE TABLE Notifications (
        notificationID INT PRIMARY KEY IDENTITY(1,1),
        userID INT NOT NULL,
        userType VARCHAR(20) NOT NULL CHECK (userType IN ('jobseeker', 'recruiter', 'admin', 'staff')),
        notificationType VARCHAR(50) NOT NULL CHECK (notificationType IN ('application', 'profile', 'job', 'chat', 'system', 'payment')),
        title NVARCHAR(255) NOT NULL,
        message NVARCHAR(1000),
        relatedID INT NULL,
        relatedType VARCHAR(50) NULL,
        isRead BIT DEFAULT 0,
        createdAt DATETIME DEFAULT GETDATE(),
        readAt DATETIME NULL,
        iconType VARCHAR(20) DEFAULT 'system' CHECK (iconType IN ('application', 'profile', 'system', 'chat')),
        priority INT DEFAULT 0 CHECK (priority BETWEEN 0 AND 2),
        actionURL VARCHAR(500) NULL,
        
        CONSTRAINT FK_Notification_User FOREIGN KEY (userID) 
            REFERENCES JobSeeker(jobSeekerID)
            ON DELETE CASCADE
    );

	-- Create indexes for better performance
CREATE INDEX idx_user_notifications ON Notifications(userID, userType, isRead, createdAt DESC);
CREATE INDEX idx_notification_type ON Notifications(notificationType, createdAt DESC);
CREATE INDEX idx_notification_read ON Notifications(isRead, createdAt DESC);

-- Job views
GO
CREATE PROCEDURE sp_IncrementJobView
    @JobID INT
AS
BEGIN
    UPDATE Jobs 
    SET ViewCount = ViewCount + 1 
    WHERE JobID = @JobID;
END
GO

-- ========================================
-- Chèn dữ liệu mẫu
-- ========================================

-- 1. Locations
INSERT INTO Locations (LocationName) VALUES
(N'Hà Nội'),
(N'Hồ Chí Minh'),
(N'Đà Nẵng'),
(N'Hải Phòng'),
(N'Cần Thơ');

-- 2. Skills
INSERT INTO Skills (SkillName) VALUES
(N'Java'),
(N'C#'),
(N'SQL'),
(N'JavaScript'),
(N'Python'),
(N'React'),
(N'Angular'),
(N'Node.js'),
(N'Spring Boot'),
(N'.NET Core');

-- 3. Categories
INSERT INTO Categories (CategoryName, ParentCategoryID) VALUES
(N'Công nghệ thông tin', NULL),
(N'Kinh doanh', NULL),
(N'Thiết kế', NULL),
(N'Marketing', NULL),
(N'Tài chính', NULL),
(N'Y tế', NULL),
(N'Giáo dục', NULL),
(N'Tester', 1),
(N'Frontend Developer', 1),
(N'Backend Developer', 1),
(N'Fullstack Developer', 1),
(N'Business Analyst', 1),
(N'Project Manager', 1),
(N'UI/UX Designer', 1),
(N'Sales Executive', 2),
(N'Account Manager', 2),
(N'Business Development', 2),
(N'Customer Success', 2),
(N'Graphic Designer', 3),
(N'Motion Designer', 3),
(N'3D Artist', 3),
(N'Digital Marketing', 4),
(N'Content Creator', 4),
(N'Performance Marketing', 4),
(N'SEO Specialist', 4),
(N'Kế toán', 5),
(N'Kiểm toán', 5),
(N'Chuyên viên phân tích tài chính', 5),
(N'Điều dưỡng', 6),
(N'Dược sĩ', 6),
(N'Bác sĩ đa khoa', 6),
(N'Giáo viên TOÁN', 7),
(N'Giáo viên TIẾNG ANH', 7),
(N'Trợ giảng', 7);

-- 4. Types (Level, JobType, Certificates)
INSERT INTO Types (TypeCategory, TypeName) VALUES
('Level', N'Intern'),
('Level', N'Junior'),
('Level', N'Senior'),
('Level', N'Lead'),
('Level', N'Manager'),
('JobType', N'Full-time'),
('JobType', N'Part-time'),
('JobType', N'Contract'),
('JobType', N'Freelance'),
('Certificate', N'High School'),
('Certificate', N'Diploma'),
('Certificate', N'Bachelor'),
('Certificate', N'Master'),
('Certificate', N'PhD');

-- 5. JobPackages - Chèn dữ liệu mẫu cho các gói đăng tin
INSERT INTO JobPackages (PackageName, PackageType, Description, Price, Duration, Points, Features)
VALUES
-- GÓI ĐỒNG
(N'Gói Đồng 15 Ngày', 'DANG_TUYEN',
 N'Gói đăng tuyển cơ bản trong 15 ngày, giúp nhà tuyển dụng tiếp cận ứng viên nhanh chóng ở mức tiết kiệm.',
 800000, 15, NULL,
 '{"posts": 10,"level": "bronze", "web_basic": true, "duration": 15}'),

(N'Gói Đồng 30 Ngày', 'DANG_TUYEN',
 N'Gói đăng tuyển cơ bản trong 30 ngày, phù hợp với nhu cầu tuyển dụng phổ thông.',
 1500000, 30, NULL,
 '{"posts": 10,"level": "bronze", "web_basic": true, "duration": 30}'),

-- GÓI BẠC
(N'Gói Bạc 15 Ngày', 'DANG_TUYEN',
 N'Gói đăng tuyển Bạc trong 15 ngày, giúp tin tuyển dụng nổi bật hơn và tiếp cận nhiều ứng viên hơn.',
 1200000, 15, NULL,
 '{"posts": 15,"level": "silver", "web_priority": true, "highlight": true, "duration": 15}'),

(N'Gói Bạc 30 Ngày', 'DANG_TUYEN',
 N'Gói đăng tuyển Bạc trong 30 ngày, giúp tăng mức hiển thị và thu hút ứng viên chất lượng.',
 2200000, 30, NULL,
 '{"posts": 15,"level": "silver", "web_priority": true, "highlight": true, "duration": 30}'),

-- GÓI VÀNG
(N'Gói Vàng 15 Ngày', 'DANG_TUYEN',
 N'Gói Vàng 15 ngày mang lại mức hiển thị cao, ưu tiên hàng đầu trên trang web tuyển dụng.',
 2500000, 15, NULL,
 '{"posts": 20,"level": "gold", "web_priority": true, "highlight": true, "featured": true, "duration": 15}'),

(N'Gói Vàng 30 Ngày', 'DANG_TUYEN',
 N'Gói Vàng 30 ngày cao cấp giúp tối đa hóa hiệu quả tuyển dụng, phù hợp doanh nghiệp cần tuyển nhanh và nhiều vị trí.',
 4000000, 30, NULL,
 '{"posts": 20,"level": "gold", "web_priority": true, "highlight": true, "featured": true, "duration": 30}');
GO




-- 6. JobSeeker
INSERT INTO JobSeeker (Email, Password, FullName, Phone, Gender, Headline, ContactInfo, Address, LocationID, Img, CurrentLevelID)
VALUES
('nguyenvana@gmail.com', '123456', N'Nguyễn Văn A', '0901234567', N'Nam', N'Lập trình viên Java', N'Liên hệ qua email', N'Hoàng Mai - Hà Nội', 1, 'avatar1.png', 2),
('tranthib@gmail.com', '123456', N'Trần Thị B', '0912345678', N'Nữ', N'Designer UI/UX', N'Liên hệ qua phone', N'Quận 1 - HCM', 2, 'avatar2.png', 2),
('levanc@gmail.com', '123456', N'Lê Văn C', '0923456789', N'Nam', N'Full-stack Developer', N'Liên hệ qua email', N'Quận 7 - HCM', 2, 'avatar3.png', 3);

-- 7. Recruiter
INSERT INTO Recruiter (Email, Password, Phone, CompanyName, CompanyDescription, CompanyLogoURL, Website, Img, CategoryID, CompanyAddress, CompanySize, ContactPerson, Taxcode, RegistrationCert)
VALUES
('hr@fpt.com', '123456', '0987654321', N'Công ty FPT Software', N'Công ty phần mềm hàng đầu VN', 'fptlogo.png', 'https://fpt.com', 'fpt.png', 1, N'Cầu Giấy - Hà Nội', N'500+', N'Nguyễn Văn HR', '123456789', 'fpt_cert.png'),
('tuyendung@vnexpress.net', '123456', '0978123456', N'Báo VnExpress', N'Cơ quan báo chí', 'vnexpress.png', 'https://vnexpress.net', 'vnexp.png', 2, N'TP HCM', N'200-500', N'Trần Thị HR', '987654321', 'vnexp_cert.png'),
('hr@techcombank.com', '123456', '0965432109', N'Ngân hàng Techcombank', N'Ngân hàng thương mại', 'techcombank.png', 'https://techcombank.com', 'tcb.png', 5, N'Hà Nội', N'1000+', N'Phạm Văn HR', '111222333', 'tcb_cert.png');

-- 8. Admins
INSERT INTO Admins (Email, Password, FullName, AvatarURL, Phone, Gender, Address, DateOfBirth, Bio)
VALUES
('dduyanh2707@gmail.com', 'duyanh2707', N'Đỗ Duy Anh', 'admin1.png', '0962021899', N'Nam', N'Hà Nội', '2005-01-01', N'Admin chính'),
('staff@topcv.vn', 'staff123', N'Nhân viên B', 'staff1.png', '0919191919', N'Nữ', N'HCM', '1995-05-10', N'Staff hỗ trợ');

-- 9. Roles
INSERT INTO Roles (Name) VALUES
(N'Admin'),
(N'Marketing Staff'),
(N'HR'),
(N'Sales');

-- 10. Role_Staff
INSERT INTO Role_Staff (RoleId, AdminId) VALUES
(1, 1), -- Admin
(2, 2); -- Staff

-- 11. Jobs
-- 11. Jobs (CẬP NHẬT LẠI VỚI CERTIFICATESID VÀ LOCATIONID)
INSERT INTO Jobs (
    RecruiterID, 
    JobTitle, 
    Description, 
    Requirements, 
    JobLevelID, 
    SalaryRange, 
    ExpirationDate, 
    CategoryID, 
    AgeRequirement, 
    JobTypeID, 
    HiringCount, 
    Status, 
    JobCode,
    CertificatesID,  
    LocationID       
)
VALUES
-- Job 1: FPT
(
    1, 
    N'Lập trình viên Java', 
    N'Tìm kiếm lập trình viên Java có kinh nghiệm để phát triển các ứng dụng web và mobile', 
    N'Yêu cầu Java, Spring Boot, SQL, có kinh nghiệm 2-3 năm', 
    2,  -- Junior
    N'15-20 triệu', 
    '2025-12-31', 
    1,  -- CNTT
    22, 
    6,  -- Full-time
    3, 
    N'Published',
    '123',
    10, -- Bachelor
    1   -- Hà Nội
),
-- Job 2: VnExpress
(
    2, 
    N'Chuyên viên Kinh doanh', 
    N'Tuyển dụng chuyên viên kinh doanh có kỹ năng giao tiếp tốt', 
    N'Có kỹ năng giao tiếp, kinh nghiệm bán hàng', 
    1,  -- Intern
    N'10-15 triệu', 
    '2025-11-30', 
    2,  -- Kinh doanh
    21, 
    6,  -- Full-time
    2, 
    N'Published',
    '124',
    10, -- Bachelor
    2   -- TP.HCM
),
-- Job 3: Techcombank
(
    3, 
    N'Senior Full-stack Developer', 
    N'Tuyển dụng Senior Developer có kinh nghiệm phát triển full-stack', 
    N'React, Node.js, MongoDB, có kinh nghiệm 4-5 năm', 
    3,  -- Senior
    N'25-35 triệu', 
    '2025-12-15', 
    1,  -- CNTT
    25, 
    6,  -- Full-time
    1, 
    N'Published',
    '125',
    11, -- ✅ Master
    1   -- ✅ Hà Nội
);-- 12. CVs
INSERT INTO CVs (JobSeekerID, CVTitle, CVContent, CVURL, IsActive)
VALUES
(1, N'CV Java Developer', N'Nội dung CV Java Developer với kinh nghiệm Spring Boot', 'cv_java.pdf', 1),
(2, N'CV Designer', N'Nội dung CV Designer UI/UX', 'cv_design.pdf', 1),
(3, N'CV Full-stack Developer', N'Nội dung CV Full-stack Developer', 'cv_fullstack.pdf', 1);

-- 13. Applications
INSERT INTO Applications (JobID, CVID, Status)
VALUES
(1, 1, N'Pending'),
(2, 2, N'Pending'),
(3, 3, N'Pending');

-- 14. ProfileSkills
INSERT INTO ProfileSkills (JobSeekerID, SkillID) VALUES
(1, 1), -- Java
(1, 3), -- SQL
(1, 9), -- Spring Boot
(2, 4), -- JavaScript
(2, 6), -- React
(3, 4), -- JavaScript
(3, 6), -- React
(3, 8); -- Node.js

-- 15. JobSkillMappings
INSERT INTO JobSkillMappings (JobID, SkillID) VALUES
(1, 1), -- Java
(1, 3), -- SQL
(1, 9), -- Spring Boot
(2, 4), -- JavaScript
(3, 4), -- JavaScript
(3, 6), -- React
(3, 8); -- Node.js

-- 16. SavedJobs
INSERT INTO SavedJobs (JobSeekerID, JobID) VALUES
(1, 1), -- Nguyễn Văn A lưu "Lập trình viên Java"
(2, 2), -- Trần Thị B lưu "Chuyên viên Kinh doanh"
(3, 3); -- Lê Văn C lưu "Senior Full-stack Developer"




-- 17.  Thanh toán mẫu
INSERT INTO Payments (RecruiterID, Amount, PaymentMethod, PaymentStatus, TransactionCode, Notes)
VALUES
(1, 800000, N'VNPay', N'Completed', 'VN123456789', N'Thanh toán gói Đồng 15-ngày - M'),
(2,  1500000, N'MoMo', N'Completed', 'MM0987654321', N'Thanh toán gói Đồng 30-ngày'),
(3, 2200000, N'Credit Card', N'Completed', 'CC1122334455', N'Thanh toán gói Bạc 30-ngày');

--18. staff
INSERT INTO Campaigns (CampaignName, TargetType, Platform, Budget, StartDate, EndDate, Status, Description, CreatedBy)
VALUES
(N'Thu hút ứng viên CNTT 2025', 'JobSeeker', 'Facebook Ads', 12000000, '2025-05-01', '2025-05-31', 'Completed', N'Chiến dịch quảng bá việc làm CNTT', 1),
(N'Tìm đối tác tuyển dụng mới', 'Recruiter', 'LinkedIn', 15000000, '2025-06-10', '2025-07-15', 'Running', N'Tìm kiếm doanh nghiệp mới sử dụng dịch vụ TopCV', 1);

INSERT INTO Campaigns (CampaignName, TargetType, Platform, Budget, StartDate, EndDate, Status, Description, CreatedBy)
VALUES
(N'Bài viết lên web', 'JobSeeker', 'Website', 12000000, '2025-05-01', '2025-05-31', 'Running', N'Chiến dịch quảng bá việc làm CNTT', 1),
(N'Tìm đối tác tuyển dụng cũ', 'Recruiter', 'Website', 15000000, '2025-06-10', '2025-07-15', 'Running', N'Tìm kiếm doanh nghiệp mới sử dụng dịch vụ TopCV', 1);


INSERT INTO MarketingContents (CampaignID, Title, ContentText, MediaURL, Platform, Status, CreatedBy)
VALUES
(3, N'TopCV tuyển dụng ngành CNTT', N'Giới thiệu các cơ hội việc làm hot trong ngành công nghệ.', 'https://cdn.topcv.vn/img/it-campaign.jpg', N'Facebook', 'Published', 1),
(4, N'Hợp tác cùng TopCV', N'Mở rộng thương hiệu tuyển dụng của bạn cùng TopCV.', 'https://cdn.topcv.vn/img/partner.jpg', N'LinkedIn', 'Published', 1);

INSERT INTO MarketingContents (CampaignID, Title, ContentText, MediaURL, Platform, Status, CreatedBy)
VALUES
(3, N'Cơ hội việc làm ngành cntt', N'Giới thiệu các cơ hội việc làm hot trong ngành công nghệ.', 'https://cdn.topcv.vn/img/it-campaign.jpg', N'Facebook', 'Published', 1),
(4, N'Cơ hội tuyển dụng', N'Mở rộng thương hiệu tuyển dụng của bạn cùng TopCV.', 'https://cdn.topcv.vn/img/partner.jpg', N'LinkedIn', 'Published', 1);


-- ========================================
-- Cập nhật mật khẩu với MD5 hash
-- ========================================

UPDATE Admins
SET Password = LOWER(CONVERT(VARCHAR(32), HASHBYTES('MD5','duyanh2707'), 2)),
    Status = 'Active'
WHERE Email = 'dduyanh2707@gmail.com';

UPDATE Recruiter
SET Password = LOWER(CONVERT(VARCHAR(32), HASHBYTES('MD5','fpt123'), 2)),
    Status = 'Active'
WHERE Email = 'hr@fpt.com';

UPDATE Jobs
SET Status = 'Published'
WHERE JobID = 3;

UPDATE Campaigns
SET Status = 'Running'
WHERE CampaignID = 4;

UPDATE JobSeeker
SET [Password] = CONVERT(VARCHAR(32), HASHBYTES('MD5', [Password]), 2);

-- ========================================
-- Kiểm tra dữ liệu
-- ========================================

PRINT '=== KIỂM TRA DỮ LIỆU ===';

PRINT '1. JobPackages:';
SELECT PackageID, PackageName, PackageType, Price FROM JobPackages;

PRINT '2. Recruiter:';
SELECT RecruiterID, Email, CompanyName, Status FROM Recruiter;

PRINT '3. Jobs:';
SELECT JobID, JobTitle, RecruiterID, Status FROM Jobs;

PRINT '4. JobSeeker:';
SELECT JobSeekerID, Email, FullName, Status FROM JobSeeker;

PRINT '5. Categories:';
SELECT CategoryID, CategoryName FROM Categories;

PRINT '6. Types:';
SELECT TypeID, TypeCategory, TypeName FROM Types;

PRINT '=== HOÀN THÀNH TẠO DATABASE ===';


--select--
select * from Admins
select * from Recruiter
select * from JobSeeker
select * from Jobs
select * from Applications
select * from Categories
SELECT * FROM Campaigns;
select * from MarketingContents
select * from Payments
select * from JobPackages
select * from PaymentDetails
