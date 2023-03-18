


--whats the death percentage if u got the flue in usa
--select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_persentage
--from CovidDeaths
--where location like '%state%'
--order by 1,2


----shows what percentage of population got covid in usa

--select location,date,population,total_cases,(total_cases/population)*100 as infected_persentage
--from CovidDeaths
--where location like '%state%'
--order by infected_persentage

----shows highest infected rates based on pouplation 

--select location,population,max(total_cases) as highInfactionCount,max((total_cases/population))*100 as HighstinfectedpPersentage
--from CovidDeaths
----where location like '%state%'
--group by location,population
--order by HighstinfectedpPersentage desc

---- shows the countres with highest death rate beased on their population


--select location,max(total_deaths) as highdeathCount
--from CovidDeaths
----where location like '%state%'
--WHERE continent is not null
--group by location
--order by highdeathCount desc


----breake things down with continent


--select continent,max(cast(total_deaths as int)) as highdeathCount
--from CovidDeaths
----where location like '%state%'
--WHERE continent is not null
--group by continent
--order by highdeathCount desc


---- global numbers

--Select date, SUM(new_cases), SUM(convert(int,new_deaths))-- as total_deaths, SUM(cast(new_deaths as nvarchar))/SUM(New_Cases)*100 as DeathPercentage
--From CovidDeaths
----Where location like '%states%'
----where continent is not null 
--Group By date
--order by 1,2


-- people infected vs people vaccinated
with popVsvac ( continent,location,date,population,new_vaccinations,rolling_people_vaccinated  )
as (
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over ( partition by dea.location order by dea.location,dea.date ROWS UNBOUNDED PRECEDING)  as rolling_people_vaccinated 
from CovidDeaths dea
join CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null 
	--order by 2,3
	)
	select *,(rolling_people_vaccinated /population)*100
	from popVsvac

	-- temp table
	drop table if exists #percentpopulatedvaccinated
	create table #percentpopulatedvaccinated(
	continent nvarchar (255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccination varchar(255),
	rolling_people_vaccinated numeric)

insert into #percentpopulatedvaccinated
	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over ( partition by dea.location order by dea.location,dea.date ROWS UNBOUNDED PRECEDING)  as rolling_people_vaccinated 
from CovidDeaths dea
join CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null 
	order by 2,3
	select *,(rolling_people_vaccinated /population)*100
	from #percentpopulatedvaccinated

	create view percentpopulatedvaccinated as
	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over ( partition by dea.location order by dea.location,dea.date ROWS UNBOUNDED PRECEDING)  as rolling_people_vaccinated 
from CovidDeaths dea
join CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null 
	

