package com.dmitri.backend.repository;

import com.dmitri.backend.database.DatabaseConnector;
import com.dmitri.backend.dto.UserDTO;
import com.dmitri.backend.model.User;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ejb.TransactionManagement;
import java.sql.*;

@Stateless
@TransactionManagement(javax.ejb.TransactionManagementType.BEAN)
public class UserRepository {

    @EJB
    private DatabaseConnector databaseConnector;

    public void addUser(UserDTO user) {
        try (Connection connection = databaseConnector.getConnection();
             PreparedStatement addUser = connection.prepareStatement(
                     "insert into users (id, login, password, name, avatar) " +
                             "values (default, ?, ?, ?, ?)"
             )) {
            addUser.setString(1, user.getLogin());
            addUser.setString(2, user.getPassword());
            addUser.setString(3, user.getName());
            addUser.setString(4, user.getAvatar());
            addUser.executeUpdate();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public User getUserByUsername(String login) {
        try (Connection connection = databaseConnector.getConnection();
             PreparedStatement getUser = connection.prepareStatement(
                     "select (login, name, password) from users where login = ? limit 1"
             )
        ) {
            getUser.setString(1, login);
            ResultSet rs = getUser.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getString(1),
                        rs.getString(2),
                        rs.getString(3)
                );
            } else {
                return null;
            }
        } catch (SQLException ex) {
            return null;
        }
    }

}
