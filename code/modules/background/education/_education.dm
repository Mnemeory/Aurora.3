// ===== EDUCATION LEVELS =====
// Global degree tiers that determine skill rank for academic fields.

ABSTRACT_TYPE(/singleton/education_level)

/singleton/education_level
	var/name
	var/education_type = EDUCATION_TYPE_ACADEMIC
	var/primary_level = SKILL_LEVEL_UNFAMILIAR
	var/secondary_level = SKILL_LEVEL_UNFAMILIAR
	var/list/minimum_character_age = list()
	var/list/species_restriction = list()

/singleton/education_level/proc/can_select(species, age)
	if(length(species_restriction) && (species in species_restriction))
		return FALSE

	var/minimum_age = (species in minimum_character_age) ? minimum_character_age[species] : 0
	if(minimum_age && age < minimum_age)
		return FALSE

	return TRUE

/proc/education_type_uses_level(education_type)
	var/list/singleton/education_level/education_levels = GET_SINGLETON_SUBTYPE_MAP(/singleton/education_level)
	for(var/level_path in education_levels)
		var/singleton/education_level/education_level = education_levels[level_path]
		if(education_level.education_type == education_type)
			return TRUE

	return FALSE

/singleton/education_level/certificate
	name = "Certificate"
	primary_level = SKILL_LEVEL_FAMILIAR
	secondary_level = SKILL_LEVEL_UNFAMILIAR
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50,
	)

/singleton/education_level/bachelors
	name = "Bachelor's"
	primary_level = SKILL_LEVEL_TRAINED
	secondary_level = SKILL_LEVEL_FAMILIAR
	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60,
	)

/singleton/education_level/masters
	name = "Master's"
	primary_level = SKILL_LEVEL_PROFESSIONAL
	secondary_level = SKILL_LEVEL_FAMILIAR
	minimum_character_age = list(
		SPECIES_HUMAN = 28,
		SPECIES_SKRELL = 65,
		SPECIES_SKRELL_AXIORI = 65,
	)

/singleton/education_level/doctorate
	name = "Doctorate"
	primary_level = SKILL_LEVEL_PROFESSIONAL
	secondary_level = SKILL_LEVEL_TRAINED
	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 70,
		SPECIES_SKRELL_AXIORI = 70,
	)

// ===== EDUCATION FIELDS =====
// Education options; education_type determines which selector exposes them.

ABSTRACT_TYPE(/singleton/education)

/singleton/education
	var/name
	var/education_type = EDUCATION_TYPE_ACADEMIC
	var/description_body = ""
	var/primary_skill
	var/list/secondary_skills = list()
	var/list/skills = list()
	var/list/minimum_character_age = list()
	var/list/species_restriction = list()

/singleton/education/proc/can_select(species, age)
	if(length(species_restriction) && (species in species_restriction))
		return FALSE

	var/minimum_age = (species in minimum_character_age) ? minimum_character_age[species] : 0
	if(minimum_age && age < minimum_age)
		return FALSE

	return TRUE

/singleton/education/proc/uses_level()
	return education_type_uses_level(education_type)

/**
 * Returns an assoc list of skill type paths -> skill levels
 * based on the provided education level.
 */
/singleton/education/proc/get_skills(singleton/education_level/level)
	. = list()
	if(length(skills))
		return skills.Copy()
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

/singleton/education/proc/get_display_name(singleton/education_level/level)
	if(uses_level())
		if(!istype(level))
			return "No Education"
		return "[level.name] in [name]"
	return name

/**
 * Returns a full description string for this field at the given level.
 */
/singleton/education/proc/get_description(singleton/education_level/level, species)
	var/minimum_age
	if(species in minimum_character_age)
		minimum_age = minimum_character_age[species]
	else
		minimum_age = minimum_character_age[SPECIES_HUMAN]

	if(uses_level())
		if(!istype(level))
			return description_body
		if(!minimum_age)
			if(species in level.minimum_character_age)
				minimum_age = level.minimum_character_age[species]
			else
				minimum_age = level.minimum_character_age[SPECIES_HUMAN]
	if(!minimum_age)
		minimum_age = 18

	if(!uses_level())
		. = "You are at least [minimum_age] years of age, with [name]."
		if(description_body)
			. += " [description_body]"
		return

	var/article = "a"
	var/first_character = uppertext(copytext(level.name, 1, 2))
	if(first_character in list("A", "E", "I", "O", "U"))
		article = "an"
	. = "You are at least [minimum_age] years of age, with [article] [level.name] in [name]."
	if(description_body)
		. += " [description_body]"

/*#######################
	Vocational Backgrounds
#######################*/

/singleton/education/high_school
	name = "High School Diploma"
	education_type = EDUCATION_TYPE_VOCATIONAL
	description_body = "Your character has a high school diploma."
