Rails.application.routes.draw do
  namespace :modata do
    get "deleted(/:last_id)" => "modata_data/modata_data#deleted"
    get "data(/:object)" => "modata_data/modata_data#data"
    get "xcode/:model)" => "modata_data/modata_xcode#index"
    get "commit" => "modata_data/modata_data#commit"
  end
end