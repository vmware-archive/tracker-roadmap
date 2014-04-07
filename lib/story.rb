class Story < Model
  self.site = "#{v5}/projects/:project_id"

  # bypass pagination and load ALL stories
  def self.find_every(options)
    all_results = []
    options[:params] ||= {}
    limit = 100
    options[:params][:limit] = limit
    options[:params][:offset] = 0
    begin
      results = super(options)
      all_results += results
      options[:params][:offset] += limit
    end while results.length == limit
    all_results
  end
end