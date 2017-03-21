module App

  # The following are required as state keys:
  #  - window_height, window_width

  def self.state_keys
    %i{
      window_height
      window_width
    }
  end

  def self.with_state(app)
    app.config do
      set_query ""
      set_results Hash.new
    end
  end
end
