import re
import pandas as pd
from bs4 import BeautifulSoup

with open('cs2matches.html', 'r', encoding='utf-8') as f: 
    # The utf-8 encoding is needed to avoid Pythons misenterpreting characters such as "★".
    soup = BeautifulSoup(f.read(), 'html.parser')

match_table = []

MAP_PATTERN = r'\b(Dust\s*II|Mirage|Inferno|Nuke|Overpass|Anubis|Ancient|Vertigo|Office|Italy|Cache)\b'
DATE_PATTERN = r'\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}\s+GMT'
# These two variables are needed to later search for the map and date in the text string where they're mixed with part we don't need, such as 'Match Duration'.

current_map = "Unknown Map"
current_date = "Unknown Date"
# Since there are 10 different players for each map, these variables are needed to be applied to all ten players, then get updated.

for string in soup.find_all('tr'):
    raw_string = string.get_text(separator=' ', strip=True)

    if "GMT" in raw_string or "Match Duration" in raw_string:
        map_match = re.search(MAP_PATTERN, raw_string)
        date_match = re.search(DATE_PATTERN, raw_string)

        if map_match:
            current_map = map_match.group(0).strip().title().replace('Ii', 'II')

        if date_match:
           current_date = date_match.group(0).strip()

    else:
        player_link = string.find('a', class_='linkTitle')

        if player_link:
            player = player_link.get_text(strip=True)

            stats = string.find_all('td')

            ping = stats[1].get_text(strip=True)
            kills = stats[2].get_text(strip=True)
            assists = stats[3].get_text(strip=True)
            deaths = stats[4].get_text(strip=True)
            mvps = stats[5].get_text(strip=True).replace("★", "") or "0"
            hsp = stats[6].get_text(strip=True).replace("%", "") or "0"
            score = stats[7].get_text(strip=True)

            match_table.append({
                'date': current_date,
                'map': current_map,
                'player': player,
                'ping': ping,
                'kills': kills,
                'assists': assists,
                'deaths': deaths,
                'mvps': mvps,
                'hsp': hsp,
                'score': score
            }) 

total_rows = len(match_table)
total_matches = total_rows // 10

df = pd.DataFrame(match_table)
df.to_csv('cs2_matches.csv', index=False, encoding='utf-8')

print(f'Exported {total_matches} matches, for a total of {total_rows} rows.')