<!-----------------------------------------------------------------------
Author 	 :	Luis Majano
Date     :	September 25, 2005
Description :
	Unit Tests integration for the ehGeneral Handler.

----------------------------------------------------------------------->
<cfcomponent name="generalTest" extends="coldbox.system.testing.BaseTest" output="false">
	
	<cfscript>
		//Uncomment the following if you dont' need the controller in application scope for testing.
		//this.PERSIST_FRAMEWORK = false;
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="private" output="false">
		<cfscript>
		//Setup ColdBox Mappings For this Test
		setAppMapping("/coldbox/ApplicationTemplate");
		setConfigMapping(ExpandPath(instance.AppMapping & "/config/coldbox.xml.cfm"));
		
		//Call the super setup method to setup the app.
		super.setup();
		
		//EXECUTE THE APPLICATION START HANDLER: UNCOMMENT IF NEEDED AND FILL IT OUT.
		//getController().runEvent("main.onAppInit");

		//EXECUTE THE ON REQUEST START HANDLER: UNCOMMENT IF NEEDED AND FILL IT OUT
		//getController().runEvent("main.onRequestStart");
		</cfscript>
	</cffunction>
	
	<cffunction name="testindex" access="public" returntype="void" output="false">
		<cfscript>
		var event = "";
		
		//Place any variables on the form or URL scope to test the handler.
		//FORM.name = "luis"
		event = execute("general.index");
			
		//Do your asserts below
		assertEqualsString("Welcome to ColdBox!", event.getValue("welcomeMessage",""), "Failed to assert welcome message");
			
		</cfscript>
	</cffunction>
	
	<cffunction name="testdoSomething" access="public" returntype="void" output="false">
		<cfscript>
		var event = "";
		
		//Place any variables on the form or URL scope to test the handler.
		//FORM.name = "luis"
		event = execute("general.doSomething");
			
		//Do your asserts below for setnextevent you can test for a setnextevent boolean flag
		assertEqualsString("general.index", event.getValue("setnextevent",""), "Relocation Test");
			
		</cfscript>
	</cffunction>
	
</cfcomponent>