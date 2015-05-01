Rails.application.routes.draw do
  get "xcode_model/:model" => "xcode_model/xcode_model#index" , as: :xcode_model
end