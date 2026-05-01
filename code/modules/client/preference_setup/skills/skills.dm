/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1

/datum/category_item/player_setup_item/skills/load_character(var/savefile/savefile)
	savefile["skills"] >> pref.skills
	savefile["education_type"] >> pref.education_type
	savefile["education_field"] >> pref.education_field
	savefile["education_level"] >> pref.education_level

/datum/category_item/player_setup_item/skills/save_character(var/savefile/savefile)
	savefile["skills"] << pref.skills
	savefile["education_type"] << pref.education_type
	savefile["education_field"] << pref.education_field
	savefile["education_level"] << pref.education_level

/datum/category_item/player_setup_item/skills/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"education_type",
				"education_field",
				"education_level",
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
			"education_type",
			"education_field",
			"education_level",
			"skills",
			"id" = 1,
			"ckey" = 1,
		),
	)

/datum/category_item/player_setup_item/skills/gather_save_parameters()
	sanitize_character()

	var/list/sanitized_skills = list()
	for(var/skill_path in pref.skills)
		if(!skill_path)
			continue
		var/singleton/skill/skill = GET_SINGLETON(skill_path)
		if(!istype(skill))
			continue
		var/skill_value = pref.skills[skill_path]
		if(skill_value <= SKILL_LEVEL_UNFAMILIAR)
			continue
		sanitized_skills["[skill.type]"] = skill_value

	return list(
		"education_type" = pref.education_type,
		"education_field" = pref.education_field,
		"education_level" = pref.education_level,
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
		if(!ispath(skill_path, /singleton/skill))
			continue
		var/singleton/skill/skill = GET_SINGLETON(skill_path)
		if(istype(skill))
			pref.skills[skill.type] = value

/datum/category_item/player_setup_item/skills/proc/is_valid_education_type(education_type)
	return education_type in get_education_type_options()

/datum/category_item/player_setup_item/skills/proc/get_education_type_options()
	var/list/singleton/education/education_list = GET_SINGLETON_SUBTYPE_MAP(/singleton/education)
	var/list/options = list()
	for(var/singleton_type in education_list)
		var/singleton/education/education = education_list[singleton_type]
		if(!education.can_select(pref.species, pref.age))
			continue
		options[education.education_type] = education.education_type

	sortTim(options, GLOBAL_PROC_REF(cmp_text_asc), FALSE)
	return options

/datum/category_item/player_setup_item/skills/proc/get_education_level_options(education_type)
	var/list/singleton/education_level/education_levels = GET_SINGLETON_SUBTYPE_MAP(/singleton/education_level)
	var/list/options = list()
	for(var/level_path in education_levels)
		var/singleton/education_level/education_level = education_levels[level_path]
		if(education_level.education_type != education_type)
			continue
		if(!education_level.can_select(pref.species, pref.age))
			continue
		options[education_level.name] = education_level

	sortTim(options, GLOBAL_PROC_REF(cmp_text_asc), FALSE)
	return options

/datum/category_item/player_setup_item/skills/proc/get_education_options(education_type)
	var/list/singleton/education/education_list = GET_SINGLETON_SUBTYPE_MAP(/singleton/education)
	var/list/options = list()
	for(var/singleton_type in education_list)
		var/singleton/education/education = education_list[singleton_type]
		if(education.education_type != education_type)
			continue
		if(!education.can_select(pref.species, pref.age))
			continue
		options[education.name] = education

	sortTim(options, GLOBAL_PROC_REF(cmp_text_asc), FALSE)
	return options

/datum/category_item/player_setup_item/skills/proc/get_selected_education()
	var/education_path = text2path(pref.education_field)
	if(!ispath(education_path, /singleton/education))
		return null

	var/singleton/education/education = GET_SINGLETON(education_path)
	if(!istype(education))
		return null
	if(education.education_type != pref.education_type)
		return null
	if(!education.can_select(pref.species, pref.age))
		return null

	return education

/datum/category_item/player_setup_item/skills/proc/get_selected_education_level()
	var/level_path = text2path(pref.education_level)
	if(!ispath(level_path, /singleton/education_level))
		return null

	var/singleton/education_level/education_level = GET_SINGLETON(level_path)
	if(!istype(education_level))
		return null
	if(education_level.education_type != pref.education_type)
		return null
	if(!education_level.can_select(pref.species, pref.age))
		return null

	return education_level

/// Returns the effective skills map from the current education selection.
/datum/category_item/player_setup_item/skills/proc/get_current_education_skills()
	var/singleton/education/education = get_selected_education()
	if(!istype(education))
		return list()

	return education.get_skills(get_selected_education_level())

/// Returns the display name of the current education selection.
/datum/category_item/player_setup_item/skills/proc/get_education_display_name()
	var/singleton/education/education = get_selected_education()
	if(!istype(education))
		return "No Education"

	return education.get_display_name(get_selected_education_level())

/// Applies the current education's minimum skills to pref.skills.
/datum/category_item/player_setup_item/skills/proc/apply_education_skills()
	pref.skills = list()
	for(var/key in SSskills.required_skills)
		var/singleton/skill/skill = GET_SINGLETON(key)
		if(istype(skill))
			pref.skills[skill.type] = SKILL_LEVEL_UNFAMILIAR

	var/list/education_skills = get_current_education_skills()
	for(var/skill_path in education_skills)
		if(!skill_path)
			continue
		var/singleton/skill/skill = GET_SINGLETON(skill_path)
		if(!istype(skill))
			continue
		pref.skills[skill_path] = education_skills[skill_path]

/datum/category_item/player_setup_item/skills/sanitize_character(var/sql_load = 0)
	if(!pref.skills)
		pref.skills = list()

	if(!is_valid_education_type(pref.education_type))
		pref.education_type = null
		pref.education_field = null
		pref.education_level = null
	else
		if(pref.education_field && !get_selected_education())
			pref.education_field = null
		if(!education_type_uses_level(pref.education_type))
			pref.education_level = null
		else if(pref.education_level && !get_selected_education_level())
			pref.education_level = null

	if(!pref.education_field)
		pref.education_level = null

	var/list/education_skills = get_current_education_skills()
	for(var/skill_path in education_skills)
		if(!(skill_path in pref.skills) || pref.skills[skill_path] < education_skills[skill_path])
			pref.skills[skill_path] = education_skills[skill_path]
	for(var/skill_path in pref.skills.Copy())
		if(!skill_path)
			pref.skills -= skill_path
			continue
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

	dat += "<table>"
	dat += get_education_rows()

	var/list/education_skills = get_current_education_skills()
	for(var/category in SSskills.skill_tree)
		var/singleton/skill_category/skill_category = category
		dat += "<tr><th colspan = 5><b>[skill_category.name] ([calculate_remaining_skill_points(skill_category)] points remaining)</b>"
		dat += "</th></tr>"
		for(var/subcategory in SSskills.skill_tree[skill_category])
			dat += "<tr><th colspan = 5><b>[subcategory]</b></th></tr>"
			for(var/singleton/skill/skill in SSskills.skill_tree[skill_category][subcategory])
				dat += get_skill_row(skill, education_skills)
	dat += "</table>"

	. = JOINTEXT(dat)

/**
 * Returns the education selector rows.
 */
/datum/category_item/player_setup_item/skills/proc/get_education_rows()
	var/list/dat = list()
	dat += "<tr><th colspan = 5><b>Education</b></th></tr>"

	dat += get_education_type_row()
	dat += get_education_level_row()
	dat += get_education_field_row()
	dat += get_education_row(null, "<i>[get_education_skill_summary()]</i>")

	dat += "<tr><td colspan = 5><hr></td></tr>"
	return JOINTEXT(dat)

/**
 * Returns an education selector row.
 */
/datum/category_item/player_setup_item/skills/proc/get_education_row(label, value)
	if(!label)
		return "<tr style='text-align:left;'><th></th><th colspan = 4>[value]</th></tr>"
	return "<tr style='text-align:left;'><th>[label]</th><th colspan = 4>[value]</th></tr>"

/**
 * Returns the inline education type selector row.
 */
/datum/category_item/player_setup_item/skills/proc/get_education_type_row()
	var/list/dat = list()
	dat += "<tr style='text-align:left;'><th>Type</th><th colspan = 4>"

	var/list/options = get_education_type_options()
	for(var/education_type in options)
		dat += get_education_button(capitalize(education_type), "set_education_type=[education_type]", pref.education_type == education_type)

	dat += "</th></tr>"
	return JOINTEXT(dat)

/**
 * Returns the inline education level selector row.
 */
/datum/category_item/player_setup_item/skills/proc/get_education_level_row()
	var/list/dat = list()
	dat += "<tr style='text-align:left;'><th>Level</th><th colspan = 4>"

	if(!is_valid_education_type(pref.education_type))
		dat += "Unselected</th></tr>"
		return JOINTEXT(dat)

	if(!education_type_uses_level(pref.education_type))
		dat += "Not Applicable</th></tr>"
		return JOINTEXT(dat)

	var/list/options = get_education_level_options(pref.education_type)
	if(!length(options))
		dat += "Not Applicable</th></tr>"
		return JOINTEXT(dat)

	for(var/level_name in options)
		var/singleton/education_level/education_level = options[level_name]
		dat += get_education_button(education_level.name, "set_education_level=[education_level.type]", pref.education_level == "[education_level.type]")

	dat += "</th></tr>"
	return JOINTEXT(dat)

/**
 * Returns the inline education field selector row.
 */
/datum/category_item/player_setup_item/skills/proc/get_education_field_row()
	var/list/dat = list()
	dat += "<tr style='text-align:left;'><th>Field</th><th colspan = 4>"

	if(!is_valid_education_type(pref.education_type))
		dat += "Unselected</th></tr>"
		return JOINTEXT(dat)

	var/list/options = get_education_options(pref.education_type)
	if(!length(options))
		dat += "Not Applicable</th></tr>"
		return JOINTEXT(dat)

	for(var/field_name in options)
		var/singleton/education/education = options[field_name]
		dat += get_education_button(education.name, "set_education_field=[education.type]", pref.education_field == "[education.type]")

	dat += "</th></tr>"
	return JOINTEXT(dat)

/**
 * Returns an inline education selector button.
 */
/datum/category_item/player_setup_item/skills/proc/get_education_button(text, href, selected)
	if(selected)
		return span("Current", text)
	return "<a class='Selectable' href='?src=[REF(src)];[href]'>[text]</a>"

/**
 * Returns the skills granted by the current education selection as display text.
 */
/datum/category_item/player_setup_item/skills/proc/get_education_skill_summary()
	var/list/education_skills = get_current_education_skills()
	if(!length(education_skills))
		return "No skills granted."

	var/list/granted_skills = list()
	for(var/skill_path in education_skills)
		if(!skill_path)
			continue
		var/singleton/skill/skill = GET_SINGLETON(skill_path)
		if(!istype(skill))
			continue
		granted_skills += "[skill.name] ([skill.skill_level_map[education_skills[skill_path]]])"
	if(!length(granted_skills))
		return "No skills granted."

	sortTim(granted_skills, GLOBAL_PROC_REF(cmp_text_asc), FALSE)
	return "Grants [english_list(granted_skills)]."

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

	var/datum/species/species = GLOB.all_species[pref.species]
	if(!istype(species))
		return 0

	var/culture_path = text2path(pref.culture)
	var/singleton/origin_item/culture/culture
	if(ispath(culture_path, /singleton/origin_item/culture))
		culture = GET_SINGLETON(culture_path)

	var/origin_path = text2path(pref.origin)
	var/singleton/origin_item/origin/origin
	if(ispath(origin_path, /singleton/origin_item/origin))
		origin = GET_SINGLETON(origin_path)

	var/skill_points_remaining = skill_category.calculate_skill_points(species, pref.age, culture, origin)
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
		if(!skill_type)
			continue
		var/singleton/skill/skill = GET_SINGLETON(skill_type)
		if(!istype(skill))
			continue
		if(skill.category != skill_category.type)
			continue

		if(skill.type in education_skills)
			continue

		. += skill.get_cost(pref.skills[skill.type])

/datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
	if(href_list["skillinfo"])
		var/skill_path = text2path(href_list["skillinfo"])
		if(!ispath(skill_path, /singleton/skill))
			return
		var/singleton/skill/skill_to_show = GET_SINGLETON(skill_path)
		if(!istype(skill_to_show))
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
		var/skill_path = text2path(href_list["setskill"])
		if(!ispath(skill_path, /singleton/skill))
			return
		var/singleton/skill/new_skill = GET_SINGLETON(skill_path)
		if(!istype(new_skill))
			log_debug("SKILLS: Invalid skill selected for [user]: [new_skill]")
			return

		var/list/education_skills = get_current_education_skills()
		var/minimum_skill_level = (new_skill.type in education_skills) ? education_skills[new_skill.type] : SKILL_LEVEL_UNFAMILIAR
		var/maximum_skill_level = get_maximum_skill_level(new_skill, education_skills)
		var/new_skill_value = clamp(text2num(href_list["newvalue"]), minimum_skill_level, maximum_skill_level)
		pref.skills[new_skill.type] = new_skill_value
		return TOPIC_REFRESH

	else if(href_list["set_education_type"])
		if(!is_valid_education_type(href_list["set_education_type"]))
			return

		pref.education_type = href_list["set_education_type"]
		pref.education_field = null
		pref.education_level = null
		pref.skills = list()
		sanitize_character()
		return TOPIC_REFRESH

	else if(href_list["set_education_level"])
		var/level_path = text2path(href_list["set_education_level"])
		if(!education_type_uses_level(pref.education_type))
			return
		if(!ispath(level_path, /singleton/education_level))
			return
		var/singleton/education_level/education_level = GET_SINGLETON(level_path)
		if(!istype(education_level) || !education_level.can_select(pref.species, pref.age))
			return
		if(education_level.education_type != pref.education_type)
			return

		pref.education_level = "[level_path]"
		pref.skills = list()
		apply_education_skills()
		sanitize_character()
		return TOPIC_REFRESH

	else if(href_list["set_education_field"])
		var/field_path = text2path(href_list["set_education_field"])
		if(!is_valid_education_type(pref.education_type))
			return
		if(!ispath(field_path, /singleton/education))
			return
		var/singleton/education/education = GET_SINGLETON(field_path)
		if(!istype(education))
			return
		if(education.education_type != pref.education_type)
			return
		if(!education.can_select(pref.species, pref.age))
			return

		if(!education_type_uses_level(pref.education_type))
			pref.education_level = null
		pref.education_field = "[field_path]"
		pref.skills = list()
		apply_education_skills()
		sanitize_character()
		return TOPIC_REFRESH

	return ..()
