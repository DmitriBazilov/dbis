package com.dmitri.backend.controller;

import com.dmitri.backend.dto.FilmWithInfo;
import com.dmitri.backend.repository.FilmRepository;
import org.json.JSONObject;

import javax.ejb.EJB;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("/films")
public class FilmController {

    @EJB
    private FilmRepository filmRepository;

    @GET
    @Path("get-page")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getFilmsPage(int page) {
        List<FilmWithInfo> films = filmRepository.getFilmsByPageWithSort(page, "film_rating");
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("films", films);
        return Response.ok().entity(jsonResponse.toString()).build();
    }

    @GET
    @Path("get-page-with-sort")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getFilmsPage(int page, String sortFactor) {
        List<FilmWithInfo> films = filmRepository.getFilmsByPageWithSort(page, sortFactor);
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("films", films);
        return Response.ok().entity(jsonResponse.toString()).build();
    }
}
