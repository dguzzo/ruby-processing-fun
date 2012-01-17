require 'pp'

class BoxFittingMod < Processing::App

  class << self; attr_accessor :numpal, :goodcolor, :maxpal end
  @maxpal = 256
  @goodcolor = Array.new(@maxpal)
  @numpal = 8

  # @@numpal = 0
  # def self.numpal
  #   @@numpal
  # end
  # def self.numpal=(n)
  #   @@numpal = n
  # end
  
  def initialize(args) # necessary if we want Background to be an instance var (@) and not a class var (@@). more verbose this way, but done for learning purposes
    @BACKGROUND = 0
    @BACKGROUND_DARK = 0
    @BACKGROUND_LIGHT = 255
    @num = 0
    @maxnum = 1000
    @dim = 600
    @boxes = []
    super(args)
  end
  
  def setup
    frame_rate 30
    rectMode(CENTER)
    takecolor("images/test.gif")
    background(255)
    
    3.times do 
      makeNewBox()
    end
    
  end
  
  def draw
    @boxes.each do |box|
      box.draw
    end
  end
  
  def makeNewBox
    if @num < @maxnum
      pp "@dim: #{@dim}"
      @boxes[@num] = Box.new({:dim => @dim})
      @num += 1
    end
  end
  
  ## OBJECTS ---
  class Box
    attr_accessor :x, :y, :d, :myc, :okToDraw, :chaste

    def initialize(options)
      
      pp "------@numpal: #{BoxFittingMod.numpal}"
      # pp "------options: #{options[:dim]}"
      
      @x = rand(options[:dim])
      @y = rand(options[:dim])
      @d = 0
      @myc = somecolor(1.0*@y/options[:dim])
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
      d += 2
      
       # // look for obstructions around perimeter at width d
       #  int obstructions = 0;
       #  for (int j=int(x-d/2-1);j<int(x+d/2);j++) {
       #    int k=int(y-d/2-1);
       #    obstructions += checkPixel(j,k);
       #    k=int(y+d/2);
       #    obstructions += checkPixel(j,k);
       #  }      
       #  for (int k=int(y-d/2-1);k<int(y+d/2);k++) {
       #    int j=int(x-d/2-1);
       #    obstructions += checkPixel(j,k);
       #    j=int(x+d/2);
       #    obstructions += checkPixel(j,k);
       #  }      
       # 
       #  if (obstructions>0) {
       #    // reset
       #    selfinit();    
       #    if (chaste) {
       #      makeNewBox();
       #      chaste = false;
       #    }
       #  } else {
       #    okToDraw = true;
       #  }
      
    end
    
    def checkPixel(x, y)
      c = get(x,y)
      if brightness(c) < 254
        return 1
      else
        return 0
      end
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
