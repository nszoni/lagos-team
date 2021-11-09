#!/bin/bash

# this shell script loads all the necessary data for you.

# User input credentials
 
read -p "Enter source data folder (absolute path): " dir

read -p "Enter MySQL username: " user

read -s -p "Enter Password: "  password

read -p "Enter Host: "  host

read -p "Enter Port: "  port

database=imdb

# truncate db

mysql --user="$user" --password="$password" --host="$host"  --port="$port"  --database="$database" << EOF
set FOREIGN_KEY_CHECKS = 0;
truncate table actors;
truncate table directors;
truncate table directors_genres;
truncate table movies;
truncate table movies_genres;
truncate table movies_directors;
truncate table roles;
set FOREIGN_KEY_CHECKS = 1;
EOF

for f in "$dir"*.tsv
do
    mysql -e "LOAD DATA LOCAL INFILE '"$f"' INTO TABLE `expr "$f" | sed -r "s/.+\/(.+)\..+/\1/"` COLUMNS TERMINATED BY '\t' IGNORE 1 LINES;" --user="$user" --password="$password" --host="$host"  --port="$port" --database="$database"
echo "Done: '"$f"' loaded at $(date)"
done
