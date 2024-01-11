package com.dmitri.backend.controller;

import com.dmitri.backend.dto.FilmWithInfo;
import com.dmitri.backend.model.FilmPage;
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

    private final List<String> supportedFactors = List.of(
            "release_date",
            "film_rating",
            "film_name"
    );

    @GET
    @Path("get-page")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getFilmsPage(FilmPage page) {
        if (!supportedFactors.contains(page.getSortFactor())) {
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("error", "Данная сортировка не поддерживается.");
            return Response.status(400).entity(jsonResponse.toString()).build();
        }
        if (page.getSortFactor() == null) {
            page.setSortFactor("film_rating");
        }
        List<FilmWithInfo> films = filmRepository.getFilmsByPageWithSort(page.getPage(), page.getSortFactor());
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("films", films);
        return Response.ok().entity(jsonResponse.toString()).build();
    }
}
