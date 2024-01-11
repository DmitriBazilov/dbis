package com.dmitri.backend.controller;

import com.dmitri.backend.dto.UserDTO;
import com.dmitri.backend.model.User;
import com.dmitri.backend.repository.UserRepository;
import org.json.JSONObject;

import javax.ejb.EJB;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.Map;

@Path("/auth")
public class AuthController {

    @EJB
    private UserRepository userRepository;

    @GET
    @Path("/login")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getTempLog() {
        JSONObject jsonResopnse = new JSONObject();
        jsonResopnse.append("login", "ivan");
        jsonResopnse.append("password", "12345678");
        jsonResopnse.append("token", "qwerty123452281337");
        return Response.ok(jsonResopnse.toString()).build();
    }

    @POST
    @Path("/authorize")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response authorize(User data) {
        String error = "";
        System.out.println(data.getLogin() + " " + data.getPassword());
        User user = userRepository.getUserByUsername(data.getLogin());
        if (user == null) {
            error = "Такого пользователя не существует.";
        } else if (!user.getPassword().equals(data.getPassword())) {
            error = "Неправильный пароль";
        } else {
            return Response.ok().build();
        }
        return Response.status(400).entity(new JSONObject(Map.of("message", error)).toString()).build();
    }

    @POST
    @Path("/register")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response register(User data) {
        User dbUser = userRepository.getUserByUsername(data.getLogin());
        if (dbUser == null) {
            UserDTO dto = new UserDTO();
            dto.setLogin(data.getLogin());
            dto.setPassword(data.getPassword());
            userRepository.addUser(dto);
            return Response.ok().build();
        } else {
            String error = "Такой пользователь уже существует";
            JSONObject jsonResopnse = new JSONObject();
            jsonResopnse.put("message", error);
            return Response.status(400).entity(jsonResopnse.toString()).build();
        }

    }
}
