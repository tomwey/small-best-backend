ActiveAdmin.register Merchant do
  
  menu parent: 'merchants', label: '商家管理', priority: 1
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :logo, :name, :balance, :auth_type, :opened, :mobile, :address
#
# or
#
index do
  selectable_column
  column('ID', :uniq_id)
  column :logo, sortable: false do |o|
    o.logo.blank? ? '' : image_tag(o.logo.url(:large), size: '60x60')
  end
  column :name, sortable: false 
  column :balance do |o|
    "#{o.balance / 100.00}元"
  end
  column :auth_type, sortable: false do |o|
    I18n.t("common.merchant.auth_type_#{o.auth_type}")
  end
  column :opened,sortable: false
  column('at', :created_at)
  
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  f.inputs do
    f.input :name
    f.input :logo, hint: '图片格式为：jpg,jpeg,gif,png'
    f.input :mobile
    f.input :balance
    f.input :address
    f.input :auth_type, as: :select, collection: [['未实名认证', 0], ['实名认证', 1], ['个体户实名认证', 2], ['企业实名认证', 3]]
    f.input :opened, as: :boolean
  end
  actions
end

end
