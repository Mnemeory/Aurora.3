/*#######################
	Academic Fields
#######################*/

/singleton/education/forensics
	name = "Forensics Science"
	description_body = "You specialize in the medical procedures required to understand why someone died. While not necessarily a medical degree, there's not much difference in suturing a body whether or not its approaching room temperature."
	primary_skill = /singleton/skill/forensics
	secondary_skills = list(
		/singleton/skill/surgery,
		/singleton/skill/anatomy,
		/singleton/skill/firearms,
	)

/*#######################
	Vocational Backgrounds
#######################*/

/singleton/education/military_training
	name = "Military Training"
	education_type = EDUCATION_TYPE_VOCATIONAL
	description_body = "You have finished at least one full contract of military service. Alternatively, this could be equivalent experience from mercenary work (legal or otherwise), \
		or simply surviving for long in a grim environment where self-discipline matters as much as skill."
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60,
	)
	skills = list(
		/singleton/skill/unarmed_combat = SKILL_LEVEL_TRAINED,
		/singleton/skill/armed_combat = SKILL_LEVEL_TRAINED,
		/singleton/skill/firearms = SKILL_LEVEL_TRAINED,
	)

/singleton/education/corpsman_training
	name = "Corpsman Training"
	education_type = EDUCATION_TYPE_VOCATIONAL
	description_body = "After completing basic military training (or having lived a life that taught you comparable lessons), you received advanced individual training in battlefield medicine. \
		Your combat skills are not as sharp as others, but you made up for it by knowing how to keep your comrades in arms from bleeding out on the battlefield. \
		A character with this training is NOT legally considered a medical doctor. You're on the hook for manslaughter if you attempt and fail to save them yourself instead of taking them to a real doctor."
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60,
	)
	skills = list(
		/* Significantly worse combat skills than other security educations, though not so bad they'll footgun themselves.
			Alternatively, this is a plausible though less specialized alternative for paramedic training, as is common in real life. */
		/singleton/skill/armed_combat = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/firearms = SKILL_LEVEL_TRAINED,
		/singleton/skill/surgery = SKILL_LEVEL_FAMILIAR, /* Only enough to repair an artery. */
		/singleton/skill/medicine = SKILL_LEVEL_FAMILIAR,
	)

/singleton/education/police_academy
	name = "Police Academy Graduate"
	education_type = EDUCATION_TYPE_VOCATIONAL
	description_body = "You are a police academy graduate, or else you have certified through (or survived) a local institution of comparable sort. \
		Your combat skills are not as stringent as actual military service, though this is made up for with more generalized training suitable for a first-responder."
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60,
	)
	skills = list(
		/singleton/skill/unarmed_combat = SKILL_LEVEL_FAMILIAR,
		/singleton/skill/firearms = SKILL_LEVEL_TRAINED,
		/singleton/skill/forensics = SKILL_LEVEL_FAMILIAR, /* Very basic crime investigation skills. */
		/singleton/skill/medicine = SKILL_LEVEL_FAMILIAR, /* Police are also trained in basic first aid. */
	)
