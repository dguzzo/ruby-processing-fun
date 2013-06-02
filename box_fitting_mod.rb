require 'pp'

class BoxFittingMod < Processing::App

    @@BACKGROUND = 0
    @@BACKGROUND_DARK = 0
    @@BACKGROUND_LIGHT = 255
    @@num = 0
    @@maxnum = 1000
    @@dim = 600
    @@boxes = []

    # unfortunately necessary to do this manuallyf or class variables accessible outside the class itself. if i could easily load active_support via
    # jruby, then i could use :cattr_accessor and this would define the getters/setters automatically, but I keep running into issues with gem
    # dependencies. a stack overflow answer said that doing it manually was a workable alternative.
    
    def self.numpal
        @@numpal
    end

    def self.numpal=(n)
        @@numpal = n
    end

    def self.maxpal
        @@maxpal
    end

    def self.goodcolor
        @@goodcolor
    end

    def initialize(args)
        @@numpal = 0
        @@maxpal = 256
        @@goodcolor = Array.new(@@maxpal)
        super(args)
    end

    def setup
        frame_rate 30
        rectMode(CENTER)
        takecolor("images/test.gif")
        background(255)
        
        3.times do 
            BoxFittingMod.makeNewBox
        end
    end

    def draw
        @@boxes.each do |box|
            box.draw
        end
    end

    def self.makeNewBox
        if @@num < @@maxnum
            pp "@dim: #{@@dim}"
            @@boxes[@@num] = Box.new({:dim => @@dim})
            @@num += 1
        end
    end

    ## OBJECTS ---
    class Box
        attr_accessor :x, :y, :d, :myc, :okToDraw, :chaste

        def initialize(options={})

            pp "------@numpal: #{BoxFittingMod.numpal}"
            # pp "------options: #{options[:dim]}"
            dim = options[:dim] || 600
            @x = rand(dim)
            @y = rand(dim)
            @d = 0
            @myc = somecolor(1.0*@y/dim)
            @okToDraw = false
            @chaste = true
        end

        def draw
            expand
            if okToDraw
                fill myc
                rect(x,y,d,d)
            end
        end

        def expand
            # assume expansion is ok
            @d += 2

            #look for obstructions around perimeter at width d
             @obstructions = 0
             
             j = (@x - @d/2 - 1).to_i
             
             while j < (@x + @d/2).to_i
                 k = (@y - @d/2 - 1).to_i
                 @obstructions += checkPixel(j,k)
                 k = (@y+@d/2).to_i
                 @obstructions += checkPixel(j,k)
                 j += 1
             end

             k = (@y - @d/2 - 1).to_i

             while k < (@y + @d/2).to_i
                 j = (@x - @d/2 - 1).to_i
                 @obstructions += checkPixel(j,k)
                 j = (@x+@d/2).to_i
                 @obstructions += checkPixel(j,k)
                 k += 1
             end

             if @obstructions > 0
                 initialize
                 # reset
                 if @chaste
                     BoxFittingMod.makeNewBox
                     @chaste = false
                 end
             else
                 @okToDraw = true
             end

        end

        def checkPixel(x, y)
            c = get(x,y)
            ( brightness(c) < 254 ) ? 1 : 0
        end

        def somecolor(p)
            pp "somecolor, p= #{p}"
            # pick color according to range
            BoxFittingMod.goodcolor[(p.to_f*BoxFittingMod.numpal).to_i];
        end

    end


    def takecolor(fn)

        pp '------ takecolor()'

        # PImage b
        b = loadImage(fn)
        image(b,0,0)

        b.width.times do |itemW|
            b.height.times do |itemH|
                c = get(x,y)
                exists = false

                p BoxFittingMod
                BoxFittingMod.numpal.times do |n|
                    if c == BoxFittingMod.goodcolor[n]
                        exists = true
                        break
                    end
                end

                unless exists
                    # add color to pal
                    if BoxFittingMod.numpal < BoxFittingMod.maxpal
                        BoxFittingMod.goodcolor[BoxFittingMod.numpal] = c
                        BoxFittingMod.numpal += 1
                    else
                        break
                    end
                end

            end
        end

    end

end

BoxFittingMod.new(:width => 400, :height => 400, :title => "BoxFittingMod")
puts BoxFittingMod.numpal
