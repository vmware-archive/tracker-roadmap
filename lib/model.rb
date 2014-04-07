class Model < ActiveResource::Base
  def self.v5
    "https://www.pivotaltracker.com/services/v5"
  end

  def self.headers
    {
        'X-TrackerToken' => TRACKER_TOKEN
    }
  end
end