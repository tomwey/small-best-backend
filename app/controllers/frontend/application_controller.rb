class Frontend::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include SessionsHelper
  
  layout "frontend"
  
  protect_from_forgery with: :null_session
  
  # 需要登录
  before_filter :require_user
  
  before_action :set_active_menu
  def set_active_menu
    @current = ["/#{controller_name}"]
  end

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_optional_error_file(status_code)
    status = status_code.to_s
    fname = %W(404 403 422 500).include?(status) ? status : 'unknown'
    render template: "/errors/#{fname}", format: [:html], handler: [:erb], status: status, layout: 'application'
  end
  
  helper_method :render_page_title
  def render_page_title
    site_name = "小优大惠"
    @page_title || site_name
    # content_tag(:title, title, nil, false)
  end
  
  helper_method :notice_message
  def notice_message
    flash_messages = []
    flash.each do |type, message|
      type = :success if type.to_s == "notice"
      type = :warning if type.to_s == "alert"
      type = :danger if type.to_s == "error"
      text = content_tag(:div, link_to("×", "#", class: "close", 'data-dismiss' => "alert") + message, class: "alert alert-#{type}", style: "margin-top: 20px;")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end

  def set_seo_meta(title = '', meta_keywords = '', meta_description = '')
    @page_title = "#{title}" if title && title.length > 0
    @meta_keywords = meta_keywords
    @meta_description = meta_description
  end

  def require_user
    if current_user.blank?
      # 登录
      store_location
      
      redirect_url  = "http://b.hb.small-best.com/wx/auth/redirect_uri?url=#{wechat_redirect_uri_url}"
      @wx_auth_url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{SiteConfig.wx_app_id}&redirect_uri=#{Rack::Utils.escape(redirect_url)}&response_type=code&scope=snsapi_userinfo&state=yujian#wechat_redirect"
      
      redirect_to @wx_auth_url
      # redirect_to wechat_login_path
    end
  end
  
  def check_user
    unless current_user.verified
      # flash[:error] = "您的账号已经被禁用"
      # redirect_to wechat_shop_root_path
      render(text: "您的账号已经被禁用", status: 403)
      return
    end
  end

  def fresh_when(opts = {})
    return if Rails.env.development?
    # return if Rails.env.production?
    opts[:etag] ||= []
    # 保证 etag 参数是 Array 类型
    opts[:etag] = [opts[:etag]] unless opts[:etag].is_a?(Array)
    # 加入页面上直接调用的信息用于组合 etag
    opts[:etag] << current_user
    # Config 的某些信息
    # opts[:etag] << SiteConfig.
    # 加入flash, 确保当前页面刷新后flash不会再出现
    opts[:etag] << flash
    # 所有 etag 保持一天
    # opts[:etag] << SiteConfig.welcome_html
    # opts[:etag] << SiteConfig.contact_us
    opts[:etag] << Date.current
    super(opts)
  end

  helper_method :mobile?
  MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                        'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
                      
  def mobile?
    agent_str = request.user_agent.to_s.downcase
    return false if agent_str =~ /ipad/
    agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
  end 
    
end