module XcodeModel
  class Engine < Rails::Engine

    config.app_root = app.root
    
    initializer "xcode_model.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

  end  
end