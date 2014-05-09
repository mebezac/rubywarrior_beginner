class Player

  def initialize
    @direction = :forward
    @has_gone_back = false
  end

  def play_turn(warrior)
    @current_health = warrior.health
    if should_rest?(warrior)
      warrior.rest!
    else
      what_to_do?(warrior, warrior.look)
      @start_of_turn_health = warrior.health
    end
  end

  def under_attack?(start_of_turn_health, current_health)
    true unless start_of_turn_health <= current_health
  end

  def should_rest?(warrior)
    warrior.health < 17 and !under_attack?(@start_of_turn_health, @current_health)
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

  def should_pivot?(warrior)
    warrior.feel(@direction).wall?
  end

  def do_the_right_thing(warrior)
    if warrior.feel.wall?
      warrior.pivot!
    elsif warrior.feel(@direction).empty?
      warrior.walk!(@direction)
    else
      attack_or_rescue(warrior)
    end
  end

  def closest_thing(array_of_spaces)
    array_of_spaces.each do |space|
      unless space.empty?
        return [space]
        break
      end
    end
  end

  def enemy_is_closest?(array_of_spaces)
    closest_thing(array_of_spaces).any? {|space| space.enemy?}
  end

  def what_to_do?(warrior, array_of_spaces)
    right_in_front = array_of_spaces[0]
    if right_in_front.captive?
      warrior.rescue!(@direction)
    elsif right_in_front.empty? && !enemy_is_closest?(array_of_spaces)
      warrior.walk!(@direction)
    elsif enemy_is_closest?(array_of_spaces)
      warrior.shoot!
    end
  end

  def attack_or_rescue(warrior)
    warrior.feel(@direction).captive? ? warrior.rescue!(@direction) : warrior.attack!(@direction)
  end

  def back_to_the_wall?(warrior)
    warrior.feel(:backward).wall?
  end

end
