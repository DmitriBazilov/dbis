package com.dmitri.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FilmWithInfo {

    private int id;
    private String filmName;
    private String filmDescription;
    private double filmRating;
    private Date releaseDate;
    private WriterDTO writer;
    private DirectorDTO director;
    private List<String> genreList;
    private List<ActorDTO> actorsList;
    private String studioName;
}
