Select *
From PortfolioProject..coviddeaths
Where continent is not null
Order by 3,4


--Select *
--From PortfolioProject..covidvaccinations
--Order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..coviddeaths
Order by 1,2

--Total cases vs total deaths

Select location,date,total_cases,total_deaths,CAST(total_deaths AS float)/CAST(total_cases AS float) *100 as DeathPercentage
From PortfolioProject..coviddeaths
Where location like '%tan%'
Order by 1,2

--Total cases vs population

Select location,date,total_cases,total_deaths,population,CAST(total_cases AS float)/CAST(population AS float) *100 as DeathPercentage
From PortfolioProject..coviddeaths
Order by 1,2

--Countries with highest infection rate compared to population

Select location,MAX(total_cases) as HighestInfectionCount,population,MAX(CAST(total_cases AS float)/CAST(population AS float)) *100 as PercentPopulationInfected
From PortfolioProject..coviddeaths
Group by location,population
Order by PercentPopulationInfected desc

--countries with highest death count per population

Select location,MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject..coviddeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc

-- Seperating by continents

Select continent,MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject..coviddeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Displaying continents with the highest death count per poplulation

Select continent,MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject..coviddeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc


--Global numbers

SELECT
       SUM(new_cases) AS total_cases,
       SUM(CAST(new_deaths AS int)) AS total_deaths,
       SUM(CAST(new_deaths AS int)) / SUM(new_cases) * 100 AS DeathPercentage
FROM PortfolioProject..coviddeaths
WHERE continent IS NOT NULL
-- AND location LIKE '%tan%'
--GROUP BY date
HAVING SUM(new_cases) > 0
ORDER BY 1, 2

--Total population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as Rollingpeoplevaccinated

FROM PortfolioProject..coviddeaths dea
JOIN PortfolioProject..covidvaccination vac
     ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

-- Using CTE

With popvsvac (continent,location,date,population,Rollingpeoplevaccinated, new_vaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as Rollingpeoplevaccinated

FROM PortfolioProject..coviddeaths dea
JOIN PortfolioProject..covidvaccination vac
     ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3
)
Select *,(Rollingpeoplevaccinated/population)*100
From popvsvac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

insert into #PercentPopulationVaccinatedc 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as Rollingpeoplevaccinated

FROM PortfolioProject..coviddeaths dea
JOIN PortfolioProject..covidvaccination vac
     ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3

Select *,(Rollingpeoplevaccinated/population)*100
From #PercentPopulationVaccinated

--Creating view 

CREATE VIEW MyPercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM PortfolioProject..coviddeaths dea
JOIN PortfolioProject..covidvaccination vac
     ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


--create view PercentPopulationVaccinated as
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--       SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as Rollingpeoplevaccinated

--FROM PortfolioProject..coviddeaths dea
--JOIN PortfolioProject..covidvaccination vac
--     ON dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
----ORDER BY 2, 3




 





























































Select location,date,total_cases,total_deaths, CAST(total_deaths AS float) / CAST(total_cases AS float) as death_rate
From PortfolioProject..coviddeaths
Order by 1,2

