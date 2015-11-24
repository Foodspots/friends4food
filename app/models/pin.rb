class Pin < ActiveRecord::Base
  #before_save :set_location
  #before_save :set_external_image_url
  acts_as_votable
  belongs_to :user
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  before_save :geocode
  geocoded_by :location, :if => :location_changed?


  #def set_location
    #self.location = "#{address} #{place}"
  #end

  #def set_external_image_url
     #self.external_image_url = "#{"http://s3.amazonaws.com/dinderapp/pins/"}#{name}#{"_"}#{place}#{".jpg"}"
   #end

  def self.deduplicate
    # Find all duplicate records and group them by a field
    pins = 
       Pin.group(:name)
          .having('count("name") > 1')
          .count(:name)

    # Iterate on each grouped item to destroy duplicate
    pins.each do |key, value|

    # Keep one and return rest of the duplicate records
    duplicates = Pin.where(name: key)[1..value-1]
    puts "#{key} = #{duplicates.count}"

    # Destroy duplicates and their dependents
    duplicates.each(&:destroy)
    end  
  end

  def self.search(search)
    if search
      where('lower(name) LIKE ?', "%#{search.downcase}%")
    else
      all
    end
  end

	def self.import(file)
		CSV.foreach(file.path, headers: true, quote_char: "\"") do |row|
			pin = Pin.find_or_initialize_by(id: row['id'])
			pin.update_attributes! row.to_hash
		end
	end

	def self.to_csv(o)
		options = {:quote_char => "\"", :force_quotes => true}
		options.merge! o
		CSV.generate(options) do |csv|
			csv << column_names
			all.each do |pin|
				csv << pin.attributes.values_at(*column_names)
			end
		end
	end

	def safe_image_url
		if external_image_url.nil?
			Settings.app.pins.default_image
		else
			URI.escape(external_image_url.gsub('http://', 'https://'))
		end
	end
end
	