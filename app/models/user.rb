class User < ApplicationRecord
  
  include LogValidationErrors # :''confirmable, :lockable, :timeoutable, :trackable and :omniauthable # Include default devise modules. Others available are:



  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    if password_confirmation.blank?
      self.errors[:password_confirmation] << "can't be blank"
    end
    if password != password_confirmation
      self.errors[:password_confirmation] << 'does not match password'
    end
    password == password_confirmation && !password.blank?
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  def password_required?
    !persisted? ? false : !password.nil? || !password_confirmation.nil?
  end # Password is required if it is being set, but not for new records
end
