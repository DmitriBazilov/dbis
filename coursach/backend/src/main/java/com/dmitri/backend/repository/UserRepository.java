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
                     "select login, name, password from users where login = ?"
             )
        ) {
            getUser.setString(1, login);
            ResultSet rs = getUser.executeQuery();
            if (rs.next()) {
                System.out.println("WE ARE HERE");
                return new User(
                        rs.getString(1),
                        rs.getString(2),
                        rs.getString(3)
                );
            } else {
                System.out.println("WE ARE NOT HERE");
                return null;
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            System.out.println("MB WE ARE HERE");
            return null;
        }
    }

    public UserDTO getUserDTOByUsername(String login) {
        try (Connection connection = databaseConnector.getConnection();
             PreparedStatement getUser = connection.prepareStatement(
                     "select id, login, name, password, avatar from users where login = ?"
             )
        ) {
            getUser.setString(1, login);
            ResultSet rs = getUser.executeQuery();
            if (rs.next()) {
                int idx = 1;
                UserDTO userDTO = new UserDTO();
                userDTO.setId(rs.getInt(idx++));
                userDTO.setLogin(rs.getString(idx++));
                userDTO.setName(rs.getString(idx++));
                userDTO.setPassword(rs.getString(idx++));
                userDTO.setAvatar(rs.getString(idx++));
                return userDTO;
            } else {
                return null;
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            return null;
        }
    }

}
