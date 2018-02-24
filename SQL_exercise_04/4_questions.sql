-- https://en.wikibooks.org/wiki/SQL_Exercises/Movie_theatres

-- 4.0 Get the longest length of movie titles
SELECT MAX(LENGTH(Title)) FROM Movies;

-- 4.1 Select the title of all movies.
SELECT Title FROM Movies;

-- 4.2 Show all the distinct ratings in the database.
SELECT DISTINCT Rating FROM Movies;

-- 4.3  Show all unrated movies.
SELECT *
  FROM Movies
  WHERE Rating IS NULL;

-- 4.4 Select all movie theaters that are not currently showing a movie.
-- 多此一舉版本
SELECT *
  FROM MovieTheaters
  WHERE Code IN
  (
    SELECT MT.Code
      FROM MovieTheaters MT LEFT JOIN Movies M
      ON MT.Movie = M.Code
      GROUP BY MT.Code
      HAVING COUNT(M.Code) = 0
  );

-- 直覺版本. 當MovieTheater 已經有 Movie 資訊的時候我們就不需要還跟 Movie Table 做 JOIN
SELECT * FROM MovieTheaters WHERE Movie IS NULL;

-- 4.5 Select all data from all movie theaters 
    -- and, additionally, the data from the movie that is being shown in the theater (if one is being shown).
SELECT *
  FROM MovieTheaters MT
  LEFT JOIN Movies M
  ON MT.Movie = M.Code;

-- 4.6 Select all data from all movies and, if that movie is being shown in a theater, show the data from the theater.
SELECT *
  FROM Movies M LEFT JOIN MovieTheaters MT
  ON M.Code = MT.Movie;

-- 4.7 Show the titles of movies not currently being shown in any theaters.
-- JOIN ver
SELECT M.Title
  FROM Movies M LEFT JOIN MovieTheaters MT
  ON M.Code = MT.Movie
  WHERE MT.Code IS NULL;

-- Subquery ver
SELECT Title
  FROM Movies
  WHERE Code NOT IN
  (
    SELECT Movie
    FROM MovieTheaters
    WHERE Movie IS NOT NULL
  );

-- 4.8 Add the unrated movie "One, Two, Three".
INSERT INTO Movies(Title, Rating)
  VALUES('One, Two, Three', NULL);

-- 4.9 Set the rating of all unrated movies to "G".
UPDATE Movies
  SET Rating = 'G'
  WHERE Rating IS NULL;

-- 4.10 Remove movie theaters projecting movies rated "NC-17".
DELETE FROM MovieTheaters
  WHERE Movie IN
  (
    SELECT Code
      FROM Movies
      WHERE Rating = 'NC-17'
  );

