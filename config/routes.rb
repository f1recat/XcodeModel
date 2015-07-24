Rails.application.routes.draw do
#  namespace :has_sync do
    get "has_sync/deleted(/:last_id)" => "xcode_model/xcode_model#deleted", as: :xcode_deleted_data
    get "has_sync/data(/:object)" => "xcode_model/xcode_model#data", as: :xcode_model_data  
    get "has_sync/xcode_model(/:model)" => "xcode_model/xcode_model#index" , as: :xcode_model
    get "has_sync/commit" => "xcode_model/xcode_model#commit", as: :xcode_model_commit
 # end
end