extends Node

@onready var current_step : int = 0

@onready var discover_serynge : bool = false
@onready var examine_monster_first_time : bool = false
@onready var examine_monster_alarm : bool = false
@onready var internal_bleeding : bool = false
@onready var power_back : bool = false

var dialogue : Array = [
	{
	"text" : "Hi doc, Here's your office, Your job here is to watch out for the monster, you don't want him to get to you. (Space to continue)",
	"condition" : TutorialCondition.Condition.None,
	},
	{
	"text" : "Keep it cryo, you need to check it temperature and fluid, to do that let's grab a syringe first",
	"condition" : TutorialCondition.Condition.DiscoverSyringe,
	},
	{
	"text": "Nice ! Now, let's pay a visit to our big ahh monster, and interact on it with your syringe",
	"condition": TutorialCondition.Condition.ExamineMonsterForTheFirstTime
	},
	{
	"text": "All done, go back to the desk and let's see what happened (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "As you can see, the cube turn yellow, it's a good sign, you can go back chillinfor a bit ! (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "If it's black, holy shit you have bad luck, test didn't get  successfull, you need to retry (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Mhh, yeah if it turn blue, you need to hold the red button in your office, and rise the temperature a bit, don't over heat, so dose it ! (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Well, red is the same story, but you need to deal with the fluid pump near your office this time ! (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Ok, now i'll show you something important, get the syringe and go examine the monster !",
	"condition": TutorialCondition.Condition.ExamineMonsteForAlarm
	},
	{
	"text": "Sometimes the more you do exams on him, he can do aninternal bleedin ! (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "So, if that happend to you, you need to get a pill and give him, ASAP ! After giving him the pill, you can check for the heat and fluid, friend tip",
	"condition": TutorialCondition.Condition.InternalBleeding
	},
	{
	"text": "Fuck that sound was loud bruh, I hope you understand, the more you use the syringe higher the chance of internal bleeding, but when it happens, it also reset the counter ! (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Oh, it is pretty dark in here, innit ? Press F to toggle the flashlight if you're scared of the darkness (Space to continue)",
	"condition": TutorialCondition.Condition.None,
	"action": Callable(self, "_give_flashlight")
	},
	{
	"text": "Obviously when the power goes off nothing work, so your main goal is to turn it on ! (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Go turn on this bad boy",
	"condition": TutorialCondition.Condition.PowerBack
	},
	{
	"text": "Ok now when he's back on track, you also need to check again the temp and fluid with the syringe because when everything's off, nothing works, right ? (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Oh, I forgot, give him pills only when he's in internal bleeding, I repeat, give him pills only when he's in internal bleeding ! (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "Before, I go, about the fluid pump and the heat button, you need to hold E to interact with them. There are two sound you need to be aware of. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "There is a sound that indicate that everything's good, and tells you two things, one you dosed correclty, second, next interaction might be the sound, ill tell you just in a second. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "If you hear the \"bad sound\" it means you didn't dosed the temp or the fluid correctly, the machine breaks and you need to wait at least 10 seconds before you can use it again. (Space to continue)",
	"condition": TutorialCondition.Condition.None
	},
	{
	"text": "All right, that's it, Now you can go back to the desk and press the orange button, to start the game !",
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
