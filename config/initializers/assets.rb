# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( shoutu.css follow_task.css products.css )
Rails.application.config.assets.precompile += %w( frontend.css frontend.js front.css portal.css portal.js approve.css stats.css stats.js share.css share.js qrcode.js qrcode.css choujiang.js choujiang.css )
