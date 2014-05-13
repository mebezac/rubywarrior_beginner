require 'helpers'

class Player

  def initialize
    @health_needed = 0
    @fighting = false
    @direction = :forward
    @number_of_pivots = 0
    @optimization_has_run = false
    @end_level = false
    @captives_rescued = 0
  end

  def play_turn(warrior)
    health_needed(warrior.look)
    set_fighting(warrior)
    optimize_for_points(warrior)
    if should_rest?(warrior)
      warrior.rest!
    elsif should_go_backwards?(warrior)
      @direction = :backward
      take_action(warrior)
    elsif should_pivot?(warrior)
      warrior.pivot!
      @number_of_pivots += 1
    elsif should_shoot?(warrior)
      warrior.shoot!
    else
      @direction = :forward
      take_action(warrior)
    end
  end
end
