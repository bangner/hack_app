class Bootcamp < ActiveRecord::Base
  validates_presence_of :name, :description, :website, :email, :logo

  before_save :sanitize_money

  has_and_belongs_to_many :admins, class_name: "Account"
  has_many :bootcamp_invitations, :dependent => :destroy
  has_many :locations, class_name: "BootcampLocation"

  belongs_to :primary_application,
    class_name: "BootcampApplication",
    :foreign_key => 'primary_application_id',
    dependent: :destroy

  belongs_to :secondary_application,
    class_name: "BootcampApplication",
    :foreign_key => 'secondary_application_id',
    dependent: :destroy

  accepts_nested_attributes_for :admins, :locations

  scope :search, ->(query) {
    where([%Q{
      lower(name) LIKE :q 
      or lower(stack) LIKE :q
      or lower(focus) LIKE :q
      }, { :q => "%#{query.strip.split(/[\s,]+/).join("%").downcase}%" }
    ])
  }

  scope :by_focus, ->(focus) {
    where("lower(focus) = ?", focus)
  }

  scope :by_price, ->(price) {
    where(price: price)
  }

  scope :by_price_range, ->(min, max) {
    where(price: min..max)
  }

  scope :by_location, ->(location) {
    joins(:locations).where("lower(bootcamp_locations.city || \", \" || bootcamp_locations.state) = ?", location)
  }

  def get_applications_by_set
    {
      "primary" => self.primary_application,
      "secondary" => self.secondary_application
    }
  end

  def sanitize_money
    self.price.to_money.format(
      :symbol => false,
      :thousands_separator => false
      ).to_f
  end

  def self.newest limit = 4
    self.includes(:locations).order(created_at: :desc).limit(limit)
  end

  def retrieve_stripe_customer
    return unless self.stripe_customer_id
    Stripe.api_key = Rails.configuration.stripe_sk
    Stripe::Customer.retrieve(self.stripe_customer_id)
  end

  def retrieve_stripe_cc
    return unless self.stripe_customer_id
    str_cust = self.retrieve_stripe_customer
    str_cust.cards.data.first if str_cust.cards.count
  end

  def update_stripe_cc_token! cc_token
    Stripe.api_key = Rails.configuration.stripe_sk
    if self.stripe_customer_id
      str_cust = Stripe::Customer.retrieve(self.stripe_customer_id)
      str_cust.card = cc_token # obtained with Stripe.js
      str_cust.save
    else
      str_cust = Stripe::Customer.create(
        :description => self.name,
        :card  => cc_token
      )
      self.stripe_customer_id = str_cust.id
    end
    str_cust
  end

  def add_admin account
    return if self.admins.pluck(:id).include?(account.id)
    self.admins << account
    self.save
  end

end
