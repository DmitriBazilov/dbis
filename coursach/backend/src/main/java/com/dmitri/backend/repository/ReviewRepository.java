package com.dmitri.backend.repository;

import com.dmitri.backend.database.DatabaseConnector;
import com.dmitri.backend.dto.ReviewDTO;
import com.dmitri.backend.model.Review;
import com.dmitri.backend.util.SQLStatus;

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
public class ReviewRepository {

    @EJB
    private DatabaseConnector connector;

    public List<Review> getReviewsByFilm(int filmId) {
        try (Connection connection = connector.getConnection();
             PreparedStatement getReviews = connection.prepareStatement(
                     "select review.review, review.rating, film_id, u.login from review " +
                             "join film f on f.id = review.film_id " +
                             "join users u on u.id = review.user_id " +
                             "where review.film_id = ? limit 20"
             )) {
            getReviews.setInt(1, filmId);
            ResultSet rs = getReviews.executeQuery();
            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                reviews.add(mapEntryToReview(rs));
            }
            return reviews;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            return null;
        }
    }

    public SQLStatus submitReview(ReviewDTO review) {
        try (Connection connection = connector.getConnection();
             PreparedStatement addReview = connection.prepareStatement(
                     "insert into review (user_id, film_id, review, rating) " +
                             "values (?, ?, ?, ?)"
             )) {
            int idx = 1;
            addReview.setInt(idx++, review.getUserId());
            addReview.setInt(idx++, review.getFilmId());
            addReview.setString(idx++, review.getReview());
            addReview.setFloat(idx++, review.getRating());
            addReview.executeUpdate();
            return SQLStatus.OK;
        } catch (SQLException ex) {
            ex.printStackTrace();
            System.out.println(ex.getMessage());
            return SQLStatus.ERROR;
        }
    }

    private Review mapEntryToReview(ResultSet rs) throws SQLException {
        Review result = new Review();
        int idx = 1;
        result.setReview(rs.getString(idx++));
        result.setRating(rs.getFloat(idx++));
        result.setFilmId(rs.getInt(idx++));
        result.setLogin(rs.getString(idx++));
        return result;
    }
}
