game_mode = 0
game_state = 0

mole {
  int state
  int time_elapsed
  const int index
  const int time_limit_on
  const int time_limit_off
}

moles = []
points

time


delay(10)

while 1:

	# Whack-a-mole
	if game_mode == 0:

		# Reset
		if game_state == 0:

			# reset all variables

			game_state = 1

		# Loop
		if game_state == 1:

		   	for mole in moles:
				i = mole.index

				mole.time_elapsed += time_increment


				# sensor touched
				if(sensor[i] > THRESHOLD[i]):
				
					# mole active
					if(mole.state != 0):
					    mole.state = 0
					    mole.time_elapsed = 0
				        points += GAIN

				    # mole not active
				    else:
				    	points += LOSS

				# on time limit reached
				else if mole.time_elapsed > time_limit_on:

					# mole active
					if(mole.state != 0):
						mole.state = 0
						set_led(i, mole.state)
						mole.time_limit_off = random_time()
						mole.time_elapsed = 0
					
				# off time limit reached	
			    else if mole.time_elapsed > time_limit_off:

			    	# mole not active
			    	if(mole.state == 0):
			    		mole.state = random_color()
			    		set_led(i, mole.state)
			    		mole.time_limit_on = random_time()
			    		mole.time_elapsed = 0


			if time > GAME_TIME:
				game_state = 2
			delay(10)

			if reset_switch:
				game_state = 0

	    # Done
		if game_state == 2:

			for mole in moles:
				set_led(mole.index, 0)

			if reset_switch:
				game_state = 0


			delay(10)
