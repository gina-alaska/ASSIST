# require 'csv'
#
# class Array
#   #Being bad here.  We're assuming this is only used for observations
#   def to_csv opts={}
#     c = ::CSV.generate(headers: true) do |csv|
#       csv << Observation.headers
#       self.each do |obs|
#         csv << obs.as_csv
#       end
#     end
#     c
#   end
# end
