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
    select avg(rating) into users_rating
    from review where review.film_id=get_film_id;
    return users_rating;
end;
$$;

create or replace trigger check_update
    after insert on review
    for each row
    execute procedure updateRating();

create or replace function getPage(n integer, order_col text = 'film_rating')
returns setof film
language plpgsql
as
$$
DECLARE
    n2 integer = n*2;
Begin
    return query execute format('
        select * from film
        ORDER BY %I desc
        offset %s rows
        fetch next 2 rows only
    ', order_col, n2);
end
$$;

select * from getPage(0, 'release_date')


