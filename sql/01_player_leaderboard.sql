with match_ranks as (
select *,
dense_rank() over (partition by date order by score desc) as "rnk"
-- The date is used as an ID since an user cannot start two matches at the same hour
from cs2_matches cm)

select
cm.player,
count(*) as total_matches,
round(count(case when "rnk" = 1 then 1 end)::NUMERIC/count(*)::NUMERIC, 2) as "Best Player Rate",
round(avg(mvps), 2) as "Average MVPs",
round(avg(kills), 2) as "Average Kills",
round(avg(assists), 2) as "Average Assists",
round(avg(deaths), 2) as "Average Deaths",
round(avg(kills)/NULLIF(avg(deaths), 0), 2) as "KD Ratio",
round((avg(kills)+avg(assists))/NULLIF(avg(deaths), 0), 2) as "KDA Ratio",
round(avg(hsp), 2) as "Average HS%",
round(avg(score), 2) as "Average Score"
from match_ranks cm
where player in ('user_1', 'user_2')
-- Change the users in the "where" clausule with all the users whose performance you want to track
group by player
order by avg(score) DESC