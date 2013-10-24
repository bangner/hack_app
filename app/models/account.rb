class Account < ActiveRecord::Base
  before_save :hash_password
  validates_presence_of :name, :email, :password_hash

  has_and_belongs_to_many :schools
  has_and_belongs_to_many :roles

  accepts_nested_attributes_for :roles

  def has_role?(role)
    self.roles.where(:name => role).any?
  end

  private
    def hash_password
      self.password_hash = BCrypt::Password.create(self.password_hash)
    end

end
