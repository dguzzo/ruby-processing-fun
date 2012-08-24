module Helpers
  def self.bright_balls(balls)
    brights = balls.select { |ball| ball.is_bright_color? }
    brights.length
  end
end