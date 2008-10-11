module OFCAjax
  def periodically_call_function(function, options = {})
     frequency = options[:frequency] || 10 # every ten seconds by default
     code = "new PeriodicalExecuter(function() {#{function}}, #{frequency})"
     ActionView::Base.new.javascript_tag(code)
  end
  
  def js_open_flash_chart_object(div_name, width, height, base="/")
    return %[
      <script type="text/javascript">
        swfobject.embedSWF("#{base}open-flash-chart.swf", "#{div_name}", "#{width}", "#{height}", "9.0.0");
      </script>
      #{self.to_open_flash_chart_data}
      <div id="#{div_name}"></div>
    ]
  end

  def link_to_ofc_load(link_text, div_name)
    data_name = "#{link_text.gsub(" ","_")}_#{div_name.gsub(" ","_")}"
    return %[
      <script type="text/javascript">
        function load_#{data_name}() {
          tmp = findSWF("#{div_name}");
          x = tmp.load(Object.toJSON(data_#{data_name}));
        }
        var data_#{data_name} = #{self.render};
      </script>
      #{ActionView::Base.new.link_to_function link_text, "load_#{data_name}()"}
    ]
  end

  def link_to_remote_ofc_load(link_text, div_name, url)
    fx_name = "#{link_text.gsub(" ","_")}_#{div_name.gsub(" ","_")}"
    return %[
      <script type="text/javascript">
        function reload_#{fx_name}() {
          tmp = findSWF("#{div_name}");
          new Ajax.Request('#{url}', {
            method    : 'get',
            onSuccess : function(obj) {tmp.load(obj.responseText);},
            onFailure : function(obj) {alert("Failed to request #{url}");}});
        }
      </script>
      #{ActionView::Base.new.link_to_function link_text, "reload_#{fx_name}()"}
    ]
  end
  
  def periodically_call_to_remote_ofc_load(div_name, url, options={})
    fx_name = "#{div_name.gsub(" ","_")}"
    frequency = options[:frequency] || 10 # every ten seconds by default
    return %[
      <script type="text/javascript">
        function reload_#{fx_name}() {
          tmp = findSWF("#{div_name}");
          new Ajax.Request('#{url}', {
            method    : 'get',
            onSuccess : function(obj) {tmp.load(obj.responseText);},
            onFailure : function(obj) {alert("Failed to request #{url}");}});
        }
      </script>
      #{periodically_call_function("reload_#{fx_name}()", "#{frequency}")}
    ]
  end


  def to_open_flash_chart_data
    # this builds the open_flash_chart_data js function
    return %'
      <script type="text/javascript">
        function ofc_ready() {
        }
        function open_flash_chart_data() {
          return Object.toJSON(data);
        }
        function findSWF(movieName) {
          if (navigator.appName.indexOf("Microsoft")!= -1) {
            return window[movieName];
          } else {
            return document[movieName];
          }
        }
        var data = #{self.render};
      </script>
    '
  end
end
