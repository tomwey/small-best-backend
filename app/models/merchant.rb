class Merchant < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:mobile]
  
  mount_uploader :avatar, AvatarUploader
  
  attr_accessor :code
  
  validates :mobile, :name, presence: true
  validates :mobile, format: { with: /\A1[3|4|5|8|7][0-9]\d{8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 },:uniqueness => true
  
  before_create :generate_uid_and_private_token
  def generate_uid_and_private_token
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.merch_id = (n.to_s + SecureRandom.random_number.to_s[2..6]).to_i
    end while self.class.exists?(:merch_id => merch_id)
    self.private_token = SecureRandom.uuid.gsub('-', '')
  end
  
  ### 重写devise方法
  def email_required?
    false
  end
  
  def email_changed?
    false
  end
  
  # 是否进行实名认证
  def authed?
    not self.auth_type.blank?
  end
  
  def update_with_password(params = {})
    if !params[:current_password].blank? or !params[:password].blank? or !params[:password_confirmation].blank?
      super
    else
      params.delete(:current_password)
      self.update_without_password(params)
    end
  end
  
end
