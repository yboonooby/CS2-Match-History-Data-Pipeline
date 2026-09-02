# CS2 Match History ETL & SQL Analytics Pipeline

An E2E data analytics pipeline, converting raw CS2 match history HTML exports using Python, loading it in a PostgreSQL database and runs advanced analytical queries for performance tracking.

## Tech Stack

* **ETL / SCRIPTING:** Python (Pandas, BeautifulSoup)
* **Database:** PostgreSQL
* **Database Driver:** SQLAlchemy, psycopg2
* **Database GUI:** DBeaver
* **Version Control:** Git

## Pipeline Architecture

**Extraction & cleaning (convert.py):** 
Parses the raw CS2 match history HTML (cs2matches.html), cleans missing/formatted numeric strings, and exports into a standardised CSV file.

**Database and upload (upload_to_db.py):**
Establishes a connection to PostgreSQL via SQLAlchemy and loads the dataset into the "cs2_matches" table.

**Advanced SQL Analytics (sql/):**
Runs custom analytical queries in PostgreSQL to analyze player statistics, personal map-specific and player-specific performance.

## Setup & Execution

### 1. Requirements
Ensure you have *Python 3.x* and *PostgreSQL* installed. DBeaver is not strictly needed, but this project uses it to run the SQL queries so I suggest using it to follow the instructions.

### 2. Download the CS2 Match History HTML
(You necessarily need to be logged into the steam account)
1. **Open your steam profile and click on "Games"**
2. **Search for "Counter-Strike 2"**
3. **Click on "My Game Stats" then on "[your_user]'s Personal Game Data"**
4. **Open "Ranked Competitive Matches" (or "Competitive Matches" if you don't have prime or only play with people who don't have it)**
5. **The number of matches you load is the number you will download. In order to download them all, scroll down until you see "LOAD MORE HISTORY". Repeat the process until the date at the bottom goes back but no more matches appear**
6. **To download the HTML, press CTRL+S (or CMD+S if on Mac) and rename the file to "cs2matches.html"**
7. **Finally, put it in the same folder as the Python scripts**

### 3. Configure Database Credentials
Create a local credentials file from the example template **upload_to_db.py.example** (run the terminal command *"cp upload_to_db.py.example upload_to_db.py"*). Open the created file and update the PostgreSQL credentials with your own.

### 4. Run the Pipeline
Execute both Python scripts (in the terminal or directly from VSCode or any other editor you're using) in the following order:
1. *python convert.py*
2. *python upload_to_db.py*

### 5. Run SQL Queries
Open DBeaver, connect your database and run any query in the sql/ folder.

## Example Outputs

### Query 01
Outputs the overall performance of every specified player, including the statistics:
* **Total matches played**
* **Best player rate (highest score in the match)**
* **Average MVP count**
* **Average kills, assists, deaths and score**
* **Average KD and KDA Ratio**
* **Average headshot percentage (HS%/HSP)**

This query also orders descendingly the output by score.

### Query 02
Outputs the same values of query 01, but instead focuses on one player's performance through all the maps played. This query also includes "Average Ping".

### Query 03
Outputs the same values of query 01, but instead focuses on one player's performance with all the specified players.