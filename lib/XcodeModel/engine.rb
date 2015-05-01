module XcodeModel
  class Engine < Rails::Engine

    initialize "xcode_model.load_app_instance_data" do |app|
      XcodeModel.setup do |config|
        config.app_root = app.root
      end
    end

    initialize "xcode_model.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

  end  
end