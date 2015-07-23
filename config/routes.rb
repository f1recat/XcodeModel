Rails.application.routes.draw do
  get "has_sync/data(/:object)" => "xcode_model/xcode_model#data", as: :xcode_model_data  
  get "has_sync/xcode_model(/:model)" => "xcode_model/xcode_model#index" , as: :xcode_model
end