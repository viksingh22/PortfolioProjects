/*
Objective:
Explore and analyze COVID-19 data using SQL in SQL Server to gain insights into cases, deaths, vaccinations, and population percentages.

Data:
COVID-19 data was sourced from "https://ourworldindata.org/covid-deaths," imported, cleaned, and organized into CovidDeaths and CovidVaccinations tables.

Analysis:
SQL queries calculated relationships between total cases and deaths, death likelihood by country, cases vs populations, population percentages affected, highest infection rates, and more.

Highlights:
- Imported, cleaned, and segmented COVID-19 data.
- Employed SQL queries to address key questions.
- Temporary tables and views aided in intermediate results.
- Demonstrated problem-solving in data exploration.

Conclusion:
This project used SQL Server to effectively analyze COVID-19 data, achieving its objectives by providing insights into cases, deaths, vaccinations, and population percentages. The exercise underscored the power of SQL for extracting insights from large datasets.
*/
SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3,4

SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
ORDER BY 3,4

-- Select Data that I am going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths (USA)
-- Shows percentage of Total Cases that resulted in death in the United States
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS NUMERIC)/ CAST(total_cases AS NUMERIC))*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location='United States'
ORDER BY 1,2

-- Looking at Total Cases vs Population (USA)
-- Shows what percentage of population infected with covid (USA)
SELECT location, date, total_cases, population, (CAST(total_cases AS NUMERIC)/ CAST(population AS NUMERIC))*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE location='United States'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, (CAST(MAX(total_cases) AS NUMERIC)/ CAST(population AS NUMERIC))*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Showing Total Death Count by Countries
SELECT location, MAX(CAST(total_deaths AS NUMERIC)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing Total Death Count by Continents
SELECT location, MAX(CAST(total_deaths AS NUMERIC)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS by date
SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS NUMERIC)) AS TotalDeaths, (SUM(CAST(new_deaths AS NUMERIC))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Looking at Total Population vs Vaccinations
-- Use CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS NUMERIC)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

Select *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac
ORDER BY location, date;


-- TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent NVARCHAR(255),
location NVARCHAR(255),
date datetime,
population NUMERIC,
new_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS NUMERIC)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated
ORDER BY location, date;


-- Creating View to store data for later visulizations
USE PortfolioProject
GO
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS NUMERIC)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT * 
FROM PercentPopulationVaccinated
ORDER BY location, date;