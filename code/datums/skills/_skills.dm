/singleton/skill
	/// The displayed name of the skill.
	var/name
	/// A description of what this skill entails.
	var/description
	/// A detailed description of what a character should expect with their current level in this skill. Assoc list of skill level to string.
	var/alist/skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You are clueless.",
		SKILL_LEVEL_FAMILIAR = "You have read up on the subject or have prior real experience.",
		SKILL_LEVEL_TRAINED = "You have received some degree of official training on the subject, whether through certifications or courses.",
		SKILL_LEVEL_PROFESSIONAL = "You are an expert in this field, devoting many years of study or practice to it.",
	)
	/// Map of skill names and descriptions by their index.
	var/list/skill_level_map = list(
		"Unfamiliar",
		"Familiar",
		"Trained",
		"Professional",
	)
	/// The maximum level someone with no education can reach in this skill. Typically, this should be FAMILIAR on occupational skills.
	/// If null, then there is no cap.
	var/uneducated_skill_cap
	/// The maximum level this skill can reach.
	var/maximum_level = SKILL_LEVEL_TRAINED
	/// The category of this skill. Used for sorting, typically.
	var/category
	/// The sub-category of this skill. Used to better sort skills.
	var/subcategory
	/**
	 * Required skills are always included in the user's saved skills preference, even if it's at the lowest rank.
	 * This is needed for skills that rely on components.
	 */
	var/required = FALSE
	/// The component datum that this skill will add during character spawning
	var/component_type = null
	/// Map of skill levels to level costs. How many skill points it takes to purchase this rank in a skill.
	var/alist/skill_cost_map = alist(
		SKILL_LEVEL_UNFAMILIAR = 0,
		SKILL_LEVEL_FAMILIAR = 2,
		SKILL_LEVEL_TRAINED = 4,
		SKILL_LEVEL_PROFESSIONAL = 8,
	)

/**
 * Returns the maximum level a character can have in this skill based on their education skill map.
 */
/singleton/skill/proc/get_maximum_level(list/education_skills)
	if(!uneducated_skill_cap)
		return maximum_level

	if(type in education_skills)
		return education_skills[type]

	return uneducated_skill_cap

/**
 * Returns the cost of this skill, modified by its difficulty modifier.
 */
/singleton/skill/proc/get_cost(level)
	return skill_cost_map[level]

/**
 * ECS hook for Skills, based on a one-shot-on-spawn pattern common to traits/disabilities/loadouts, etc.
 * Skills may optionally include this, but are not required to.
 * This is primarily useful for making skills that offload all of their functional logic to a Component.
 *
 * It will be called during the process of spawning a player character in.
 */
/singleton/skill/proc/on_spawn(mob/owner, skill_level)
	SHOULD_CALL_PARENT(TRUE)
	if(!owner || !component_type)
		return

	owner.AddComponent(component_type, skill_level)
