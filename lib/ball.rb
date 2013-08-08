class Ball
    attr_accessor :x, :y, :r, :m, :vec, :ball_fill, :num_collisions

    @@MIN_FILL = 90
    @@INCREMENT_FILL_VAL = 5
    @@GRAYS_USED = []
    BRIGHTNESS_THRESHOLD_LOW = 200

    def initialize(r = 0.0, vec = nil, x = 0.0, y = 0.0)
        @x, @y, @r = x, y, r
        @m = r * 0.1
        @vec = vec
        @ball_fill = rand(255)
        @num_collisions = 0
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
        increment_fill
    end

    # increment the fill value of the ball
    def increment_fill
        begin
            # increment the fill value. reset value to a certain minimum if it goes over the max gray value.
            @ball_fill = ((@ball_fill += @@INCREMENT_FILL_VAL) > 255 ) ? @@MIN_FILL : @ball_fill += @@INCREMENT_FILL_VAL
            @@GRAYS_USED << @ball_fill unless @@GRAYS_USED.include?(@ball_fill)
        rescue => e
            puts "error in increment_fill: #{e.message}"
        end
    end

    # returns true if the ball's fill color is above a certain, arbitrary threshold for brightness value.
    # basically an excuse to use the .between? method as a learning experience
    def is_bright_color?
        begin
            if @ball_fill.is_a? Array
                # puts "#{@ball_fill[0]} #{@ball_fill[1]} #{@ball_fill[2]}"
                return @ball_fill[0].between?(BRIGHTNESS_THRESHOLD_LOW,255) || @ball_fill[1].between?(BRIGHTNESS_THRESHOLD_LOW,255) || @ball_fill[2].between?(BRIGHTNESS_THRESHOLD_LOW,255)
            else
                return @ball_fill.between?(BRIGHTNESS_THRESHOLD_LOW,255)
            end
        rescue => e
            puts "error in is_bright_color? #{e.message}"
            false
        end
    end

end
