require 'gosu'
require './gosu_wrapper.rb'

require 'active_support/all'

require './app/state'
require './app/helpers'
require './app/hooks'

module App
  def self.new
    with_state with_helpers with_hooks GosuWrapper.new(
      width: 600,
      height: 500,
      attributes: state_keys,
    )
  end
end

App.new.show
