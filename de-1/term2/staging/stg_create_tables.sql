/*
IMDB reduced size dataset: https://relational.fit.cvut.cz/dataset/IMDb
Dataset was stored on a MariaDB server from which I extracted the data as TSV files
*/

create database imdb;

use imdb;

-- drop existing tables

drop table if exists actors;
drop table if exists directors;
drop table if exists directors_genres;
drop table if exists movies;
drop table if exists movies_directors;
drop table if exists movies_genres;
drop table if exists roles;

-- Below DDL was retrieved from the source MariaDB database with the built-in DataGrip DDL generator

create table actors
(
    id int default 0 not null
    primary key,
    first_name varchar(100) null,
    last_name varchar(100) null,
    gender char null,
    film_count int default 0 null
);

create table directors
(
    id int default 0 not null
    primary key,
    first_name varchar(100) null,
    last_name varchar(100) null
);

create table directors_genres
(
    director_id int null,
    genre varchar(100) null,
    prob float null,
    constraint directors_genres_ibfk_1
        foreign key (director_id) references directors (id)
            on update cascade on delete cascade
);

create table movies
(
    id int default 0 not null
    primary key,
    `name` varchar(100) null,
    `year` int null,
    `rank` float null
);

create table movies_directors
(
    director_id int not null,
    movie_id int not null,
    primary key (director_id, movie_id),
    constraint movies_directors_ibfk_1
        foreign key (movie_id) references movies (id)
            on update cascade on delete cascade,
    constraint movies_directors_ibfk_2
        foreign key (director_id) references directors (id)
            on update cascade on delete cascade
);

create table movies_genres
(
    movie_id int not null,
    genre varchar(100) not null,
    primary key (movie_id, genre),
    constraint movies_genres_ibfk_1
        foreign key (movie_id) references movies (id)
            on update cascade on delete cascade
);

create table roles
(
    actor_id int not null,
    movie_id int not null,
    role varchar(100) not null,
    primary key (actor_id, movie_id, role),
    constraint roles_ibfk_1
        foreign key (movie_id) references movies (id)
            on update cascade on delete cascade,
    constraint roles_ibfk_2
        foreign key (actor_id) references actors (id)
            on update cascade on delete cascade
);

/*
Creating index for id of tables.
It is unrealistic at this point but makes the queries more performant when data starts to grow.
*/

create index idx_director_id
on directors_genres (director_id);

create index idx_director_id
on movies_directors (director_id);

create index idx_movie_id
on movies_directors (movie_id);

create index movie_id
on movies_genres (movie_id);

create index idx_actor_id
on roles (actor_id);

create index idx_movie_id
on roles (movie_id);