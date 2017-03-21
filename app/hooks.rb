module App
  def self.with_hooks(app)
    app.config do

      add_hook(:update) do
      end

      add_hook(:button_down) do |id|
        invoke(:handle_left_click, id)
      end

      app.add_hook(:draw) do
      end

    end
  end
end
