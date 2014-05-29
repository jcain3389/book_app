class User < ActiveRecord::Base
  has_many :asaves
  has_many :authors, through: :asaves
  has_many :bsaves
  has_many :books, through: :bsaves

  #Add save handlers for formatting data:
  before_create :create_remember_token #This becomes the user's initial login session.
  before_save :normalize_fields #This downcases the user's e-mail.

#USER VALIDATIONS (3)

  #1.) Validate the user's name:
  validates :name,
    presence: true, #Makes sure the name exists.
    length: {maximum: 50} #Makes sure the name is no longer than 50 characters.

  #2.) Validate email address:
  validates :email,
    presence: true, #Makes sure an email exists.
    uniqueness: {case_sensitive: false}, #Makes sure the email is unique and case-insensitive.
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i } #Regex that makes sure the email is correctly formatted.

  #3.) Validate password: it's at least 8 characters long
  validates :password,
    length: {minimum: 8}

#SECURE PASSWORD FEATURES: 'has_secure_password' is an integral bit of Rails voodoo; does the following:
  #1.) Adds 'password' and 'password_confirmation' fields onto the model, and validates that they always match.
  #2.) Securely hashes and saves passwrods into the password_digest column.
  #3.) Adds an 'authenticate' method onto the User model, which accepts plain text and tests if it matches the stored password digest.
has_secure_password

#USER CLASS METHODS (2)

  #1.) Create a new remember token for a user:
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  #2.) Hash a token:
  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  #Creates a new session token for the user:
  def create_remember_token
    remember_token = User.hash(User.new_remember_token)
  end

  #Normalize the email field for consistency:
  def normalize_fields
    self.email.downcase!
  end

end
