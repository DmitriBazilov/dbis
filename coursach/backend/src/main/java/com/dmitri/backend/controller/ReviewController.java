package com.dmitri.backend.controller;

import com.dmitri.backend.dto.ReviewDTO;
import com.dmitri.backend.dto.UserDTO;
import com.dmitri.backend.model.Review;
import com.dmitri.backend.model.ReviewRequest;
import com.dmitri.backend.model.User;
import com.dmitri.backend.repository.ReviewRepository;
import com.dmitri.backend.repository.UserRepository;
import com.dmitri.backend.util.SQLStatus;
import org.json.JSONObject;

import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("/review")
public class ReviewController {

    @EJB
    private ReviewRepository reviewRepository;

    @EJB
    private UserRepository userRepository;

    @GET
    @Path("/get-reviews-by-film")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getReviewsByFilm(ReviewRequest request) {
        List<Review> reviews = reviewRepository.getReviewsByFilm(request.getFilmId());
        if (reviews == null) {
            return Response.status(405).build();
        } else {
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("reviews", reviews);
            return Response.ok().entity(jsonResponse.toString()).build();
        }
    }

    @POST
    @Path("submit-review")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response submitReview(ReviewRequest request) {
        UserDTO user = userRepository.getUserDTOByUsername(request.getLogin());
        if (user.getPassword().equals(request.getPassword())) {
            SQLStatus status = reviewRepository.submitReview(new ReviewDTO(
                    user.getId(),
                    request.getFilmId(),
                    request.getReview(),
                    request.getRating()
            ));
            if (status == SQLStatus.OK) {
                return Response.ok().build();
            } else {
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("message", "Вы уже оставляли отзыв на данный фильм");
                return Response.status(400).entity(jsonResponse.toString()).build();
            }
        } else {
            return Response.status(401).build();
        }
    }
}
