# == Schema Information
# Schema version: 20100829021049
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable, :confirmable  and :activatable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :karma, :ignore, :admin, :email, :password, :password_confirmation, :login

  acts_as_voter

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates_length_of :name, maximum: 50

  validates_format_of :twitter, with: /(\A[a-zA-Z0-9]]+\Z)/

  validates_format_of :github, with: /(\A[a-zA-Z0-9]]+\Z)/
  # validates :email, :format     => { :with => email_regex },
  #                  :uniqueness => { :case_sensitive => false }
  # validates :password, :presence => true,
  #                     :confirmation => true,
  #                     :length => { :within => 6..40 }

  has_many :stories,    dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }
  
  ROLES = %w[admin moderator author]
  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  def role_symbols
    roles.map(&:to_sym)
  end

  def mark_as_blocked(value)
    self.ignore = value
    self.save
  end

  def increase_karma
    self.karma += 1
    save
  end

  def decrease_karma
    self.karma += 1
    save
  end

  before_save do
    if !self.twitter.blank?
      #self.twitter.gsub!(/.*([^a-zA-Z0-9]+)/,'')
      #  must start with either @ followed by alphanums, or with http(s)://twitter

    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['name = :value OR email = :value', { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  
end