class ColoredBall < Ball
    
    attr_accessor :rainbow_mode

    @@RAINBOW_THRESHOLD = 5 #determines how many collisions are needed for a ball to enter rainbow mode
    @@COLORS_USED = []
    
    def initialize(r = 0.0, vec = nil, x = 0.0, y = 0.0)
        super
        @rainbow_mode = false
    end
    
    def collision_side_effects
        @rainbow_mode = true if @num_collisions > @@RAINBOW_THRESHOLD
        super
    end    

    def increment_fill
        if @rainbow_mode
            new_color = [rand(255),rand(255),rand(255)]
            @ball_fill = new_color
            @@COLORS_USED << new_color unless @@COLORS_USED.include?(new_color)
        end
    end

    def self.colors_used
        @@COLORS_USED.length
    end

end