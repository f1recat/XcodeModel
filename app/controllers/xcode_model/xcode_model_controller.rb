module XcodeModel
  class XcodeModelController < ::ApplicationController
    def index
      if params[:model]
        @object_name = params[:model].singularize.camelize
        begin
          @database_name = params[:database] || "MyDatabase"
          @properties = []
          @internal_properties = []
          @database_fields = []
          @mapping = []      
          @object_name.constantize.columns.each do |column|
            next if %w[created_at deleted_at updated_at].include?(column.name.to_s) || column.name.to_s == "id"
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
              @properties << {type:"NSInteger ", retain_type: "assign", name: column.name.camelize(:lower)}                        
              @database_fields << {type: "INTEGER", name: column.name}     
              @mapping << {to: column.name.camelize(:lower), from: column.name, type:"NSInteger"}
            when "time", "datetime"
              @properties << {type:"NSDate *", retain_type: "strong", name: column.name.camelize(:lower)}
              @internal_properties << {type: "NSUInteger ", retain_type: "assign", name: "_i#{column.name.camelize}", ref_type:"datetime", ref_name:column.name.camelize(:lower)}
              @database_fields << {type: "INTEGER", name: column.name}   
              @mapping << {to: "_i#{column.name.camelize}", from: column.name, type: "NSUInteger"}
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
      else
        render 'all'
      end
    end
    
    def data
      timestamp = params[:timestamp]
      table = params[:object]
      if table
        if timestamp
          render xcode: table.singularize.camelize.constantize.where("updated_at > ?", DateTime.strptime((timestamp.to_i + 1).to_s,'%Q'))
        else
          render xcode: table.singularize.camelize.constantize.all
        end
      else
      end
    end
    
    def deleted
      last_id = params[:last_id]
      last_id ||= 0      
      delete = HasSyncDelete.order('id').last
      delete = delete.nil? ? 0 : delete.id      
      if last_id == "init"
        render json:{sync_state: delete}
      else
        ret = HasSyncDelete.where("id > ?", last_id).group_by {|obj| obj.table_name}
        ret_arr = []
        ret.each {|k, v| ret[k] = v.map{|o| o.row_id}}.each {|k, v| ret_arr << {table: k, ids: v.join(",")}}
        ret_arr << {table: "sync_state", ids:delete}
        render json: ret_arr  
      end
    end
    
    def commit
      device_id = params[:device_id]
      platform = params[:platform]
      sync_state = params[:sync_state]
      if device_id && platform && sync_state
        device = HasSyncDevice.find_or_initialize_by(device: "#{platform}_#{device_id}")
        device.state = sync_state.to_i
        device.last_sync_timestamp = DateTime.now
        device.save
        HasSyncDelete.destroy_all("id < #{HasSyncDevice.order(:state).first.state}")
        render json:{success:1}        
      else
        render json:{success:0}
      end
    end
  end
end