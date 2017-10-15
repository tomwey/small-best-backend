class Banner < ActiveRecord::Base
  validates :image, presence: true
  mount_uploader :image, BannerImageUploader
  
  scope :opened, -> { where(opened: true) }
  scope :sorted, -> { order('sort asc') }
  
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
  
  def adable
    if link.blank?
      nil
    else
      if link.start_with?('http://') or link.start_with?('https://')
        { type: 'url', link: link }
      elsif link.start_with?('event:')
        cls,id = link.split(':')
        klass = cls.classify.constantize
        klass.find_by(uniq_id: id)
      elsif link.start_with?('page:')
        cls,slug = link.split(':')
        klass = cls.classify.constantize
        klass.find_by(slug: slug)
      else
        nil
      end
    end
  end
  
  def event
    cls,id = link.split(':')
    klass = cls.classify.constantize
    klass.find_by(uniq_id: id)
  end
  
  def page
    cls,slug = link.split(':')
    klass = cls.classify.constantize
    klass.find_by(slug: slug)
  end
  
  # def format_link
  #   if link.start_with?('http://') or link.start_with?('https://')
  #     link
  #   else
  #     arr = link.split(':')
  #     if arr.first == 'event'
  #       
  #     else
  #       
  #     end
  #   end
  # end
  
end
