class ImportObservation
  include ActiveAttr::Model

  class InvalidLookupException < Exception;end

  attr_accessor :file, :cruise_id

  def persisted?
    false
  end

  def save
    begin
      if imported_observations.map(&:valid?).all?
        imported_observations.each(&:save)
        true
      else
        imported_observations.each_with_index do |obs, index|
          obs.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+2}: #{message}"
          end
        end
        false
      end
    rescue Exception => ex
      errors.add :base, ex.message
      false
    end
  end

  def imported_observations
    @imported_observations ||= load_imported_observations
  end

  def load_imported_observations
    imports = open_file.flatten
  end

  def open_file
    case File.extname(file.original_filename)
    when ".zip"
      from_zip
    when ".csv"
      from_csv
    when ".json"
      from_json
    else raise "Unknown filetype: #{::File.basename(file.original_filename)}"
    end
  end


  def create_observation(obs)
    begin
      o = Observation.new(lookup_code_to_id(obs))

      #Handle csv that doesn't have hexcodes
      if o.hexcode.nil?
        o.hexcode = Digest::MD5.hexdigest("#{o.obs_datetime}#{o.latitude}#{o.longitude}#{o.primary_observer.try(&:first_and_last_name)}")
      end

      o.cruise_id = cruise_id
    rescue InvalidLookupException => ex
      o = Observation.new
      o.errors.add :base, "Invalid Lookup Code #{ex.inspect}"
    end
    o
  end

  def from_json
    imports = []
    raw_data = ::JSON.parse(::File.read(file.tempfile))

    raw_data.each do |obs|
      obs = JSON.parse(obs) if obs.is_a? String
      imports << create_observation(obs)
    end
    imports
  end

  def from_csv
    imports = []
    import_map_path = Rails.root.join("vendor","csv")
    import_map_filename = "#{::File.basename(file.original_filename).split(".").first}.yml"
    unless File.exists?(import_map_path.join(import_map_filename))
      import_map_filename = "assist_2012.yml"
    end
    import_map = ::YAML.load_file(import_map_path.join(import_map_filename))

    raw_data = ::CSV.open(file.tempfile, {headers: true, return_headers: false})

    raw_data.each do |row|
      next if row.empty?
      imports << create_observation(csv_to_hash(row, import_map))
    end
    imports
  end

  def from_zip
    imports = []
    Zip::ZipFile.open(file.tempfile) do |z|
      obs_file = nil
      if(z.file.exists?("METADATA"))
        md = YAML.load((z.file.read("METADATA")))
        obs_file = case md[:assist_version]
        when "1.0"
          "aorlich_summer_2012.observations.json"
        else
          md[:observations]
        end
      elsif z.file.exists?("observations.json")
        obs_file = "observations.json"
      end

      unless obs_file.nil?
        raw_data = ::JSON.parse(z.read(obs_file))
        raw_data.each do |obs|
          obs = JSON.parse(obs) if obs.is_a? String
          imports << create_observation(obs)
        end
      end
    end
    imports
  end

  def csv_to_hash(row, mapping)
    data = Hash.new
    mapping.each do |k,v|
      case v.class.to_s
      when "String"
        case k
        when :primary_observer
          row[v] ||= ""
          el = row[v].split(" ")
          val = User.find_or_create_by_firstname_and_lastname(firstname: el.first, lastname: el.last)
        when :additional_observers
          val = []
          row[v] ||= ""
          row[v].split(":").each do |name|
            el = name.split(" ")
            val << User.find_or_create_by_firstname_and_lastname(firstname: el.first, lastname: el.last)
          end
        else
          val = row.include?(v) ? row[v] : v
          val = nil if val.blank?
        end

        data[k] = val
      when "Hash"
        case k
        when :faunas_attributes
          names = row[v[:name]].to_s.split("//") if row.include?(v[:name])
          counts = row[v[:count]].to_s.split("//") if row.include?(v[:count])
          faunas = []
          unless names.nil? or counts.nil?
            names.zip(counts).each do |fauna|
              faunas << {name: fauna.first, count: fauna.last}
            end
          end
          data[k] = faunas
        else
          data[k] = self.csv_to_hash(row, v)
        end
      when "Array"
        data[k] = v.collect{|i| self.csv_to_hash(row, i) }
      end
    end
    data
  end

  private
  def lookup_code_to_id attrs
    attrs.inject(Hash.new) do |h,(k,v)|
      key = k.to_s.gsub(/lookup_code$/, "lookup_id")
      if key =~ /lookup_id$/ and not v.nil?
        table = key.gsub(/^thi(n|ck)_ice_lookup_id$/,"ice_lookup_id")
        lookup = table.chomp("_id").camelcase.constantize.where(code: v).first
        logger.info "Unknown Lookup Id -- #{table}: #{v.inspect}" if lookup.nil?
        raise InvalidLookupException, "Unknown Lookup Id -- #{table}: #{v.inspect}" if lookup.nil?
        v = lookup.id
      end

      case v.class.to_s
      when "Hash"
        h[key] = lookup_code_to_id(v)
      when "Array"
        h[key] = v.collect{|el| el.is_a?(Hash) ? lookup_code_to_id(el) : el}
      else
        h[key] = v
      end

      h
    end
  end
end
