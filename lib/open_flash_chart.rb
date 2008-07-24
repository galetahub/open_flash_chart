# OpenFlashChart
class OpenFlashChart

  def initialize(args={})
    # set all the instance variables we want
    # assuming something like this OpenFlashChart.new(:x_axis => 5, :y_axis => 10, :elements => ["one", "two"], ...)
    args.each do |k,v|
      self.instance_variable_set("@#{k}", v)
    end
  end

  def to_s
    # need to return the following like this
    # 1) font_size as font-size 
    # 2) dot_size as dot-size
    # 3) outline_colour as outline-colour
    # 4) halo_size as halo-size
    # 5) start_angle as start-angle
    # 6) tick_height as tick-height
    # 7) grid_colour as grid-colour
    # 8) threed as 3d
    # 9) tick_length as tick-length
    self.to_json.gsub("threed","3d").gsub("_","-")
  end
  alias_method :render, :to_s

  def add_element(element)
    @elements ||= []
    @elements << element
  end

  def set_key(text, size)
    @text      = text
    @font_size = size
  end
  
  def append_value(v)
    @values ||= []
    @values << v
  end

  def set_range(min,max,steps=1)
    @min = min
    @max = max
    @steps = steps
  end
  
  def set_offset(v)
    @offset = v ? true : false
  end
  
  def set_colours(colour, grid_colour)
    @colour = colour
    @grid_colour = grid_colour
  end

  def method_missing(method_name, *args)
    method_name = method_name.to_s
    if method_name =~ /.*=/   # i.e., if it is something x_legend=
      # if the user wants to set an instance variable then let them
      # the other args (args[0]) are ignored since it is a set method
      return self.instance_variable_set("@#{method_name}", args[0])
    elsif method_name =~/^set_(.*)/
      # backwards compatible ... the user can still use the same set_y_legend methods if they want
      return self.instance_variable_set("@#{$1}", args[0])
    else
      # if the method/attribute is missing and it is not a set method then hmmmm better let the user know
      super
    end
  end
end