package com.dmitri.backend.repository;

import com.dmitri.backend.database.DatabaseConnector;
import com.dmitri.backend.dto.ActorDTO;
import com.dmitri.backend.dto.DirectorDTO;
import com.dmitri.backend.dto.FilmWithInfo;
import com.dmitri.backend.dto.WriterDTO;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ejb.TransactionManagement;
import javax.ejb.TransactionManagementType;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Stateless
@TransactionManagement(TransactionManagementType.BEAN)
public class FilmRepository {

    @EJB
    private DatabaseConnector databaseConnector;

    public List<FilmWithInfo> getFilmsByPageWithSort(int page, String sortFactor) {
        try (Connection connection = databaseConnector.getConnection();
             PreparedStatement getFilms = connection.prepareStatement(
                     "select * from getpage(?, ?)"
             );
             PreparedStatement getActors = connection.prepareStatement(
                     "select film_id, actor_id, actor_name from actor" +
                             " join s335102.actor_film af on actor.id = af.actor_id " +
                             " where af.film_id in (select film_id from getpage(?, ?))"
             );
             PreparedStatement getGenres = connection.prepareStatement(
                     "select film_id, genre.genre from genre" +
                             " join s335102.film_genre fg on genre.id = fg.genre_id" +
                             " where fg.film_id in (select film_id from getpage(?, ?))"
        )) {
            getFilms.setInt(1, page);
            getFilms.setString(2, sortFactor);
            getActors.setInt(1, page);
            getActors.setString(2, sortFactor);
            getGenres.setInt(1, page);
            getGenres.setString(2, sortFactor);
            ResultSet filmRS = getFilms.executeQuery();
            ResultSet actorRS = getActors.executeQuery();
            Map<Integer, List<ActorDTO>> actors = actorsResultSetToMap(actorRS);
            ResultSet genreRS = getGenres.executeQuery();
            Map<Integer, List<String>> genres = genresResultSetToMap(genreRS);
            List<FilmWithInfo> films = new ArrayList<>();
            while (filmRS.next()) {
                films.add(setEntryToFilmWithInfo(filmRS, actors, genres));
            }
            return films;
        } catch (SQLException ex) {
            ex.printStackTrace();
            System.out.println(ex.getMessage());
            return null;
        }
    }

    private Map<Integer, List<String>> genresResultSetToMap(ResultSet genreRS) throws SQLException {
        Map<Integer, List<String>> result = new HashMap<>();
        while (genreRS.next()) {
            Integer id = genreRS.getInt(1);
            String genre = genreRS.getString(2);
            if (result.get(id) == null) {
                List<String> t = new ArrayList<>();
                t.add(genre);
                result.put(id, t);
            } else {
                result.get(id).add(genre);
            }
        }
        return result;
    }

    private Map<Integer, List<ActorDTO>> actorsResultSetToMap(ResultSet actorRS) throws SQLException {
        Map<Integer, List<ActorDTO>> result = new HashMap<>();
        while (actorRS.next()) {
            Integer filmId = actorRS.getInt(1);
            int actorId = actorRS.getInt(2);
            String actorName = actorRS.getString(3);
            if (result.get(filmId) == null) {
                List<ActorDTO> t = new ArrayList<>();
                t.add(new ActorDTO(actorId, actorName));
                result.put(filmId, t);
            } else {
                result.get(filmId).add(new ActorDTO(actorId, actorName));
            }
        }
        return result;
    }

    public FilmWithInfo setEntryToFilmWithInfo(ResultSet rs,
                                               Map<Integer, List<ActorDTO>> actors,
                                               Map<Integer, List<String>> genres) throws SQLException {
        FilmWithInfo result = new FilmWithInfo();
        int idx = 1;
        result.setId(rs.getInt(idx++));
        result.setFilmName(rs.getString(idx++));
        result.setFilmDescription(rs.getString(idx++));
        result.setFilmRating(rs.getFloat(idx++));
        result.setReleaseDate(rs.getDate(idx++));
        result.setWriter(
                new WriterDTO(rs.getInt(idx++), rs.getString(idx++))
        );
        result.setDirector(
                new DirectorDTO(rs.getInt(idx++), rs.getString(idx++))
        );
        result.setStudioName(rs.getString(idx++));
        result.setActorsList(actors.get(result.getId()));
        result.setGenreList(genres.get(result.getId()));
        return result;
    }

}
