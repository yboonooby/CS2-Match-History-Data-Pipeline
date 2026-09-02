with match_ranks as (
select *,
dense_rank() over (partition by date order by score desc) as "rnk"
from cs2_matches cm)

select
map,
count(*) as total_matches,
round(avg(ping), 2) as "Average Ping",
round(count(case when "rnk" = 1 then 1 end)::NUMERIC/count(*)::NUMERIC, 2) as "Best Player Rate",
round(avg(mvps), 2) as "Average MVPs",
round(avg(kills), 2) as "Average Kills",
round(avg(assists), 2) as "Average Assists",
round(avg(deaths), 2) as "Average Deaths",
round(avg(kills)/NULLIF(avg(deaths), 0), 2) as "KD Ratio",
round((avg(kills)+avg(assists))/NULLIF(avg(deaths), 0), 2) as "KDA Ratio",
round(avg(hsp), 2) as "Average HS%",
round(avg(score), 2) as "Average Score"
from match_ranks
where player in ('user')
-- Change the user in the "where" clausule with the user whose performance you want to track
group by player, map
order by round(avg(score), 2) desc