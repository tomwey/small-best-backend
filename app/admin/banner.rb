ActiveAdmin.register Banner do

menu parent: 'system', priority: 18, label: 'Banner广告'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :image, :sort, :link, :view_count, :click_count, :opened
#
# or

index do
  selectable_column
  column('ID', :uniq_id)
  column :image, sortable: false do |b|
    image_tag b.image.url(:small)
  end
  column :view_count
  column :click_count
  column :opened
  column :sort
  column('at', :created_at)
  
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs '广告基本信息' do
    f.input :image, hint: '图片格式为：jpg,jpeg,gif,png；尺寸为1080x504'
    f.input :link, placeholder: '可能是url地址，也可能是活动的ID，也可能官方平台网页文档，也可以不填该值'
    f.input :opened, as: :boolean
    f.input :sort, hint: '值越小排名越靠前'
  end
  f.inputs '广告统计信息' do
    f.input :view_count
    f.input :click_count
  end
  
  actions
  
end

end
