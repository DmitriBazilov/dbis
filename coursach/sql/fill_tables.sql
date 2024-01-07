insert into country values (default, 'Россия', 'РФ');
insert into country values (default, 'Соединенные Штаты Америки', 'США');
insert into country values (default, 'Вьетнам', null);

insert into genre values (default, 'Комедия');
insert into genre values (default, 'Драма');
insert into genre values (default, 'Триллер');

-- todo subquery instead of hardcode country_id
insert into actor values (default, 2, 'Джони Деп');
insert into actor values (default, 2, 'Раян Гослинг');
insert into actor values (default, 1, 'Сергей Бодров');
insert into actor values (default, 2, 'Том Хэнкс');

insert into writer values (default, 2, 'Квентин Тарантино');
insert into writer values (default, 1, 'Алексей Балабанов');
insert into writer values (default, 2, 'Эрик Рот');

insert into director values (default, 2, 'Квентин Тарантино');
insert into director values (default, 2, 'Роберт Земекис');
insert into director values (default, 1, 'Алексей Балабанов');

insert into film values (default, 3, 2, '2019-02-02'::date, 'Брат', 'description', default);
insert into film values (default, 3, 2, '2019-02-03'::date, 'Брат 2', 'description', default);
insert into film values (default, 1, 1, '2019-03-02'::date, 'Криминальное чтиво', 'description', default);
insert into film values (default, 2, 3, '2013-02-02'::date, 'Форест Гамп', 'description', default);

insert into studio values (default, 1, 'Киностудия им. М. Горького');
insert into studio values (default, 2, 'Marvel');

insert into users values (default, 'test1337', 'test1337', 'stepka', 'img.com/test');
insert into users values (default, 'tester_pivka', 'qwerty123', 'dimka', 'img.com/pivo');

insert into rating_aggregator values (default, 'metacritic');
insert into rating_aggregator values (default, 'imdb');

insert into film_rating values (
    (select id from film where film_name='Форест Гамп'),
    (select id from rating_aggregator where aggregator_name='imdb'),
    10
);

insert into film_rating values (
    (select id from film where film_name='Брат 2'),
    (select id from rating_aggregator where aggregator_name='metacritic'),
    8.6
);

insert into actor_film values (
    (select id from actor where actor_name = 'Сергей Бодров' limit 1),
    (select id from film where film_name = 'Брат' limit 1)
);
insert into actor_film values (
    (select id from actor where actor_name = 'Сергей Бодров' limit 1),
    (select id from film where film_name = 'Брат 2' limit 1)
);
insert into actor_film values (
    (select id from actor where actor_name = 'Том Хэнкс' limit 1),
    (select id from film where film_name = 'Форест Гамп' limit 1)
);
insert into actor_film values (
    (select id from actor where actor_name = 'Раян Гослинг' limit 1),
    (select id from film where film_name = 'Брат 2' limit 1)
);
insert into actor_film values (
    (select id from actor where actor_name = 'Джони Деп' limit 1),
    (select id from film where film_name = 'Криминальное чтиво' limit 1)
);

insert into film_location values (
    (select id from film where film_name = 'Форест Гамп'),
    2
);
insert into film_location values (
    (select id from film where film_name = 'Форест Гамп'),
    3
);
insert into film_location values (
    (select id from film where film_name='Криминальное чтиво'),
    2
);
insert into film_location values (
    (select id from film where film_name = 'Брат'),
    1
);
insert into film_location values (
    (select id from film where film_name = 'Брат 2'),
    1
);
insert into film_location values (
    (select id from film where film_name = 'Брат 2'),
    2
);

insert into trailer values (
    default,
    (select id from film where film_name = 'Форест Гамп' limit 1),
    'youtube.com/trailer_forest_gump'
);
insert into trailer values (
    default,
    (select id from film where film_name = 'Брат 2' limit 1),
    'youtube.com/trailer_brat_2'
);
insert into trailer values (
    default,
    (select id from film where film_name = 'Криминальное чтиво' limit 1),
    'youtube.com/pulp_fiction_trailer'
);

insert into review values (
    (select id from users where login='tester_pivka'),
    (select id from film where film_name='Форест Гамп'),
    'лучший фильм всех времен и народов. шедевр мирового кинематографа',
    10.0
);
insert into review values (
                           (select id from users where login='tester_pivka'),
                           (select id from film where film_name='Брат'),
                           'BABABABABA',
                           5.55
                          );
insert into review values (
                              (select id from users where login='tester_pivka'),
                              (select id from film where film_name='Криминальное чтиво'),
                              'BABABABABA',
                              7.66
                          );
insert into review values (
    (select id from users where login='test1337'),
    (select id from film where film_name='Брат 2'),
    'Первая часть намного лучше!!!!',
    5
);
insert into review values (
    (select id from users where login='test1337'),
    (select id from film where film_name='Форест Гамп'),
    'Дурацкий фильм об американской пропаганде. ТЬФУ!!!',
    2.5
);

insert into film_status_for_user values (
    (select id from users where login='test1337' limit 1),
    (select id from film where film_name='Форест Гамп'),
    'Просмотрено'
);
insert into film_status_for_user values (
    (select id from users where login='test1337' limit 1),
    (select id from film where film_name='Брат'),
    'В планах'
);
insert into film_status_for_user values (
    (select id from users where login='test1337' limit 1),
    (select id from film where film_name='Криминальное чтиво'),
    'Бросил'
);

insert into film_genre values (
    (select id from film where film_name='Форест Гамп'),
    (select id from genre where genre.genre='Драма')
);
insert into film_genre values (
    (select id from film where film_name='Форест Гамп'),
    (select id from genre where genre.genre='Комедия')
);
insert into film_genre values (
    (select id from film where film_name='Брат 2'),
    (select id from genre where genre.genre='Триллер')
);
insert into film_genre values (
    (select id from film where film_name='Брат'),
    (select id from genre where genre.genre='Триллер')
);
insert into film_genre values (
    (select id from film where film_name='Криминальное чтиво'),
    (select id from genre where genre.genre='Драма')
);