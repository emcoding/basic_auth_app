class User < ActiveRecord::Base
  has_secure_password
  before_save { email.downcase! }
  validates :email, presence: true, uniqueness: true
end