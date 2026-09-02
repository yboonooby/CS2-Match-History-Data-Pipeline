with match_ranks as(
select *,
dense_rank() over (partition by date order by score desc) as rnk
from cs2_matches cm)

select
teammate.player as "Teammate",
count(*) as "Total Matches",
round(count(case when "rnk" = 1 then 1 end)::numeric/count(*)::numeric, 2) as "Best Player Rate",
round(avg(my_stats.mvps), 2) as "Average MVPs",
round(avg(my_stats.kills), 2) as "Average Kills",
round(avg(my_stats.assists), 2) as "Average Assists",
round(avg(my_stats.deaths), 2) as "Average Deaths",
round(avg(my_stats.kills)/NULLIF(avg(my_stats.deaths), 0), 2) as "KD Ratio",
round((avg(my_stats.kills)+avg(my_stats.assists))/NULLIF(avg(my_stats.deaths), 0), 2) as "KDA Ratio",
round(avg(my_stats.hsp), 2) as "Average HS%",
round(avg(my_stats.score), 2) as "Average Score"
from match_ranks my_stats
join cs2_matches teammate
on my_stats.date = teammate.date
where my_stats.player = 'user_1'
-- Change the user in the "where" clausule with the user whose performance you want to track
and teammate.player in ('user_2', 'user_3')
-- Change the user in the "and" clausule with the teammates you want to pair the first user with
group by teammate.player
order by round(avg(my_stats.score), 2) desc