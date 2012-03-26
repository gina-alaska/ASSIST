class MeltPond < ActiveRecord::Base
  include ImportHandler

  belongs_to :ice_observation
  belongs_to :max_depth_lookup
  belongs_to :pattern_lookup
  belongs_to :surface_lookup

  def as_csv
    [
      surface_coverage,
      max_depth_lookup.try(&:code),
      pattern_lookup.try(&:code),
      surface_lookup.try(&:code),
      freeboard
    ]
  end

  def self.headers opts={}
    headers = %w( SurfaceCoverage MaxDepth Pattern Surface Freeboard )
    headers.map{|h| "#{opts[:prefix]}#{h}"} if opts[:prefix]
    headers.map{|h| "#{h}#{opts[:postfix]}"}  if opts[:postfix] 

    headers.flatten.join(",")
  end  
end
