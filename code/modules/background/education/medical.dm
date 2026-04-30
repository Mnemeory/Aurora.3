/singleton/education_field/medicine
	name = "Medicine"
	description_body = "You specialize in the diagnosis, treatment, and management of illnesses and injuries in organic humanoids."
	primary_skill = /singleton/skill/medicine
	secondary_skills = list(
		/singleton/skill/surgery,
		/singleton/skill/anatomy,
	)

/singleton/education_field/pharmacology
	name = "Pharmacology"
	description_body = "You specialize in the preparation, dispensing, and appropriate use of medication."
	primary_skill = /singleton/skill/pharmacology
	secondary_skills = list(
		/singleton/skill/medicine,
		/singleton/skill/anatomy,
	)

/singleton/education_background/doctor_of_psychology
	name = "Doctor of Psychology"
	description = "You have at least a doctorate from an accredited university in an applicable field. \
		This is more of a research degree that has medical applications, as opposed to a true medical degree. \
		As such, it is only tangentially involved with actual medicine. A character with only this education is not legally considered a licensed doctor. \
		You are however qualified to perform psychological evaluations on behalf of the SCC, as well as perform psychotherapy."
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60,
	)
	skills = list(
		/* Uncomment this block after finishing the Leadership skill. Psychologists should be able to give people morale bonuses as a mechanic.
		/singleton/skill/leadership = SKILL_LEVEL_TRAINED,
		*/
		/singleton/skill/pharmacology = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/medicine = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/anatomy = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/research = SKILL_LEVEL_TRAINED,
	)

/singleton/education_background/psychiatry
	name = "MD, Psychiatry Track"
	description = "You have an applicable MD from an accredited school and you have completed 2 years of residency at an \
					accredited hospital or clinic. Unlike Psychology, this is an actual medical degree, and a character with this education is considered a licensed doctor."
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60,
	)
	skills = list(
		/singleton/skill/surgery = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/medicine = SKILL_LEVEL_TRAINED,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED,
		/singleton/skill/pharmacology = SKILL_LEVEL_TRAINED,
	)

/singleton/education_background/paramedic
	name = "Paramedic Certification"
	description = "You have a Paramedic certification."
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55,
	)
	skills = list(
		/* Can perform only the most basic surgeries up to arterial bleeds. */
		/singleton/skill/surgery = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/medicine = SKILL_LEVEL_TRAINED,
		/singleton/skill/anatomy = SKILL_LEVEL_TRAINED,
	)
