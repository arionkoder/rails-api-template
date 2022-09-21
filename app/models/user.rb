class User < ApplicationRecord
  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  has_secure_password

  has_many :posts

  validates :email, presence: true, uniqueness: true

  validates :password,
    presence: true,
    length: { in: 8..16 },
    format: { with: PASSWORD_FORMAT },
    confirmation: true,
    on: :create

  validates :password,
    allow_nil: true,
    length: { in: 8..16 },
    format: { with: PASSWORD_FORMAT },
    confirmation: true,
    on: :update
end
