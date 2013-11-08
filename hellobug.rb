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

  def initialize(options = {})
    super

    self.input = [:holding_left, :holding_right, :holding_up, :holding_down]
    self.factor = 1.5

    @animation = Chingu::Animation.new(:file => "spritesheet.png", :size => 300, :delay => 100)
    @animation.frame_names = { :bitey => 0..1}

    @frame_name = :bitey

    @last_x, @last_y = @x, @y
    update
  end

  def holding_left
    @x -= 2

  end

  def holding_right
    @x += 2

  end
  
  def holding_up
    @y -= 2

  end

  def holding_down
    @y += 2

  end

  def update
    
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation[@frame_name].next

    @frame_name = :bitey if @x == @last_x && @y == @last_y
    
    # @x, @y = @last_x, @last_y if outside_window?
    @last_x, @last_y = @x, @y                    
  end
end

Game.new.show

