module Modata
  class ModataAndroidController < ::ApplicationController
    def index
      if params[:model]
        @object_name = params[:model].singularize.camelize
        begin
          @package_name = params[:package] || "com.change.me"
          @properties = [{type: "long", name: "id_"}, {type: "long", name: "updated_at"}, {type: "long", name: "created_at"}]
          @object_name.constantize.columns.each do |column|
            next if %w[created_at deleted_at updated_at].include?(column.name.to_s) || column.name.to_s == "id"
            case column.type.to_s
            when "string", "text"
              @properties << {type:"String", name: column.name}
            when "float"
              @properties << {type:"double", name: column.name}            
            when "integer"
              @properties << {type:"long", name: column.name}                        
            when "time", "datetime"
              @properties << {type:"long",  name: column.name}
            when "boolean"
              @properties << {type:"boolean",  name: column.name}              
            end      
          end  
        rescue
          render text: "Model #{@object_name} not found"      
        end
      else
        render 'all'
      end
    end
  end
end