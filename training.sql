-- Below code is what i used to upload my csv dataset into
-- the table in mysql bench

-- LOAD DATA local INFILE 'C:/Users/O.BA/Videos/Data Analysis/Alex-The-Analyst-Bootcamp-main/Alex-The-Analyst-Bootcamp-main/SQL/Data-Exploration/CovidVaccinations.csv'
-- INTO TABLE covidvaccinations
-- fields terminated by ','
-- enclosed by '"'
-- lines terminated by '\n'
-- ignore 1 rows;


-- select count(*)
-- from covidimpact.covidvaccinations
-- -- where location='nigeria'
-- ;

-- select count(*)
-- from covidimpact.coviddeaths
-- where location='nigeria'
;


-- LOAD DATA local INFILE 'C:/Users/O.BA/Videos/Data Analysis/Alex-The-Analyst-Bootcamp-main/Alex-The-Analyst-Bootcamp-main/SQL/Data-Exploration/CovidVaccinations.csv'
-- INTO TABLE covidvaccinations
-- fields terminated by ','
-- enclosed by '"'
-- lines terminated by '\n'
-- ignore 1 rows;


-- SELECT location, date, total_cases, new_cases, total_deaths, population
-- FROM covidimpact.coviddeaths
-- ORDER BY location, date;

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

-- SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
-- FROM covidimpact.coviddeaths
-- WHERE location = 'Nigeria'
-- ORDER BY location, date;

-- -- Looking at Total Cases vs Population
-- -- Shows what percentage of population got covid

-- SELECT location, date, population, total_cases, (total_cases/population)*100 AS covid_percentage
-- FROM covidimpact.coviddeaths
-- ORDER BY location, date;

-- -- Looking at Countries with Highest Infection Rate compared to Population

-- SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS percent_of_population_infected
-- FROM covidimpact.coviddeaths
-- GROUP BY location, population
-- ORDER BY percent_of_population_infected DESC;

-- -- Showing Countries with Highest Death Count per Population

-- SELECT location, MAX(total_deaths) AS total_death_count
-- FROM covidimpact.coviddeaths
-- GROUP BY location
-- ORDER BY total_death_count DESC;

-- -- LET'S BREAK THINGS DOWN BY CONTINENT

-- -- Showing continents with the highest death count per population

-- SELECT continent, MAX(total_deaths) AS total_death_count
-- FROM covidimpact.coviddeaths
-- WHERE continent IS NOT NULL
-- GROUP BY continent
-- ORDER BY total_death_count DESC;

-- -- GLOBAL NUMBERS 
-- SELECT SUM(new_cases), SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
-- FROM covidimpact.coviddeaths
-- WHERE continent IS NOT NULL;

-- -- GROUP BY date

-- -- Vaccination table
-- SELECT * FROM covidimpact.covidvaccinations;

-- Looking at Total Population vs Vaccinations
-- SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- FROM covidimpact.coviddeaths AS dea
-- JOIN covidvaccinations AS vac
-- ON dea.location = vac.location
-- and dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- ORDER BY dea.continent, dea.location;

-- -- USE CTE
-- WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
-- AS
-- (SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- FROM covidimpact.coviddeaths AS dea
-- JOIN covidimpact.covidvaccinations AS vac
-- ON dea.location = vac.location
-- and dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- ORDER BY dea.continent, dea.location)
-- SELECT *, (RollingPeopleVaccinated/Population)*100
-- FROM PopVsVac;

-- -- TEMP TABLE
-- DROP TEMPORARY TABLE IF EXISTS percent_population_vaccinated;
-- CREATE TEMPORARY TABLE percent_population_vaccinated 
-- (
-- Continent nvarchar(255), 
-- Location nvarchar(255), 
-- Date datetime, 
-- Population numeric, 
-- New_Vaccinations numeric,
-- RollingPeopleVaccinated numeric
-- );
-- INSERT INTO percent_population_vaccinated
-- (SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- FROM covidimpact.coviddeaths AS dea
-- JOIN covidimpact.covidvaccinations AS vac
-- ON dea.location = vac.location
-- and dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- ORDER BY dea.continent, dea.location);


-- creating a view for data visualization later

-- CREATE view PercentPopulationVaccinated as 
-- (SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- FROM covidimpact.coviddeaths AS dea
-- JOIN covidimpact.covidvaccinations AS vac
-- ON dea.location = vac.location
-- and dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- ORDER BY dea.continent, dea.location);

-- somehow above method didnt work but the below method works

-- CREATE VIEW PercentPopulationVaccinated AS 
-- SELECT 
--     dea.continent, 
--     dea.location, 
--     dea.date, 
--     dea.population, 
--     vac.new_vaccinations,
--     SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
-- FROM 
--     covidimpact.coviddeaths AS dea
-- JOIN 
--     covidimpact.covidvaccinations AS vac
-- ON 
--     dea.location = vac.location
-- AND 
--     dea.date = vac.date
-- WHERE 
--     dea.continent IS NOT NULL;

-- now to query the view
-- select *
-- from covidimpact.percentpopulationvaccinated;
