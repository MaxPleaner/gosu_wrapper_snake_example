module App

  def self.state_keys
    %i{
      window_height
      window_width
      grid_sections
      snake_coords
      apple_coord
      snake_direction
      snake_just_ate
      frames_per_move
      frame_idx
      num_rows
      num_cols
      margin
    }
  end

  def self.with_state(app)
    app.config do
      set_query ""
      set_results Hash.new
      set_grid_sections nil
      set_snake_coords [[0,0]]
      set_apple_coord [6,6]
      set_snake_direction :right
      set_snake_just_ate false
      set_frames_per_move 10
      set_frame_idx 0
      set_num_rows 10
      set_num_cols 10
      set_margin 1
    end
  end
end
