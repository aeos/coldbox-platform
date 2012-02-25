/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

The ColdBox Validation Manager, all inspired by awesome Hyrule Validation Framework by Dan Vega.

When using constraints you can use {} values for replacements:
- {now} = today
- {property-name} = A property value
- {udf-name} = Call a UDF provider

Constraint Definition Sample:

propertyName = {
	// required or not
	blank : boolean [false],
	// type constraint
	type  : (ssn,email,url,alpha,boolean,date,usdate,eurodate,numeric,GUID,UUID,integer,[string],telephone,zipcode,ipaddress,creditcard,binary,component,query,struct),
	// size or length of the value (struct,string,array,query)
	size  : numeric or range, eg: 10 or 6,8
	// range is a range of values the property value should exist in
	range : eg: 1,10 or 5,-5
	// regex validation
	regex : valid regex
	// same as another property or value
	sameAs : value
	// same as but with no case
	sameAsNoCase : value
	// value in list
	inList : list
	// discrete math modifiers
	discrete : (gt,gte,lt,lte):value
	// UDF to use for validation
	udf : function
	// Custom validator, must implement 
	validator : path or wirebox id: 'mypath.MyValidator' or 'id:MyValidator'
	
};

*/
component accessors="true" serialize="false" singleton{

	/**
	* DI
	*/
	property name="wirebox" inject="wirebox";
	
	/**
	* Shared constraints
	*/
	property name="sharedConstraints" type="struct";
	
	/**
	* Lazy loaded object constraints
	*/
	property name="objectConstraints" type="struct";
	

	// constructor
	ValidationManager function init(){
		
		// shared constraints
		sharedConstraints = {};
		// loaded object constraints
		objectConstraints = {};
		
		return this;
	}
	
	/**
	* Validate an object
	* @target.hint The target object to validate
	* @fields.hint One or more fields to validate on, by default it validates all fields in the constraints. This can be a simple list or an array.
	* @constraints.hint An optional shared constraints name or an actual structure of constraints to validate on.
	*/
	IValidationResult function validate(required any target, string fields, any constraints){
		// discover and determine constraints definition for an incoming target.
		var thisConstraints = determineConstraintsDefinition(arguments.target, arguments.constraints);
		

		
	}
	
	/**
	* Retrieve the shared constraints
	* @name.hint Filter by name or not
	*/
	struct function getSharedConstraints(string name){
		return ( structKeyExists(arguments,"name") ? sharedConstraints[arguments.name] : sharedConstraints );
	}
	
	/**
	* Check if a shared constraint exists by name
	* @name.hint The shared constraint to check
	*/
	boolean function sharedConstraintsExists(required string name){
		return structKeyExists( sharedConstraints, arguments.name );
	}
	
	
	/**
	* Retrieve the shared constraints
	* @constraints.hint Filter by name or not
	*/
	ValidationManager function setSharedConstraints(struct constraints){
		variables.sharedConstraints = arguments.constraints;
		return this;
	}
	
	/**
	* This method is called by ColdBox when the application loads so you can load or process shared constraints
	* @constraints.hint A structure of validation constraints { key (shared name) = { constraints} }
	*/
	IValidationManager function loadSharedConstraints(required struct constraints){
		
	}
	
	/************************************** private *********************************************/
	
	private struct function determineConstraintsDefinition(required any target, required any constraints){
		var thisConstraints = {};
		
		// Discover contraints, check passed constraints first
		if( structKeyExists(arguments,"constraints") ){ 
			// simple value means shared lookup
			if( isSimpleValue(arguments.constraints) ){ 
				if( !sharedConstraintsExists(arguments.constraints) ){
					throw(message="The shared constraint you requested (#arguments.constraints#) does not exist",
						  detail="Valid constraints are: #structKeyList(sharedConstraints)#",
						  type="ValidationManager.InvalidSharedConstraint");
				}
				// retrieve the shared constraint
				thisConstraints = getSharedConstraints( arguments.constraints ); 
			}
			// else it is a struct just assign it
			else{ thisConstraints = arguments.constraints; }
		}
		// discover constraints from target object
		else{ thisConstraints = discoverConstraints( arguments.target ); }
		
		// now back to the fun stuff.
		return thisConstraints;
	}
	
}