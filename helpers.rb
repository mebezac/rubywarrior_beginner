def take_action(warrior)
  if warrior.feel(@direction).empty?
    warrior.walk!(@direction)
    @fighting = false
  else
    attack_or_rescue(warrior)
  end
end

def should_rest?(warrior)
  warrior.health < @health_needed && !@fighting && !should_shoot_sludge?(warrior)
end

def attack_or_rescue(warrior)
 if warrior.feel(@direction).captive?
   warrior.rescue!(@direction)
   @captives_rescued += 1
 else
   warrior.attack!
   @fighting = true
 end
end

def should_go_backwards?(warrior)
  warrior.look(:backward).any? {|s| s.captive?} && !should_shoot_sludge?(warrior) || warrior.health < @health_needed && long_range_attack(warrior) && !archer_could_not_attack(warrior)
end

def long_range_attack(warrior)
  warrior.look.map {|s| s.to_s}[-1] == "Archer" || warrior.look.map {|s| s.to_s}[-2] == "Archer"
end

def should_pivot?(warrior)
  warrior.feel.wall? || clear_road(warrior.look) && warrior.look.any? { |s| s.stairs? } && @number_of_pivots == 0 && @end_level
end

def should_shoot?(warrior)
  closest_thing(warrior.look)[0].to_s == "Wizard" || should_shoot_sludge?(warrior)
end

def set_fighting(warrior)
  if warrior.look[0].empty? || warrior.look[0].wall?
    @fighting = false
  end
end

def clear_road(array_of_spaces)
  !array_of_spaces.any? {|space| space.enemy?} && !array_of_spaces.any? {|space| space.captive?}
end

def health_needed(array_of_spaces)
  closest_thing = closest_thing(array_of_spaces)[0].to_s
  if @end_level && closest_thing != "Wizard" && closest_thing != "Archer" && @captives_rescued == 0
    @health_needed = 9
  elsif clear_road(array_of_spaces) || closest_thing == "Wizard" || closest_thing == "Captive"
    @health_needed = 0
  elsif closest_thing == "Sludge"
    @health_needed = 7
  elsif closest_thing == "Thick Sludge"
    @health_needed = 16
  elsif closest_thing == "Archer"
    @long_distance_attacks = true
    @fighting = true
    @health_needed = 7 
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

def archer_could_not_attack(warrior)
  @fighting && warrior.look.map { |s| s.to_s }[1] == "Archer" 
end

def should_shoot_sludge?(warrior)
  closest_thing(warrior.look)[0].to_s == "Thick Sludge" && !archer_could_not_attack(warrior) && @direction == :forward && !@end_level || closest_thing(warrior.look)[0].to_s == "Thick Sludge" && closest_thing(warrior.look(:backward))[0].to_s == "Captive" || closest_thing(warrior.look)[0].to_s == "Sludge" && warrior.health < 3
end

def optimize_for_points(warrior)
  if !@optimization_has_run
    @optimization_has_run = true
    if warrior.look(:backward).any? { |s| s.to_s == "Archer" }
      @end_level = true
    end
  end
end
