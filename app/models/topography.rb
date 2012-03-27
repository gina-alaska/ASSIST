class Topography < ActiveRecord::Base
  include ImportHandler

  belongs_to :ice_observation
  belongs_to :topography_lookup

  def as_csv 
    [
      topography_lookup.try(:code),
      old,
      consolidated,
      concentration,
      ridge_height
    ]
  end

  def as_json opts={}
    {
      topography_lookup_code: topography_lookup.try(&:code),
      old: old,
      consolidated: consolidated,
      concentration: concentration,
      ridge_height: ridge_height
    }
  end

  def self.headers opts={}
    headers = %w( Topography Old Consolidated Concentration RidgeHeight )
    headers.map!{|h| "#{opts[:prefix]}#{h}"} if opts[:prefix]
    headers.map!{|h| "#{h}#{opts[:postfix]}"}  if opts[:postfix] 
    headers
  end 
end
