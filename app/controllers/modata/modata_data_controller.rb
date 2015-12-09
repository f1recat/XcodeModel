module Modata
  class ModataDataController < ::ApplicationController
    def data
      timestamp = params[:timestamp]
      table = params[:object]
      if table
        klass = nil
        begin
          klass = table.singularize.camelize.constantize
        rescue
          klass = table.camelize.constantize          
        end
        if klass.has_modata?
          data = []
          if timestamp
            data = klass.where("updated_at > ?", DateTime.strptime((timestamp.to_i + 1).to_s,'%Q'))
          else
            data = klass.all
          end
          if klass.modata_filter_method
            render modata: klass.send(klass.modata_filter_method, data)
           else
            render modata: data    
          end
        else
          render text:"forbidden"
        end
      else
      end
    end

    def deleted
      last_id = params[:last_id]
      last_id ||= 0
      delete = ModataDelete.order('id').last
      delete = delete.nil? ? 0 : delete.id
      if last_id == "init"
        render json:{sync_state: delete}
      else
        ret = ModataDelete.where("id > ?", last_id).group_by {|obj| obj.table_name}
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
        device = ModataDevice.find_or_initialize_by(device: "#{platform}_#{device_id}")
        device.state = sync_state.to_i
        device.last_sync_timestamp = DateTime.now
        device.save
        ModataDelete.destroy_all("id < #{ModataDevice.order(:state).first.state}")
        render json:{success:1}
      else
        render json:{success:0}
      end
    end
  end
end
