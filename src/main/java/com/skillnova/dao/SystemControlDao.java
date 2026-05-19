package com.skillnova.dao;

import com.skillnova.model.RolePermission;
import com.skillnova.model.SystemControlOverview;
import com.skillnova.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SystemControlDao {

    public SystemControlOverview getOverview() throws SQLException {
        SystemControlOverview overview = new SystemControlOverview();
        if (!tableExists("users")) {
            overview.setPermissions(loadPermissions());
            return overview;
        }
        overview.setActiveUsers(countByStatus("ACTIVE"));
        overview.setSuspendedUsers(countByStatus("SUSPENDED"));
        overview.setRejectedUsers(countByStatus("REJECTED"));
        overview.setPermissions(loadPermissions());
        return overview;
    }

    public boolean updateUserStatus(long userId, String status) throws SQLException {
        if (!tableExists("users")) {
            return false;
        }
        final String sql = "UPDATE users SET account_status = ? WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setLong(2, userId);
            return statement.executeUpdate() == 1;
        }
    }

    private boolean tableExists(String tableName) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, tableName);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) > 0;
            }
        }
    }

    private int countByStatus(String status) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM users WHERE account_status = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
                return 0;
            }
        }
    }

    private List<RolePermission> loadPermissions() {
        List<RolePermission> permissions = new ArrayList<>();

        permissions.add(buildPermission(1, "ADMIN_MANAGE_USERS", "Approve, reject, suspend, and activate user accounts"));
        permissions.add(buildPermission(2, "ADMIN_MONITOR_JOBS", "Monitor all posted jobs and their current status"));
        permissions.add(buildPermission(3, "ADMIN_MONITOR_APPLICATIONS", "Review all freelancer applications across jobs"));
        permissions.add(buildPermission(4, "CLIENT_MANAGE_OWN_JOBS", "Create and manage jobs owned by the logged-in client"));
        permissions.add(buildPermission(5, "FREELANCER_APPLY_JOBS", "Apply to open jobs and track application status"));

        return permissions;
    }

    private RolePermission buildPermission(long id, String code, String description) {
        RolePermission permission = new RolePermission();
        permission.setPermissionId(id);
        permission.setPermissionCode(code);
        permission.setDescription(description);
        return permission;
    }
}
