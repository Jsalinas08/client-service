class Client < ApplicationRecord
  validates :name, :address, presence: true
  validates :dni, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
