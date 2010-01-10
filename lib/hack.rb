class Array
  def find_dups
    uniq.map {|v| (self - [v]).size < (self.size - 1) ? v : nil}.compact
  end
end

ActionController::Routing::Routes.instance_eval(%Q{
  def clear!
  end
}) if defined? ActionController

#module ActionController
  #class Base
    #def render_for_file(template_path, status = nil, layout = nil, locals = {}) #:nodoc:
      ## orders/new
      #template_path = "#{RAILS_ROOT}/vendor/plugins/commodules/spec/rails_root/vendor/modules/test_mod/app/views/#{template_path}"
      #logger.info("Rendering #{template_path}" + (status ? " (#{status})" : '')) if logger
      #render_for_text @template.render(:file => template_path, :locals => locals, :layout => layout), status
    #end
  #end
#end
