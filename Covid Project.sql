Use [Covid Project]

 Select * From CovidDeaths$
 Where continent is not null
 Order by 3, 4
 --Select * From CovidVaccinations$
 --Order by 3, 4

 Select location ,date ,total_cases,new_cases ,total_deaths ,population
 From CovidDeaths$
  Order by 1, 2

  --Total Cases Vs Total Deaths--
  --This shows the likelihood of dying if you tracked the covid in your country--
Select location ,date ,total_cases ,total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
 From CovidDeaths$
 Where location like '%nigeria%'
  Order by 1, 2

  -- Total Cases Vs Population
  -- This shows what percentage of the Population has Covid
  Select location ,date ,total_cases,(total_cases/population)*100 as PopulationPercentage
 From CovidDeaths$
 Where location like '%nigeria%'
  Order by 1, 2

  -- Country with the Highest Infection rate compared to population--

  Select location ,Max(total_cases) AS HighestInfectionCount, Max(total_deaths/population)*100 as PercentagePopulationInfected
 From CovidDeaths$
 --Where location like '%nigeria%'
 Where continent is not null
 Group by location, population
  Order by PercentagePopulationInfected DESC

  --Countries with the Highest Death Count per Population
    Select location, MAX(cast(total_deaths as int)) as TotalDeathCounts
 From CovidDeaths$
 --Where location like '%nigeria%'
 Where continent is null
 Group by location
  Order by TotalDeathCounts DESC

  -- By not null locations--
 Select  location, MAX(cast(total_deaths as int)) as TotalDeathCounts
 From CovidDeaths$
 --Where location like '%nigeria%'
 Where continent is not null
 Group by location
  Order by TotalDeathCounts DESC

-- Continents with the Highest death counts--

    Select continent, MAX(cast(total_deaths as int)) as TotalDeathCounts
 From CovidDeaths$
 --Where location like '%nigeria%'
 Where continent is not null
 Group by continent
  Order by TotalDeathCounts DESC

--Global Numbers--
   
Select date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as Total_deaths,
SUM(cast(new_deaths as int)), SUM(new_cases) *100   as DeathPercentage
 From CovidDeaths$
 --Where location like '%nigeria%'
 Where continent is not null
 Group by date
  Order by 1, 2

  Select * From CovidDeaths$ dea
  Join CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date 

  -- Total Population va Vaccinations
  Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
  , SUM(Convert(int, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) AS PeopleVaccinated
From CovidDeaths$ dea
  Join CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date 
  Where dea.continent is not null
  Order by 2,3

-- USING CTE--
With PopvsVac (continent, location, date, population,new_vaccinations, PeopleVaccinated)
AS 
(
  Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
  , SUM(Convert(int, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location, dea.date) AS PeopleVaccinated
From CovidDeaths$ dea
  Join CovidVaccinations$ vac
  on dea.location = vac.location
  and dea.date = vac.date 
  Where dea.continent is not null
  --Order by 2,3
  )
Select *
From PopvsVac 