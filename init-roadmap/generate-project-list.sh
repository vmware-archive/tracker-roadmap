#/bin/sh

source _environment.sh

# clean up before start
rm -f tmp-*

# get all projects
curl -X GET -H "X-TrackerToken: $TOKEN" "https://www.pivotaltracker.com/services/v5/projects" > tmp-projects-raw.json

# only keep the k-vs we want
jq '[.[] | { id: .id, name: .name, enabled: true}]' < tmp-projects-raw.json | jq 'sort' > projects.json

# convert to csv
jq -r '.[] | [ .id, "*" + .name + ":* "] | @csv '  < projects.json > tmp-projects-id-name.csv

# should probably break the script into 2 here
