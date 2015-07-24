module Modata
  class Engine < Rails::Engine
    
    initializer "modata.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

  end  
end