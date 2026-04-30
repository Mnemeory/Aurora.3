/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1

/datum/category_item/player_setup_item/skills/load_character(var/savefile/savefile)
	savefile["skills"] >> pref.skills
	savefile["education_field"] >> pref.education_field
	savefile["education_level"] >> pref.education_level
	savefile["education_background"] >> pref.education_background

/datum/category_item/player_setup_item/skills/save_character(var/savefile/savefile)
	savefile["skills"] << pref.skills
	savefile["education_field"] << pref.education_field
	savefile["education_level"] << pref.education_level
	savefile["education_background"] << pref.education_background

/datum/category_item/player_setup_item/skills/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"education_field",
				"education_level",
				"education_background",
				"skills",
			),
			"args" = list("id"),
		),
	)

/datum/category_item/player_setup_item/skills/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/skills/gather_save_query()
	return list(
		"ss13_characters" = list(
			"education_field",
			"education_level",
			"education_background",
			"skills",
			"id" = 1,
			"ckey" = 1,
		),
	)

/datum/category_item/player_setup_item/skills/gather_save_parameters()
	var/list/sanitized_skills = list()
	for(var/skill_path in pref.skills)
		var/singleton/skill/skill = GET_SINGLETON(skill_path)
		if(!istype(skill))
			continue
		var/skill_value = pref.skills[skill_path]
		if(skill_value <= SKILL_LEVEL_UNFAMILIAR)
			continue
		sanitized_skills["[skill.type]"] = skill_value

	return list(
		"education_field" = pref.education_field,
		"education_level" = pref.education_level,
		"education_background" = pref.education_background,
		"skills" = json_encode(sanitized_skills),
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY,
	)

/datum/category_item/player_setup_item/skills/load_character_special(savefile/savefile)
	if(!pref.skills)
		pref.skills = "{}"

	var/before = pref.skills
	var/loaded_skills
	try
		if(istext(pref.skills))
			loaded_skills = json_decode(pref.skills)
		else
			loaded_skills = pref.skills
	catch(var/exception/e)
		log_debug("SKILLS: Caught [e]. Initial value: [before]")
		loaded_skills = list()

	pref.skills = list()
	for(var/key in SSskills.required_skills)
		var/singleton/skill/skill = GET_SINGLETON(key)
		if(istype(skill))
			pref.skills[skill.type] = SKILL_LEVEL_UNFAMILIAR

	for(var/key, value in loaded_skills)
		if(!key)
			continue
		var/skill_path = istext(key) ? text2path(key) : key
		var/singleton/skill/skill = GET_SINGLETON(skill_path)
		if(istype(skill))
			pref.skills[skill.type] = value

/// Returns the effective skills map from the current education selection (field+level or background).
/datum/category_item/player_setup_item/skills/proc/get_current_education_skills()
	if(pref.education_background)
		var/singleton/education_background/education_background = GET_SINGLETON(text2path(pref.education_background))
		if(istype(education_background))
			return education_background.skills.Copy()
	if(pref.education_field && pref.education_level)
		var/singleton/education_field/education_field = GET_SINGLETON(text2path(pref.education_field))
		var/singleton/education_level/education_level = GET_SINGLETON(text2path(pref.education_level))
		if(istype(education_field) && istype(education_level))
			return education_field.get_skills(education_level)
	return list()

/// Returns the display name of the current education selection.
/datum/category_item/player_setup_item/skills/proc/get_education_display_name()
	if(pref.education_background)
		var/singleton/education_background/education_background = GET_SINGLETON(text2path(pref.education_background))
		if(istype(education_background))
			return education_background.name
	if(pref.education_field && pref.education_level)
		var/singleton/education_field/education_field = GET_SINGLETON(text2path(pref.education_field))
		var/singleton/education_level/education_level = GET_SINGLETON(text2path(pref.education_level))
		if(istype(education_field) && istype(education_level))
			return "[education_level.name] in [education_field.name]"
	return "No Education"

/// Applies the current education's minimum skills to pref.skills.
/datum/category_item/player_setup_item/skills/proc/apply_education_skills(mob/user)
	pref.skills = list()
	for(var/key in SSskills.required_skills)
		var/singleton/skill/skill = GET_SINGLETON(key)
		if(istype(skill))
			pref.skills[skill.type] = SKILL_LEVEL_UNFAMILIAR

	var/list/education_skills = get_current_education_skills()
	for(var/skill_path in education_skills)
		var/singleton/skill/skill = GET_SINGLETON(skill_path)
		if(!istype(skill))
			continue
		pref.skills[skill_path] = education_skills[skill_path]
		if(user)
			to_chat(user, SPAN_NOTICE("Added the [skill.name] skill at level [skill.skill_level_map[education_skills[skill_path]]]."))

/datum/category_item/player_setup_item/skills/sanitize_character(var/sql_load = 0)
	if(!pref.skills)
		pref.skills = list()

	if(istext(pref.education_background) && ispath(text2path(pref.education_background), /singleton/education_background))
		var/singleton/education_background/education_background = GET_SINGLETON(text2path(pref.education_background))
		if(istype(education_background))
			if(length(education_background.species_restriction) && (pref.species in education_background.species_restriction))
				pref.education_background = null
			if(length(education_background.minimum_character_age) && (pref.species in education_background.minimum_character_age))
				if(pref.age < education_background.minimum_character_age[pref.species])
					pref.education_background = null

	var/singleton/education_field/education_field = GET_SINGLETON(text2path(pref.education_field))
	var/singleton/education_level/education_level = GET_SINGLETON(text2path(pref.education_level))
	if(!istype(education_field) || !istype(education_level))
		pref.education_field = null
		pref.education_level = null
	else
		if(length(education_field.species_restriction) && (pref.species in education_field.species_restriction))
			pref.education_field = null
			pref.education_level = null
		if(length(education_level.species_restriction) && (pref.species in education_level.species_restriction))
			pref.education_field = null
			pref.education_level = null
		var/field_minimum_age = (pref.species in education_field.minimum_character_age) ? education_field.minimum_character_age[pref.species] : 0
		var/level_minimum_age = (pref.species in education_level.minimum_character_age) ? education_level.minimum_character_age[pref.species] : 0
		var/minimum_age = max(field_minimum_age, level_minimum_age)
		if(minimum_age && pref.age < minimum_age)
			pref.education_field = null
			pref.education_level = null

	if(!pref.education_background && (!pref.education_field || !pref.education_level))
		var/singleton/education_background/default_education = find_suitable_education()
		pref.education_background = default_education ? "[default_education.type]" : null
		pref.education_field = null
		pref.education_level = null

	var/list/education_skills = get_current_education_skills()
	for(var/skill_path in education_skills)
		if(!(skill_path in pref.skills) || pref.skills[skill_path] < education_skills[skill_path])
			pref.skills[skill_path] = education_skills[skill_path]
	for(var/skill_path in pref.skills.Copy())
		var/singleton/skill/skill = GET_SINGLETON(skill_path)
		if(!istype(skill))
			pref.skills -= skill_path
			continue
		var/maximum_skill_level = skill.get_maximum_level(education_skills)
		if(pref.skills[skill_path] > maximum_skill_level)
			pref.skills[skill_path] = maximum_skill_level

// Skills HTML UI, along with a lot of other components here, lifted from Baystation 12. Credit goes to Afterthought12. Thank you for saving me from HTML hell!
/datum/category_item/player_setup_item/skills/content(var/mob/user)
	if(!SSskills.initialized)
		return "<center><large>Skills not initialized yet. Please wait a bit and reload this section.</large></center>"

	var/list/dat = list()

	dat += "<body>"
	dat += "<style>.Selectable,.Current,.Unavailable,.Toohigh,.Forced{border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0}</style>"
	dat += "<style>.Forced,a.Forced{background: #FF0000}</style>"
	dat += "<style>.Selectable,a.Selectable{background: #40628a}</style>"
	dat += "<style>.Current,a.Current{background: #2f943c}</style>"
	dat += "<style>.Unavailable{background: #d09000}</style>"

	var/education_name = get_education_display_name()
	if(pref.education_background)
		dat += "<center><b>Education:</b> <a href='?src=[REF(src)];open_education_type_menu=1'>Vocational Background</a> - "
		dat += "<a href='?src=[REF(src)];open_education_background_menu=1'>[education_name]</a></center><br/><hr>"
	else if(pref.education_field && pref.education_level)
		var/singleton/education_field/education_field = GET_SINGLETON(text2path(pref.education_field))
		var/singleton/education_level/education_level = GET_SINGLETON(text2path(pref.education_level))
		dat += "<center><b>Education:</b> <a href='?src=[REF(src)];open_education_type_menu=1'>Academic Degree</a> - "
		dat += "<a href='?src=[REF(src)];open_education_field_menu=1'>[education_field.name]</a> - "
		dat += "<a href='?src=[REF(src)];open_education_level_menu=1'>[education_level.name]</a></center><br/><hr>"
	else
		dat += "<center><b>Education:</b> <a href='?src=[REF(src)];open_education_type_menu=1'>[education_name]</a></center><br/><hr>"

	dat += "<table>"
	var/list/education_skills = get_current_education_skills()
	for(var/category in SSskills.skill_tree)
		var/singleton/skill_category/skill_category = category
		dat += "<tr><th colspan = 4><b>[skill_category.name] ([calculate_remaining_skill_points(skill_category)] points remaining)</b>"
		dat += "</th></tr>"
		for(var/subcategory in SSskills.skill_tree[skill_category])
			dat += "<tr><th colspan = 3><b>[subcategory]</b></th></tr>"
			for(var/singleton/skill/skill in SSskills.skill_tree[skill_category][subcategory])
				dat += get_skill_row(skill, education_skills)
	dat += "</table>"

	. = JOINTEXT(dat)

/**
 * Returns an HTML skill row.
 */
/datum/category_item/player_setup_item/skills/proc/get_skill_row(singleton/skill/skill, list/education_skills)
	var/list/dat = list()
	dat += "<tr style='text-align:left;'>"
	dat += "<th><a href='?src=[REF(src)];skillinfo=[skill.type]'>[skill.name]</a></th>"

	var/level_from_pref = pref.skills[skill.type]
	var/current_level = level_from_pref ? level_from_pref : SKILL_LEVEL_UNFAMILIAR
	var/maximum_skill_level = get_maximum_skill_level(skill, education_skills)

	for(var/selection_level in SKILL_LEVEL_UNFAMILIAR to skill.maximum_level)
		dat += skill_to_button(skill, education_skills, current_level, selection_level, maximum_skill_level)

	return JOINTEXT(dat)

/datum/category_item/player_setup_item/skills/proc/get_maximum_skill_level(singleton/skill/skill, list/education_skills)
	var/base_maximum_level = skill.get_maximum_level(education_skills)
	var/remaining_skill_points = calculate_remaining_skill_points(GET_SINGLETON(skill.category))

	var/current_level = SKILL_LEVEL_UNFAMILIAR
	if(skill.type in pref.skills)
		current_level = pref.skills[skill.type]

	var/current_cost = 0
	if(!(skill.type in education_skills))
		current_cost = skill.get_cost(current_level)

	var/available_points = remaining_skill_points + current_cost

	for(var/skill_level_offset in SKILL_LEVEL_UNFAMILIAR to base_maximum_level)
		var/skill_level = base_maximum_level - (skill_level_offset - SKILL_LEVEL_UNFAMILIAR)
		if(skill.get_cost(skill_level) <= available_points)
			return skill_level

	return SKILL_LEVEL_UNFAMILIAR

/**
 * Turns a skill into a dynamic button.
 */
/datum/category_item/player_setup_item/skills/proc/skill_to_button(singleton/skill/skill, list/education_skills, current_level, selection_level, maximum_skill_level)
	var/effective_level = selection_level
	if(effective_level <= 0)
		return "<th></th>"

	var/level_name = skill.skill_level_map[effective_level]
	var/cost = skill.get_cost(effective_level)
	var/button_label = "[level_name] ([cost])"
	var/given_skill = FALSE

	// Prevent removal of skills given by education. These are meant to be minimum skills for jobs, after all.
	if(skill.type in education_skills)
		given_skill = TRUE

	if((effective_level < current_level) && given_skill)
		return "<th>[span("Forced", "[button_label]")]</th>"
	else if((effective_level < current_level) && !given_skill)
		return "<th>[add_link(skill, education_skills, button_label, "'Current'", effective_level)]</th>"
	else if(effective_level == current_level)
		return "<th>[span("Current", "[button_label]")]</th>"
	else if(effective_level <= maximum_skill_level)
		return "<th>[add_link(skill, education_skills, button_label, "'Selectable'", effective_level)]</th>"
	else
		return "<th>[span("Toohigh", "[button_label]")]</th>"

/**
 * Returns a button to set a skill in the skill UI.
 */
/datum/category_item/player_setup_item/skills/proc/add_link(singleton/skill/skill, list/education_skills, text, style, value)
	if(skill.get_maximum_level(education_skills) >= value)
		return "<a class=[style] href='?src=[REF(src)];setskill=[skill.type];newvalue=[value]'>[text]</a>"
	return text

/**
 * Returns the currently remaining skill points in a given category.
 */
/datum/category_item/player_setup_item/skills/proc/calculate_remaining_skill_points(singleton/skill_category/skill_category)
	if(!istype(skill_category))
		crash_with("Invalid skill category [skill_category] fed to calculate_remaining_skill_points!")

	var/skill_points_remaining = skill_category.calculate_skill_points(GLOB.all_species[pref.species], pref.age, GET_SINGLETON(text2path(pref.culture)), GET_SINGLETON(text2path(pref.origin)))
	var/current_points_used = get_used_skill_points_per_category(skill_category, get_current_education_skills())
	return skill_points_remaining - current_points_used

/**
 * Returns the amount of used skill points in a certain skill category, ignoring skills given by education.
 */
/datum/category_item/player_setup_item/skills/proc/get_used_skill_points_per_category(singleton/skill_category/skill_category, list/education_skills)
	if(!istype(skill_category))
		crash_with("Invalid skill category [skill_category] fed to get_used_skill_points_per_category!")

	. = 0
	for(var/skill_type in pref.skills)
		var/singleton/skill/skill = GET_SINGLETON(skill_type)
		if(skill.category != skill_category.type)
			continue

		if(skill.type in education_skills)
			continue

		. += skill.get_cost(pref.skills[skill.type])

/datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
	if(href_list["skillinfo"])
		var/singleton/skill/skill_to_show = GET_SINGLETON(text2path(href_list["skillinfo"]))
		if(!skill_to_show)
			log_debug("SKILLS: Invalid skill selected for [user]: [skill_to_show]")
			return
		var/datum/browser/skill_window = new(user, "skill_info", "Skill Information")
		var/dat = "<html><center><b>[skill_to_show.name]</center></b>"
		dat += "<hr>[skill_to_show.description]<br>"
		if(skill_to_show.uneducated_skill_cap)
			dat += "Without the relevant education, you may only reach the <b>[skill_to_show.skill_level_map[skill_to_show.uneducated_skill_cap]]</b> level.<br>"
		dat += "<hr>"
		var/skill_level = (skill_to_show.type in pref.skills) ? pref.skills[skill_to_show.type] : SKILL_LEVEL_UNFAMILIAR
		dat += "Your current level in this skill is [SPAN_BOLD(skill_to_show.skill_level_map[skill_level])].<br>"
		dat += "[skill_to_show.skill_level_descriptions[skill_level]]"
		dat += "</html>"
		skill_window.set_content(dat)
		skill_window.open()

	else if(href_list["setskill"])
		var/singleton/skill/new_skill = GET_SINGLETON(text2path(href_list["setskill"]))
		if(!new_skill)
			log_debug("SKILLS: Invalid skill selected for [user]: [new_skill]")
			return

		var/list/education_skills = get_current_education_skills()
		var/minimum_skill_level = (new_skill.type in education_skills) ? education_skills[new_skill.type] : SKILL_LEVEL_UNFAMILIAR
		var/maximum_skill_level = get_maximum_skill_level(new_skill, education_skills)
		var/new_skill_value = clamp(text2num(href_list["newvalue"]), minimum_skill_level, maximum_skill_level)
		pref.skills[new_skill.type] = new_skill_value
		return TOPIC_REFRESH

	else if(href_list["open_education_type_menu"])
		var/list/options = list("Academic Degree", "Vocational Background")
		var/result = tgui_input_list(user, "Choose your education type.", "Education Type", options)
		if(result == "Academic Degree")
			pref.education_background = null
			pref.education_field = null
			pref.education_level = null
			pref.skills = list()
			to_chat(user, SPAN_WARNING("Your skills have been reset as you changed your education."))
			return TOPIC_REFRESH
		else if(result == "Vocational Background")
			pref.education_field = null
			pref.education_level = null
			pref.education_background = null
			pref.skills = list()
			to_chat(user, SPAN_WARNING("Your skills have been reset as you changed your education."))
			return TOPIC_REFRESH

	else if(href_list["open_education_field_menu"])
		var/list/options = list()
		var/list/singleton/education_field/field_list = GET_SINGLETON_SUBTYPE_MAP(/singleton/education_field)
		for(var/singleton_type in field_list)
			var/singleton/education_field/education_field = field_list[singleton_type]
			if(length(education_field.species_restriction) && (pref.species in education_field.species_restriction))
				continue
			var/field_minimum_age = (pref.species in education_field.minimum_character_age) ? education_field.minimum_character_age[pref.species] : 0
			if(field_minimum_age && pref.age < field_minimum_age)
				continue
			options[education_field.name] = education_field
		var/result = tgui_input_list(user, "Choose your field of study.", "Education Field", options)
		var/singleton/education_field/chosen_field = options[result]
		if(chosen_field)
			pref.education_field = "[chosen_field.type]"
			if(!pref.education_level)
				pref.education_level = "/singleton/education_level/bachelors"
			pref.skills = list()
			to_chat(user, SPAN_WARNING("Your skills have been reset as you changed your education."))
			apply_education_skills(user)
			sanitize_character()
			return TOPIC_REFRESH

	else if(href_list["open_education_level_menu"])
		var/list/options = list()
		var/list/singleton/education_level/level_list = GET_SINGLETON_SUBTYPE_MAP(/singleton/education_level)
		for(var/singleton_type in level_list)
			var/singleton/education_level/education_level = level_list[singleton_type]
			if(length(education_level.species_restriction) && (pref.species in education_level.species_restriction))
				continue
			var/level_minimum_age = (pref.species in education_level.minimum_character_age) ? education_level.minimum_character_age[pref.species] : 0
			if(level_minimum_age && pref.age < level_minimum_age)
				continue
			options[education_level.name] = education_level
		var/result = tgui_input_list(user, "Choose your degree level.", "Education Level", options)
		var/singleton/education_level/chosen_level = options[result]
		if(chosen_level)
			pref.education_level = "[chosen_level.type]"
			pref.skills = list()
			to_chat(user, SPAN_WARNING("Your skills have been reset as you changed your education."))
			apply_education_skills(user)
			sanitize_character()
			return TOPIC_REFRESH

	else if(href_list["open_education_background_menu"])
		var/list/options = list()
		var/list/singleton/education_background/background_list = GET_SINGLETON_SUBTYPE_MAP(/singleton/education_background)
		for(var/singleton_type in background_list)
			var/singleton/education_background/education_background = background_list[singleton_type]
			if(length(education_background.species_restriction) && (pref.species in education_background.species_restriction))
				continue
			var/background_minimum_age = (pref.species in education_background.minimum_character_age) ? education_background.minimum_character_age[pref.species] : 0
			if(background_minimum_age && pref.age < background_minimum_age)
				continue
			options[education_background.name] = education_background
		var/result = tgui_input_list(user, "Choose your vocational background.", "Education Background", options)
		var/singleton/education_background/chosen_bg = options[result]
		if(chosen_bg)
			pref.education_background = "[chosen_bg.type]"
			pref.education_field = null
			pref.education_level = null
			pref.skills = list()
			to_chat(user, SPAN_WARNING("Your skills have been reset as you changed your education."))
			apply_education_skills(user)
			sanitize_character()
			return TOPIC_REFRESH

	return ..()

/**
 * Finds and returns the first suitable default education for the pref datum.
 * Defaults to High School Diploma background.
 */
/datum/category_item/player_setup_item/skills/proc/find_suitable_education()
	var/singleton/education_background/education_background = GET_SINGLETON(/singleton/education_background/high_school)
	if(!istype(education_background))
		return null
	if(length(education_background.species_restriction) && (pref.species in education_background.species_restriction))
		return null
	if(length(education_background.minimum_character_age) && (pref.species in education_background.minimum_character_age))
		if(pref.age < education_background.minimum_character_age[pref.species])
			return null
	return education_background
