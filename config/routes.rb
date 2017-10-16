Rails.application.routes.draw do
  # 富文本上传路由
  mount RedactorRails::Engine => '/redactor_rails'
  
  ########### 前端app入口开始 ###########
  namespace :frontend, path: '/' do
    root 'home#index'
    
    
  end # end frontend
  ########### 前端app入口结束 ###########
  
  ########### 微信公众号入口 ###########
  namespace :wechat, path: 'wx' do
    get  '/portal'      => 'portal#echo'
    post '/portal'      => 'portal#message', defaults: { format: 'xml' }
    get  '/yj-portal'   => 'portal#yujian'
    post '/pay_notify'  => 'portal#pay_notify'
    get  '/auth/redirect' => 'portal#auth', as: :auth_redirect
    get  '/auth/redirect2' => 'portal#app_auth_redirect', as: :auth_app_redirect
    # get  '/share'       => 'share#offical'
    # get  '/events/:event_id/share' => 'share#event'
    get  '/share/event'   => 'share#event', as: :share_event
    get  '/share/hb'      => 'share#redbag', as: :share_redbag
    get  '/share/invite'  => 'share#invite', as: :share_invite
    get  '/share/hb2'     => 'share#redbag2', as: :just_share_redbag # 仅仅是简单的分享
    get  '/share/result'  => 'share#result', as: :share_result
    get  '/share/offical' => 'share#offical', as: :share_offical
    
    # 用户优惠卡验证二维码
    # /user_card_qrcode?code=xxxxxx&i=123321&ak=3839282
    get  '/user_card_qrcode' => 'qrcode#user_card', as: :card_verify
    
    # 用户余额支付二维码
    # /user_pay_qrcode?code=xxxxxx&i=123321&ak=3839282
    get  '/user_pay_qrcode'  => 'qrcode#user_pay', as: :user_pay_verify
    
    # 获取水印二维码图片
    # /share_poster_qrcode?code=xxxx&i=123321&ak=38333
    get '/share_poster_qrcode' => 'qrcode#share_poster'
    
    get '/stats' => 'stats#index'
    
    # 抽奖路由
    resources :lucky_draws, path: :cj, only: [:show] do
      member do
        post :begin
        get  :results
      end
    end
    
    # 网页认证登录
    get    'login'    => 'sessions#new',       as: :login
    get    'redirect' => 'sessions#save_user', as: :redirect_uri
    delete 'logout'   => 'sessions#destroy',   as: :logout
    
  end
  
  # 网页文档
  resources :pages, path: :p, only: [:show]
  
  resources :events, only: [:new, :create]
  
  # 后台系统登录
  devise_for :admins, ActiveAdmin::Devise.config
  
  # 后台系统路由
  ActiveAdmin.routes(self)
  
  # 商家会员系统登录
  # devise_for :merchants, path: "account", controllers: {
  #   registrations: :account,
  #   sessions: :sessions,
  # }
  # 
  # # 商家后台系统
  # namespace :portal, path: '' do
  #   root 'home#index'
  # end
  
  # 队列后台管理
  require 'sidekiq/web'
  authenticate :admin do
    mount Sidekiq::Web => 'sidekiq'
  end
  
  # # API 文档
  # mount GrapeSwaggerRails::Engine => '/apidoc'
  # #
  # # API 路由
  # mount API::Dispatch => '/api'
  
  match '*path', to: 'home#error_404', via: :all
end
