select * 
from  `dataexplorationproject-350216.CovidData.CovidDeaths`
where continent is not null --not to show entire continents data 
and location = 'Canada'
order by 3,4
 

--select * 
--from  `dataexplorationproject-350216.CovidData.CovidVaccination`
--order by 3,4

--Select Data we will be using

select location, date, total_cases, new_cases, total_deaths, population
from  `dataexplorationproject-350216.CovidData.CovidDeaths`
where continent is not null --not to show entire continents data
order by 1,2

--Looking at total cases vs total deaths
--likelihood of dying if getting covid-19 on your country
select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from  `dataexplorationproject-350216.CovidData.CovidDeaths`
Where location = 'Colombia'
order by 1,2

--Looking at total cases vs population
--what percentage of population got covid-19
select location, date, total_cases,population,(total_cases/population)*100 as Case_Percentage
from  `dataexplorationproject-350216.CovidData.CovidDeaths`
Where location = 'Colombia'
order by 1,2

--Which country has the higher case percentage

select location, population, MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as Case_Percentage
from  `dataexplorationproject-350216.CovidData.CovidDeaths`
where continent is not null --not to show entire continents data
group by location, population
order by Case_Percentage desc

--countries with highest death count per population

select location, MAX(total_deaths) as TotalDeathCount
from  `dataexplorationproject-350216.CovidData.CovidDeaths`
where continent is not null --not to show entire continents data
group by location
order by TotalDeathCount desc

--Breaking it down by Continent

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from  `dataexplorationproject-350216.CovidData.CovidDeaths`
where continent is null
group by location
order by TotalDeathCount desc

--Continents with highest death per population

select continent, MAX(total_deaths) as TotalDeathCount
from  `dataexplorationproject-350216.CovidData.CovidDeaths`
where continent is not null --not to show entire continents data
group by continent
order by TotalDeathCount desc

--Global Numbers

select  SUM(new_cases) as total_cases, SUM(new_deaths)as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from  `dataexplorationproject-350216.CovidData.CovidDeaths`
Where continent is not null
--group by date
order by 1,2





--total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,dea.date) as Vaccinated_up_to_date
, ()
from `dataexplorationproject-350216.CovidData.CovidDeaths` dea
join `dataexplorationproject-350216.CovidData.CovidVaccination` vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null  --and dea.location = 'Canada'
order by 2,3  

--Using a CTE

with PopvsVac 
AS (select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location,dea.date) as Vaccinated_up_to_date
from `dataexplorationproject-350216.CovidData.CovidDeaths` dea
join `dataexplorationproject-350216.CovidData.CovidVaccination` vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null  --and dea.location = 'Canada'
)
Select *, (Vaccinated_up_to_date/population)*100 as Vaccinated_Percentage
from PopvsVac