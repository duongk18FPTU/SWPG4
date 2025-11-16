package dal;

import java.sql.*;
import model.JobSeeker;
import java.util.ArrayList;
import java.util.List;
import util.MD5Util;

public class JobSeekerDAO extends DBContext {

    //convert ResultSet -> JobSeeker
    private JobSeeker extractJobSeeker(ResultSet rs) throws SQLException {
        return new JobSeeker(
                rs.getInt("JobSeekerID"),
                rs.getString("Email"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getString("Phone"),
                rs.getString("Gender"),
                rs.getString("Headline"),
                rs.getString("ContactInfo"),
                rs.getString("Address"),
                (Integer) rs.getObject("LocationID"), // dùng getObject để tránh lỗi khi null
                rs.getString("Img"),
                (Integer) rs.getObject("CurrentLevelID"),
                rs.getString("Status")
        );
    }

    public List<JobSeeker> getAllJobSeekers() {
        List<JobSeeker> list = new ArrayList<>();
        String sql = "SELECT * FROM JobSeeker";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                JobSeeker js = extractJobSeeker(rs);
                list.add(js);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public JobSeeker getJobSeekerById(int id) {
        String sql = "SELECT * FROM JobSeeker WHERE JobSeekerID = ?";
        System.out.println("Executing query: " + sql + " with ID: " + id);

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                JobSeeker js = extractJobSeeker(rs);
                System.out.println("JobSeeker found: " + js.getFullName());
                return js;
            } else {
                System.out.println("No JobSeeker found with ID: " + id);
            }
        } catch (Exception e) {
            System.out.println("Error in getJobSeekerById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public void updateProfileModal(JobSeeker js) {
        String sql = "UPDATE JobSeeker SET Email=?, FullName=?, Phone=?, Gender=?, "
                + "Headline=?, ContactInfo=?, Address=?, LocationID=?, CurrentLevelID=?, Status=? "
                + "WHERE JobSeekerID=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, js.getEmail());
            ps.setString(2, js.getFullName());
            ps.setString(3, js.getPhone());
            ps.setString(4, js.getGender());
            ps.setString(5, js.getHeadline());
            ps.setString(6, js.getContactInfo());
            ps.setString(7, js.getAddress());
            // LocationID
            if (js.getLocationId() == null) {
                ps.setNull(8, java.sql.Types.INTEGER);
            } else {
                ps.setInt(8, js.getLocationId());
            }
            // CurrentLevelID
            if (js.getCurrentLevelId() == null) {
                ps.setNull(9, java.sql.Types.INTEGER);
            } else {
                ps.setInt(9, js.getCurrentLevelId());
            }
            ps.setString(10, js.getStatus());
            ps.setInt(11, js.getJobSeekerId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

// Đăng nhập JobSeeker
    public JobSeeker getJobSeekerAccount(String email, String password) {
        String sql = "SELECT * FROM JobSeeker WHERE Email = ? AND Password = ?";
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new JobSeeker(
                        rs.getInt("JobSeekerID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Gender"),
                        rs.getString("Headline"),
                        rs.getString("ContactInfo"),
                        rs.getString("Address"),
                        rs.getInt("LocationID"),
                        rs.getString("Img"),
                        rs.getInt("CurrentLevelID"),
                        rs.getString("Status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách JobSeeker đang Active
    public List<JobSeeker> getAllJobSeekersActive() {
        List<JobSeeker> list = new ArrayList<>();
        String sql = "SELECT * FROM JobSeeker WHERE Status = 'Active'";
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new JobSeeker(
                        rs.getInt("JobSeekerID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Gender"),
                        rs.getString("Headline"),
                        rs.getString("ContactInfo"),
                        rs.getString("Address"),
                        rs.getInt("LocationID"),
                        rs.getString("Img"),
                        rs.getInt("CurrentLevelID"),
                        rs.getString("Status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm số lượng JobSeeker
    public int countJobSeeker() {
        String sql = "SELECT COUNT(*) FROM JobSeeker";
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean deleteJobSeekerById(int id) {
        String sql = "UPDATE JobSeeker SET Status = 'Inactive' WHERE JobSeekerID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateAvatar(int jobSeekerId, String imgFileName) {
        String sql = "UPDATE JobSeeker SET Img = ? WHERE JobSeekerID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, imgFileName);
            ps.setInt(2, jobSeekerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    //MINH
    public JobSeeker login(String email, String password) {
        JobSeeker jobSeeker = null;
        String sql = "SELECT * FROM JobSeeker WHERE Email = ? AND Password = ?";

        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);
            // Mã hóa mật khẩu bằng MD5 trước khi so sánh
            ps.setString(2, MD5Util.getMD5Hash(password));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                jobSeeker = new JobSeeker(
                        rs.getInt("JobSeekerID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Gender"),
                        rs.getString("Headline"),
                        rs.getString("ContactInfo"),
                        rs.getString("Address"),
                        rs.getInt("LocationID"),
                        rs.getString("Img"),
                        rs.getInt("CurrentLevelID"),
                        rs.getString("Status")
                );
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return jobSeeker;
    }

    public JobSeeker getJobSeekerByEmail(String email) {
        JobSeeker jobSeeker = null;
        String sql = "SELECT * FROM JobSeeker WHERE Email = ?";

        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                jobSeeker = new JobSeeker(
                        rs.getInt("JobSeekerID"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Gender"),
                        rs.getString("Headline"),
                        rs.getString("ContactInfo"),
                        rs.getString("Address"),
                        rs.getInt("LocationID"),
                        rs.getString("Img"),
                        rs.getInt("CurrentLevelID"),
                        rs.getString("Status")
                );
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return jobSeeker;
    }

    // Kiểm tra email đã tồn tại trong bảng JobSeeker
    // (1 email có thể vừa là JobSeeker vừa là Recruiter, nên chỉ check trong bảng này)
    public boolean isEmailExistsInAllTables(String email) {
        System.out.println("=== DEBUG: Checking if email exists in JobSeeker ===");
        System.out.println("Email: " + email);
        
        String sql = "SELECT COUNT(*) FROM JobSeeker WHERE Email = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("JobSeeker count for email: " + count);
                rs.close();
                return count > 0;
            }
            rs.close();
            return false;
        } catch (SQLException e) {
            System.err.println("!!! SQLException in isEmailExistsInAllTables !!!");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            return false; // Cho phép đăng ký khi có lỗi DB
        }
    }

    public JobSeeker insertJobSeeker(String email, String password, String status) {
        String sql = "INSERT INTO JobSeeker (Email, Password, Status) VALUES (?, ?, ?)";
        try {
            PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, status);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int jobSeekerID = generatedKeys.getInt(1);
                    JobSeeker jobSeeker = new JobSeeker(
                            jobSeekerID,
                            email,
                            password,
                            null, // FullName
                            null, // Phone
                            null, // Gender
                            null, // Headline
                            null, // ContactInfo
                            null, // Address
                            0, // LocationID
                            null, // Img
                            0, // CurrentLevelID
                            status
                    );
                    generatedKeys.close();
                    ps.close();
                    return jobSeeker;
                }
                generatedKeys.close();
            }
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Dùng cho đăng nhập Google: tạo tài khoản tối thiểu kèm FullName (NOT NULL)
     */
    public JobSeeker insertJobSeeker(String email, String password, String status, String fullName) {
        String safeName = (fullName != null && !fullName.trim().isEmpty()) ? fullName.trim() : email;
        String sql = "INSERT INTO JobSeeker (Email, Password, Status, FullName) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, status);
            ps.setString(4, safeName);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int jobSeekerID = generatedKeys.getInt(1);
                    JobSeeker jobSeeker = new JobSeeker(
                            jobSeekerID,
                            email,
                            password,
                            safeName, // FullName
                            null, // Phone
                            null, // Gender
                            null, // Headline
                            null, // ContactInfo
                            null, // Address
                            0, // LocationID
                            null, // Img
                            0, // CurrentLevelID
                            status
                    );
                    generatedKeys.close();
                    ps.close();
                    return jobSeeker;
                }
                generatedKeys.close();
            }
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePassword(int jobSeekerId, String newPassword) {
        if (c == null) {
            System.err.println("Database connection is null in JobSeekerDAO.updatePassword");
            return false;
        }

        String sql = "UPDATE JobSeeker SET Password = ? WHERE JobSeekerID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, MD5Util.getMD5Hash(newPassword));
            ps.setInt(2, jobSeekerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đánh dấu tài khoản là tài khoản đăng nhập Google (không lưu mật khẩu thông thường).
     */
    public boolean setAsGoogleAccount(int jobSeekerId) {
        if (c == null) {
            System.err.println("Database connection is null in JobSeekerDAO.setAsGoogleAccount");
            return false;
        }

        String sql = "UPDATE JobSeeker SET Password = 'GOOGLE_LOGIN' WHERE JobSeekerID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobSeekerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasPasswordAccount(String email) {
        String sql = "SELECT COUNT(*) FROM JobSeeker WHERE Email = ? AND Password != 'GOOGLE_LOGIN' AND Password IS NOT NULL";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isGoogleAccount(String email) {
        String sql = "SELECT COUNT(*) FROM JobSeeker WHERE Email = ? AND Password = 'GOOGLE_LOGIN'";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int countCandidates(String keyword, Integer locationId, Integer levelId, String gender, List<Integer> skillIds) {
        System.out.println("=== DEBUG countCandidates ===");
        System.out.println("keyword: " + keyword);
        System.out.println("locationId: " + locationId);
        System.out.println("levelId: " + levelId);
        System.out.println("gender: " + gender);
        System.out.println("skillIds: " + skillIds);
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT js.JobSeekerID) FROM JobSeeker js ");
        if (skillIds != null && !skillIds.isEmpty()) {
            sql.append("JOIN ProfileSkills ps ON ps.JobSeekerID = js.JobSeekerID ");
        }
        sql.append("WHERE 1=1 ");
        sql.append("AND js.Status = 'Active' ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Keyword áp dụng cho FullName/Headline/Address để hỗ trợ gõ 't', 'hc' lọc TP.HCM
            sql.append("AND (js.FullName LIKE ? OR js.Headline LIKE ? OR js.Address LIKE ?) ");
        }
        if (locationId != null) {
            sql.append("AND js.LocationID = ? ");
        }
        if (levelId != null) {
            sql.append("AND js.CurrentLevelID = ? ");
        }
        if (gender != null && !gender.equalsIgnoreCase("any") && !gender.isEmpty()) {
            sql.append("AND js.Gender = ? ");
        }
        if (skillIds != null && !skillIds.isEmpty()) {
            sql.append("AND ps.SkillID IN (");
            for (int i = 0; i < skillIds.size(); i++) {
                if (i > 0) {
                    sql.append(",");
                }
                sql.append("?");
            }
            sql.append(") ");
        }
        // Optional advanced filters: fullName, address, level/title contained in headline
        sql.append("/* advanced filters placeholders */ ");

        System.out.println("Final SQL: " + sql.toString());
        
        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                System.out.println("Added keyword parameters: " + like);
            }
            if (locationId != null) {
                ps.setInt(idx++, locationId);
                System.out.println("Added locationId parameter: " + locationId);
            }
            if (levelId != null) {
                ps.setInt(idx++, levelId);
                System.out.println("Added levelId parameter: " + levelId);
            }
            if (gender != null && !gender.equalsIgnoreCase("any") && !gender.isEmpty()) {
                ps.setString(idx++, gender);
                System.out.println("Added gender parameter: " + gender);
            }
            if (skillIds != null && !skillIds.isEmpty()) {
                for (Integer sid : skillIds) {
                    ps.setInt(idx++, sid);
                }
                System.out.println("Added skillIds parameters: " + skillIds);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Count result: " + count);
                return count;
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in countCandidates: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public List<JobSeeker> searchCandidates(String keyword, Integer locationId, Integer levelId, String gender,
            Integer minAge, Integer maxAge, List<Integer> skillIds,
            int offset, int limit,
            String fullNameLike, String addressLike, String levelOrTitleLike) {
        System.out.println("=== DEBUG searchCandidates ===");
        System.out.println("keyword: " + keyword);
        System.out.println("locationId: " + locationId);
        System.out.println("levelId: " + levelId);
        System.out.println("gender: " + gender);
        System.out.println("minAge: " + minAge);
        System.out.println("maxAge: " + maxAge);
        System.out.println("skillIds: " + skillIds);
        System.out.println("offset: " + offset);
        System.out.println("limit: " + limit);
        System.out.println("fullNameLike: " + fullNameLike);
        System.out.println("addressLike: " + addressLike);
        System.out.println("levelOrTitleLike: " + levelOrTitleLike);
        
        List<JobSeeker> results = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DISTINCT js.* FROM JobSeeker js ");
        if (skillIds != null && !skillIds.isEmpty()) {
            sql.append("JOIN ProfileSkills ps ON ps.JobSeekerID = js.JobSeekerID ");
        }
        sql.append("WHERE 1=1 ");
        sql.append("AND js.Status = 'Active' ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Keyword áp dụng cho FullName/Headline/Address để hỗ trợ gõ 't', 'hc' lọc TP.HCM
            sql.append("AND (js.FullName LIKE ? OR js.Headline LIKE ? OR js.Address LIKE ?) ");
        }
        if (locationId != null) {
            sql.append("AND js.LocationID = ? ");
        }
        if (levelId != null) {
            sql.append("AND js.CurrentLevelID = ? ");
        }
        if (gender != null && !gender.equalsIgnoreCase("any") && !gender.isEmpty()) {
            sql.append("AND js.Gender = ? ");
        }
        if (skillIds != null && !skillIds.isEmpty()) {
            sql.append("AND ps.SkillID IN (");
            for (int i = 0; i < skillIds.size(); i++) {
                if (i > 0) {
                    sql.append(",");
                }
                sql.append("?");
            }
            sql.append(") ");
        }
        if (fullNameLike != null && !fullNameLike.trim().isEmpty()) {
            sql.append("AND js.FullName LIKE ? ");
        }
        if (addressLike != null && !addressLike.trim().isEmpty()) {
            sql.append("AND js.Address LIKE ? ");
        }
        if (levelOrTitleLike != null && !levelOrTitleLike.trim().isEmpty()) {
            // Headline dùng để lưu ngành nghề/level và các thông tin liên quan
            sql.append("AND js.Headline LIKE ? ");
        }
        // minAge/maxAge: hiện chưa có DOB trong JobSeeker để tính tuổi -> bỏ qua

        sql.append("ORDER BY js.JobSeekerID DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try (PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (locationId != null) {
                ps.setInt(idx++, locationId);
            }
            if (levelId != null) {
                ps.setInt(idx++, levelId);
            }
            if (gender != null && !gender.equalsIgnoreCase("any") && !gender.isEmpty()) {
                ps.setString(idx++, gender);
            }
            if (skillIds != null && !skillIds.isEmpty()) {
                for (Integer sid : skillIds) {
                    ps.setInt(idx++, sid);
                }
            }
            if (fullNameLike != null && !fullNameLike.trim().isEmpty()) {
                ps.setString(idx++, "%" + fullNameLike.trim() + "%");
            }
            if (addressLike != null && !addressLike.trim().isEmpty()) {
                ps.setString(idx++, "%" + addressLike.trim() + "%");
            }
            if (levelOrTitleLike != null && !levelOrTitleLike.trim().isEmpty()) {
                ps.setString(idx++, "%" + levelOrTitleLike.trim() + "%");
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx++, limit);

            System.out.println("Final SQL: " + sql.toString());
            System.out.println("Executing query with offset: " + offset + ", limit: " + limit);
            
            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                JobSeeker js = extractJobSeeker(rs);
                results.add(js);
                count++;
                System.out.println("Found JobSeeker " + count + ": " + js.getFullName() + " (ID: " + js.getJobSeekerId() + ")");
            }
            System.out.println("Total results found: " + count);
        } catch (SQLException e) {
            System.out.println("SQL Error in searchCandidates: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Returning " + results.size() + " results");
        return results;
    }
    //Minh
}
