class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  enum role: { member: 0, librarian: 1, admin: 2 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def jwt_payload
    super
  end

  # Scopes to easily find users by role
  scope :librarians, -> { where(role: roles[:librarian]) }
  scope :admins, -> { where(role: roles[:admin]) }
  
end
