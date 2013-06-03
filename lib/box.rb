# see here about the use of $app: http://www.processing.org/discourse/beta/num_1238452139.html
class Box
    attr_accessor :x, :y, :d, :my_color, :ok_to_draw, :chaste

    def initialize(options={})
        dim = options[:dim] || $CANVAS_WIDTH
        @x = rand(dim)
        @y = rand(dim)
        @d = 0
        # @my_color = some_color(@y.to_f / dim)
        @my_color = random_color
        @ok_to_draw = false
        @chaste = true
    end

    def draw
        expand
        if ok_to_draw
            if @my_color.is_a? Array
                $app.fill *@my_color
            else
                $app.fill @my_color
            end
            
            rounded_if_possible
        end
    end

    def rounded_if_possible
        threshold = 7
        if @d > threshold
            @corner_radius = rand(threshold)
            $app.rect(@x, @y, @d, @d, @corner_radius, @corner_radius, @corner_radius, @corner_radius)
        else
            $app.rect(@x, @y, @d, @d)
        end
    end
    private :rounded_if_possible

    def expand
        # assume expansion is ok
        @d += 2

        #look for obstructions around perimeter at width d
         @obstructions = 0
         
         j = (@x - @d/2 - 1).to_i
         
         while j < (@x + @d/2).to_i
             k = (@y - @d/2 - 1).to_i
             @obstructions += check_pixel(j,k)
             k = (@y+@d/2).to_i
             @obstructions += check_pixel(j,k)
             j += 1
         end

         k = (@y - @d/2 - 1).to_i

         while k < (@y + @d/2).to_i
             j = (@x - @d/2 - 1).to_i
             @obstructions += check_pixel(j,k)
             j = (@x+@d/2).to_i
             @obstructions += check_pixel(j,k)
             k += 1
         end

         if @obstructions > 0
             initialize
             # reset
             if @chaste
                 BoxFittingMod.make_new_box
                 @chaste = false
             end
         else
             @ok_to_draw = true
         end

    end

    def check_pixel(x, y)
        c = $app.get(x,y)
        ( $app.brightness(c) < 254 ) ? 1 : 0
    end

    def some_color(param)
        # pick color according to range
        BoxFittingMod.good_color[(param.to_f * BoxFittingMod.numpal).to_i]
    end
    
    private
    
    def random_color
        include_grayscale = false
        
        if include_grayscale
            (rand(100) < 25) ? rand(256) : color_from_settings
        else
            color_from_settings
        end
    end
    
    def color_from_settings
        # Settings.colors.sample.split(',')
        Settings.colors[rand(Settings.colors.length)].split(',').map! {|c| c.to_i}
    end

end
