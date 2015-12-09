def process_value(value)
  return (value.to_time.to_f * 1000).to_i if value && ["Date", "DateTime", "Time", "ActiveSupport::TimeWithZone"].include?(value.class) 
  value
end

ActionController::Renderers.add :modata do |obj, options|
  if obj.count > 0
    data = []
    only = obj[0].class.modata_only_attributes

    except = {} 
    except_array = obj[0].class.modata_except_attributes    
    except_array.each {|elem| except[elem.to_sym] = true } if except_array 
    
    computed_attributes = obj[0].class.modata_computed_attributes
    computed_attributes ||= []
    
    obj.each do |object|
      ret = {}      
      if only
        only.each do |column|
          value = object.read_attribute(column)
          ret[column] = process_value(value)
        end
      else
        object.class.columns.each do |column|
          next if except[column.name.to_sym]
          if ["date", "time", "datetime"].include? column.type.to_s
            ret[column.name] = process_value(object.send(column.name))
          elsif column.type == :hstore
            if (hstore = object.send(column.name))
              hstore.each { |key, value| ret[key] = value } 
            end
          else
            ret[column.name] = object.send(column.name)          
          end
        end        
      end
      computed_attributes.each do |attrib|
        value = object.send(attrib)
        ret[attrib] = process_value(value)        
      end
      data << ret
    end
    render json:data
  else
    render json:obj
  end
end