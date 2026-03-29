extends Node

@onready var current_step : int = 0

@onready var discover_serynge : bool = false
@onready var examine_monster_first_time : bool = false
@onready var examine_monster_alarm : bool = false
@onready var internal_bleeding : bool = false
@onready var power_back : bool = false

var dialogue : Array = [
	{
	"text" : "Hello you! The dev speaking! We just received a new creature from the lab. It needs to be examined, so we’ll need your help... (Space to continue)",
	"condition" : TutorialCondition.Condition.None,
	},
	{
	"text" : "Alright, let me explain what you need to do. Your job is to monitor the entity's temperature. As you can see, it’s cryogenized. Keep in mind, the temperature depends on the cryo-fluid... (Space to continue)",
	"condition" : TutorialCondition.Condition.None,
	},
	{
	"text" : "So, how do you check the temperature or the fluid? You’ll need a syringe. Go grab one, it should be on the desk outside the office!",
	"condition" : TutorialCondition.Condition.DiscoverSyringe,
	},
	{
	"text": "Nice! Now let’s examine the monster. With the syringe in your hand, interact with it. [\"Press E to interact with the monster\"]",
	"condition": TutorialCondition.Condition.ExamineMonsterForTheFirstTime
	},
	{
	"text": "Good job! Now go back to the desk where you picked up the syringe... (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "You might have noticed a cube near the syringe spot... (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "When the cube turns yellow, it means something’s wrong. Temperature rising, or fluid running low. Either way, it’s a warning. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "But if it turns black, that means the test failed. You’ll need to retry until you get a different result... (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "If it turns blue, that’s where things start getting serious. It means the temperature is too low, and you’ll need to cool it down properly. I’ll show you how in a moment... (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "If it turns red, same idea, but this time it’s the fluid. You’ll need to refill it using the pump near your desk. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Now, something important. It’s better if I show you. Take the syringe again and examine the monster one more time. [\"Press E to interact\"]",
	"condition": TutorialCondition.Condition.ExamineMonsteForAlarm
	},
	{
	"text": "Hear that loud noise? That’s the alarm. It means the monster is suffering from internal bleeding. You’ll need a pill to stop it. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Don’t worry, it’s just the tutorial for now. But when it happens, grab the pill from the desk near the syringe and use it. [\"Press E to interact\"]",
	"condition": TutorialCondition.Condition.InternalBleeding
	},
	{
	"text": "Pretty loud, right? Every test increases the chance of causing internal bleeding. Once you fix it, the risk goes back down… but never to zero. It can happen anytime. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "That’s why failed tests are dangerous. Use the syringe wisely... (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Oh... that’s unfortunate. The power just went out. Luckily, we left you a flashlight. You might need it. [\"Press F to toggle flashlight\"] (Space to continue)",
	"condition": TutorialCondition.Condition.None,
	"action": Callable(self, "_give_flashlight")
	},
	{
	"text": "Yeah... not the best lab, we know. If the power goes out, you’ll need to restart the generator. It should be somewhere near the monster. [\"Hold E on the generator\"]",
	"condition": TutorialCondition.Condition.PowerBack
	},
	{
	"text": "One more thing. The temperature system and fluid pump both depend on the generator. If it’s off, things will get worse quickly... (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Oh, right, the pills. Only use them if there’s internal bleeding. Otherwise, they’re useless… and we’re not sure how the creature will react. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Before I let you go, here’s the basics. If the temperature is off, use the red button in the office. If the fluid is low, use the pump near the doorway. [\"Hold E to interact\"] (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "You’ll hear two types of sounds when interacting. A good one, and a bad one. The good sound means you did it right. The bad one… not so much. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "If you hear the bad sound, the system locks for a few seconds. It’s a safety measure. You pushed it too far. It will also make the situation worse over time... (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Alright, that’s a lot, I know. You’ll get used to it. Your goal is simple: survive 6 minutes… until 6 AM. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Before you start, press the orange button in the office. And hey… if you enjoy the game, or have feedback, let me know. Good luck. [\"Hold the orange button to start\"]",
	"condition": TutorialCondition.Condition.None
	}
]

func _give_flashlight() -> void:
	AllSignals.emit_signal("generator_state", true)

func _check_condition(condition: TutorialCondition.Condition) -> bool:
	match condition:
		TutorialCondition.Condition.None:
			return true
		TutorialCondition.Condition.DiscoverSyringe:
			return discover_serynge
		TutorialCondition.Condition.ExamineMonsterForTheFirstTime:
			return examine_monster_first_time
		TutorialCondition.Condition.ExamineMonsteForAlarm:
			return examine_monster_alarm
		TutorialCondition.Condition.InternalBleeding:
			return internal_bleeding
		TutorialCondition.Condition.PowerBack:
			return power_back
		_:
			return false

func show_dialogue() -> void:
	AllSignals.emit_signal("send_dialogue", dialogue[current_step]["text"])

func _ready() -> void:
	show_dialogue()
	AllSignals.step_complete.connect(_on_step_complete)

func _on_step_complete(condition: TutorialCondition.Condition) -> void:
	match condition:
		TutorialCondition.Condition.DiscoverSyringe:
			if discover_serynge: return
			discover_serynge = true
			_next_dialogue()
		TutorialCondition.Condition.ExamineMonsterForTheFirstTime:
			if examine_monster_first_time: return
			examine_monster_first_time = true
			_next_dialogue()
		TutorialCondition.Condition.ExamineMonsteForAlarm:
			if examine_monster_alarm: return
			examine_monster_alarm = true
			_next_dialogue()
		TutorialCondition.Condition.InternalBleeding:
			if internal_bleeding: return
			internal_bleeding = true
			_next_dialogue()
		TutorialCondition.Condition.PowerBack:
			if power_back: return
			power_back = true
			_next_dialogue()
func _next_dialogue() -> void:
	if current_step >= dialogue.size(): return
	if _check_condition(dialogue[current_step]["condition"]):
		current_step += 1
		if current_step >= dialogue.size(): return
		if dialogue[current_step].has("action"):
			dialogue[current_step]["action"].call()
		print(current_step)
		show_dialogue()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_next_dialogue()
