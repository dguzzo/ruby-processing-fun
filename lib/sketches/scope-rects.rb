# The MIT License
# 
# Copyright (c) 2014 Dominick Guzzo
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Uses the "bare" style, where a Processing::App sketch is implicitly wrapped

def setup
  size(500, 500)
  frame_rate(10)
end

def draw
  drawer = RectDrawer.new
  drawer.draw_whites
  drawer.draw_blacks
  drawer.draw_greys('chaotic')
end

class RectDrawer
  def draw_whites(style = nil)
    fill(255)
    stroke(0)

    draw_rects(style)
  end

  def draw_blacks(style = nil)
    fill(0)
    stroke(255)

    pushMatrix()
    translate(100, 100)
    draw_rects(style)
    popMatrix()
  end

  def draw_greys(style)
    fill(100)
    stroke(0)

    pushMatrix()
    translate(300, 300)
    draw_rects(style)
    popMatrix()
  end
  
  private
  def draw_rects(style)
    10.times do
      if style == 'chaotic'
        rect(balanced_offset, balanced_offset, 50 + balanced_offset , 50 + balanced_offset)
      else
        offset =  non_negative_offset
        rect(offset, offset, 50 + offset , 50 + offset)
      end
    end
  end
  
  def balanced_offset
    (-50..50).to_a.sample
  end

  def non_negative_offset
    random(100)
  end
  
end
