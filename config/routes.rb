Rails.application.routes.draw do
  namespace :modata do
    get "deleted(/:last_id)" => "modata_data#deleted"
    get "data(/:object)" => "modata_data#data", as: :data
    get "xcode(/:model)" => "modata_xcode#index", as: :xcode_model
    get "android(/:model)" => "modata_android#index", as: :android_model    
    get "commit" => "modata_data#commit"
  end
end