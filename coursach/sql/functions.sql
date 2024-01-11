CREATE OR REPLACE FUNCTION updateRating()
    returns trigger
    language plpgsql
as
$$
Begin
    update film
    set film_rating = getRating(new.film_id)
    where film.id = new.film_id;
    return new;
end;
$$;

create or replace function getRating(get_film_id integer)
    returns float
    language plpgsql
as
$$
DECLARE
    users_rating float;
BEGIN
    select avg(rating)
    into users_rating
    from review
    where review.film_id = get_film_id;
    return users_rating;
end;
$$;

create or replace trigger check_update
    after insert
    on review
    for each row
execute procedure updateRating();

create or replace function getPage(n integer, order_col text = 'film_rating')
    returns table (
        film_id integer,
        film_name varchar,
        film_description text,
        film_rating float,
        release_date date,
        writer_id int,
        writer_name varchar,
        director_id int,
        director_name varchar,
        studio_name varchar
                  )
    language plpgsql
as
$$
DECLARE
    n2 integer = n * 2;
Begin
    return query execute format('
        select film.id,
                film_name,
                film_description,
                film_rating,
                release_date,
                writer_id,
                writer_name, director_id, director_name,
                studio_name
        from film
                 left join director on director.id = film.director_id
                 left join writer on writer.id = film.writer_id
                 left join film_studio on film.id = film_studio.film_id
                 left join studio on studio.id = film_studio.studio_id
        order by %I desc
        offset %s rows
        fetch first 2 rows only;
    ', order_col, n2);
end
$$;

drop function getPage(n integer, order_col text);
select * from getPage(1, 'release_date');

select film.id,
       film_name,
       film_description,
       film_rating,
       release_date,
       writer_id,
       writer_name, director_id, director_name,
       studio_name
from film
         left join director on director.id = film.director_id
         left join writer on writer.id = film.writer_id
         left join film_studio on film.id = film_studio.film_id
         left join studio on studio.id = film_studio.studio_id
order by film_rating desc;
-- offset 2 rows
-- fetch first 2 rows only;