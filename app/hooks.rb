module App
  def self.with_hooks(app)

    app.config do

      add_hook(:update) do

      end

      add_hook(:button_down) do |id|
      end

      add_hook(:draw) do
        get_or_set_grid_sections do
          call_helper :div_window_into, {
            num_rows: 2,
            num_cols: 2,
            margin: 1
          }
        end
        call_helper :draw_grid, {
          sections: get_grid_sections,
          row_color: colors[:green],
          col_color: colors[:red]
        }
      end

    end
  end
end
