module ModataXcodeHelper
  def modata_xcode_class_save(properties)
    ret = ""
    properties.each {|property| ret += "#{property[:name]}, "}
    ret
  end
  
  def modata_xcode_class_save_types_mapping(type)
    return "%ld" if type == "INTEGER"
    return "%f" if type == "REAL"
    return "?" if type == "TEXT"
  end
  
  def modata_xcode_class_save_types(properties)
    ret = ""
    properties.each {|property| ret += "#{modata_xcode_class_save_types_mapping property[:type].to_s}, "}
    ret    
  end
  
  def modata_xcode_class_save_names(mapping)
    ret = ""
    mapping.each do |map| 
      if map[:type].nil? || map[:type] != "string"
        if map[:type] == "NSInteger"
          ret += "(long)self.#{map[:to]}, "          
        else
          ret += "self.#{map[:to]}, "
        end
      end
    end
    ret
  end
  
  def modata_xcode_class_save_names_strings(mapping)
    ret = ""
    mapping.each {|map| ret += "self.#{map[:to]}, " if map[:type] && map[:type] == "string"}    
    ret = ret[0..-3] if ret.length > 0
    ret
  end
end
