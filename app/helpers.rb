module App
  def self.with_helpers(app)

    app.config do

      add_helper(:x_out_of_bounds?) do
      end

      add_helper(:y_out_of_bounds?) do
      end

      add_helper(:handle_left_click) do |id|
        if id == Gosu::MsLeft
        end
      end  

    end
  end
end
