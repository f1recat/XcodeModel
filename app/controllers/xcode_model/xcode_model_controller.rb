module XcodeModel
  class XcodeModelController < ::ApplicationController
    def index
      @object_name = params[:table].singularize.camelize
      begin
        @database_name = params[:database] || "MyDatabase"
        @properties = []
        @internal_properties = []
        @database_fields = []
        @mapping = []      
        @object_name.constantize.columns.each do |column|
          next if %w[created_at deleted_at updated_at].include? column.name
          case column.type.to_s
          when "string", "text"
            @properties << {type:"NSString *", retain_type: "strong", name: column.name.camelize(:lower)}
            @database_fields << {type: "TEXT", name: column.name}
            @mapping << {to: column.name.camelize(:lower), from: column.name, type:"string"}
          when "float"
            @properties << {type:"double ", retain_type: "assign", name: column.name.camelize(:lower)}            
            @database_fields << {type: "REAL", name: column.name}       
            @mapping << {to: column.name.camelize(:lower), from: column.name, type:"double"}
          when "integer"
            @properties << {type:"int ", retain_type: "assign", name: column.name.camelize(:lower)}                        
            @database_fields << {type: "INTEGER", name: column.name}     
            @mapping << {to: column.name.camelize(:lower), from: column.name, type:"int"}
          when "time", "datetime"
            @properties << {type:"NSDate *", retain_type: "strong", name: column.name.camelize(:lower)}
            @internal_properties << {type: "int ", retain_type: "assign", name: "_i#{column.name.camelize}", ref_type:"datetime", ref_name:column.name.camelize(:lower)}
            @database_fields << {type: "INTEGER", name: column.name}   
            @mapping << {to: "_i#{column.name.camelize}", from: column.name, type: "int"}
          when "hstore"
            st = Station.new
            st.methods.each do |method|
              if method.to_s =~ /=/ && method.to_s[0] != "_"
                begin 
                  st.send(method, 1) if method.to_s =~ /[a-zA-Z0-9_]+/ && method.to_s[0..-2] != column.name.to_s
                rescue
                end
              end
            end
            st.send(column.name).each do |key, _|          
              @properties << {type:"BOOL ", retain_type: "assign", name: key.camelize(:lower)}                        
              @database_fields << {type: "INTEGER", name: key}     
              @mapping << {to: key.camelize(:lower), from: key, type:"int"}              
            end
          end      
        end  
      rescue
        render text: "Model #{@object_name} not found"      
      end
    end
  end
end