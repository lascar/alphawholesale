class UserProduct < ApplicationRecord
  belongs_to :user, polymorphic: true

end
