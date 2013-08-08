require 'pp'

$CANVAS_WIDTH = 1200
$CANVAS_HEIGHT = 400

class ImageSketch < Processing::App

    FRAME_RATE = 30
    
    def initialize(args)
        super(args)
    end

    def setup
        frame_rate FRAME_RATE
        rectMode(CENTER)
        
        background(255)
        @frames = 0
        @images = load_source_images
        @image = load_image
    end

    def draw
        if @frames.zero?
            #background(255) 
            @image = load_image
        end
        
        @frames = (@frames > 4 * FRAME_RATE) ? 0 : @frames + 1
        
        30.times do |index|
            transparentize_image
            image(@image, 0 + index * rand($CANVAS_WIDTH), 0 + index * rand($CANVAS_HEIGHT))
        end
    end

    private

    def transparentize_image
        tint(255, rand(256))
    end

    def load_image
        # loaded_image = loadImage(IMAGES.sample) # can't use .sample with this version of jRuby. argh.
        loaded_image = loadImage(@images[rand(@images.size)])
    end

    def load_source_images
        %w(images/warm_red.png images/green.png images/purple.png)
    end

    def color_from_image(filename)
        loaded_image = loadImage(filename)
        image(loaded_image, 0, 0)
        pixel_value = get(0, 0)
        pixel_value
    end
    
end

ImageSketch.new(:width => $CANVAS_WIDTH, :height => $CANVAS_HEIGHT, :title => "ImageSketch")
