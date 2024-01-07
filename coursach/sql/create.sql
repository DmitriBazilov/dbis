CREATE TABLE IF NOT EXISTS country (
    id serial PRIMARY KEY,
    counry_name varchar(40) not null,
    country_short_name varchar(8)
);

CREATE TABLE IF NOT EXISTS genre (
    id serial PRIMARY KEY,
    genre varchar(30) not null
);

CREATE TABLE IF NOT EXISTS rating_aggregator (
    id serial PRIMARY KEY,
    aggregator_name varchar(30) not null
);

CREATE TABLE IF NOT EXISTS actor (
    id serial PRIMARY KEY,
    country_id int not null references country(id),
    actor_name varchar(60)
);

CREATE TABLE IF NOT EXISTS director (
    id serial PRIMARY KEY,
    country_id int not null references country(id),
    director_name varchar(60)
);

CREATE TABLE IF NOT EXISTS writer (
    id serial PRIMARY KEY,
    country_id int not null references country(id),
    writer_name varchar(60)
);

CREATE TABLE IF NOT EXISTS studio (
    id serial PRIMARY KEY,
    country_id int not null references country(id),
    studio_name varchar(60)
);

CREATE TABLE IF NOT EXISTS users (
    id serial PRIMARY KEY,
    login varchar(30),
    password varchar(255),
    name varchar(60),
    avatar varchar(255)
);

CREATE TABLE IF NOT EXISTS film (
    id serial PRIMARY KEY,
    director_id int not null references director(id),
    writer_id int not null references writer(id),
    release_date date not null,
    film_name varchar(60),
    film_description text,
    film_rating float DEFAULT 0.0
);

create index rating_index on film(film_rating);
create index release_date_index on film(release_date);

CREATE TABLE IF NOT EXISTS trailer (
    id serial PRIMARY KEY,
    film_id int not null references film(id),
    trailer varchar(255)
);

CREATE TABLE IF NOT EXISTS actor_film (
    actor_id int not null references actor(id),
    film_id int not null references film(id),
    PRIMARY KEY(actor_id, film_id)
);

CREATE TABLE IF NOT EXISTS film_location (
    film_id int not null references film(id),
    country_id int references country(id),
    PRIMARY KEY(film_id, country_id)
);

CREATE TABLE IF NOT EXISTS film_studio (
    film_id int not null references film(id),
    studio_id int references studio(id),
    PRIMARY KEY(film_id, studio_id)
);

CREATE TABLE IF NOT EXISTS review (
    user_id int not null references users(id),
    film_id int not null references film(id),
    review text,
    rating float,
    PRIMARY KEY(user_id, film_id)
);

create index on review(film_id);

CREATE TABLE IF NOT EXISTS film_status_for_user (
    user_id int not null references users(id),
    film_id int not null references film(id),
    status varchar(30),
    PRIMARY KEY(user_id, film_id)
);

CREATE TABLE IF NOT EXISTS film_genre (
    film_id int not null references film(id),
    genre_id int not null references genre(id),
    PRIMARY KEY(film_id, genre_id)
);

CREATE TABLE IF NOT EXISTS film_rating (
    film_id int not null references film(id),
    aggregator_id int not null references rating_aggregator(id),
    rating float not null,
    PRIMARY KEY(film_id, aggregator_id)
);
