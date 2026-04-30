/singleton/education_field/mechanical_engineering
	name = "Mechanical Engineering"
	description_body = "You specialize in constructing structural systems, lathing, and the more manual pleasures of engineering, such as welding and wrenching."
	primary_skill = /singleton/skill/mechanical_engineering
	secondary_skills = list(
		/singleton/skill/electrical_engineering,
		/singleton/skill/atmospherics_systems,
		/singleton/skill/reactor_systems,
	)

/singleton/education_field/electrical_engineering
	name = "Electrical Engineering"
	description_body = "You specialize in variable-voltage cabling, grid management, electronic hardware, and other electrical systems."
	primary_skill = /singleton/skill/electrical_engineering
	secondary_skills = list(
		/singleton/skill/mechanical_engineering,
		/singleton/skill/atmospherics_systems,
		/singleton/skill/reactor_systems,
	)

/singleton/education_field/atmospherics
	name = "Atmospherics Systems"
	description_body = "You specialize in everything to do with atmospherics systems, whether that's the delivery of gases, usage of atmospherics machines, or simply how to use a pipe wrench."
	primary_skill = /singleton/skill/atmospherics_systems
	secondary_skills = list(
		/singleton/skill/mechanical_engineering,
		/singleton/skill/electrical_engineering,
		/singleton/skill/reactor_systems,
	)

/singleton/education_field/reactor_systems
	name = "Reactor Systems"
	description_body = "You specialize in everything to do with a reactor's systems, whether you are looking at a Supermatter crystal, a fusion reactor, or a combustion chamber."
	primary_skill = /singleton/skill/reactor_systems
	secondary_skills = list(
		/singleton/skill/mechanical_engineering,
		/singleton/skill/electrical_engineering,
		/singleton/skill/atmospherics_systems,
	)

/singleton/education_background/engineering_certification
	name = "Engineering Certification"
	description = "You may not have an Engineering degree or a specialized background, but you had enough fundamental experience for the Conglomerate to validate it instead \
		of a degree. You do not have the same specialization as your fellow Engineers with a degree, making up for it by being a jack of all trades. \
		You could probably fix a car, whereas they might not be able to."
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60,
	)
	skills = list(
		/singleton/skill/mechanical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/electrical_engineering = SKILL_LEVEL_TRAINED,
		/singleton/skill/atmospherics_systems = SKILL_LEVEL_TRAINED,
		/singleton/skill/reactor_systems = SKILL_LEVEL_TRAINED,
	)
