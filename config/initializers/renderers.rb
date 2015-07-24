ActionController::Renderers.add :modata do |obj, options|
  if obj.count > 0
    data = []
    obj.each do |object|
      ret = {}
      object.class.columns.each do |column|
        if ["date", "time", "datetime"].include? column.type.to_s
          if (datetime = object.send(column.name))
            ret[column.name] = (datetime.to_time.to_f * 1000).to_i
          else
            ret[column.name] = nil
          end
        elsif column.type == :hstore
          if (hstore = object.send(column.name))
            hstore.each { |key, value| ret[key] = value } 
          end
        else
          ret[column.name] = object.send(column.name)          
        end
      end
      data << ret
    end
    render json:data
  else
    render json:obj
  end
end