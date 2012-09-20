class Meteorology < ActiveRecord::Base
  include ImportHandler
  include AssistShared::CSV::Meteorology
  include AssistShared::Validations::Meteorology
  
  belongs_to :observation
  belongs_to :weather_lookup
  belongs_to :visibility_lookup
  has_many :clouds, :dependent => :destroy do
    def cloud_type c
      c = c.to_sym
      cld = where(:cloud_type => c).first
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

  before_create do |met|
    %w(high medium low).each do |cloud_type|
      if(met.clouds.cloud_type(cloud_type).nil?)
        met.clouds << Cloud.new(cloud_type: cloud_type)
      end
    end
  end

  accepts_nested_attributes_for :clouds

  #validates_presence_of :visibility_lookup_id, :if => :finalized_or_meteorology?
  
  # def finalized_or_meteorology?
  #   return false if observation.nil?
  #   o = Observation.find(self.observation_id)
  #   o.finalized? || o.status == 'meteorology'
  # end
  # 
  # def as_csv 
  #   [ 
  #     visibility_lookup.try(&:code),
  #     weather_lookup.try(&:code),
  #     clouds.collect{|c| c.try(&:as_csv) }
  #   ]
  # end

  def as_json opts={}
    {
      visibility_lookup_code: visibility_lookup.try(&:code),
      weather_lookup_code: weather_lookup.try(&:code),
      clouds_attributes: clouds.collect(&:as_json)
    }
  end

  # def self.headers opts={}
  #   headers = %w( Visibility Weather )
  #   headers.map!{|h| "#{opts[:prefix]}#{h}"} if opts[:prefix]
  #   headers.map!{|h| "#{h}#{opts[:postfix]}"}  if opts[:postfix] 
  #   %w(High Medium Low).each{|h| headers.push(Cloud.headers(:prefix => h))}
  #   headers
  # end
end
