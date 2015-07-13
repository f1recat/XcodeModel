module XcodeModel
  class Engine < Rails::Engine

    initializer "xcode_model.load_app_instance_data" do |app|
      XcodeModel.setup do |config|
        config.app_root = app.root
      end
    end

    initializer "xcode_model.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

  end  
end