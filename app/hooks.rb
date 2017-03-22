module App
  def self.with_hooks(app)

    # update and draw are called every tick

    app.config do

      add_hook(:update) do
        get_or_set_grid_sections do
          call_helper :div_window_into, {
            num_rows: get_num_rows,
            num_cols: get_num_cols,
            margin: get_margin
          }
        end
        set_frame_idx(
          (get_frame_idx + 1) % get_frames_per_move 
        )
        if get_frame_idx.zero?
          call_helper :move_snake, {
            direction: get_snake_direction
          }
        end
      end

      add_hook(:draw) do
        call_helper :draw_grid, {
          sections: get_grid_sections,
          row_color: colors[:green],
          col_color: colors[:red]
        }
        call_helper :draw_snake, {
          snake_coords: get_snake_coords,
          color: colors[:blue]
        }
        call_helper :draw_apple, {
          apple_coord: get_apple_coord,
          color: colors[:aqua]
        }
      end

      # handle user input
      add_hook(:button_down) do |id|
        case id
        when buttons[:right]
          set_snake_direction :right
        when buttons[:left]
          set_snake_direction :left
        when buttons[:down]
          set_snake_direction :down
        when buttons[:up]
          set_snake_direction :up
        when buttons[:escape]
          exit
        end
      end

    end
  end
end
