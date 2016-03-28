package com.meread.buildenv;

import java.io.Serializable;

public class HostInfo implements Serializable {
    public static final String DEFAULT_USER = "root";
    public static final int DEFAULT_PORT = 22;
    public static final String DEFAULT_PASSWORD = "vagrant";

    private String ip;
    private String hostName;
    private String user = DEFAULT_USER;
    private int port = DEFAULT_PORT;
    private String password = DEFAULT_PASSWORD;

    public HostInfo(String ip, String hostName, String user, int port, String password) {
        this.ip = ip;
        this.hostName = hostName;
        this.user = user;
        this.port = port;
        this.password = password;
    }

    public HostInfo(String ip, String hostName) {
        this.ip = ip;
        this.hostName = hostName;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public int getPort() {
        return port;
    }

    public void setPort(int port) {
        this.port = port;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        HostInfo hostInfo = (HostInfo) o;

        if (port != hostInfo.port) return false;
        if (!ip.equals(hostInfo.ip)) return false;
        if (!hostName.equals(hostInfo.hostName)) return false;
        if (!user.equals(hostInfo.user)) return false;
        return password.equals(hostInfo.password);

    }

    @Override
    public int hashCode() {
        int result = ip.hashCode();
        result = 31 * result + hostName.hashCode();
        result = 31 * result + user.hashCode();
        result = 31 * result + port;
        result = 31 * result + password.hashCode();
        return result;
    }
}
