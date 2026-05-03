package com.skillnova.model;

import java.util.List;

public class SystemControlOverview {
    private int activeUsers;
    private int suspendedUsers;
    private int rejectedUsers;
    private List<RolePermission> permissions;

    public int getActiveUsers() {
        return activeUsers;
    }

    public void setActiveUsers(int activeUsers) {
        this.activeUsers = activeUsers;
    }

    public int getSuspendedUsers() {
        return suspendedUsers;
    }

    public void setSuspendedUsers(int suspendedUsers) {
        this.suspendedUsers = suspendedUsers;
    }

    public int getRejectedUsers() {
        return rejectedUsers;
    }

    public void setRejectedUsers(int rejectedUsers) {
        this.rejectedUsers = rejectedUsers;
    }

    public List<RolePermission> getPermissions() {
        return permissions;
    }

    public void setPermissions(List<RolePermission> permissions) {
        this.permissions = permissions;
    }
}
