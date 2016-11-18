class Grain < ApplicationRecord
	before_save   :normalize_name
  
	has_many :recipes

	protected
	  def normalize_name
      self.name = name.downcase
    end
end
