class Player
  def play_turn(warrior)
    if warrior.health < 15 and warrior.feel.empty?
      warrior.rest!
    else
      warrior.feel.empty? ? warrior.walk! : warrior.attack!
    end
  end
end
