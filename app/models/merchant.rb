class Merchant < ActiveRecord::Base
  validates :name, :mobile, presence: true
  
  mount_uploader :logo, AvatarUploader
  
  before_create :generate_unique_id
  def generate_unique_id
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..8]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def tag_name=(val)
    if val.present?
      self.tags = val.split(',')
    end
  end
  
  def tag_name
    tags.join(',')
  end
  
end
