class Ball
  attr_accessor :x, :y, :r, :m, :vec, :ball_fill, :num_collisions, :rainbow_mode
  
  @@MIN_FILL = 90
  @@INCREMENT_FILL_VAL = 5
  @@RAINBOW_THRESHOLD = 5 #determines how many collisions are needed for a ball to enter rainbow mode
  @@COLORS_USED = []
  @@GRAYS_USED = []
  
  def initialize(r = 0.0, vec = nil, x = 0.0, y = 0.0)
    @x, @y, @r = x, y, r
    @m = r * 0.1
    @vec = vec
    @ball_fill = rand(255)
    @num_collisions = 0
    @rainbow_mode = false
  end
  
  def self.colors_used
    @@COLORS_USED.length
  end
  
  def self.grays_used
    @@GRAYS_USED.length
  end
  
  def move
    @x += @vec.x
    @y += @vec.y
    self
  end

  def draw
    r = @r * 2
    $app.ellipse @x, @y, r, r
    @px, @py = @x, @y
  end

  def erase
    r = @r * 2
    $app.rect @px, @py, r, r
  end
  
  def collision_side_effects
    # @num_collisions += 1
    @num_collisions = @num_collisions.next # just having fun with methods for learning purposes
    if @num_collisions > @@RAINBOW_THRESHOLD
      @rainbow_mode = true
    end
    increment_fill
  end
  
  # increment the fill value of the ball
  def increment_fill
    begin
      # increment the fill value. reset value to a certain minimum if it goes over the max gray value.
      if @rainbow_mode
        new_color = [rand(255),rand(255),rand(255)]
        @ball_fill = new_color
        @@COLORS_USED << new_color unless @@COLORS_USED.include?(new_color)
      else
        @ball_fill = ((@ball_fill += @@INCREMENT_FILL_VAL) > 255 ) ? @@MIN_FILL : @ball_fill += @@INCREMENT_FILL_VAL
        @@GRAYS_USED << @ball_fill unless @@GRAYS_USED.include?(@ball_fill)
      end
    rescue => e
      puts "error in increment_fill: #{e.message}"
    end
  end

  # returns true if the ball's fill color is above a certain, arbitrary threshold for brightness value.
  # basically an excuse to use the .between? method as a learning experience
  def is_bright_color?
    brightness_threshold_low = 200
    begin
      if @ball_fill.class == Array
        # puts "#{@ball_fill[0]} #{@ball_fill[1]} #{@ball_fill[2]}"
        return @ball_fill[0].between?(brightness_threshold_low,255) || @ball_fill[1].between?(brightness_threshold_low,255) || @ball_fill[2].between?(brightness_threshold_low,255)
      else
        return @ball_fill.between?(brightness_threshold_low,255)
      end
    rescue => e
      puts "error in is_bright_color? #{e.message}"
      false
    end
  end
  
end
