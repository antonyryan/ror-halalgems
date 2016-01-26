class SpaceType < ActiveRecord::Base
  has_many :listings, foreign_key: :type_of_space_id
end
