class Meteorology < ActiveRecord::Base
  include ImportHandler

  belongs_to :observation
  belongs_to :weather_lookup
  belongs_to :visibility_lookup
  has_many :clouds, :dependent => :destroy do
    def cloud_type c
      c = c.to_sym
      cld = where(:cloud_type => c).first
      cld ||= create :cloud_type => c
      cld
    end
    def high
      cloud_type "high"
    end
    def med
      cloud_type "medium"
    end
    def medium
      cloud_type "medium"
    end
    def low
      cloud_type "low"
    end
  end

  accepts_nested_attributes_for :clouds


  def as_csv 
    [ 
      visibility_lookup.try(&:code),
      weather_lookup.try(&:code),
      clouds.collect(&:as_csv)
    ]
  end

  def as_json opts={}
    {
      visibility_lookup: visibility_lookup.try(&:code),
      weather_lookup: weather_lookup.try(&:code),
      clouds: clouds.collect(&:as_json)
    }
  end

  def self.headers opts={}
    headers = %w( Visibility Weather )
    headers.map!{|h| "#{opts[:prefix]}#{h}"} if opts[:prefix]
    headers.map!{|h| "#{h}#{opts[:postfix]}"}  if opts[:postfix] 
    %w(High Medium Low).each{|h| headers.push(Cloud.headers(:prefix => h))}
    headers
  end
end
