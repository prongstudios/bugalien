#!/usr/bin/env ruby
require 'chingu'
include Gosu

class Game < Chingu::Window
  def initialize
    super
    self.factor = 6
    self.input = { :escape => :exit }
    self.caption = "bugalien: the experience"
    Bug.create(:x => $window.width/2, :y => $window.height/2)
  end
end

class Bug < Chingu::GameObject
  traits :timer
  attr_accessor :biting, :bite_sound

  def initialize(options = {})
    super

    self.input = {[:holding_left] => :holding_left,
                  [:holding_right] => :holding_right,
                  [:holding_up] => :holding_up,
                  [:holding_down] => :holding_down,
                   :holding_space => :bite }
    self.factor = 1

    @animation = Chingu::Animation.new(:file => "spritesheet-bite-n-walk.png", :size => 300, :delay => 100)
    @animation.frame_names = { :bitey => 1..2, :walking => 0..1, :walkbite => 3..4, :idle => 0..0, :idle_open => 2..2 }
    @bite_file = Sample["chomp.wav"]
    @bite_sound = @bite_file.play(1,1,true)

    @frame_name = :walking

    @last_x, @last_y = @x, @y
    update
  end

  def bite
    @biting = true
    unless @bite_sound.playing?
      @bite_sound = @bite_file.play(1,1,true)
    end
  end




  def holding_left
    @x -= 2
    if @biting
      @frame_name = :walkbite
    else
      @frame_name = :walking
    end

  end

  def holding_right
    @x += 2
    if @biting
      @frame_name = :walkbite
    else
      @frame_name = :walking
    end
  end
  
  def holding_up
    @y -= 2
    if @biting
      @frame_name = :walkbite
    else
      @frame_name = :walking
    end
  end

  def holding_down
    @y += 2
    if @biting
      @frame_name = :walkbite
    else
      @frame_name = :walking
    end
  end

  def update
    
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation[@frame_name].next
    if @x == @last_x && @y == @last_y
      if @biting
        @frame_name = :bitey
      else
        @frame_name = :idle 
      end
    end
    
    # @x, @y = @last_x, @last_y if outside_window?
    @last_x, @last_y = @x, @y


    unless $window.button_down? Gosu::KbSpace
      @biting = false
      @bite_sound.stop
    end
  end




end

Game.new.show

