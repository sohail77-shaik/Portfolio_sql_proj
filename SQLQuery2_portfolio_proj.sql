--SELECT *
--FROM Portfolio_Proj..CovidDeaths$
--order by 3,4
--SELECT *
--FROM Portfolio_Proj..CovidVaccination$
--order by 3,4

SELECT date, SUM(new_cases) as totalcases, SUM(cast(new_deaths as int)) as totaldeaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as deathpercent
FROM Portfolio_Proj.. CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY date
order by 1,2
-- Population vs vaccination
with popvsvac(continent,population,location,date,new_vaccinations,sumofvac)
as
(
SELECT dae.continent,dae.population, dae.location, dae.date, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (partition by dae.location order by dae.location,dae.date) sumofvac
FROM Portfolio_Proj.. CovidDeaths$ dae Join
Portfolio_Proj ..CovidVaccination$ vac on
dae.location = vac.location and dae.date=vac.date
WHERE dae.continent IS NOT NULL

)
SELECT *,(sumofvac/population)*100 as totpopvac from popvsvac
--create view
Create View popvsvaccine as
SELECT dae.continent,dae.population, dae.location, dae.date, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (partition by dae.location order by dae.location,dae.date) sumofvac
FROM Portfolio_Proj.. CovidDeaths$ dae Join
Portfolio_Proj ..CovidVaccination$ vac on
dae.location = vac.location and dae.date=vac.date
WHERE dae.continent IS NOT NULL;


SELECT * FROM popvsvaccine