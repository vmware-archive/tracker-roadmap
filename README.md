Tracker Roadmap
===============

This code makes it easier to visualize cross-project progress towards a release.  It assumes you've got a single tracker
project with epics that represents your roadmap, but that the stories for each of those epics are actually in one or more
different backlogs.  The goal of showing progress is accomplished by copying in all the relevant stories from the different
backlogs and using tracker's Epic Progress Bars.


How to set up your tracker project
----------------------------------

Your roadmap project needs to have no stories in it (except icebox stories which we ignore), because they will all be wiped
 out by running this tool.  It also needs epics named the format `*PROJECT NAME:* Some epic title` that are backed by a
 label which will be used to bring in stories.  Multiple project names can be used if separated by `&`. Examples:

1.  `*BOSH:* After-deployment tasks` backed by `bosh errands`
1.  `*Runtime & Services:* V2 Broker API` backed by `v2 broker api`

In the first example, the tool will look for all stories in backlogs that you access to that contain the string `BOSH`
(such as BOSH Public and BOSH Agent) and bring in all stories labeled with `bosh errands`.
In the second example, the backlog names can contain either `Runtime` or `Services`.

The tool stops when it reaches an epic that begins with `__`, such as `__My release 1.2__`

The roadmap tracker project is required to have a Fibonacci pointing scale.

Additionally you need to configure a 3rd party "Other Integration" on your project named `Tracker`
with the Base URL of `http://www.pivotaltracker.com/story/show/`.

What happens when you run the script?
-------------------------------------
1.  All non-icebox **stories in your roadmap project are deleted** (because they are about to be re-created).
1.  If the epic starts with `__` the script exits
1.  Each epic is examined.  For each matching backlog, all non-icebox stories that are labeled with the epic-label are copied into the roadmap project.

How to run the script
---------------------

    bundle
    export TRACKER_TOKEN=xxxx   # Your API token
    export PROJECT_ID=yyyy  # The ID of your roadmap project
    ./copy_stories.rb

Script options
--------------

By default, the script will only pull in feature stories. However, if you run the script with `-a` flag, the script will pull in features, bugs, chores, and releases.
