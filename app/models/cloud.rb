class Cloud < ActiveRecord::Base
  include ImportHandler
  belongs_to :meteorology
  belongs_to :cloud_lookup

  def as_csv
    [ cover,
      height,
      cloud_lookup.try(:code),
      cloud_type
    ]
  end

  def self.headers opts={}
    headers = %w( Cover Height Cloud CloudType )
    headers.map!{|h| "#{opts[:prefix]}#{h}"} if opts[:prefix]
    headers.map!{|h| "#{h}#{opts[:postfix]}"}  if opts[:postfix] 
    headers
  end
end
