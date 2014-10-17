#/bin/sh

export TOKEN=**FILL IN THE BLANK**
export DEST_PROJECT=**FILL IN THE BLANK**

# clean up before start
rm -f tmp-*

# get all projects
curl -X GET -H "X-TrackerToken: $TOKEN" "https://www.pivotaltracker.com/services/v5/projects" > tmp-projects-raw.json

# only keep the k-vs we want
jq '[.[] | { id: .id, name: .name, enabled: true}]' < tmp-projects-raw.json | jq 'sort' > projects.json

# convert to csv
jq -r '.[] | [ .id, "*foo*" + .name + ":* "] | @csv '  < projects.json > tmp-projects-id-name.csv

# should probably break the script into 2 here

# only look at enabled projects
jq '[.[] | select(.enabled == true)]' < projects.json > tmp-projects-filtered.json

# turn into a list of ids
jq '.[].id' < tmp-projects-filtered.json > tmp-projects-filtered-ids.txt

# create a blank epics.json
echo > epics.json

while read PROJECT_ID; do
    curl -X GET -H "X-TrackerToken: $TOKEN" "https://www.pivotaltracker.com/services/v5/projects/$PROJECT_ID/epics" > tmp-project-epics.json
    jq -s '.[0] + .[1]' epics.json tmp-project-epics.json > tmp-epics-new.json # this is json compliant append of arrays
    rm epics.json
    mv tmp-epics-new.json epics.json
done < tmp-projects-filtered-ids.txt

# turn this into csvs, with second project_id file to be used for subtitution
jq -r '.[] | [.project_id, .id, .project_id, .name ] | @csv' < epics.json > tmp-epics-filtered.csv

# subtitute second project_id with project name
awk -f mapping3rd-col.awk tmp-projects-id-name.csv tmp-epics-filtered.csv > tmp-epics-with-projects.csv

# mash the second project_id (now project name) with the epic name
sed s/\",\"//g tmp-epics-with-projects.csv > tmp-projectid-epicid-epic.csv

# create it back into tracker
# temp stuff, need to change later

cut -f 3- -d"," tmp-projectid-epicid-epic.csv > tmp-epic-list.txt
sed s/\"//g tmp-epic-list.txt > tmp-epic-list-clean.txt

while read EPIC_NAME; do
    curl -X POST -H "X-TrackerToken: $TOKEN" -H "Content-Type: application/json" -d "{\"name\":\"$EPIC_NAME\"}" "https://www.pivotaltracker.com/services/v5/projects/$DEST_PROJECT/epics"
    # echo "{\"name\":\"$EPIC_NAME\"}" 
done < tmp-epic-list-clean.txt