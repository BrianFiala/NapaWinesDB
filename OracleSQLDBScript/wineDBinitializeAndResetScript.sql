/*
	Hi guys, I just finished phase 4. Run this script every time you need
	to reset the database when working on your phase 5. You can just do
	SELECT ALL then COPY and PASTE into a new SQL worksheet and then run the
	script. I’m going to submit phase 4 to the Professor in a few minutes.
*/

/*******************************************************************************
  Phase 3, part a: use CREATE TABLE commands to make DB schema, declaring keys
*******************************************************************************/
DROP TABLE Grapes CASCADE CONSTRAINTS;
CREATE TABLE Grapes (
  varietal VARCHAR2(20) PRIMARY KEY
);

DROP TABLE Appellations CASCADE CONSTRAINTS;
CREATE TABLE Appellations (
  appellationName VARCHAR(20) PRIMARY KEY,
  county VARCHAR2(10),
  climate VARCHAR2(5)
);

DROP TABLE Comes_From CASCADE CONSTRAINTS;
CREATE TABLE Comes_From (
  varietal VARCHAR2(20),
  appellationName VARCHAR2(20),
  PRIMARY KEY (varietal, appellationName),
  FOREIGN KEY (varietal)
    REFERENCES Grapes(varietal),  -- disallow deletion of used Grapes(varietals)
  FOREIGN KEY (appellationName)        -- disallow deletion of used appellations
    REFERENCES Appellations(appellationName)
);

DROP TABLE Wines CASCADE CONSTRAINTS;
CREATE TABLE Wines (
  wineName VARCHAR2(20),
  vintage INTEGER,
  makerName VARCHAR2(30),
  color VARCHAR2(5),
  PRIMARY KEY (wineName, vintage, makerName),
  FOREIGN KEY (makerName)
    REFERENCES Maker(makerName)
    ON DELETE CASCADE            -- deletes all tuples referencing deleted maker
    INITIALLY DEFERRED DEFERRABLE
);

DROP TABLE Maker CASCADE CONSTRAINTS;
CREATE TABLE Maker (
  makerName VARCHAR2(30) PRIMARY KEY,
  tastingRoom VARCHAR2(5) DEFAULT 'No',
  makerAddress VARCHAR2(50) UNIQUE,
  bestSellerName VARCHAR2(20),
  bestSellerVintage INTEGER,
  FOREIGN KEY (bestSellerName, bestSellerVintage, makerName)
    REFERENCES Wines(wineName, vintage, makerName)
);  -- keeping Best_Seller table would've allowed deletion of best-selling wines

DROP TABLE Made_Of CASCADE CONSTRAINTS;
CREATE TABLE Made_Of (
  wineName VARCHAR2(20),
  vintage INTEGER,
  makerName VARCHAR2(30),
  varietal VARCHAR2(20),
  PRIMARY KEY (wineName, vintage, makerName, varietal),
  FOREIGN KEY (varietal)
    REFERENCES Grapes(varietal),  -- disallow deletion of used Grapes(varietals)
  FOREIGN KEY (wineName, vintage, makerName)
    REFERENCES Wines(wineName, vintage, makerName)
    ON DELETE CASCADE             -- deletes all tuples referencing deleted wine
);

DROP TABLE Origin CASCADE CONSTRAINTS;
CREATE TABLE Origin (
  wineName VARCHAR2(20),
  vintage INTEGER,
  makerName VARCHAR2(30),
  appellationName VARCHAR2(20),
  PRIMARY KEY (wineName, vintage, makerName, appellationName),
  FOREIGN KEY (wineName, vintage, makerName)
    REFERENCES Wines(wineName, vintage, makerName)
    ON DELETE CASCADE,            -- deletes all tuples referencing deleted wine
  FOREIGN KEY (appellationName)        -- disallow deletion of used appellations
    REFERENCES Appellations(appellationName)
);

DROP TABLE Restaurants CASCADE CONSTRAINTS;
CREATE TABLE Restaurants (
  restaurantName VARCHAR2(30),
  restaurantAddress VARCHAR2(50) PRIMARY KEY,
  bestSellerName VARCHAR2(20),
  bestSellerVintage INTEGER,
  bestSellerMaker VARCHAR2(30),
  FOREIGN KEY (bestSellerName, bestSellerVintage, bestSellerMaker)
    REFERENCES Wines(wineName, vintage, makerName)
    ON DELETE SET NULL,-- bestSeller fields referencing deleted wine become NULL
  FOREIGN KEY (restaurantAddress, bestSellerName, bestSellerVintage,
      bestSellerMaker)    -- disallow deletion of best-selling wines from Serves
    REFERENCES Serves(restaurantAddress, wineName, vintage, makerName)
    INITIALLY DEFERRED DEFERRABLE
);

DROP TABLE Serves CASCADE CONSTRAINTS;
CREATE TABLE Serves (
  restaurantAddress VARCHAR2(50),
  wineName VARCHAR2(20),
  vintage INTEGER,
  makerName VARCHAR2(30),
  PRIMARY KEY (restaurantAddress, wineName, vintage, makerName),
  FOREIGN KEY (restaurantAddress)
    REFERENCES Restaurants(restaurantAddress)
    ON DELETE CASCADE,      -- deletes all tuples referencing deleted restaurant
  FOREIGN KEY (wineName, vintage, makerName)
    REFERENCES Wines(wineName, vintage, makerName)
    ON DELETE CASCADE           -- deletes all tuples referencing a deleted wine
);

DROP TABLE Clients CASCADE CONSTRAINTS;
CREATE TABLE Clients (
  clientName VARCHAR2(20),
  clientAddress VARCHAR2(50),
  favoriteWineName VARCHAR2(20),
  favoriteWineVintage INTEGER,
  favoriteWineMaker VARCHAR2(30),
  PRIMARY KEY (clientName, clientAddress),
  FOREIGN KEY (favoriteWineName, favoriteWineVintage, favoriteWineMaker)
    REFERENCES Wines(wineName, vintage, makerName)
    ON DELETE SET NULL   -- favorite fields referencing deleted wine become NULL
);

DROP TABLE Frequents CASCADE CONSTRAINTS;
CREATE TABLE Frequents (
  clientName VARCHAR2(20),
  clientAddress VARCHAR2(50),
  restaurantName VARCHAR2(30),
  restaurantAddress VARCHAR2(50),
  PRIMARY KEY (clientName, clientAddress, restaurantAddress),
  FOREIGN KEY (clientName, clientAddress)
    REFERENCES Clients(clientName, clientAddress)
    ON DELETE CASCADE,          -- deletes all tuples referencing deleted client
  FOREIGN KEY (restaurantAddress)
    REFERENCES Restaurants(restaurantAddress)
    ON DELETE CASCADE       -- deletes all tuples referencing deleted restaurant
);

DROP TABLE Uses CASCADE CONSTRAINTS;
CREATE TABLE Uses (
  varietal VARCHAR2(20),
  makerName VARCHAR2(30),
  PRIMARY KEY (varietal, makerName),
  FOREIGN KEY (varietal)
    REFERENCES Grapes(varietal),  -- disallow deletion of used Grapes(varietals)
  FOREIGN KEY (makerName)
    REFERENCES Maker(makerName)
    ON DELETE CASCADE            -- deletes all tuples referencing deleted maker
);

/*******************************************************************************
  Phase 3, part b: populate the tables, and use SELECT * to display one table
*******************************************************************************/
INSERT INTO Grapes VALUES ('Merlot');
INSERT INTO Grapes VALUES ('Cabernet Sauvignon');
INSERT INTO Grapes VALUES ('Pinot Noir');
INSERT INTO Grapes VALUES ('Syrah');
INSERT INTO Grapes VALUES ('Muscat');
INSERT INTO Grapes VALUES ('Cabernet Franc');
INSERT INTO Grapes VALUES ('Malbec');
INSERT INTO Grapes VALUES ('Petit Sirah');
INSERT INTO Grapes VALUES ('Pinot Blanc');
INSERT INTO Grapes VALUES ('Zinfandel');
INSERT INTO Grapes VALUES ('Chardonnay');
INSERT INTO Grapes VALUES ('Gerwurztraminer');
INSERT INTO Grapes VALUES ('Pinot Gris');
INSERT INTO Grapes VALUES ('Riesling');
INSERT INTO Grapes VALUES ('Sauvignon Blanc');
INSERT INTO Grapes VALUES ('Grenache');
INSERT INTO Grapes VALUES ('Chenin Blanc');

INSERT INTO Appellations VALUES ('Los Carneros', 'Napa', 'Cool');
INSERT INTO Appellations VALUES ('Wild Horse', 'Napa', 'Cool');
INSERT INTO Appellations VALUES ('Stags Leap', 'Napa', 'Warm');
INSERT INTO Appellations VALUES ('Yountville', 'Napa', 'Warm');
INSERT INTO Appellations VALUES ('Oakville', 'Napa', 'Warm');
INSERT INTO Appellations VALUES ('Rutherford', 'Napa', 'Warm');
INSERT INTO Appellations VALUES ('Calistoga', 'Napa', 'Warm');
INSERT INTO Appellations VALUES ('Chalk Hill', 'Sonoma', 'Warm');
INSERT INTO Appellations VALUES ('Dry Creek', 'Sonoma', 'Warm');
INSERT INTO Appellations VALUES ('Green Valley', 'Sonoma', 'Cool');
INSERT INTO Appellations VALUES ('Fort Ross', 'Sonoma', 'Cool');
INSERT INTO Appellations VALUES ('Rockpile', 'Sonoma', 'Warm');
INSERT INTO Appellations VALUES ('Alexander Valley', 'Sonoma', 'Warm');
INSERT INTO Appellations VALUES ('Bennett Valley', 'Sonoma', 'Cool');

INSERT INTO Comes_From VALUES ('Cabernet Sauvignon', 'Oakville');
INSERT INTO Comes_From VALUES ('Cabernet Sauvignon', 'Yountville');
INSERT INTO Comes_From VALUES ('Cabernet Sauvignon', 'Calistoga');
INSERT INTO Comes_From VALUES ('Cabernet Sauvignon', 'Rutherford');
INSERT INTO Comes_From VALUES ('Cabernet Sauvignon', 'Alexander Valley');
INSERT INTO Comes_From VALUES ('Cabernet Sauvignon', 'Bennett Valley');
INSERT INTO Comes_From VALUES ('Chardonnay', 'Rutherford');
INSERT INTO Comes_From VALUES ('Chardonnay', 'Calistoga');
INSERT INTO Comes_From VALUES ('Chardonnay', 'Green Valley');
INSERT INTO Comes_From VALUES ('Sauvignon Blanc', 'Yountville');
INSERT INTO Comes_From VALUES ('Sauvignon Blanc', 'Calistoga');
INSERT INTO Comes_From VALUES ('Merlot', 'Stags Leap');
INSERT INTO Comes_From VALUES ('Merlot', 'Fort Ross');
INSERT INTO Comes_From VALUES ('Malbec', 'Oakville');
INSERT INTO Comes_From VALUES ('Malbec', 'Dry Creek');
INSERT INTO Comes_From VALUES ('Syrah', 'Wild Horse');
INSERT INTO Comes_From VALUES ('Syrah', 'Rockpile');
INSERT INTO Comes_From VALUES ('Syrah', 'Chalk Hill');
INSERT INTO Comes_From VALUES ('Syrah', 'Rutherford');
INSERT INTO Comes_From VALUES ('Zinfandel', 'Los Carneros');
INSERT INTO Comes_From VALUES ('Zinfandel', 'Calistoga');
INSERT INTO Comes_From VALUES ('Zinfandel', 'Chalk Hill');
INSERT INTO Comes_From VALUES ('Muscat', 'Oakville');
INSERT INTO Comes_From VALUES ('Riesling', 'Rutherford');
INSERT INTO Comes_From VALUES ('Riesling', 'Wild Horse');
INSERT INTO Comes_From VALUES ('Petit Sirah', 'Calistoga');
INSERT INTO Comes_From VALUES ('Cabernet Franc', 'Chalk Hill');
INSERT INTO Comes_From VALUES ('Pinot Gris', 'Oakville');
INSERT INTO Comes_From VALUES ('Pinot Noir', 'Los Carneros');
INSERT INTO Comes_From VALUES ('Pinot Noir', 'Dry Creek');
INSERT INTO Comes_From VALUES ('Pinot Noir', 'Bennett Valley');
INSERT INTO Comes_From VALUES ('Pinot Blanc', 'Stags Leap');
INSERT INTO Comes_From VALUES ('Gerwurztraminer', 'Chalk Hill');
INSERT INTO Comes_From VALUES ('Grenache', 'Green Valley');
INSERT INTO Comes_From VALUES ('Chenin Blanc', 'Green Valley');

INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2012, 'Alpha Omega', 'Red');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2011, 'Alpha Omega', 'Red');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2010, 'Alpha Omega', 'Red');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2009, 'Alpha Omega', 'Red');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2008, 'Alpha Omega', 'Red');
INSERT INTO Wines VALUES ('Chardonnay', 2012, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Chardonnay', 2011, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Chardonnay', 2010, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Chardonnay', 2009, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Chardonnay', 2008, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Sauvignon Blanc', 2012, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Sauvignon Blanc', 2011, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Sauvignon Blanc', 2010, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Sauvignon Blanc', 2009, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Sauvignon Blanc', 2008, 'Alpha Omega', 'White');
INSERT INTO Wines VALUES ('Grenache', 2012, 'Domaine Chandon Winery', 'White');
INSERT INTO Wines VALUES ('Grenache', 2011, 'Domaine Chandon Winery', 'White');
INSERT INTO Wines VALUES ('Chenin Blanc', 2012, 'Domaine Chandon Winery', 'White');
INSERT INTO Wines VALUES ('Chenin Blanc', 2011, 'Domaine Chandon Winery', 'White');
INSERT INTO Wines VALUES ('Menage a Trois', 2012, 'Domaine Chandon Winery', 'Red');
INSERT INTO Wines VALUES ('Menage a Trois', 2011, 'Domaine Chandon Winery', 'Red');
INSERT INTO Wines VALUES ('Reserve Pinot Noir', 2011, 'Domaine Chandon Winery', 'Red');
INSERT INTO Wines VALUES ('Merlot', 2012, 'Black Stallion', 'Red');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2012, 'Black Stallion', 'Red');
INSERT INTO Wines VALUES ('Sauvignon Blanc', 2012, 'Black Stallion', 'White');
INSERT INTO Wines VALUES ('Syrah', 2012, 'Black Stallion', 'Red');
INSERT INTO Wines VALUES ('Zinfandel', 2012, 'Black Stallion', 'Red');
INSERT INTO Wines VALUES ('Muscat', 2012, 'Black Stallion', 'Red');
INSERT INTO Wines VALUES ('Zinfandel', 2012, 'Chateau Montelena', 'Red');
INSERT INTO Wines VALUES ('Chardonnay', 2012, 'Chateau Montelena', 'White');
INSERT INTO Wines VALUES ('Riesling', 2012, 'Chateau Montelena', 'White');
INSERT INTO Wines VALUES ('Petit Sirah', 2012, 'Chateau Montelena', 'Red');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2012, 'Chateau Montelena', 'Red');
INSERT INTO Wines VALUES ('Syrah', 2012, 'Cornerstone Cellars', 'Red');
INSERT INTO Wines VALUES ('Cabernet Franc', 2012, 'Cornerstone Cellars', 'Red');
INSERT INTO Wines VALUES ('Pinot Gris', 2012, 'Cornerstone Cellars', 'White');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2012, 'Cornerstone Cellars', 'Red');
INSERT INTO Wines VALUES ('Riesling', 2012, 'Cornerstone Cellars', 'White');
INSERT INTO Wines VALUES ('Pinot Noir', 2012, 'Etude', 'Red');
INSERT INTO Wines VALUES ('Chardonnay', 2012, 'Etude', 'White');
INSERT INTO Wines VALUES ('Pinot Blanc', 2012, 'Etude', 'White');
INSERT INTO Wines VALUES ('Malbec', 2012, 'Etude', 'Red');
INSERT INTO Wines VALUES ('Chardonnay', 2012, 'Far Niente', 'White');
INSERT INTO Wines VALUES ('Chardonnay', 2011, 'Far Niente', 'White');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2012, 'Far Niente', 'Red');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2011, 'Far Niente', 'Red');
INSERT INTO Wines VALUES ('Malbec', 2012, 'Arrowood Winery', 'Red');
INSERT INTO Wines VALUES ('Merlot', 2012, 'Arrowood Winery', 'Red');
INSERT INTO Wines VALUES ('Syrah', 2012, 'Arrowood Winery', 'Red');
INSERT INTO Wines VALUES ('Cabernet Sauvignon', 2012, 'Arrowood Winery', 'Red');
INSERT INTO Wines VALUES ('Syrah', 2012, 'Balletto Winery', 'Red');
INSERT INTO Wines VALUES ('Pinot Noir', 2012, 'Balletto Winery', 'Red');
INSERT INTO Wines VALUES ('Chardonnay', 2012, 'Balletto Winery', 'White');
INSERT INTO Wines VALUES ('Zinfandel', 2012, 'Balletto Winery', 'Red');
INSERT INTO Wines VALUES ('Gerwurztraminer', 2012, 'Balletto Winery', 'White');

INSERT INTO Maker VALUES ('Alpha Omega', 'Yes', '1155 Mee Lane, Rutherford, CA 94574', 'Chardonnay', 2010);
INSERT INTO Maker VALUES ('Domaine Chandon Winery', 'Yes', '1 California Dr., Yountville, CA 94599', 'Reserve Pinot Noir', 2011);
INSERT INTO Maker VALUES ('Black Stallion', 'Yes', '4089 Silverado Trail, Napa, CA 94558', 'Sauvignon Blanc', 2012);
INSERT INTO Maker VALUES ('Chateau Montelena', 'Yes', '1429 Tubbs Lanes, Calistoga, CA 94515', 'Chardonnay', 2012);
INSERT INTO Maker VALUES ('Cornerstone Cellars', 'Yes', '6505 Washington St., Yountville, CA 94599', 'Pinot Gris', 2012);
INSERT INTO Maker VALUES ('Etude', 'Yes', '1250 Cuttings Wharf Rd., Napa, CA 94559', 'Malbec', 2012);
INSERT INTO Maker VALUES ('Far Niente', 'No', '1350 Acacia Dr., Oakville, CA 94562', 'Cabernet Sauvignon', 2011);
INSERT INTO Maker VALUES ('Arrowood Winery', 'Yes', '14347 Sonoma Highway, Glen Ellen, CA 95442', 'Merlot', 2012);
INSERT INTO Maker VALUES ('Balletto Winery', 'Yes', '5700 Occidental Rd, Santa Rosa, CA 95401', 'Gerwurztraminer', 2012);

INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2012, 'Alpha Omega', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2011, 'Alpha Omega', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2010, 'Alpha Omega', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2009, 'Alpha Omega', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2008, 'Alpha Omega', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Chardonnay', 2012, 'Alpha Omega', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Chardonnay', 2011, 'Alpha Omega', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Chardonnay', 2010, 'Alpha Omega', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Chardonnay', 2009, 'Alpha Omega', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Chardonnay', 2008, 'Alpha Omega', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Sauvignon Blanc', 2012, 'Alpha Omega', 'Sauvignon Blanc');
INSERT INTO Made_Of VALUES ('Sauvignon Blanc', 2011, 'Alpha Omega', 'Sauvignon Blanc');
INSERT INTO Made_Of VALUES ('Sauvignon Blanc', 2010, 'Alpha Omega', 'Sauvignon Blanc');
INSERT INTO Made_Of VALUES ('Sauvignon Blanc', 2009, 'Alpha Omega', 'Sauvignon Blanc');
INSERT INTO Made_Of VALUES ('Sauvignon Blanc', 2008, 'Alpha Omega', 'Sauvignon Blanc');
INSERT INTO Made_Of VALUES ('Grenache', 2012, 'Domaine Chandon Winery', 'Grenache');
INSERT INTO Made_Of VALUES ('Grenache', 2011, 'Domaine Chandon Winery', 'Grenache');
INSERT INTO Made_Of VALUES ('Chenin Blanc', 2012, 'Domaine Chandon Winery', 'Chenin Blanc');
INSERT INTO Made_Of VALUES ('Chenin Blanc', 2011, 'Domaine Chandon Winery', 'Chenin Blanc');
INSERT INTO Made_Of VALUES ('Menage a Trois', 2012, 'Domaine Chandon Winery', 'Syrah');
INSERT INTO Made_Of VALUES ('Menage a Trois', 2012, 'Domaine Chandon Winery', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Menage a Trois', 2012, 'Domaine Chandon Winery', 'Pinot Noir');
INSERT INTO Made_Of VALUES ('Menage a Trois', 2011, 'Domaine Chandon Winery', 'Syrah');
INSERT INTO Made_Of VALUES ('Menage a Trois', 2011, 'Domaine Chandon Winery', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Menage a Trois', 2011, 'Domaine Chandon Winery', 'Pinot Noir');
INSERT INTO Made_Of VALUES ('Reserve Pinot Noir', 2011, 'Domaine Chandon Winery', 'Pinot Noir');
INSERT INTO Made_Of VALUES ('Merlot', 2012, 'Black Stallion', 'Merlot');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2012, 'Black Stallion', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Sauvignon Blanc', 2012, 'Black Stallion', 'Sauvignon Blanc');
INSERT INTO Made_Of VALUES ('Syrah', 2012, 'Black Stallion', 'Syrah');
INSERT INTO Made_Of VALUES ('Zinfandel', 2012, 'Black Stallion', 'Zinfandel');
INSERT INTO Made_Of VALUES ('Muscat', 2012, 'Black Stallion', 'Muscat');
INSERT INTO Made_Of VALUES ('Zinfandel', 2012, 'Chateau Montelena', 'Zinfandel');
INSERT INTO Made_Of VALUES ('Chardonnay', 2012, 'Chateau Montelena', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Riesling', 2012, 'Chateau Montelena', 'Riesling');
INSERT INTO Made_Of VALUES ('Petit Sirah', 2012, 'Chateau Montelena', 'Petit Sirah');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2012, 'Chateau Montelena', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Syrah', 2012, 'Cornerstone Cellars', 'Syrah');
INSERT INTO Made_Of VALUES ('Cabernet Franc', 2012, 'Cornerstone Cellars', 'Cabernet Franc');
INSERT INTO Made_Of VALUES ('Pinot Gris', 2012, 'Cornerstone Cellars', 'Pinot Gris');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2012, 'Cornerstone Cellars', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Riesling', 2012, 'Cornerstone Cellars', 'Riesling');
INSERT INTO Made_Of VALUES ('Pinot Noir', 2012, 'Etude', 'Pinot Noir');
INSERT INTO Made_Of VALUES ('Chardonnay', 2012, 'Etude', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Pinot Blanc', 2012, 'Etude', 'Pinot Blanc');
INSERT INTO Made_Of VALUES ('Malbec', 2012, 'Etude', 'Malbec');
INSERT INTO Made_Of VALUES ('Chardonnay', 2012, 'Far Niente', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Chardonnay', 2011, 'Far Niente', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2012, 'Far Niente', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2011, 'Far Niente', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Malbec', 2012, 'Arrowood Winery', 'Malbec');
INSERT INTO Made_Of VALUES ('Merlot', 2012, 'Arrowood Winery', 'Merlot');
INSERT INTO Made_Of VALUES ('Syrah', 2012, 'Arrowood Winery', 'Syrah');
INSERT INTO Made_Of VALUES ('Cabernet Sauvignon', 2012, 'Arrowood Winery', 'Cabernet Sauvignon');
INSERT INTO Made_Of VALUES ('Syrah', 2012, 'Balletto Winery', 'Syrah');
INSERT INTO Made_Of VALUES ('Pinot Noir', 2012, 'Balletto Winery', 'Pinot Noir');
INSERT INTO Made_Of VALUES ('Chardonnay', 2012, 'Balletto Winery', 'Chardonnay');
INSERT INTO Made_Of VALUES ('Zinfandel', 2012, 'Balletto Winery', 'Zinfandel');
INSERT INTO Made_Of VALUES ('Gerwurztraminer', 2012, 'Balletto Winery', 'Gerwurztraminer');

INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2012, 'Alpha Omega', 'Oakville');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2011, 'Alpha Omega', 'Oakville');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2010, 'Alpha Omega', 'Oakville');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2009, 'Alpha Omega', 'Oakville');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2008, 'Alpha Omega', 'Oakville');
INSERT INTO Origin VALUES ('Chardonnay', 2012, 'Alpha Omega', 'Rutherford');
INSERT INTO Origin VALUES ('Chardonnay', 2011, 'Alpha Omega', 'Rutherford');
INSERT INTO Origin VALUES ('Chardonnay', 2010, 'Alpha Omega', 'Rutherford');
INSERT INTO Origin VALUES ('Chardonnay', 2009, 'Alpha Omega', 'Rutherford');
INSERT INTO Origin VALUES ('Chardonnay', 2008, 'Alpha Omega', 'Rutherford');
INSERT INTO Origin VALUES ('Sauvignon Blanc', 2012, 'Alpha Omega', 'Yountville');
INSERT INTO Origin VALUES ('Sauvignon Blanc', 2011, 'Alpha Omega', 'Yountville');
INSERT INTO Origin VALUES ('Sauvignon Blanc', 2010, 'Alpha Omega', 'Yountville');
INSERT INTO Origin VALUES ('Sauvignon Blanc', 2009, 'Alpha Omega', 'Yountville');
INSERT INTO Origin VALUES ('Sauvignon Blanc', 2008, 'Alpha Omega', 'Yountville');
INSERT INTO Origin VALUES ('Grenache', 2012, 'Domaine Chandon Winery', 'Green Valley');
INSERT INTO Origin VALUES ('Grenache', 2011, 'Domaine Chandon Winery', 'Green Valley');
INSERT INTO Origin VALUES ('Chenin Blanc', 2012, 'Domaine Chandon Winery', 'Green Valley');
INSERT INTO Origin VALUES ('Chenin Blanc', 2011, 'Domaine Chandon Winery', 'Green Valley');
INSERT INTO Origin VALUES ('Menage a Trois', 2012, 'Domaine Chandon Winery', 'Bennett Valley');
INSERT INTO Origin VALUES ('Menage a Trois', 2012, 'Domaine Chandon Winery', 'Wild Horse');
INSERT INTO Origin VALUES ('Menage a Trois', 2011, 'Domaine Chandon Winery', 'Bennett Valley');
INSERT INTO Origin VALUES ('Menage a Trois', 2011, 'Domaine Chandon Winery', 'Wild Horse');
INSERT INTO Origin VALUES ('Reserve Pinot Noir', 2011, 'Domaine Chandon Winery', 'Bennett Valley');
INSERT INTO Origin VALUES ('Merlot', 2012, 'Black Stallion', 'Stags Leap');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2012, 'Black Stallion', 'Yountville');
INSERT INTO Origin VALUES ('Sauvignon Blanc', 2012, 'Black Stallion', 'Calistoga');
INSERT INTO Origin VALUES ('Syrah', 2012, 'Black Stallion', 'Wild Horse');
INSERT INTO Origin VALUES ('Zinfandel', 2012, 'Black Stallion', 'Los Carneros');
INSERT INTO Origin VALUES ('Muscat', 2012, 'Black Stallion', 'Oakville');
INSERT INTO Origin VALUES ('Zinfandel', 2012, 'Chateau Montelena', 'Calistoga');
INSERT INTO Origin VALUES ('Chardonnay', 2012, 'Chateau Montelena', 'Calistoga');
INSERT INTO Origin VALUES ('Riesling', 2012, 'Chateau Montelena', 'Rutherford');
INSERT INTO Origin VALUES ('Petit Sirah', 2012, 'Chateau Montelena', 'Calistoga');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2012, 'Chateau Montelena', 'Calistoga');
INSERT INTO Origin VALUES ('Syrah', 2012, 'Cornerstone Cellars', 'Rutherford');
INSERT INTO Origin VALUES ('Cabernet Franc', 2012, 'Cornerstone Cellars', 'Chalk Hill');
INSERT INTO Origin VALUES ('Pinot Gris', 2012, 'Cornerstone Cellars', 'Oakville');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2012, 'Cornerstone Cellars', 'Yountville');
INSERT INTO Origin VALUES ('Riesling', 2012, 'Cornerstone Cellars', 'Wild Horse');
INSERT INTO Origin VALUES ('Pinot Noir', 2012, 'Etude', 'Los Carneros');
INSERT INTO Origin VALUES ('Chardonnay', 2012, 'Etude', 'Calistoga');
INSERT INTO Origin VALUES ('Pinot Blanc', 2012, 'Etude', 'Stags Leap');
INSERT INTO Origin VALUES ('Malbec', 2012, 'Etude', 'Oakville');
INSERT INTO Origin VALUES ('Chardonnay', 2012, 'Far Niente', 'Rutherford');
INSERT INTO Origin VALUES ('Chardonnay', 2011, 'Far Niente', 'Rutherford');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2012, 'Far Niente', 'Rutherford');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2011, 'Far Niente', 'Rutherford');
INSERT INTO Origin VALUES ('Malbec', 2012, 'Arrowood Winery', 'Dry Creek');
INSERT INTO Origin VALUES ('Merlot', 2012, 'Arrowood Winery', 'Fort Ross');
INSERT INTO Origin VALUES ('Syrah', 2012, 'Arrowood Winery', 'Rockpile');
INSERT INTO Origin VALUES ('Cabernet Sauvignon', 2012, 'Arrowood Winery', 'Alexander Valley');
INSERT INTO Origin VALUES ('Syrah', 2012, 'Balletto Winery', 'Chalk Hill');
INSERT INTO Origin VALUES ('Pinot Noir', 2012, 'Balletto Winery', 'Dry Creek');
INSERT INTO Origin VALUES ('Chardonnay', 2012, 'Balletto Winery', 'Green Valley');
INSERT INTO Origin VALUES ('Zinfandel', 2012, 'Balletto Winery', 'Chalk Hill');
INSERT INTO Origin VALUES ('Gerwurztraminer', 2012, 'Balletto Winery', 'Chalk Hill');

INSERT INTO Restaurants VALUES ('Mustards Grill', '7399 Saint Helena Hwy., Napa, CA 94588', 'Chardonnay', 2012, 'Far Niente');
INSERT INTO Restaurants VALUES ('French Laundry', '6640 Washington St., Yountville, CA 94599', 'Cabernet Sauvignon', 2012, 'Chateau Montelena');
INSERT INTO Restaurants VALUES ('Carpe Diem Wine Bar', '1001 2nd St., Napa, CA 94559', 'Syrah', 2012, 'Black Stallion');
INSERT INTO Restaurants VALUES ('Etoile', '1 California Dr., Yountville, CA 94599', 'Reserve Pinot Noir', 2011, 'Domaine Chandon Winery');
INSERT INTO Restaurants VALUES ('La Toque', '1314 McKinstry St., Napa, CA 94599', 'Chardonnay', 2011, 'Far Niente');
INSERT INTO Restaurants VALUES ('FARM at the Carneros Inn', '4048 Sonoma Hwy., Napa, CA 94559', 'Cabernet Sauvignon', 2010, 'Alpha Omega');
INSERT INTO Restaurants VALUES ('LaSalette', '452 1st St. E, Sonoma, CA 95476', 'Chardonnay', 2012, 'Far Niente');
INSERT INTO Restaurants VALUES ('Burgers and Vine', '400 1st St. E, Sonoma, CA 95476', 'Riesling', 2012, 'Cornerstone Cellars');

INSERT INTO Serves VALUES ('7399 Saint Helena Hwy., Napa, CA 94588', 'Chardonnay', 2012, 'Far Niente');
INSERT INTO Serves VALUES ('7399 Saint Helena Hwy., Napa, CA 94588', 'Cabernet Sauvignon', 2012, 'Far Niente');
INSERT INTO Serves VALUES ('7399 Saint Helena Hwy., Napa, CA 94588', 'Sauvignon Blanc', 2012, 'Alpha Omega');
INSERT INTO Serves VALUES ('6640 Washington St., Yountville, CA 94599', 'Cabernet Sauvignon', 2012, 'Chateau Montelena');
INSERT INTO Serves VALUES ('6640 Washington St., Yountville, CA 94599', 'Malbec', 2012, 'Etude');
INSERT INTO Serves VALUES ('6640 Washington St., Yountville, CA 94599', 'Chardonnay', 2012, 'Chateau Montelena');
INSERT INTO Serves VALUES ('1001 2nd St., Napa, CA 94559', 'Petit Sirah', 2012, 'Chateau Montelena');
INSERT INTO Serves VALUES ('1001 2nd St., Napa, CA 94559', 'Sauvignon Blanc', 2012, 'Alpha Omega');
INSERT INTO Serves VALUES ('1001 2nd St., Napa, CA 94559', 'Merlot', 2012, 'Arrowood Winery');
INSERT INTO Serves VALUES ('1 California Dr., Yountville, CA 94599', 'Reserve Pinot Noir', 2011, 'Domaine Chandon Winery');
INSERT INTO Serves VALUES ('1 California Dr., Yountville, CA 94599', 'Grenache', 2012, 'Domaine Chandon Winery');
INSERT INTO Serves VALUES ('1 California Dr., Yountville, CA 94599', 'Grenache', 2011, 'Domaine Chandon Winery');
INSERT INTO Serves VALUES ('1 California Dr., Yountville, CA 94599', 'Chenin Blanc', 2012, 'Domaine Chandon Winery');
INSERT INTO Serves VALUES ('1 California Dr., Yountville, CA 94599', 'Chenin Blanc', 2011, 'Domaine Chandon Winery');
INSERT INTO Serves VALUES ('1 California Dr., Yountville, CA 94599', 'Menage a Trois', 2012, 'Domaine Chandon Winery');
INSERT INTO Serves VALUES ('1 California Dr., Yountville, CA 94599', 'Menage a Trois', 2011, 'Domaine Chandon Winery');
INSERT INTO Serves VALUES ('1314 McKinstry St., Napa, CA 94599', 'Chardonnay', 2011, 'Far Niente');
INSERT INTO Serves VALUES ('1314 McKinstry St., Napa, CA 94599', 'Sauvignon Blanc', 2012, 'Black Stallion');
INSERT INTO Serves VALUES ('1314 McKinstry St., Napa, CA 94599', 'Pinot Noir', 2012, 'Balletto Winery');
INSERT INTO Serves VALUES ('4048 Sonoma Hwy., Napa, CA 94559', 'Cabernet Sauvignon', 2010, 'Alpha Omega');
INSERT INTO Serves VALUES ('4048 Sonoma Hwy., Napa, CA 94559', 'Zinfandel', 2012, 'Black Stallion');
INSERT INTO Serves VALUES ('4048 Sonoma Hwy., Napa, CA 94559', 'Riesling', 2012, 'Chateau Montelena');
INSERT INTO Serves VALUES ('452 1st St. E, Sonoma, CA 95476', 'Chardonnay', 2012, 'Far Niente');
INSERT INTO Serves VALUES ('452 1st St. E, Sonoma, CA 95476', 'Chardonnay', 2012, 'Etude');
INSERT INTO Serves VALUES ('452 1st St. E, Sonoma, CA 95476', 'Pinot Gris', 2012, 'Cornerstone Cellars');
INSERT INTO Serves VALUES ('400 1st St. E, Sonoma, CA 95476', 'Riesling', 2012, 'Cornerstone Cellars');
INSERT INTO Serves VALUES ('400 1st St. E, Sonoma, CA 95476', 'Gerwurztraminer', 2012, 'Balletto Winery');

INSERT INTO Clients VALUES ('Marco Garcia', '123 Main St., Soledad, CA 93960', 'Chardonnay', 2012, 'Far Niente');
INSERT INTO Clients VALUES ('Cyrus Goh', '508 California St., Mountain View, CA 94041', 'Cabernet Sauvignon', 2012, 'Arrowood Winery');
INSERT INTO Clients VALUES ('Brian Fiala', '1018 Robin Way, Sunnyvale, CA 94087', 'Petit Sirah', 2012, 'Chateau Montelena');
INSERT INTO Clients VALUES ('Tom Bak', '426 Fell St., San Francisco, CA 94678', 'Zinfandel', 2012, 'Black Stallion');
INSERT INTO Clients VALUES ('John Peterson', '1911 Grand Ave., Oakland, CA 94653', 'Chardonnay', 2012, 'Far Niente');
INSERT INTO Clients VALUES ('Alex Brandmeyer', '1627 59th St., Oakland, CA 94657', 'Merlot', 2012, 'Arrowood Winery');
INSERT INTO Clients VALUES ('Chynna Rowe', '1248 Burnett St., Berkeley, CA 94710', 'Syrah', 2012, 'Black Stallion');
INSERT INTO Clients VALUES ('David Maksim', '1018 Robin Way, Sunnyvale, CA 94087', 'Cabernet Sauvignon', 2012, 'Chateau Montelena');
INSERT INTO Clients VALUES ('Brenna Woodmansee', '1018 Robin Way, Sunnyvale, CA 94087', 'Sauvignon Blanc', 2012, 'Alpha Omega');
INSERT INTO Clients VALUES ('Bhavin Shah', '1018 Robin Way, Sunnyvale, CA 94087', 'Pinot Gris', 2012, 'Cornerstone Cellars');
INSERT INTO Clients VALUES ('Thomas John', '1018 Robin Way, Sunnyvale, CA 94087', 'Reserve Pinot Noir', 2011, 'Domaine Chandon Winery');
INSERT INTO Clients VALUES ('Gisela Vallejo', '1018 Robin Way, Sunnyvale, CA 94087', 'Chardonnay', 2012, 'Far Niente');

INSERT INTO Uses VALUES ('Cabernet Sauvignon', 'Alpha Omega');
INSERT INTO Uses VALUES ('Chardonnay', 'Alpha Omega');
INSERT INTO Uses VALUES ('Sauvignon Blanc', 'Alpha Omega');
INSERT INTO Uses VALUES ('Grenache','Domaine Chandon Winery');
INSERT INTO Uses VALUES ('Chenin Blanc', 'Domaine Chandon Winery');
INSERT INTO Uses VALUES ('Syrah', 'Domaine Chandon Winery');
INSERT INTO Uses VALUES ('Cabernet Sauvignon', 'Domaine Chandon Winery');
INSERT INTO Uses VALUES ('Pinot Noir', 'Domaine Chandon Winery');
INSERT INTO Uses VALUES ('Merlot', 'Black Stallion');
INSERT INTO Uses VALUES ('Cabernet Sauvignon', 'Black Stallion');
INSERT INTO Uses VALUES ('Sauvignon Blanc', 'Black Stallion');
INSERT INTO Uses VALUES ('Syrah', 'Black Stallion');
INSERT INTO Uses VALUES ('Zinfandel', 'Black Stallion');
INSERT INTO Uses VALUES ('Muscat', 'Black Stallion');
INSERT INTO Uses VALUES ('Zinfandel', 'Chateau Montelena');
INSERT INTO Uses VALUES ('Chardonnay', 'Chateau Montelena');
INSERT INTO Uses VALUES ('Riesling', 'Chateau Montelena');
INSERT INTO Uses VALUES ('Petit Sirah', 'Chateau Montelena');
INSERT INTO Uses VALUES ('Cabernet Sauvignon', 'Chateau Montelena');
INSERT INTO Uses VALUES ('Syrah', 'Cornerstone Cellars');
INSERT INTO Uses VALUES ('Cabernet Franc', 'Cornerstone Cellars');
INSERT INTO Uses VALUES ('Pinot Gris', 'Cornerstone Cellars');
INSERT INTO Uses VALUES ('Cabernet Sauvignon', 'Cornerstone Cellars');
INSERT INTO Uses VALUES ('Riesling', 'Cornerstone Cellars');
INSERT INTO Uses VALUES ('Pinot Noir', 'Etude');
INSERT INTO Uses VALUES ('Chardonnay', 'Etude');
INSERT INTO Uses VALUES ('Pinot Blanc', 'Etude');
INSERT INTO Uses VALUES ('Malbec', 'Etude');
INSERT INTO Uses VALUES ('Chardonnay', 'Far Niente');
INSERT INTO Uses VALUES ('Cabernet Sauvignon', 'Far Niente');
INSERT INTO Uses VALUES ('Malbec', 'Arrowood Winery');
INSERT INTO Uses VALUES ('Merlot', 'Arrowood Winery');
INSERT INTO Uses VALUES ('Syrah', 'Arrowood Winery');
INSERT INTO Uses VALUES ('Cabernet Sauvignon', 'Arrowood Winery');
INSERT INTO Uses VALUES ('Syrah', 'Balletto Winery');
INSERT INTO Uses VALUES ('Pinot Noir', 'Balletto Winery');
INSERT INTO Uses VALUES ('Chardonnay', 'Balletto Winery');
INSERT INTO Uses VALUES ('Zinfandel', 'Balletto Winery');
INSERT INTO Uses VALUES ('Gerwurztraminer', 'Balletto Winery');

INSERT INTO Frequents VALUES ('Marco Garcia', '123 Main St., Soledad, CA 93960', 'Mustards Grill', '7399 Saint Helena Hwy., Napa, CA 94588');
INSERT INTO Frequents VALUES ('Marco Garcia', '123 Main St., Soledad, CA 93960', 'French Laundry', '6640 Washington St., Yountville, CA 94599');
INSERT INTO Frequents VALUES ('Cyrus Goh', '508 California St., Mountain View, CA 94041', 'French Laundry', '6640 Washington St., Yountville, CA 94599');
INSERT INTO Frequents VALUES ('Cyrus Goh', '508 California St., Mountain View, CA 94041', 'Carpe Diem Wine Bar', '1001 2nd St., Napa, CA 94559');
INSERT INTO Frequents VALUES ('Brian Fiala', '1018 Robin Way, Sunnyvale, CA 94087', 'Mustards Grill', '7399 Saint Helena Hwy., Napa, CA 94588');
INSERT INTO Frequents VALUES ('Brian Fiala', '1018 Robin Way, Sunnyvale, CA 94087', 'Carpe Diem Wine Bar', '1001 2nd St., Napa, CA 94559');
INSERT INTO Frequents VALUES ('Chynna Rowe', '1248 Burnett St., Berkeley, CA 94710', 'Mustards Grill', '7399 Saint Helena Hwy., Napa, CA 94588');
INSERT INTO Frequents VALUES ('Chynna Rowe', '1248 Burnett St., Berkeley, CA 94710', 'Carpe Diem Wine Bar', '1001 2nd St., Napa, CA 94559');
INSERT INTO Frequents VALUES ('David Maksim', '1018 Robin Way, Sunnyvale, CA 94087', 'LaSalette', '452 1st St. E, Sonoma, CA 95476');
INSERT INTO Frequents VALUES ('David Maksim', '1018 Robin Way, Sunnyvale, CA 94087', 'Carpe Diem Wine Bar', '1001 2nd St., Napa, CA 94559');
INSERT INTO Frequents VALUES ('Brenna Woodmansee', '1018 Robin Way, Sunnyvale, CA 94087', 'LaSalette', '452 1st St. E, Sonoma, CA 95476');
INSERT INTO Frequents VALUES ('Brenna Woodmansee', '1018 Robin Way, Sunnyvale, CA 94087', 'Carpe Diem Wine Bar', '1001 2nd St., Napa, CA 94559');
INSERT INTO Frequents VALUES ('John Peterson', '1911 Grand Ave., Oakland, CA 94653', 'La Toque', '1314 McKinstry St., Napa, CA 94599');
INSERT INTO Frequents VALUES ('John Peterson', '1911 Grand Ave., Oakland, CA 94653', 'Mustards Grill', '7399 Saint Helena Hwy., Napa, CA 94588');
INSERT INTO Frequents VALUES ('Tom Bak', '426 Fell St., San Francisco, CA 94678', 'Etoile', '1 California Dr., Yountville, CA 94599');
INSERT INTO Frequents VALUES ('Tom Bak', '426 Fell St., San Francisco, CA 94678', 'FARM at the Carneros Inn', '4048 Sonoma Hwy., Napa, CA 94559');
INSERT INTO Frequents VALUES ('Alex Brandmeyer', '1627 59th St., Oakland, CA 94657', 'FARM at the Carneros Inn', '4048 Sonoma Hwy., Napa, CA 94559');
INSERT INTO Frequents VALUES ('Alex Brandmeyer', '1627 59th St., Oakland, CA 94657', 'Carpe Diem Wine Bar', '1001 2nd St., Napa, CA 94559');
INSERT INTO Frequents VALUES ('Bhavin Shah', '1018 Robin Way, Sunnyvale, CA 94087', 'LaSalette', '452 1st St. E, Sonoma, CA 95476');
INSERT INTO Frequents VALUES ('Bhavin Shah', '1018 Robin Way, Sunnyvale, CA 94087', 'FARM at the Carneros Inn', '4048 Sonoma Hwy., Napa, CA 94559');
INSERT INTO Frequents VALUES ('Thomas John', '1018 Robin Way, Sunnyvale, CA 94087', 'Etoile', '1 California Dr., Yountville, CA 94599');
INSERT INTO Frequents VALUES ('Thomas John', '1018 Robin Way, Sunnyvale, CA 94087', 'LaSalette', '452 1st St. E, Sonoma, CA 95476');
INSERT INTO Frequents VALUES ('Gisela Vallejo', '1018 Robin Way, Sunnyvale, CA 94087', 'Mustards Grill', '7399 Saint Helena Hwy., Napa, CA 94588');
INSERT INTO Frequents VALUES ('Gisela Vallejo', '1018 Robin Way, Sunnyvale, CA 94087', 'LaSalette', '452 1st St. E, Sonoma, CA 95476');

/*******************************************************************************
  Phase 4, Part 2: write 3 data modification commands
*******************************************************************************/
DELETE FROM Frequents
WHERE restaurantName = 'LaSalette' AND
  (clientName = 'Bhavin Shah' OR clientName = 'Thomas John');

INSERT INTO Frequents
  ( SELECT Clients.clientName, Clients.clientAddress,
      Restaurants.restaurantName, Restaurants.restaurantAddress
    FROM Clients, Restaurants
    WHERE clientName = 'Bhavin Shah' AND restaurantName = 'LaSalette'
      OR clientName = 'Thomas John' AND restaurantName = 'LaSalette'
  );

INSERT INTO Serves
  ( SELECT DISTINCT Restaurants.restaurantAddress, Origin.winename,
      Origin.vintage, Origin.makerName
    FROM Restaurants, Origin, Made_of
    WHERE Restaurants.restaurantName = 'FARM at the Carneros Inn' AND
      ( (appellationName = 'Yountville' AND varietal = 'Cabernet Sauvignon' AND
          Origin.wineName = Made_of.wineName)
      OR
        (appellationName = 'Calistoga' AND varietal = 'Cabernet Sauvignon' AND
          Origin.wineName = Made_of.wineName)
      OR
        (Origin.wineName = 'Reserve Pinot Noir' AND
          Origin.wineName = Made_of.wineName)
      )
  );

/*******************************************************************************
  Phase 4, Part 3: create 2 views
*******************************************************************************/
CREATE OR REPLACE VIEW Alpha_Omega_Counties AS
  ( SELECT DISTINCT county
    FROM Appellations, Comes_From, Made_Of
    WHERE Appellations.appellationName = Comes_From.appellationName AND
      Comes_From.varietal = Made_Of.varietal
  );

CREATE OR REPLACE VIEW Popular_Wines AS
  ( SELECT DISTINCT wineName, vintage, makerName
    FROM Wines
    WHERE (wineName, vintage, makerName) IN
            ( SELECT favoriteWineName, favoriteWineVintage, favoriteWineMaker
              FROM Clients)
          OR (wineName, vintage, makerName) IN
            ( SELECT bestSellerName, bestSellerVintage, bestSellerMaker
              FROM Restaurants)
          OR (wineName, vintage, makerName) IN
            ( SELECT bestSellerName, bestSellerVintage, makerName
              FROM Maker)
  );

/*******************************************************************************
  Phase 4, Part 4: create CHECK constraints: 1 attribute-based and 1 tuple-based
*******************************************************************************/
ALTER TABLE Appellations
  ADD CONSTRAINT ck_county
    CHECK (county IN ('Napa', 'Sonoma'));

ALTER TABLE Wines
  ADD CONSTRAINT ck_vintage_color
    CHECK (vintage > 1849 AND color IN ('Red', 'White', 'Rose'));

/*******************************************************************************
  Phase 4, Part 5: create two stored functions or procedures
*******************************************************************************/
CREATE OR REPLACE PROCEDURE AddMakerToMenu (
      maker IN Wines.makerName%TYPE,
      restaurantAddress IN Restaurants.restaurantAddress%TYPE) AS
    wine Wines.wineName%TYPE;
    vintage Wines.vintage%TYPE;
    CURSOR c IS
      SELECT WineName, vintage
      FROM Wines
      WHERE makerName = maker;
  BEGIN
    OPEN c;
    LOOP
      FETCH c INTO wine, vintage;
      EXIT WHEN c%NOTFOUND;
      INSERT INTO SERVES VALUES(restaurantAddress, wine, vintage, maker);
    END LOOP;
    CLOSE c;
  END;
/
EXECUTE AddMakerToMenu('Far Niente', '6640 Washington St., Yountville, CA 94599');

CREATE OR REPLACE PROCEDURE NewLocationSameMenu (
      restaurant IN Restaurants.restaurantName%TYPE,
      newAddress IN Restaurants.restaurantAddress%TYPE) AS
    CURSOR c IS
      SELECT DISTINCT wineName, vintage, makerName
      FROM Serves
      WHERE restaurantAddress IN
        ( SELECT restaurantAddress
          FROM Restaurants
          WHERE restaurantName LIKE restaurant);
    wine Serves.wineName%TYPE;
    vintage Serves.vintage%TYPE;
    maker Serves.makerName%TYPE;
    bestName Restaurants.bestSellerName%TYPE;
    bestVintage Restaurants.bestSellerVintage%TYPE;
    bestMaker Restaurants.bestSellerMaker%TYPE;
  BEGIN
    SELECT DISTINCT bestSellerName, bestSellerVintage, bestSellerMaker
            INTO bestName, bestVintage, bestMaker
    FROM Restaurants
    WHERE restaurantName LIKE restaurant;
    INSERT INTO Restaurants
      VALUES (restaurant, newAddress, bestName, bestVintage, bestMaker);
    OPEN c;
    LOOP
      FETCH c INTO wine, vintage, maker;
      EXIT WHEN c%NOTFOUND;
      INSERT INTO Serves
        VALUES (newAddress, wine, vintage, maker);
    END LOOP;
    CLOSE c;
  END;
/
EXECUTE NewLocationSameMenu('French Laundry', '1003 2nd St., Napa, CA 94599');

/*******************************************************************************
  Phase 4, Part 6: create two triggers
*******************************************************************************/
CREATE OR REPLACE VIEW Wine_Info AS
  ( SELECT  Wines.wineName, Wines.vintage, Wines.makerName, Wines.color,
            Made_Of.varietal, Origin.appellationName, Appellations.county,
            Appellations.climate
    FROM Wines, Made_Of, Origin, Appellations
    WHERE ( Wines.wineName = Made_Of.wineName AND
            Wines.vintage = Made_Of.vintage AND
            Wines.makerName = Made_Of.makerName)
      AND ( Made_Of.wineName = Origin.wineName AND
            Made_Of.vintage = Origin.vintage AND
            Made_Of.makerName = Origin.makerName)
      AND ( Origin.appellationName = Appellations.appellationName)
  );

CREATE OR REPLACE PROCEDURE Add_Wine_Proc (
      wine IN Wines.wineName%TYPE,
      vint IN Wines.vintage%TYPE,
      maker IN Wines.makerName%TYPE,
      clr IN Wines.color%TYPE,
      grape IN Made_Of.varietal%TYPE,
      appellation IN Origin.appellationName%TYPE,
      cnty IN Appellations.county%TYPE,
      clmt IN Appellations.climate%TYPE)
IS
  rowCount NUMBER;
BEGIN
  SELECT COUNT(*) INTO rowCount
  FROM Grapes
  WHERE Grapes.varietal = grape;
  IF (rowCount = 0) THEN           --if varietal not already in database, add it
    INSERT INTO Grapes VALUES (grape);
  END IF;

SELECT COUNT(*) INTO rowCount
  FROM Appellations
  WHERE Appellations.appellationName = appellation AND
        Appellations.county = cnty AND
        Appellations.climate = clmt;
  IF (rowCount = 0) THEN        --if appellation not already in database, add it
    INSERT INTO Appellations
      VALUES (appellation, cnty, clmt);
  END IF;

  SELECT COUNT(*) INTO rowCount
  FROM Comes_From
  WHERE grape = Comes_From.varietal AND
        appellation = Comes_From.appellationName;
  IF (rowCount = 0) THEN    --if Comes_From data not already in database, add it
    INSERT INTO Comes_From
      VALUES (grape, appellation);
  END IF;

  SELECT COUNT(*) INTO rowCount
  FROM Wines
  WHERE wine = Wines.wineName AND
        vint = Wines.vintage AND
        maker = Wines.makerName;
  IF (rowCount = 0) THEN               --if wine not already in database, add it
    INSERT INTO Wines
      VALUES (wine, vint, maker, clr);
  END IF;

  SELECT COUNT(*) INTO rowCount
  FROM Made_Of
  WHERE wine = Made_Of.wineName AND
        vint = Made_Of.vintage AND
        maker = Made_Of.makerName AND
        grape = Made_Of.varietal;
  IF (rowCount = 0) THEN       --if Made_Of data not already in database, add it
    INSERT INTO Made_Of
      VALUES (wine, vint, maker, grape);
  END IF;

  SELECT COUNT(*) INTO rowCount
  FROM Origin
  WHERE wine = Origin.wineName AND
        vint = Origin.vintage AND
        maker = Origin.makerName AND
        appellation = Origin.appellationName;
  IF (rowCount = 0) THEN        --if Origin data not already in database, add it
    INSERT INTO Origin
      VALUES (wine, vint, maker, appellation);
  END IF;

  SELECT COUNT(*) INTO rowCount
  FROM Uses
  WHERE grape = Uses.varietal AND
        maker = Uses.makerName;
  IF (rowCount = 0) THEN          --if Uses data not already in database, add it
    INSERT INTO Uses
      VALUES (grape, maker);
  END IF;
END;
/

CREATE OR REPLACE TRIGGER Add_Wine_Trig
INSTEAD OF INSERT ON Wine_Info
FOR EACH ROW
DECLARE
  rowCount NUMBER;
BEGIN
  SELECT COUNT(*) INTO rowCount
  FROM Wines
  WHERE :new.wineName = wineName AND
        :new.vintage = vintage AND
        :new.makerName = makerName;
  IF (rowCount = 0) THEN          --if wine not already in database, then add it
    Add_Wine_Proc ( :new.wineName, :new.vintage, :new.makerName, :new.color,
                    :new.varietal, :new.appellationName, :new.county,
                    :new.climate);
  END IF;
END;
/

INSERT INTO Wine_Info
  VALUES ('Best Evil Wine Ever', 1850, 'Domaine Chandon Winery', 'Rose',
          'Super GMO Grape', 'Monsanto Sonoma', 'Sonoma', 'Hot');

DROP TABLE Restaurant_Chains CASCADE CONSTRAINTS;
CREATE TABLE Restaurant_Chains (
  restaurantName VARCHAR2(30) PRIMARY KEY,
  numLocations NUMBER,
  chainDate DATE
);

CREATE OR REPLACE TRIGGER Add_Chain_Trig
AFTER INSERT OR DELETE ON Restaurants
DECLARE
  currentCount NUMBER;
  locCount NUMBER;
  restaurant VARCHAR2(30);
  todayDate DATE;
  rowCount NUMBER;
  CURSOR cnt IS
    SELECT restaurantName, COUNT(*)
    FROM Restaurants
    GROUP BY restaurantName;
BEGIN
  SELECT SYSDATE INTO todayDate FROM DUAL;
  OPEN cnt;
  LOOP
    FETCH cnt INTO restaurant, locCount;
    EXIT WHEN cnt%NOTFOUND;
    SELECT COUNT(*) INTO rowCount
    FROM Restaurant_Chains
    WHERE restaurantName LIKE restaurant;
    IF locCount > 2 THEN
      IF rowCount = 0 THEN
        INSERT INTO Restaurant_Chains VALUES (restaurant, locCount, todayDate);
      ELSE
        UPDATE Restaurant_Chains
        SET numLocations = locCount
        WHERE restaurantName = restaurant;
      END IF;
    ELSIF rowCount = 1 THEN
      DELETE FROM Restaurant_Chains WHERE restaurantName LIKE restaurant;
    END IF;
  END LOOP;
  CLOSE cnt;
END;
/

EXECUTE NewLocationSameMenu('La Toque', '1316 McKinstry St., Napa, CA 94599');
EXECUTE NewLocationSameMenu('La Toque', '1318 McKinstry St., Napa, CA 94599');
EXECUTE NewLocationSameMenu('Etoile', '3 California Dr., Yountville, CA 94599');
