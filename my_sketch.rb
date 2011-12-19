# Based on circle_collision in the ruby-processing samples, which is based on http://processing.org/learning/topics/circlecollision.html
# by Joe Holt

class DomSketch < Processing::App
  
  @@BACKGROUND = 0
  
  # This inner class demonstrates the use of Ruby-Processing's emulation of
  # Java inner classes. The Balls are able to call Processing::App methods.
  class Ball
    attr_accessor :x, :y, :r, :m, :vec, :ball_fill, :num_collisions, :rainbow_mode
    
    @@MIN_FILL = 90
    @@INCREMENT_FILL_VAL = 10
    @@RAINBOW_THRESHOLD = 5
    
    def initialize(r = 0.0, vec = nil, x = 0.0, y = 0.0)
      @x, @y, @r = x, y, r
      @m = r * 0.1
      @vec = vec
      @ball_fill = rand(255)
      @num_collisions = 0
      @rainbow_mode = false
    end
    
    def move
      @x += @vec.x
      @y += @vec.y
    end
  
    def draw
      r = @r * 2
      ellipse @x, @y, r, r
      @px, @py = @x, @y
    end
  
    def erase
      r = @r * 2
      rect @px, @py, r, r
    end
    
    def collision_side_effects
      @num_collisions += 1
      if @num_collisions > @@RAINBOW_THRESHOLD
        @rainbow_mode = true
      end
      increment_fill
    end
    
    def increment_fill
      begin
        # increment the fill value. reset value to a certain minimum if it goes over the max gray value.
        if self.rainbow_mode
          #print 'rainbow\n'
          self.ball_fill = [rand(255),rand(255),rand(255)]
        else
          self.ball_fill = ((self.ball_fill += @@INCREMENT_FILL_VAL) > 255 ) ? @@MIN_FILL : self.ball_fill += @@INCREMENT_FILL_VAL
        end
        
      rescue => e
        puts "error in increment_fill: #{e}"
      end
    end
    
  end
  

  def setup
    smooth
    no_stroke
    frame_rate 30
    rect_mode RADIUS

    @balls = []
    7.times { @balls << Ball.new(10, PVector.new(2.15, -1.35), *empty_space(15)) }
    3.times { @balls << Ball.new(40, PVector.new(-1.65, 0.42), *empty_space(45)) }

    @frame_time = nil
    @frame_count = 0
  end


  def draw
    t = Time.now
    fps = 1.0 / (t - @frame_time) if @frame_time
    @frame_time = t
    @frame_count += 1

    # erase previous screen
    if @frame_count == 1
      background @@BACKGROUND
    else
      fill @@BACKGROUND
      @balls.each { |ball| ball.erase }
    end

    # move the balls 
    @balls.each do |ball|
      
      # fill the ball with its saved value
      if(ball.ball_fill.class == Array)
        fill *(ball.ball_fill) # need splat operator if ball_fill is a color and not grayscale
      else
        fill ball.ball_fill
      end
      
      ball.move
      ball.draw
      check_boundary_collision ball
    end
    check_object_collisions
  end


  def empty_space(r)
    x = y = nil
    while !x || !empty_space?(x, y, r) do
      x = rand(width)
      y = rand(height)
    end
    return x, y
  end


  def empty_space?(x, y, r)
    @balls.each do |ball|
      vx = x - ball.x
      vy = y - ball.y
      mag = sqrt(vx * vx + vy * vy)
      return false if mag < r + ball.r
    end
    return true
  end


  def check_object_collisions

    (0...(@balls.length)).each do |ia|
      ((ia+1)...(@balls.length)).each do |ib|

        ba = @balls[ia]
        bb = @balls[ib]
  
        # get distances between the balls components
        bVect = PVector.new
        bVect.x = bb.x - ba.x
        bVect.y = bb.y - ba.y

        # calculate magnitude of the vector separating the balls
        bVectMag = sqrt(bVect.x * bVect.x + bVect.y * bVect.y)
        next if bVectMag >= ba.r + bb.r
        
        # domMod change fill of balls if collision occurred
        # ba.ball_fill = rand(255)
        # bb.ball_fill = rand(255)
        ba.collision_side_effects
        bb.collision_side_effects
        
        # get angle of bVect
        theta  = atan2(bVect.y, bVect.x)
        # precalculate trig values
        sine = sin(theta)
        cosine = cos(theta)

        # bTemp will hold rotated ball positions. You just
        # need to worry about bTemp[1] position
        bTemp = [Ball.new, Ball.new]
        # bb's position is relative to ba's
        # so you can use the vector between them (bVect) as the 
        # reference point in the rotation expressions.
        # bTemp[0].x and bTemp[0].y will initialize
        # automatically to 0.0, which is what you want
        # since bb will rotate around ba
        bTemp[1].x  = cosine * bVect.x + sine * bVect.y
        bTemp[1].y  = cosine * bVect.y - sine * bVect.x

        # rotate Temporary velocities
        vTemp = [PVector.new, PVector.new]
        vTemp[0].x  = cosine * ba.vec.x + sine * ba.vec.y
        vTemp[0].y  = cosine * ba.vec.y - sine * ba.vec.x
        vTemp[1].x  = cosine * bb.vec.x + sine * bb.vec.y
        vTemp[1].y  = cosine * bb.vec.y - sine * bb.vec.x

        # Now that velocities are rotated, you can use 1D
        # conservation of momentum equations to calculate 
        # the final velocity along the x-axis.
        vFinal = [PVector.new, PVector.new]
        # final rotated velocity for ba
        vFinal[0].x = ((ba.m - bb.m) * vTemp[0].x + 2 * bb.m * 
          vTemp[1].x) / (ba.m + bb.m)
        vFinal[0].y = vTemp[0].y
        # final rotated velocity for ba
        vFinal[1].x = ((bb.m - ba.m) * vTemp[1].x + 2 * ba.m * 
          vTemp[0].x) / (ba.m + bb.m)
        vFinal[1].y = vTemp[1].y

        # hack to avoid clumping
        bTemp[0].x += vFinal[0].x
        bTemp[1].x += vFinal[1].x

        # Rotate ball positions and velocities back
        # Reverse signs in trig expressions to rotate 
        # in the opposite direction
        # rotate balls
        bFinal = [Ball.new, Ball.new]
        bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y
        bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x
        bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y
        bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x

        # update balls to screen position
        bb.x = ba.x + bFinal[1].x
        bb.y = ba.y + bFinal[1].y
        ba.x = ba.x + bFinal[0].x
        ba.y = ba.y + bFinal[0].y

        # update velocities
        ba.vec.x = cosine * vFinal[0].x - sine * vFinal[0].y
        ba.vec.y = cosine * vFinal[0].y + sine * vFinal[0].x
        bb.vec.x = cosine * vFinal[1].x - sine * vFinal[1].y
        bb.vec.y = cosine * vFinal[1].y + sine * vFinal[1].x
      end
    end

  end


  def check_boundary_collision(ball)
    if ball.x > width-ball.r
      ball.x = width-ball.r
      ball.vec.x *= -1
    elsif ball.x < ball.r
      ball.x = ball.r
      ball.vec.x *= -1
    end
    if ball.y > height-ball.r
      ball.y = height-ball.r
      ball.vec.y *= -1
    elsif ball.y < ball.r
      ball.y = ball.r
      ball.vec.y *= -1
    end
  end

end


DomSketch.new(:width => 400, :height => 400, :title => "DomSketch")
