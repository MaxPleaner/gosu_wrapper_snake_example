require 'gosu'
require './util'
require './gosu_wrapper.rb'

require 'active_support/all'
require 'byebug'


app = GosuWrapper.new(
  width: 800,
  height: 600,
  attributes: %i{
    x y
    height width
    velocity_x velocity_y
    visible hit score
    window_width window_height
    font hammer_image image
  }
)

app.config do
  set_x 200
  set_y 200
  set_height 43
  set_width 50
  set_velocity_x 5
  set_velocity_y 5
  set_visible 0
  set_image image(path: "416.png")
  set_hammer_image image(path: '416.png')
  set_hit 0
  set_font Gosu::Font.new(30)
  set_score 0
end

app.config do
  add_helper(:x_out_of_bounds?) do
    ((get_x + (get_width) / 2) > get_window_width) ||
    ((get_x - (get_width) / 2) < 0)
  end
end

app.config do
  add_helper(:y_out_of_bounds?) do
    ((get_y + (get_height) / 2) > get_window_height) ||
    ((get_y - (get_height) / 2) < 0)
  end
end

app.config do
  add_helper(:handle_left_click) do |id|
    if id == Gosu::MsLeft
      if (Gosu.distance(
        invoke(:mouse_x), invoke(:mouse_y), get_x, get_y
      ) < 50) && (get_visible >= 0)
        set_hit 1
        change_score :+, 5
      else
        set_hit 0
        change_score :-, 1
      end
    end
  end  
end

app.config do
  add_hook(:update) do
    change_x :+, get_velocity_x
    change_y :+, get_velocity_y
    change_velocity_x(:*, -1) if invoke(:x_out_of_bounds?)
    change_velocity_y(:*, -1) if invoke(:y_out_of_bounds?)
    change_visible :-, 1
    set_visible(30) if (get_visible < -10) && (rand < 0.01)
    set_time_left(100 - (Gosu.milliseconds / 1000))
  end
end

app.config do
  add_hook(:button_down) do |id|
    invoke(:handle_left_click, id)
  end
end

app.add_hook(:draw) do
  if get_visible > 0
    draw_x = get_x - (get_width / 2)
    draw_y = get_y - (get_height / 20)
    get_image.draw(draw_x, draw_y, 1)
  end
  draw_hammer_x = invoke(:mouse_x) - 40
  draw_hammer_y = invoke(:mouse_y) - 10
  get_hammer_image.draw(draw_hammer_x, draw_hammer_y, 1)
  color = case get_hit
  when 0
    Gosu::Color::NONE
  when 1
    Gosu::Color::GREEN
  when -1
    Gosu::Color::RED
  end
  invoke(:draw_quad, *[
    0, 0, color,
    800, 0, color,
    800, 600, color,
    0, 600, color
  ])
  set_hit 0
  get_font.draw get_score.to_s, 700, 20, 2
  get_font.draw get_time_left.to_s, 20, 20, 2
end

app.window.show
