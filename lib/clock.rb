require 'clockwork'

#require File.expand_path('../../config/boot',        __FILE__)
#require File.expand_path('../../config/environment', __FILE__)

include Clockwork

handler do |job|
  puts "Executing #{job}"
  system(job)
end

every(1.day, 'rake boom', :at => ['08:00', '16:00'])
