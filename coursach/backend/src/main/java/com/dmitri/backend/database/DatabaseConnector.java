package com.dmitri.backend.database;

import javax.ejb.Singleton;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@Singleton
public class DatabaseConnector {

    private final String HOST = "pg";
    private final String DB_NAME = "studs";
    private final String USER = "s335102";
    private final String PASSWORD = "uB6g5zRTQ2CuB0cN";
    private final String URL = "jdbc:postgresql://" + HOST + ":5432" + DB_NAME;

    public DatabaseConnector() {}

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
