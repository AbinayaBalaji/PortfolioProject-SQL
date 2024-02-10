-- To select all rows from table CovidDeaths where continent is not null. This is juust to get overview of table structure and data
select * from PortfolioProject..CovidDeaths 
where continent is NOT NULL order by 3,4
----------------------------------------------------------------------------------------------------------------------------
-- To select all rows from table CovidVaccinations . This is juust to get overview of table structure and data
select * from PortfolioProject..CovidVaccinations order by 3,4 
----------------------------------------------------------------------------------------------------------------------------
-- To select all rows from table CovidDeaths where continent is Asia
select * from PortfolioProject..CovidDeaths 
where continent ='Asia'
----------------------------------------------------------------------------------------------------------------------------
-- shows likelyhood of death if covid in Singapore
select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as percentage 
from PortfolioProject..CovidDeaths where Location ='Singapore'
----------------------------------------------------------------------------------------------------------------------------
-- looking at total cases / population 
select Location,date,total_cases,population, (total_cases/population)*100 as Affectedpercentage 
from PortfolioProject..CovidDeaths where Location ='Singapore'
----------------------------------------------------------------------------------------------------------------------------
-- looking at countries with high inection rate 
select Location,population ,max(total_cases) as highestcaseCount ,
max((total_cases/population))*100 as PercentPopulationInfected 
from PortfolioProject..CovidDeaths where continent is not null
group by Location,population order by highestcaseCount desc 
----------------------------------------------------------------------------------------------------------------------------
-- countries with highest death count  
select Location,population ,max(cast(total_deaths as int)) as totaldeathcount 
from PortfolioProject..CovidDeaths where continent IS NOT NULL 
group by Location,population order by totaldeathcount desc 
----------------------------------------------------------------------------------------------------------------------------
-- List of countries in NorthAmerica with total case and total death count 
select  continent,location, max(cast(total_cases as int)) as totalcasecount, 
max(cast(total_deaths as int)) as totaldeathcount from PortfolioProject..CovidDeaths
where continent is not null and continent ='North America'
group by continent,Location order by totalcasecount desc
----------------------------------------------------------------------------------------------------------------------------
-- List of countries in Asia with total case and total death count 
select  continent, location,max(cast(total_cases as int)) as totalcasecount, 
max(cast(total_deaths as int)) as totaldeathcount from PortfolioProject..CovidDeaths 
where continent is not null and continent ='Asia'
group by continent,Location order by totaldeathcount desc
----------------------------------------------------------------------------------------------------------------------------
-- List of countries in SouthAmerica with total case and total death count 
select continent,location, max(cast(total_cases as int)) as totalcasecount,
max(cast(total_deaths as int)) as totaldeathcount from PortfolioProject..CovidDeaths 
where continent is not null and continent ='South America' 
group by continent,Location order by totalcasecount desc
----------------------------------------------------------------------------------------------------------------------------
-- List of countries in Africa with total case and total death count 
select continent,location, max(cast(total_cases as int)) as totalcasecount,
max(cast(total_deaths as int)) as totaldeathcount from PortfolioProject..CovidDeaths  
where continent is not null and continent ='Africa' 
group by continent,Location order by totaldeathcount desc
----------------------------------------------------------------------------------------------------------------------------
-- List of countries in Oceania with total case and total death count 
select continent,location, max(cast(total_cases as int)) as totalcasecount, 
max(cast(total_deaths as int)) as totaldeathcount from PortfolioProject..CovidDeaths
where continent is not null and continent ='Oceania'
group by continent,Location order by totalcasecount desc
----------------------------------------------------------------------------------------------------------------------------
-- List of countries in Europe with total case and total death count 
select  location,continent, max(cast(total_cases as int)) as totalcasecount,
max(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths where continent is not null 
and continent ='Europe' group by continent,Location 
order by totalcasecount desc
----------------------------------------------------------------------------------------------------------------------------
-- we can use new_cases column with sum instead of total_cases field also 
-- List of countries in Oceania with total case and total death count 
select  location,continent, sum(cast(new_cases as int)) as totalcasecount,
sum(cast(new_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths where continent is not null
and continent ='Oceania' group by continent,Location 
order by totalcasecount desc
----------------------------------------------------------------------------------------------------------------------------
-- List of all continents and their respective total case count and death count 
select continent, sum(cast(new_cases as int)) as totalcasecount, sum(cast(new_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths 
where continent is not null  
group by continent
----------------------------------------------------------------------------------------------------------------------------
--find out total cases ans total death and death percentage across world date-wise 
select date, SUM(new_cases) as totalcasecount, SUM(cast(new_deaths as int)) as totaldeathcount, 
sum(cast(new_deaths as int))/sum(new_cases) *100 as deathpercentage 
from PortfolioProject..CovidDeaths where continent is not null  
group by date
order by date
----------------------------------------------------------------------------------------------------------------------------
--find out total cases ans total death and death percentage across world without date
select  SUM(new_cases) as totalcasecount, SUM(cast(new_deaths as int)) as totaldeathcount, 
sum(cast(new_deaths as int))/sum(new_cases) *100 as deathpercentage 
from PortfolioProject..CovidDeaths 
where continent is not null  
----------------------------------------------------------------------------------------------------------------------------
-- find in each continent which country has max case count 
select Top (1) Location, max(total_cases) as totalcasecount 
from PortfolioProject..CovidDeaths where continent is not null and continent = 'Oceania'
group by Continent,Location 
order by totalcasecount desc
----------------------------------------------------------------------------------------------------------------------------
select Top (1) Location, max(total_cases) as totalcasecount 
from PortfolioProject..CovidDeaths 
where continent is not null  and continent = 'North America'
group by Continent,Location
order by totalcasecount desc
----------------------------------------------------------------------------------------------------------------------------
--Join two tables and find total case count, total death count and total vaccinated count for Australia
select distinct d.location,max(d.total_cases) as totalcasecount,
max(cast(d.total_deaths as int)) as totaldeathcount,max(v.total_vaccinations) as vaccinatedcount
from PortfolioProject..CovidDeaths d
join 
 PortfolioProject..CovidVaccinations  v
on d.location = v.location
and d.continent = v.continent
where v.continent is not null  and v.continent='Oceania' and v.location='Australia'
group by d.continent,d.location
order by totalcasecount desc;
----------------------------------------------------------------------------------------------------------------------------
--Join two tables and find total case count, total death count and total vaccinated count for continent Oceania
select distinct d.location,max(d.total_cases) as totalcasecount,
max(cast(d.total_deaths as int)) as totaldeathcount,max(v.total_vaccinations) as vaccinatedcount
from  PortfolioProject..CovidDeaths AS  d
 join 
 PortfolioProject..CovidVaccinations v
on d.location = v.location
where d.continent is not null and d.continent ='Oceania'
group by d.location,d.continent
order by totalcasecount desc;
----------------------------------------------------------------------------------------------------------------------------
-- Find rollingvaccinationcount and percentage of people vaccinated using CTE - Common Table Expressions
with PopVsVac(continent, Location, date,population,new_vaccinations,rollingvaccinationcount)
as
(
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) Over(Partition by d.location order by d.location ,d.date) as rollingtotal
from PortfolioProject..CovidDeaths AS  d
join 
PortfolioProject..CovidVaccinations AS  v
on d.location = v.location and 
d.date = v.date
where d.continent is not null 
)
select *,(rollingvaccinationcount/population)*100 as percentagevaccinated from PopVsVac 
----------------------------------------------------------------------------------------------------------------------------
-- Find rollingvaccinationcount and percentage of people vaccinated using Temp Table

Drop table if exists PercentagePopulationVaccinated
create table PercentagePopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_Vaccination numeric,
Rollingpeoplevaccinated numeric
)

Insert into PercentagePopulationVaccinated
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) Over(Partition by d.location order by d.location ,d.date) as rollingtotal
from PortfolioProject..CovidDeaths AS  d
join 
PortfolioProject..CovidVaccinations AS  v
on d.location = v.location and 
d.date = v.date
where d.continent is not null and d.location ='Albania'

select *,(Rollingpeoplevaccinated/population)*100 as percentagevaccinated from PercentagePopulationVaccinated 

--------------------------------------------------------------------------------------------------------------------------------------
-- create view 
create view percentagepopulationvaccinatedview as 
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) Over(Partition by d.location order by d.location ,d.date) as rollingtotal
from PortfolioProject..CovidDeaths AS  d
join 
PortfolioProject..CovidVaccinations AS  v
on d.location = v.location and 
d.date = v.date
where d.continent is not null 

select * from percentagepopulationvaccinatedview