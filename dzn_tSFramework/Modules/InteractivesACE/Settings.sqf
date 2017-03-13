tSF_IACE_Timeout = -1;

/*
 *	Configuration of ACE Actions:
 *		[ @ActionType, @Name, @ID, @ParentID, @Code, @Condition ]
 *		0:  @List of Classname OR List of @Objects  -   if list of classname is used, then all map objects with given class will be applyed
 *		1:  @Name		-	displayed name of the action node
 *		2:  @ID		-	ID of action node
 *		3:  @ParentID	-	ID of parent action node
 *		4:  @Code		-	code to execute (_target is the action-related object)
 *		5:  @Condition	-	condition of action availabness
 *
 */

#define	ACE_INTRACTIVES_TABLE		tSF_IACE_Actions = [
#define	ACE_INTRACTIVES_TABLE_END	];

ACE_INTRACTIVES_TABLE
	[
		"SELF"
		, "Survive and Surveillance Competition"
		, "SSC_Node"
		, ""
		, {}
		, { true }
	]
	, [
		"SELF"
		, "Start Competition"
		, "SSC_Node_Start"
		, "SSC_Node"
		, { call dzn_fnc_c_doStartAction; }
		, { !(player getVariable "SSC_CompetitionStarted") }
	]
	, [
		"SELF"
		, "Abort Competition"
		, "SSC_Node_Abort"
		, "SSC_Node"
		, { [] spawn dzn_fnc_c_doAbortAction; }
		, { player getVariable "SSC_CompetitionStarted" }
	]
	, [
		"SELF"
		, "Report CP"
		, "SSC_Node_ReportCP"
		, "SSC_Node"
		, { [] spawn dzn_fnc_c_doReportAction; }
		, { player getVariable "SSC_CompetitionStarted" }
	]
	
	
ACE_INTRACTIVES_TABLE_END
