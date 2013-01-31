class Array
  def as_csv
    items = []
    self.each do |item|
      if item.respond_to? :as_csv
        puts item.class
        items << item.as_csv
      else
        items << item
      end
    end
  end
  
  def to_csv
        
    
  end
    
end