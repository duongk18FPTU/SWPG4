package dal;

import model.JobSkillMapping;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobSkillMappingDAO extends DBContext {
    
    // Thêm mapping giữa Job và Skill
    public boolean addMapping(int jobID, int skillID) {
        // Validate input
        if (jobID <= 0 || skillID <= 0) {
            System.out.println("DEBUG JobSkillMappingDAO: Invalid input - JobID: " + jobID + ", SkillID: " + skillID);
            return false;
        }
        
        // Kiểm tra xem mapping đã tồn tại chưa
        if (mappingExists(jobID, skillID)) {
            System.out.println("DEBUG JobSkillMappingDAO: Mapping already exists - JobID: " + jobID + ", SkillID: " + skillID);
            return true; // Đã tồn tại, không cần insert lại
        }
        
        // Thử cả hai tên bảng (JobSkillMapping và JobSkillMappings)
        String[] tableNames = {"JobSkillMapping", "JobSkillMappings"};
        
        for (String tableName : tableNames) {
            String sql = "INSERT INTO " + tableName + " (JobID, SkillID) VALUES (?, ?)";
            
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, jobID);
                ps.setInt(2, skillID);
                
                System.out.println("DEBUG JobSkillMappingDAO: Attempting to insert into " + tableName + " - JobID: " + jobID + ", SkillID: " + skillID);
                int rowsAffected = ps.executeUpdate();
                System.out.println("DEBUG JobSkillMappingDAO: Insert result - rows affected: " + rowsAffected);
                
                if (rowsAffected > 0) {
                    System.out.println("DEBUG JobSkillMappingDAO: Successfully inserted mapping into " + tableName);
                    return true;
                } else {
                    System.out.println("DEBUG JobSkillMappingDAO: WARNING - No rows affected for " + tableName);
                }
            } catch (SQLException e) {
                // Nếu là lỗi tên bảng, tiếp tục thử tên bảng tiếp theo
                if (e.getMessage() != null && (e.getMessage().contains("Invalid object name") || e.getMessage().contains("does not exist"))) {
                    System.out.println("DEBUG JobSkillMappingDAO: Table " + tableName + " does not exist, trying next...");
                    continue;
                }
                
                System.out.println("DEBUG JobSkillMappingDAO: SQL Exception occurred for " + tableName + "!");
                System.out.println("DEBUG JobSkillMappingDAO: Error Code: " + e.getErrorCode());
                System.out.println("DEBUG JobSkillMappingDAO: SQL State: " + e.getSQLState());
                System.out.println("DEBUG JobSkillMappingDAO: Message: " + e.getMessage());
                System.out.println("DEBUG JobSkillMappingDAO: JobID: " + jobID + ", SkillID: " + skillID);
                
                // Nếu là lỗi ràng buộc khóa ngoại hoặc lỗi khác không phải tên bảng, trả về false
                if (e.getErrorCode() != 208) { // 208 = Invalid object name
                    e.printStackTrace();
                    return false;
                }
            } catch (Exception e) {
                System.out.println("DEBUG JobSkillMappingDAO: General Exception for " + tableName + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        System.out.println("DEBUG JobSkillMappingDAO: Failed to insert mapping after trying all table names");
        return false;
    }
    
    // Kiểm tra mapping đã tồn tại chưa
    public boolean mappingExists(int jobID, int skillID) {
        // Thử cả hai tên bảng
        String[] tableNames = {"JobSkillMapping", "JobSkillMappings"};
        
        for (String tableName : tableNames) {
            String sql = "SELECT COUNT(*) FROM " + tableName + " WHERE JobID = ? AND SkillID = ?";
            
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, jobID);
                ps.setInt(2, skillID);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    if (count > 0) {
                        System.out.println("DEBUG JobSkillMappingDAO: Mapping exists in " + tableName);
                        return true;
                    }
                }
            } catch (SQLException e) {
                // Nếu là lỗi tên bảng, tiếp tục thử tên bảng tiếp theo
                if (e.getMessage() != null && (e.getMessage().contains("Invalid object name") || e.getMessage().contains("does not exist"))) {
                    continue;
                }
                System.out.println("DEBUG JobSkillMappingDAO: Error checking mapping existence in " + tableName + ": " + e.getMessage());
            }
        }
        return false;
    }
    
    // Lấy tất cả skills của một job
    public List<Integer> getSkillIDsByJobID(int jobID) {
        List<Integer> skillIDs = new ArrayList<>();
        // Thử cả hai tên bảng
        String[] tableNames = {"JobSkillMapping", "JobSkillMappings"};
        
        for (String tableName : tableNames) {
            String sql = "SELECT SkillID FROM " + tableName + " WHERE JobID = ?";
            
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, jobID);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    skillIDs.add(rs.getInt("SkillID"));
                }
                // Nếu thực thi thành công (không có ngoại lệ), trả về kết quả (kể cả rỗng)
                return skillIDs;
            } catch (SQLException e) {
                // Nếu là lỗi tên bảng, tiếp tục thử tên bảng tiếp theo
                if (e.getMessage() != null && (e.getMessage().contains("Invalid object name") || e.getMessage().contains("does not exist"))) {
                    continue;
                }
                System.out.println("DEBUG JobSkillMappingDAO: Error getting skills from " + tableName + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
        return skillIDs;
    }
    
    // Xóa mapping theo JobID
    public boolean deleteMappingsByJobID(int jobID) {
        // Thử cả hai tên bảng
        String[] tableNames = {"JobSkillMapping", "JobSkillMappings"};
        
        for (String tableName : tableNames) {
            String sql = "DELETE FROM " + tableName + " WHERE JobID = ?";
            
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, jobID);
                int rowsAffected = ps.executeUpdate();
                System.out.println("DEBUG JobSkillMappingDAO: Deleted " + rowsAffected + " mappings from " + tableName + " for JobID: " + jobID);
                return true; // Thành công hoặc bảng không tồn tại đều trả về true (vì mục tiêu đều là xóa)
            } catch (SQLException e) {
                // Nếu là lỗi tên bảng, tiếp tục thử tên bảng tiếp theo
                if (e.getMessage() != null && (e.getMessage().contains("Invalid object name") || e.getMessage().contains("does not exist"))) {
                    continue;
                }
                System.out.println("DEBUG JobSkillMappingDAO: Error deleting mappings from " + tableName + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
        return false;
    }
    
    // Xóa một mapping cụ thể
    public boolean deleteMapping(int jobID, int skillID) {
        // Thử cả hai tên bảng
        String[] tableNames = {"JobSkillMapping", "JobSkillMappings"};
        
        for (String tableName : tableNames) {
            String sql = "DELETE FROM " + tableName + " WHERE JobID = ? AND SkillID = ?";
            
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, jobID);
                ps.setInt(2, skillID);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                // Nếu là lỗi tên bảng, tiếp tục thử tên bảng tiếp theo
                if (e.getMessage() != null && (e.getMessage().contains("Invalid object name") || e.getMessage().contains("does not exist"))) {
                    continue;
                }
                e.printStackTrace();
            }
        }
        return false;
    }
}

