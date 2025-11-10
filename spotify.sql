-- Advance SQL Project -- Spotify Data


-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes FLOAT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


select * from spotify
limit 50;

-- EDA
-- Total values
select count(*) 
from spotify;


-- Unique number of artist
select count(distinct(artist))
from spotify;


-- unique number of albums
select count(distinct(album))
from spotify;

-- different types of album
select distinct(album_type) 
from spotify;

-- maximum duration
select max(duration_min) from spotify;

-- min duration 
select min(duration_min) from spotify;

select * from spotify
where duration_min = 0;


-- delete it
delete from spotify
where duration_min = 0;

select * from spotify
where duration_min = 0;

-- How many channels
select distinct(channel) from spotify;

-- Most_played_song
select distinct most_played_on from spotify;


-- Easy Level
1.Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify;

select track 
from spotify
where stream > 100000000;
2.List all albums along with their respective artists.

select * from spotify;

select distinct album, artist
from spotify
order by 1;

3.Get the total number of comments for tracks where licensed = TRUE.

select * from spotify;

select sum(comments) as total_comments
from spotify
where licensed = TRUE;

4.Find all tracks that belong to the album type single.

select * from spotify;

select track, album_type
from spotify
where album_type = 'single';

5.Count the total number of tracks by each artist.

select * from spotify;

select artist, count(track) as total_number_of_tracks
from spotify
group by artist
order by total_number_of_tracks
limit 10;


-- Medium Level
6.Calculate the average danceability of tracks in each album.

select * from spotify;

select album, avg(danceability) as avg_danceability
from spotify
group by 1;


7.Find the top 5 tracks with the highest energy values.

select * from spotify;

select track, max(energy) as high_energy
from spotify
group by 1
order by 2 desc
limit 5;
8.List all tracks along with their views and likes where official_video = TRUE.

select * from spotify;

select track, sum(views) as total_views, sum(likes) as total_likes
from spotify
where official_video = TRUE
group by 1
order by 2 desc
limit 5;
9.For each album, calculate the total views of all associated tracks.

select * from spotify;

select album,track, sum(views) as total_views
from spotify
group by 1, 2
order by 3 desc;

10.Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from spotify;

select * from 
(SELECT
	TRACK,
	coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) AS STREAMED_ON_YOUTUBE,
	coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) AS STREAMED_ON_SPOTIFY
FROM
	SPOTIFY
group by 1
) as t1
where streamed_on_spotify > streamed_on_youtube
	and streamed_on_youtube <> 0;

-- Advanced Level
11.Find the top 3 most-viewed tracks for each artist using window functions.

select * from spotify;

with ranking_artist as(
select artist, track, sum(views) as total_view,
dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by 1,2
order by 1,2 desc
)
select * from ranking_artist
where rank <=3;


12.Write a query to find tracks where the liveness score is above the average.

select track, artist,liveness  from spotify
where liveness > (select avg(liveness) from spotify)



13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

select * from spotify;


with cte as (
select 
	album,
	max(energy)as highest_energy,
	min(energy) as lowest_energy 
from spotify
group by 1
)
select album,
	highest_energy - lowest_energy as energy_difference
from cte
order by 2 desc;

-- Query Optimization

explain analyze -- et 7.97ms pt 0.112ms
select artist, track, views from spotify
where artist = 'Gorillaz'
	and 
		most_played_on = 'Youtube'
order by stream desc
limit 25;

drop index if exists artist_index;
create index artist_index on spotify (artist);
