require 'gosu'
require 'byebug'

module GosuWrapper
  def self.test
    window = Constructors::Window.new.new(
      width: 600, height: 800, caption: "OK"
    )
    window.show
  end
end

require './gosu_wrapper/constructors'

GosuWrapper.test
