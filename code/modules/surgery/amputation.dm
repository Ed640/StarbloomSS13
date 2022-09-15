
/datum/surgery/amputation
	name = "Amputation"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/sever_limb)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD)
	requires_bodypart_type = 0


/datum/surgery_step/sever_limb
	name = "sever limb"
	implements = list(
		/obj/item/shears = 300,
		TOOL_SCALPEL = 100,
		TOOL_SAW = 100,
		/obj/item/melee/arm_blade = 80,
		/obj/item/fireaxe = 50,
		/obj/item/hatchet = 40,
		/obj/item/knife/butcher = 25)
	time = 64
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	pain_amount = 16 // Losing a limb also applies pain to chest

/datum/surgery_step/sever_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to sever [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to sever [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] begins to sever [target]'s [parse_zone(target_zone)]!"))
	display_pain(target, "You feel a gruesome pain in your [parse_zone(target_zone)]'s joint!", target_zone = target_zone)

/datum/surgery_step/sever_limb/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("You sever [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] severs [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] severs [target]'s [parse_zone(target_zone)]!"))
	display_pain(target, "You lose all feeling in your [parse_zone(target_zone)]!", target_zone = target_zone)
	if(surgery.operated_bodypart)
		// Pain is caused by having a limb removed, not a lot but a decent amount
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		target_limb.drop_limb()
	return ..()
