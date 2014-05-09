class Player

  def initialize
    @direction = :forward
    @has_gone_back = false
  end

  def play_turn(warrior)
    puts @direction
    puts should_go_backwards?
    @current_health = warrior.health
    if should_rest?(warrior)
      warrior.rest!
    else
      take_action(warrior)
      @start_of_turn_health = warrior.health
    end
  end

  def under_attack?(start_of_turn_health, current_health)
    true unless start_of_turn_health <= current_health
  end

  def should_rest?(warrior)
    warrior.health < 17 and warrior.feel(@direction).empty? and not under_attack?(@start_of_turn_health, @current_health)
  end

  def take_action(warrior)
    if back_to_the_wall?(warrior)
      @has_gone_back = true
      @direction = :forward
    elsif should_go_backwards?
      @direction = :backward
    else
      @direction = :forward
    end
    do_the_right_thing(warrior)
  end

  def should_go_backwards?
    !@has_gone_back || @current_health < 8 
  end

  def do_the_right_thing(warrior)
    warrior.feel(@direction).empty? ? warrior.walk!(@direction) : attack_or_rescue(warrior)
  end

  def attack_or_rescue(warrior)
    warrior.feel(@direction).captive? ? warrior.rescue!(@direction) : warrior.attack!(@direction)
  end

  def back_to_the_wall?(warrior)
    warrior.feel(:backward).wall?
  end

end
