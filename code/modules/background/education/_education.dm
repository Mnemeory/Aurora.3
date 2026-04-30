// ===== EDUCATION LEVELS =====
// Global degree tiers that determine skill rank for academic fields.

ABSTRACT_TYPE(/singleton/education_level)

/singleton/education_level
	var/name
	var/primary_level = SKILL_LEVEL_UNFAMILIAR
	var/secondary_level = SKILL_LEVEL_UNFAMILIAR
	var/list/minimum_character_age = list()
	var/list/species_restriction = list()

/singleton/education_level/certificate
	name = "Certificate"
	primary_level = SKILL_LEVEL_FAMILIAR
	secondary_level = SKILL_LEVEL_UNFAMILIAR
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50,
	)

/singleton/education_level/associates
	name = "Associate's"
	primary_level = SKILL_LEVEL_TRAINED
	secondary_level = SKILL_LEVEL_FAMILIAR
	minimum_character_age = list(
		SPECIES_HUMAN = 20,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55,
	)

/singleton/education_level/bachelors
	name = "Bachelor's"
	primary_level = SKILL_LEVEL_TRAINED
	secondary_level = SKILL_LEVEL_TRAINED
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60,
	)

/singleton/education_level/masters
	name = "Master's"
	primary_level = SKILL_LEVEL_PROFESSIONAL
	secondary_level = SKILL_LEVEL_TRAINED
	minimum_character_age = list(
		SPECIES_HUMAN = 28,
		SPECIES_SKRELL = 65,
		SPECIES_SKRELL_AXIORI = 65,
	)

/singleton/education_level/doctorate
	name = "Doctorate"
	primary_level = SKILL_LEVEL_PROFESSIONAL
	secondary_level = SKILL_LEVEL_PROFESSIONAL
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 70,
		SPECIES_SKRELL_AXIORI = 70,
	)

// ===== EDUCATION FIELDS =====
// Academic specializations; paired with an education_level to produce skills.

ABSTRACT_TYPE(/singleton/education_field)

/singleton/education_field
	var/name
	var/description_body = ""
	var/primary_skill
	var/list/secondary_skills = list()
	var/list/minimum_character_age = list()
	var/list/species_restriction = list()

/**
 * Returns an assoc list of skill type paths -> skill levels
 * based on the provided education level.
 */
/singleton/education_field/proc/get_skills(singleton/education_level/level)
	. = list()
	if(!istype(level))
		return
	if(primary_skill && level.primary_level > SKILL_LEVEL_UNFAMILIAR)
		.[primary_skill] = level.primary_level
	if(level.secondary_level <= SKILL_LEVEL_UNFAMILIAR)
		return
	for(var/secondary_skill in secondary_skills)
		if(secondary_skill == primary_skill)
			continue
		.[secondary_skill] = level.secondary_level

/**
 * Returns a full description string for this field at the given level.
 */
/singleton/education_field/proc/get_description(singleton/education_level/level, species)
	var/minimum_age
	if(species in minimum_character_age)
		minimum_age = minimum_character_age[species]
	else if(species in level.minimum_character_age)
		minimum_age = level.minimum_character_age[species]
	else
		minimum_age = level.minimum_character_age[SPECIES_HUMAN]
		if(!minimum_age)
			minimum_age = minimum_character_age[SPECIES_HUMAN]
	if(!minimum_age)
		minimum_age = 18

	var/article = "a"
	var/first_character = uppertext(copytext(level.name, 1, 2))
	if(first_character in list("A", "E", "I", "O", "U"))
		article = "an"
	. = "You are at least [minimum_age] years of age, with [article] [level.name] in [name]."
	if(description_body)
		. += " [description_body]"

// ===== EDUCATION BACKGROUNDS =====
// Vocational / non-degree options with fixed skill sets.

ABSTRACT_TYPE(/singleton/education_background)

/singleton/education_background
	var/name
	var/description
	var/list/skills = list()
	var/list/minimum_character_age = list()
	var/list/species_restriction = list()

/singleton/education_background/high_school
	name = "High School Diploma"
	description = "Your character has a high school diploma."
