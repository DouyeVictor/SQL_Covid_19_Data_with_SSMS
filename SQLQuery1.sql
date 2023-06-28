--Aurthor: Douye Victor O.
--Topic: Data Exploration of Covid 19 Data Set
--Tool Used: SSMS
--Dataset Source: https://ourworldindata.org/covid-deaths
--Date of collection: 26-06-2023
--Date of most recent update before collection: 25-06-2023

SELECT *
FROM PortfolioProject.dbo.Covid19Deaths
WHERE Continent is not null
ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.Covid19Deaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
SELECT Location, date, total_cases,total_deaths, (total_deaths *100 / total_cases) as DeathPercentage
FROM PortfolioProject.dbo.Covid19Deaths
WHERE location like '%Kingdom%'
and total_cases is not null
ORDER BY 1,2 

SELECT Location, date, population,total_cases, (total_cases / population) *100 as tp
FROM PortfolioProject.dbo.Covid19Deaths
ORDER BY 1,2

--Looking at countries with the highest infection rate compared to Population
SELECT Location,population,MAX(total_cases) as HighestInfectionCount, Max((total_cases / population))*100 as PercentPopulationInfected
FROM PortfolioProject.dbo.Covid19Deaths
--WHERE location like '%States%'
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

--Showing countries with the highest death count by population
SELECT Location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.Covid19Deaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--Breakdown by continent
SELECT continent, Max(cast(total_deaths as int)) as TotalDeathCount 
FROM PortfolioProject.dbo.Covid19Deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--Global Numbers
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
  (new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.Covid19Deaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

SELECT*
FROM PortfolioProject.dbo.Covid19Deaths as Death
Join PortfolioProject.dbo.CovidVaccinations as Vac
 ON Death.location = Vac.location
 AND Death.date = Vac.date

 --Looking at total population vs Vaccination
 SELECT Death.continent, Death.location, Death.date, Death.population, Vac.new_vaccinations
 , SUM(CONVERT(bigint, Vac.new_vaccinations)) OVER (Partition by Death.location ORDER BY Death.location,
 Death.date) as RollingPeopleVaccinated
 FROM PortfolioProject.dbo.Covid19Deaths as Death
 Join PortfolioProject.dbo.CovidVaccinations as Vac
  ON Death.location = Vac.location
  AND Death.date = Vac.date
WHERE Death.continent is not null
ORDER BY 2,3

-- USE CTE
With PopvsVac ( Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT Death.continent, Death.location, Death.date, Death.population, Vac.new_vaccinations
 , SUM(CONVERT(bigint, Vac.new_vaccinations)) OVER (Partition by Death.location ORDER BY Death.location,
 Death.date) as RollingPeopleVaccinated
 FROM PortfolioProject.dbo.Covid19Deaths as Death
 Join PortfolioProject.dbo.CovidVaccinations as Vac
  ON Death.location = Vac.location
  AND Death.date = Vac.date
WHERE Death.continent is not null
--ORDER BY 2,3
)
SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PopvsVac

--TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated

SELECT Death.continent, Death.location, Death.date, Death.population, Vac.new_vaccinations
 , SUM(CONVERT(bigint, Vac.new_vaccinations)) OVER (Partition by Death.location ORDER BY Death.location,
 Death.date) as RollingPeopleVaccinated
 FROM PortfolioProject.dbo.Covid19Deaths as Death
 Join PortfolioProject.dbo.CovidVaccinations as Vac
  ON Death.location = Vac.location
  AND Death.date = Vac.date
--WHERE Death.continent is not null
--ORDER BY 2,3

SELECT *,(RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

--Creating view to store data for data visualizations
CREATE VIEW PercentPopulationVaccinated as

SELECT Death.continent, Death.location, Death.date, Death.population, Vac.new_vaccinations
 , SUM(CONVERT(bigint, Vac.new_vaccinations)) OVER (Partition by Death.location ORDER BY Death.location,
 Death.date) as RollingPeopleVaccinated
 FROM PortfolioProject.dbo.Covid19Deaths as Death
 Join PortfolioProject.dbo.CovidVaccinations as Vac
  ON Death.location = Vac.location
  AND Death.date = Vac.date
WHERE Death.continent is not null
--ORDER BY 2,3

CREATE VIEW Global_Numbers as

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
  (new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.Covid19Deaths
WHERE continent is not null
--GROUP BY date
--ORDER BY 1,2

CREATE VIEW Infection_Rate_by_Population as
SELECT Location,population,MAX(total_cases) as HighestInfectionCount, Max((total_cases / population))*100 as PercentPopulationInfected
FROM PortfolioProject.dbo.Covid19Deaths
--WHERE location like '%States%'
GROUP BY location, population
--ORDER BY PercentPopulationInfected desc

CREATE VIEW UK_Cases_vs_Deaths as
SELECT Location, date, total_cases,total_deaths, (total_deaths *100 / total_cases) as DeathPercentage
FROM PortfolioProject.dbo.Covid19Deaths
WHERE location like '%Kingdom%'
and total_cases is not null
--ORDER BY 1,2 