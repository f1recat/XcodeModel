Rails.application.routes.draw do
  namespace :modata do
    get "deleted(/:last_id)" => "modata_data#deleted"
    get "data(/:object)" => "modata_data#data", as: :data
    get "xcode(/:model)" => "modata_xcode#index", as: :model
    get "commit" => "modata_data#commit"
  end
end