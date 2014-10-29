# Tracker Roadmap Initializer

For all the projects visible to an account on Pivotal Tracker:
1. gets all the epics for each project, and 
1. create all epics in a single destination project with the source project name prepended to the original  epic name

## Requirements

### Software
* Need to install
	* [jq 1.4](http://stedolan.github.io/jq/download/)
		* ```brew install jq``` is easist on Mac if you alread have [Homebrew](http://mxcl.github.com/homebrew/) setup
* Stuff that should already be on your computer
	* awk
	* bash
	* curl

### Configuration
* [Pivotal Tracker Access Token](https://www.pivotaltracker.com/profile) - on the bottom of the page
* Destination Project ID number - the numbers at the end of a URL like https://www.pivotaltracker.com/n/projects/

## Instructions

1. Fill out the ```TOKEN``` and ```DEST_PROJECT``` variables at the top of ```generate-project-list.sh``` the script
2. Invoke by running ```./generate-project-list.sh``` in your directory

## What are all the files in the directory after a run?
* ```tmp-*``` files are the temporary data created by each step of the process. These are not automatically deleted at the end of the run to allow for debugging. The script does erase them when run.
* ```projects.json``` is the "database" of all projects visible to the user. This file will be used for additional features in the future.
* ```epics.json``` is the "database" of all epics from all projects in ```projects.json``` This file will be used for additional features in the future.

## TODO
* Project level
	* Per project enabled/disabled setting (need to break up the current script into two phases)
	* New project list diff vs existing list of project
	* Project rename handling
* Epic level
	* Diff/merge of new/deleted/modified epics

## Author
For any questions about this, please contact [David Lee](dclee@pivotal.io).