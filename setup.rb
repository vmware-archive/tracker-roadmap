TRACKER_TOKEN = ENV["TRACKER_TOKEN"]

raise "Specify your tracker API token with environment variable TRACKER_TOKEN" if TRACKER_TOKEN.nil?

PROJECT_ID = ENV["PROJECT_ID"]

raise "Specify your tracker destination project ID with environment variable PROJECT_ID" if PROJECT_ID.nil?

require "rubygems"
require "bundler"
Bundler.setup(:default)
Bundler.require(:default)

$LOAD_PATH.unshift(File.expand_path("lib"))
require "model"
require "epic"
require "story"
require "integration"
require "project"

ActiveResource::Base.logger = Logger.new(STDOUT)
ActiveResource::Base.logger.level = Logger::DEBUG
