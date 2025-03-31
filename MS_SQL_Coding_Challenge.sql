create database VirtualArtGallery;
use VirtualArtGallery;

-- Create the Artists table

create table Artists (
      ArtistID INT PRIMARY KEY,
      Name VARCHAR(255) NOT NULL,Biography TEXT,
      Nationality VARCHAR(100));

-- Create the Categories table

create table Categories (
    CategoryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL);

-- Create the Artworks table

create table Artworks (
        ArtworkID INT PRIMARY KEY,Title VARCHAR(255) NOT NULL,
		ArtistID INT,CategoryID INT,
		Year INT,Description TEXT,ImageURL VARCHAR(255),
        FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
        FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

-- Create the Exhibitions table

create table Exhibitions (
          ExhibitionID INT PRIMARY KEY,
		  Title VARCHAR(255) NOT NULL,
          StartDate DATE,
		  EndDate DATE,
		  Description TEXT);

-- Create a table to associate artworks with exhibitions

create table ExhibitionArtworks (
       ExhibitionID INT,
       ArtworkID INT,
       PRIMARY KEY (ExhibitionID, ArtworkID),
       FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
       FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

-- Insert sample data into the Artists table

insert into Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- Insert sample data into the Categories table

insert into Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

-- Insert sample data into the Artworks table

insert into Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso''s powerful anti-war mural.', 'guernica.jpg');

-- Insert sample data into the Exhibitions table

insert into Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions

insert into ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);
--some additional Insert statements
insert into Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(4, 'IndiaFreedom', 2, 1, 1952,'A famous painting by Vincent van Gogh.','freedom.jpg'),
(5, 'Force of Nature', 3, 2, 1937,'A Perfect Sculpture by Leonardo da Vinci.','Nature.jpg'),
(6, 'WaterLily', 3, 3, 1927,'Natural Photography by Leonardo da Vinci.','lily.jpg')

insert into ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 4), 
(2, 5), 

select * from Artists
select * from Categories
select * from Artworks
select * from Exhibitions
select * from ExhibitionArtworks

--Solve the below queries:

--1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.

select a.Name as Artist_Name,Count(art.ArtworkId) as NumberOfArtworks from Artists a left join Artworks art on a.ArtistID=art.ArtistID group by a.ArtistID,a.Name 
order by NumberOfArtworks DESC

--2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order.

select title as TitlesOfArtworks,year from Artworks where ArtistID in (
select ArtistID from Artists where Nationality='Spanish' or Nationality='Dutch')
order by year ASC

--3. Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category.

select a.Name as Artist_Name,Count(art.ArtworkId) as NumberOfArtworks,c.Name as CategoryName from Artists a 
left join Artworks art on a.ArtistID=art.ArtistID join Categories c on c.CategoryID=art.CategoryID where c.Name='Painting'
group by a.ArtistID,a.Name,c.Name 


--4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.

select a.Name as ArtistName,c.Name as CategoryName,art.Title as TitleOfArtworks from Exhibitions e join ExhibitionArtworks ea on e.ExhibitionID=ea.ExhibitionID left join Artworks art on art.ArtworkId=ea.ArtworkId
join Artists a on art.ArtistId=a.Artistid join Categories c on art.CategoryID=c.CategoryID where e.Title='Modern Art Masterpieces'

--5. Find the artists who have more than two artworks in the gallery.

select a.Name as Artist_Name,Count(art.ArtworkId) as NumberOfArtworks from Artists a Join Artworks art on a.ArtistID=art.ArtistID 
group by a.ArtistID,a.Name having Count(art.ArtworkId)>2

--6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions

select art.Title
from Artworks art
where art.ArtworkID IN (
    select ea.ArtworkID from ExhibitionArtworks ea
    JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
    where e.Title = 'Modern Art Masterpieces'
) 
AND art.ArtworkID IN (select ea.ArtworkID
    from ExhibitionArtworks ea join Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
    where e.Title = 'Renaissance Art'
);
--7. Find the total number of artworks in each category

select c.Name as CategoryName,Count(art.ArtworkId) as NumberOfArtworks from Categories c left join Artworks art
on c.CategoryID = art.CategoryID group by c.Name 

--8. List artists who have more than 3 artworks in the gallery.

select a.Name as Artist_Name,Count(art.ArtworkId) as NumberOfArtworks from Artists a Join Artworks art on a.ArtistID=art.ArtistID 
group by a.ArtistID,a.Name having Count(art.ArtworkId)>3

--9. Find the artworks created by artists from a specific nationality (e.g., Spanish).

select a.Name as Artist_Name, art.Title as TitleOfArtwork from Artists a Join Artworks art on a.ArtistID=art.ArtistID where Nationality='Spanish'
group by a.ArtistID,a.Name,art.Title

--10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.

select e.Title, e.StartDate, e.EndDate, e.Description FROM Exhibitions e
where e.ExhibitionID IN (
    select ea.ExhibitionID FROM ExhibitionArtworks ea
    join Artworks art ON ea.ArtworkID = art.ArtworkID
    join Artists a ON art.ArtistID = a.ArtistID
    where a.Name = 'Vincent van Gogh')
AND e.ExhibitionID IN (
    select ea.ExhibitionID from ExhibitionArtworks ea
    join Artworks art ON ea.ArtworkID = art.ArtworkID
    join Artists a ON art.ArtistID = a.ArtistID
    where a.Name = 'Leonardo da Vinci'
);
--11. Find all the artworks that have not been included in any exhibition.

select art.ArtworkID,art.title from Artworks art left join ExhibitionArtworks ea on art.ArtworkID=ea.ArtworkID 
where ea.ExhibitionID is null

--12. List artists who have created artworks in all available categories.
 
select a.ArtistID,a.Name as ArtistName from Artists a join Artworks art on a.ArtistID=art.ArtistID 
join Categories c on c.CategoryID=art.CategoryID group by a.ArtistID, a.Name 
Having COUNT(distinct art.CategoryID) = (Select COUNT(*) from Categories);

--13. List the total number of artworks in each category.

select c.Name, Count(a.ArtworkID) as ArtworksInCategory from Categories c left join Artworks a on
c.CategoryID=a.CategoryID group by c.Name 

--14. Find the artists who have more than 2 artworks in the gallery.

select a.Name as Artist_Name,Count(art.ArtworkId) as NumberOfArtworks from Artists a Join Artworks art on a.ArtistID=art.ArtistID 
group by a.ArtistID,a.Name having Count(art.ArtworkId)>2

--15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.

select c.Name as CategoryName,Avg(art.Year) as AverageYear from Artworks art 
join Categories c on art.CategoryID=c.CategoryID 
group by c.Name HAVING COUNT(art.ArtworkID) > 1;

--16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.

select art.Title as ArtworksName,e.Title as ExhibitionTitle from Artworks art 
join ExhibitionArtworks ea on art.ArtworkID=ea.ArtworkID 
join Exhibitions e on e.ExhibitionID=ea.ExhibitionID 
where e.Title='Modern Art Masterpieces'

--17. Find the categories where the average year of artworks is greater than the average year of all artworks.

select c.Name as CategoryName,AVG(art.Year) as AverageYear from Artworks art join Categories c on art.CategoryID=c.CategoryID group by c.Name 
Having AVG(art.Year) > (Select AVG(Year) from Artworks)

--18. List the artworks that were not exhibited in any exhibition.

select art.ArtworkID,art.title from Artworks art left join ExhibitionArtworks ea on art.ArtworkID=ea.ArtworkID 
where ea.ExhibitionID is null

--19. Show artists who have artworks in the same category as "Mona Lisa."

select Distinct Artists.Name as ArtistName,c.Name as CategoryName from Artists  join Artworks a on a.ArtistId=Artists.Artistid join Categories c on a.CategoryID=c.CategoryID 
where c.CategoryID = (select  DISTINCT CategoryID FROM Artworks WHERE Title = 'Mona Lisa')

--20. List the names of artists and the number of artworks they have in the gallery.

select a.ArtistID,a.name,Count(art.ArtworkId) as NumberOfArtworks from Artists a join Artworks art 
on a.ArtistID=art.ArtistID 
group by a.ArtistID,a.Name
