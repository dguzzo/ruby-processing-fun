require 'pp'
require 'lib/box'

$CANVAS_WIDTH = 1200

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

    def self.max_pal
        @@max_pal
    end

    def self.good_color
        @@good_color
    end

    def initialize(args)
        @@numpal = 0
        @@max_pal = 256
        @@good_color = Array.new(@@max_pal)
        super(args)
    end

    def setup
        frame_rate 30
        rectMode(CENTER)
        take_color("images/test.gif")
        background(255)
        
        3.times do 
            BoxFittingMod.make_new_box
        end
    end

    def draw
        @@boxes.each do |box|
            box.draw
        end
    end

    def self.make_new_box
        if @@num < @@maxnum
            @@boxes[@@num] = Box.new({:dim => @@dim})
            @@num += 1
        end
    end

    def take_color(fn)
        # PImage b
        b = loadImage(fn)
        image(b,0,0)

        b.width.times do |itemW|
            b.height.times do |itemH|
                c = get(x,y)
                exists = false

                BoxFittingMod.numpal.times do |n|
                    if c == BoxFittingMod.good_color[n]
                        exists = true
                        break
                    end
                end

                unless exists
                    # add color to pal
                    if BoxFittingMod.numpal < BoxFittingMod.max_pal
                        BoxFittingMod.good_color[BoxFittingMod.numpal] = c
                        BoxFittingMod.numpal += 1
                    else
                        break
                    end
                end

            end
        end

    end

end

BoxFittingMod.new(:width => $CANVAS_WIDTH, :height => 400, :title => "BoxFittingMod")
