module XcodeModelHelper
  def xcode_model_class_save(properties)
    ret = ""
    properties.each {|property| ret += "#{property[:name]}, "}
    ret
  end
  
  def xcode_model_class_save_types_mapping(type)
    return "%d" if type == "INTEGER"
    return "%f" if type == "REAL"
    return "?" if type == "TEXT"
  end
  
  def xcode_model_class_save_types(properties)
    ret = ""
    properties.each {|property| ret += "#{xcode_model_class_save_types_mapping property[:type].to_s}, "}
    ret    
  end
  
  def xcode_model_class_save_names(mapping)
    ret = ""
    mapping.each {|map| ret += "self.#{map[:to]}, " if map[:type].nil? || map[:type] != "string"}    
    ret
  end
  
  def xcode_model_class_save_names_strings(mapping)
    ret = ""
    mapping.each {|map| ret += "self.#{map[:to]}, " if map[:type] && map[:type] == "string"}    
    ret = ret[0..-3] if ret.length > 0
    ret
  end
end
