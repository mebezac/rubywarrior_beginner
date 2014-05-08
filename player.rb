class Player

  def play_turn(warrior)
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
    warrior.health < 15 and warrior.feel.empty? and not under_attack?(@start_of_turn_health, @current_health)
  end

  def take_action(warrior)
    warrior.feel.empty? ? warrior.walk! : attack_or_rescue(warrior)
  end

  def attack_or_rescue(warrior)
    warrior.feel.captive? ? warrior.rescue! : warrior.attack!
  end

end
