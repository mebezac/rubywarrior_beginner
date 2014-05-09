class Player

  def initialize
    @direction = :forward
    @number_of_pivots = 0
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
    warrior.health < 17 && !under_attack?(@start_of_turn_health, @current_health) && closest_thing(warrior.look)[0].to_s != "Wizard" && warrior.look.any? {|space| space.enemy?}
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

  def walk_and_attack_or_rescue_or_shoot(warrior)
    if closest_thing(warrior.look)[0].to_s != "Wizard"
      walk_and_attack_or_rescue(warrior)
    else
      warrior.shoot!
    end
  end

  def walk_and_attack_or_rescue(warrior)
    warrior.feel.empty? ? warrior.walk! : attack_or_rescue(warrior)
  end

  def attack_or_rescue(warrior)
    warrior.feel.captive? ? warrior.rescue! : warrior.attack!
  end

  def what_to_do?(warrior, array_of_spaces)
    right_in_front = array_of_spaces[0]
    if should_pivot?(warrior)
      @number_of_pivots += 1
      warrior.pivot!
    else
      walk_and_attack_or_rescue_or_shoot(warrior)
    end
  end

  def should_pivot?(warrior)
    if closest_thing(warrior.look)[0].to_s == "Archer"
      false
    elsif closest_thing(warrior.look(:backward))[0].to_s == "Archer"
      true
    elsif warrior.look.any? {|space| space.wall?} && @number_of_pivots <= 2 && !warrior.look.any? {|space| space.captive?}
      true
    else
      false
    end
  end
end
