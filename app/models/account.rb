class Account < ActiveRecord::Base
  before_validation :lowercase_email
  before_create :generate_auth_token, :hash_password!

  validates_presence_of :name, :email, :password_hash
  validates :email, :uniqueness => true

  has_and_belongs_to_many :roles

  accepts_nested_attributes_for :roles

  def has_role? role
    self.roles.each { |r| return true if r.name.eql? role }
    false
  end

  def add_role role
    return if self.roles.pluck(:name).include?(role)
    self.roles << Role.find_by_name(role)
    self.save
  end

  def authenticate password
    BCrypt::Password.new(self.password_hash).is_password? password
  end

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  def generate_auth_token!
    self.generate_auth_token
    self.save
  end

  def hash_password!
    self.password_hash = BCrypt::Password.create(self.password_hash)
  end

  private
    def lowercase_email
      self.email = self.email.downcase
    end

end
