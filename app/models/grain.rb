class Grain < ApplicationRecord
	before_save   :normalize_name
  
	has_many :recipes

	#this could probably go in its own module if being used repeatedly?
	protected
	  def normalize_name
      self.name = name.downcase
    end
end