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
  attr_accessor :biting

  def initialize(options = {})
    super

    self.input = {[:holding_left] => :holding_left,
                  [:holding_right] => :holding_right,
                  [:holding_up] => :holding_up,
                  [:holding_down] => :holding_down,
                   :holding_space => :bite }
    self.factor = 1

    @animation = Chingu::Animation.new(:file => "spritesheet-bite-n-walk.png", :size => 300, :delay => 100)
    @animation.frame_names = { :bitey => 0..1, :walking => 0..1, :walkbite => 1..2, :idle => 2..3 }

    @frame_name = :walking

    @last_x, @last_y = @x, @y
    update
  end

  def bite
    @biting = true
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
    @frame_name = :walking
  end

  def holding_down
    @y += 2
    @frame_name = :walking
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
    @biting=false
  end
end

Game.new.show

