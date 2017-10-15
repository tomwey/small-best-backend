class Withdraw < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, :money, :account_no, presence: true
  
  before_create :generate_oid
  def generate_oid
    begin
      self.oid = Time.now.to_s(:number)[2,6] + (Time.now.to_i - Date.today.to_time.to_i).to_s + Time.now.nsec.to_s[0,6]
    end while self.class.exists?(:oid => oid)
  end
  
  after_create :add_trade_log
  def add_trade_log
    TradeLog.create!(tradeable: self, user_id: self.user_id, money: self.money, title: "#{note || '提现'}#{'%.2f' % self.money}元")
    
    # 发送消息
    send_message
  end
  
  def confirm_pay!
    self.payed_at = Time.zone.now
    self.save!
  end
  
  def send_message
    payload = {
      first: {
        value: "您好，提现申请已经收到，大约1-2天会到账\n",
        color: "#FF3030",
      },
      keyword1: {
        value: "#{user.format_nickname}",
        color: "#173177",
      },
      keyword2: {
        value: "#{self.created_at.strftime('%Y-%m-%d %H:%M:%S')}",
        color: "#173177",
      },
      keyword3: {
        value: "#{money == 0.0 ? '0.00' : '%.2f' % money}元",
        color: "#173177",
      },
      keyword4: {
        value: "#{account_no == account_name ? '微信' : '支付宝'}",
        color: "#173177",
      },
      remark: {
        value: "感谢您的使用！",
        color: "#173177",
      }
    }.to_json
    
    user_ids = User.where(uid: SiteConfig.wx_message_admin_receipts.split(',')).pluck(:id).to_a
    if not user_ids.include?(user.id)
      user_ids << user.id
    end
    Message.create!(message_template_id: 7, content: payload,link: SiteConfig.wx_app_url, to_users: user_ids)
  end
end
