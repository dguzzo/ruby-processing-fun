require 'pp'
require 'yaml'
require 'vendor/deep_symbolize'
require 'vendor/settings'
require 'lib/box'

Settings.load!("config/settings.yml")

$CANVAS_WIDTH = 1200
$CANVAS_HEIGHT = 400

class BoxFittingMod < Processing::App
    @@num_boxes = 0
    @@max_boxes = 1000
    @@boxes = []

    # unfortunately necessary to do this manually or class variables accessible outside the class itself. if i could easily load active_support via
    # jruby, then i could use :cattr_accessor and this would define the getters/setters automatically, but I keep running into issues with gem
    # dependencies. a stack overflow answer said that doing it manually was a workable alternative.
    
    def self.num_pal
        @@num_pal
    end

    def self.num_pal=(n)
        @@num_pal = n
    end

    def self.max_pal
        @@max_pal
    end

    def self.good_color
        @@good_color
    end

    def initialize(args)
        @@num_pal = 0
        @@max_pal = 256
        @@good_color = Array.new(@@max_pal)
        super(args)
    end

    def setup
        frame_rate 30
        rectMode(CENTER)
        # take_color("images/test.gif")
        background(255)
        
        3.times { BoxFittingMod.make_new_box }
    end

    def draw
        @@boxes.each { |box| box.draw }
    end

    def self.make_new_box
        if @@num_boxes < @@max_boxes
            @@boxes[@@num_boxes] = Box.new({:dim => 600})
            @@num_boxes += 1
        end
    end
    
    private
    def take_color(filename)
        loaded_image = loadImage(filename)
        image(loaded_image, 0, 0)

        loaded_image.width.times do |itemW|
            loaded_image.height.times do |itemH|
                pixel_value = get(x,y)
                exists = false

                BoxFittingMod.num_pal.times do |n|
                    if pixel_value == BoxFittingMod.good_color[n]
                        exists = true
                        break
                    end
                end

                unless exists
                    break if BoxFittingMod.num_pal >= BoxFittingMod.max_pal
                    # add color to pal
                    BoxFittingMod.good_color[BoxFittingMod.num_pal] = pixel_value
                    BoxFittingMod.num_pal += 1
                end
            end
        end
    end

end

BoxFittingMod.new(:width => $CANVAS_WIDTH, :height => $CANVAS_HEIGHT, :title => "BoxFittingMod")
