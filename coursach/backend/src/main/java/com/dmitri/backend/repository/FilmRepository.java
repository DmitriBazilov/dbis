package com.dmitri.backend.repository;

import com.dmitri.backend.database.DatabaseConnector;
import com.dmitri.backend.dto.FilmWithInfo;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ejb.TransactionManagement;
import javax.ejb.TransactionManagementType;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Stateless
@TransactionManagement(TransactionManagementType.BEAN)
public class FilmRepository {

    @EJB
    private DatabaseConnector databaseConnector;

    public List<FilmWithInfo> getFilmsByPageWithSort(int page, String sortFactor) {
        try (Connection connection = databaseConnector.getConnection();
             PreparedStatement getFilms = connection.prepareStatement(
                     "select * from getpage(?, ?)"
             )) {
            getFilms.setInt(1, page);
            getFilms.setString(2, sortFactor);
            ResultSet rs = getFilms.executeQuery();
            List<FilmWithInfo> films = new ArrayList<>();
            while (rs.next()) {
                films.add(setEntryToFilmWithInfo(rs));
            }
            return films;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            return null;
        }
    }

    public FilmWithInfo setEntryToFilmWithInfo(ResultSet rs) {
        return new FilmWithInfo();
    }
}
