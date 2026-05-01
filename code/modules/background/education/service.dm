/*#######################
	Vocational Backgrounds
#######################*/

/singleton/education/bartending
	name = "Bartending"
	education_type = EDUCATION_TYPE_VOCATIONAL
	description_body = "You know everyone's favorite and how to make it. Whether you successfully passed the test for an Idris mixing license or have tended enough bars to have seen it all, you are a specialist in mixing cocktails, mocktails, and whatever else. Time to mix drinks and save lives."
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50,
	)
	skills = list(
		/singleton/skill/bartending = SKILL_LEVEL_TRAINED,
	)

/singleton/education/culinary_arts
	name = "Culinary Arts"
	education_type = EDUCATION_TYPE_VOCATIONAL
	description_body = "You either obtained an Idris certification to work as a cook, or you've survived enough kitchens to compete with the best. \
		Pancakes, steaks, and cultural food - you've learnt about how to cook it all."
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50,
	)
	skills = list(
		/singleton/skill/cooking = SKILL_LEVEL_TRAINED,
	)

/singleton/education/hydroponics
	name = "Hydroponics"
	education_type = EDUCATION_TYPE_VOCATIONAL
	description_body = "You either obtained an Idris certification to work as a hydroponicist or gardener, or you have worked with enough plant life to hit the same mark. \
		Your background covered both manual and hydroponic gardening of just about every plant known to your species, alongside plants that are more typical to other cultures in the Spur."
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50,
	)
	skills = list(
		/singleton/skill/gardening = SKILL_LEVEL_TRAINED,
	)
