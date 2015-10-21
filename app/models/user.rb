class User < ActiveRecord::Base

  has_many :posts
# Callbacks are hooks into the life cycle of an Active Record object that allow
# you to trigger logic before or after an aleration of the object state.

  before_save do
    self.email = email.downcase

    self.name = (name.split.each { |n| n.capitalize!}).join(" ")
  end
=begin
    n_array = name.split
    n_capitalize = []
    n_array.each do |n|
      n_capitalize << n.capitalize!
    end
    self.name = n_capitalize.join(" ")
  end
=end



# we set a variable to a regular expression, which defines a specific character
# pattern that we want to match against a string. The character pattern that we
# set EMAIL_REGEX to defines what constitutes a valid email address.

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: "password_digest.nil?"
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 100 },
            format: { with: EMAIL_REGEX }

# has_secure_password adds methods to set and authenticate against a BCrypt password.
# creates two virtual attributes, password and password_confirmation that we use
# to set and save the password.
# To use BCrypt we need to install it.  BCrypt is a module that encapsulates complex
# encryption algorithms.

   has_secure_password

end
