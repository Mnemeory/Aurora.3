/*#######################
	Academic Fields
#######################*/

/singleton/education/research
	name = "Research & Development"
	description_body = "Your specialization is in scientific research and development. This may range from Firearms Engineering to Bluespace Engineering or even Aerospace Engineering. Space is the limit for your research."
	primary_skill = /singleton/skill/research
	secondary_skills = list(
		/singleton/skill/mechanical_engineering,
		/singleton/skill/pharmacology,
		/singleton/skill/anatomy,
	)

/singleton/education/robotics
	name = "Robotics"
	description_body = "Your specialization is in building and repairing IPCs and other smaller robots, though you are also capable of building exoskeletons and mechs. You're proficient with some fundamental engineering skills, though you prefer the theoretical aspect and robots in general."
	primary_skill = /singleton/skill/robotics
	secondary_skills = list(
		/singleton/skill/research,
		/singleton/skill/electrical_engineering,
		/singleton/skill/mechanical_engineering,
	)

/singleton/education/mechatronics
	name = "Mechatronics"
	description_body = "Your specialization is with building large human-sized exoskeletons and mechs, though you've also learnt how to repair IPCs and simpler robots as well. You're more proficient with the mechanical aspects of engineering."
	primary_skill = /singleton/skill/mechanical_engineering
	secondary_skills = list(
		/singleton/skill/research,
		/singleton/skill/electrical_engineering,
		/singleton/skill/robotics,
	)

/singleton/education/xenobotany
	name = "Xenobotany"
	description_body = "Your specialization is with discovering, sequencing, and creating alien flora... though you can also grow some potatoes in your spare time."
	primary_skill = /singleton/skill/xenobotany
	secondary_skills = list(
		/singleton/skill/research,
		/singleton/skill/gardening,
		/singleton/skill/pharmacology,
	)

/singleton/education/xenobiology
	name = "Xenobiology"
	description_body = "Your specialization is with discovering and cataloguing alien animals."
	primary_skill = /singleton/skill/xenobiology
	secondary_skills = list(
		/singleton/skill/research,
		/singleton/skill/surgery,
		/singleton/skill/anatomy,
		/singleton/skill/pharmacology,
	)
