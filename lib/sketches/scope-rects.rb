# Uses the "bare" style, where a Processing::App sketch is implicitly wrapped

def setup
  size 500, 500
  frame_rate(10)
end

def draw
  draw_whites
  draw_blacks
  draw_greys('chaotic')
end

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
