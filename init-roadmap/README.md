# Tracker Roadmap Initializer

For all the projects visible to an account on Pivotal Tracker:

1. gets all the epics for each project you can see (and want to sync), and 
1. create all epics in a single destination project with the source project name prepended to the original epic name

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
Change the settings in ```_environment.sh``` to your situation:
* [Pivotal Tracker Access Token](https://www.pivotaltracker.com/profile) - on the bottom of the page
* Destination Project ID number - the numbers at the end of a URL like https://www.pivotaltracker.com/n/projects/

## Instructions

1. Fill out the ```TOKEN``` and ```DEST_PROJECT``` variables at the top of ```_environment.sh``` the script
1. Run ```./generate-project-list.sh``` in your directory to get all the projects you can see with that token
1. Make any changes ```enabled``` property in ```projects.json``` to configure which projects to sync epics (use ```false``` if you don't want it)
1. Run ```./generate-epic-list.sh``` to pull the epics from enabled projects and create them in the ```DEST_PROJECT``` tracker

## What are all the files in the directory after a run?
* ```tmp-*``` files are the temporary data created by each step of the process. These are not automatically deleted at the end of the run to allow for debugging. The script does erase them when run.
* ```projects.json``` is the "database" of all projects visible to the user. You can check this in for reuse (and posterity), but then **DO NOT** rerun ```generate-project-list.sh```. It will happily stomp over your settings.
* ```epics.json``` is the "database" of all epics from all projects in ```projects.json``` This file will be used for additional features in the future.

## TODO
* Project level
	* Done ~~Per project enabled/disabled setting (need to break up the current script into two phases)~~
	* New project list diff vs existing list of project
	* Project rename handling
* Epic level
	* Diff/merge of new/deleted/modified epics

## Author
For any questions about this, please contact [David Lee](dclee@pivotal.io).