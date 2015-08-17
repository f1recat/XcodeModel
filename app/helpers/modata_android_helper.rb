module ModataAndroidHelper
  def modata_android_prop_name(value, options={})
    ret = value.camelize(:lower)
    ret += "_" if value.last == "_"
    ret = ret.sub(/^(.)/) { $1.capitalize } if options[:capitalize]
    ret
  end
  
  def modata_android_rm_underscore(value) 
    value.sub(/(.)$/) { $1 == "_" ? "" : $1}     
  end
  
end
