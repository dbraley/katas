class Player

  def play_turn(warrior)
  	if warrior.feel.wall?
  		warrior.pivot!
  		@found_back_wall = true
  	elsif @found_back_wall.nil?
  		if warrior.feel(:backward).wall?
  			@found_back_wall=true
  		elsif warrior.feel(:backward).captive?
  			warrior.rescue! :backward
  		else
  			warrior.walk! :backward
  		end

  	elsif warrior.feel.captive?
  		warrior.rescue!
  	elsif warrior.feel.enemy?
  		warrior.attack!
  	elsif !@latent_health.nil?
		if warrior.health < @latent_health
			if warrior.health < 13 
				warrior.walk! :backward
			else
				warrior.walk! :forward
			end
  		else
  			warrior.health < 20 ? warrior.rest! : warrior.walk!
    	end
    else
    	warrior.walk!
	end
    @latent_health = warrior.health
  end
end
