
class GosuWrapper

  extend Util

  attr_reader :window_constructor, :window, :window_attributes

  def initialize(width:, height:, attributes:)
    @window_constructor = Class.new(Gosu::Window) do
      const_set("Attributes", attributes)
      attr_accessor *attributes
    end
    @window_attributes = @window_constructor::Attributes
    @window = @window_constructor.new(width, height)
    @window.window_height = height
    @window.window_width = width
  end

  # Delegate "set_<attr>" setters to window
  method_missing_for /^set_(.+)$/, type: :instance do |window_attr, val|
    Proc.new do
      if window_attr.to_sym.in? window_attributes
        window.instance_variable_set("@#{window_attr}", val)
      end
    end
  end

  # Delegate "get_<attr>" getters to window
  method_missing_for /^get_(.+)$/, type: :instance do |window_attr|
    Proc.new do
      if window_attr.to_sym.in? window_attributes
        window.instance_variable_get("@#{window_attr}")
      end
    end
  end

  # Delegate "change_<attr>" non-destructive setters to window
  # i.e. change_x(:+, 1) is equivalent to @x += 1
  method_missing_for /^change_(.+)$/, type: :instance do |window_attr, method_name, val|
    Proc.new do
      if window_attr.to_sym.in? window_attributes
        window.instance_variable_set(
          "@#{window_attr}",
          window.instance_variable_get("@#{window_attr}").send(method_name, val) 
        )
      end
    end
  end

  # Methods are defined on the window's anonyous class
  # to connect to Gosu::Window's hooks
  # these are predefined; see their docs.
  # The generated method's body is always invoked within the App instance's scope.
  # Aliased to add_helper to distinguish custom methods from those in the
  # Gosu::Window lifecycle
  def add_hook(name, &blk)
    app = self
    window.define_singleton_method(name) { |*args, **keywords| app.scope(&blk) }
  end
  alias add_helper add_hook

  def image(path:)
    Gosu::Image.new(path)
  end

  # A wrapper over instance_eval i.e. app.scope { set_x 200 }
  # Always returns self (app)
  # Be aware that this only sets the scope for one level
  # i.e. if you call a method in the passed block, it'll use a different scope
  def scope &blk
    instance_eval &blk
    self
  end
  alias config scope

  # Call a method which is defined on window.
  # Although this could have been overloaded onto get_<attr>,
  # for the sake of easier debugging that's limited to instance variables
  def invoke(name, *args, &blk)
    window.send(name, *args, &blk)
  end

end
