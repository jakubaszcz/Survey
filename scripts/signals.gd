extends Node

signal jumpscare(player : Node3D)
signal temperature(temperature : float)
signal fluid(fluid: float)
signal rise_temperature(temperature : float)
signal rise_fluid(fluid : int)
signal generator_state(test: bool)
signal internal_bleeding(state : bool)
signal examine(type: ExamineType.type)
signal timer(time : int)
signal action_error()
signal action_success()
signal game_over(type: GameOverType.Type)
signal heat_start
signal heat_end
signal cooling_start
signal cooling_end
signal end_tutorial
