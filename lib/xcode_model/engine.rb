module XcodeModel
  class Engine < Rails::Engine
    
    initializer "xcode_model.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

  end  
end