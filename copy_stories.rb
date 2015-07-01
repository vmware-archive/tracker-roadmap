#!/usr/bin/env ruby

require File.expand_path("setup")
require 'pp'
require 'benchmark'

time = Benchmark.realtime do
  ALL_PROJECTS = Project.all(:params => {:fields => "id,name"})
  p ALL_PROJECTS

  dest_project = Project.find(PROJECT_ID)
  stories_to_delete = dest_project.stories.reject { |s| s.current_state == "unscheduled" }
  puts "About to delete #{stories_to_delete.length} non-icebox stories from project #{PROJECT_ID}, okay (y/n)?"
  #raise "User aborted" unless STDIN.gets.chomp == "y"
  stories_to_delete.map(&:destroy)
  epics = dest_project.epics
  p epics

  integration = dest_project.integrations.detect { |i| i.name == "Tracker" }
  raise "Please create a Pivotal Tracker integration named 'Tracker' with BaseURL http://www.pivotaltracker.com/story/show/" if integration.nil?
  INTEGRATION_ID = integration.id

  epics.each do |epic|
    puts "==================== EPIC #{epic.name} ====================="
    if epic.name =~ /^__/
      puts 'Stopping on epic that begins with __'
      exit
    end

    label = epic.label.name
    p epic
    p label
    src_proj_name = epic.name.match(/^\*(.*):\*/)[1]
    p src_proj_name
    src_proj_name.split("&").each do |spn|
      src_projs = ALL_PROJECTS.select { |pr| pr.name.downcase.include?(spn.strip.downcase) }
      p src_projs

      if src_projs.any?
        src_projs.each do |src_proj|
          src_stories = Story.all(params: {with_label: label, project_id: src_proj.id})
          p src_stories

          dest_stories = Story.all(params: {with_label: label, project_id: dest_project.id})
          p dest_stories

          puts "\n----- Processing #{src_stories.select.count} stories for label '#{label}' from #{src_proj.name}: ----"
          src_stories.each do |src_story|
            if src_story.current_state != "unscheduled" && (src_story.story_type == "feature" || (ARGV[0] == "-a" && src_story.story_type != "release"))
              pp src_story
              dest_story = dest_stories.detect { |s| s.name == src_story.name }

              #puts "Matching: #{dest_story.inspect}"
              dest_story ||= Story.new(:project_id => dest_project.id)
              dest_story.name = src_story.name
              dest_story.description = src_story.description if src_story.respond_to?(:description)
              dest_story.story_type = src_story.story_type
              if src_story.respond_to?(:estimate) && src_story.story_type == "feature"
                dest_story.estimate = src_story.estimate
                dest_story.estimate = 5 if dest_story.estimate == 4 || dest_story.estimate == 6 || dest_story.estimate == 7
                dest_story.estimate = [dest_story.estimate, 8].min
                dest_story.estimate = [dest_story.estimate, 0].max
              end
              if src_story.current_state == "planned"
                dest_story.current_state = "unstarted"
              else
                dest_story.current_state = src_story.current_state
              end
              dest_story.accepted_at = src_story.accepted_at if dest_story.current_state == "accepted"
              dest_story.integration_id = INTEGRATION_ID
              dest_story.external_id = src_story.id.to_s
              dest_story.labels = [{name: label}, {name: src_proj.name}] if dest_story.new?

              puts " ---------------- Ready to save ------------------"
              pp dest_story
              dest_story.save
            end
          end
        end
      else
        puts "WARNING: NO source projects found for #{spn}"
      end
    end
  end
end

puts time
puts " ** COMPLETE ** "
