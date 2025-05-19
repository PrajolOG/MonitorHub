package com.MonitorHub.model;

import java.io.Serializable;

public class Role implements Serializable {

    private static final long serialVersionUID = 1L;

    private int roleid;
    private String roleName;

    public Role() {}

    public Role(int roleid, String roleName) {
        this.roleid = roleid;
        this.roleName = roleName;
    }

    // Getters and Setters
    public int getRoleid() { return roleid; }
    public void setRoleid(int roleid) { this.roleid = roleid; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    @Override
    public String toString() {
        return "Role{" + "roleid=" + roleid + ", roleName='" + roleName + '\'' + '}';
    }
}