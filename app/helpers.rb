module App

  def self.with_helpers(app)
    app.config do

      add_helper(:move_snake) do |direction:|
        grid_sections = get_grid_sections
        snake_coords = get_snake_coords
        vector = case direction
        when :right then [0, 1] 
        when :left then [0, -1]
        when :up then [-1, 0]
        when :down then [1, 0]
        end
        head_coords = snake_coords[-1]
        next_row_idx = head_coords[0] + vector[0]
        next_col_idx = head_coords[1] + vector[1]
        next_cell = [next_row_idx, next_col_idx]
        if grid_sections[next_row_idx]&.fetch(:cols, {})&.fetch(next_col_idx, nil)
          snake_coords.push next_cell
          if get_snake_just_ate
            set_snake_just_ate false
          else
            if next_cell == get_apple_coord
              call_helper :gen_apple_coord
              set_snake_just_ate true
            end
            snake_coords.shift
          end
        else
          call_helper(:cant_move)
        end
      end

      add_helper(:gen_apple_coord) do
        snake_rows = get_snake_coords.map(&:first)
        snake_cols = get_snake_coords.map(&:second)
        possible_rows = get_num_rows.times.reject { |idx| idx.in? snake_rows }
        possible_cols = get_num_cols.times.reject { |idx| idx.in? snake_cols }
        new_apple_coord = [possible_rows, possible_cols].map &:sample
        if new_apple_coord.all?
          set_apple_coord new_apple_coord
        else
          set_apple_coord nil
        end
      end
 
      add_helper(:draw_apple) do |apple_coord:, color:|
        if apple_coord
          cell = get_grid_sections[apple_coord[0]][:cols][apple_coord[1]] rescue byebug
          draw_rect cell.merge(color: color)
        end
      end

      add_helper(:cant_move) do
      end

      add_helper(:draw_snake) do |snake_coords:, color:|
        grid_sections = get_grid_sections
        snake_coords.each do |coord|
          cell = grid_sections[coord[0]][:cols][coord[1]]
          draw_rect cell.merge(color: color)
        end
      end

      add_helper(:div_window_into) do |num_cols:, num_rows:, margin: |
        call_helper :div_section_into, {
          start_x: 0,
          start_y: 0,
          end_x: get_window_width,
          end_y: get_window_height,
          margin: margin,
          num_rows: num_rows,
          num_cols: num_cols
        }
      end

      add_helper(:div_section_into) do |
        start_x:, start_y:, end_x:, end_y:, num_cols:, num_rows:, margin:
      |
        total_height = end_y - start_y
        total_width = end_x - start_x
        row_height = total_height / num_rows
        col_width = total_width / num_cols
        (num_rows).times.reduce({}) do |rows, row_idx|
          row_start_y = (row_height * row_idx)
          row_end_y = (row_start_y + row_height)
          rows[row_idx] = {
            start_y: row_start_y,
            end_y: row_end_y,
            start_x: start_x,
            end_x: end_x,
            cols: (num_cols).times.reduce({}) do |cols, col_idx|
              col_start_x = col_width * col_idx
              col_end_x = col_start_x + col_width
              cols[col_idx] = {
                start_x: col_start_x + margin,
                end_x: col_end_x - margin,
                start_y: row_start_y + margin,
                end_y: row_end_y - margin,
              } 
              cols
            end
          }
          rows
        end
      end

      add_helper(:draw_grid) do |sections:, row_color:, col_color:|
        sections.each do |row_num, row|
          draw_rect row.merge(color: row_color)
          row[:cols].each do |col_num, col|
            draw_rect col.merge(color: col_color)
          end
        end
      end

    end
  end
end
