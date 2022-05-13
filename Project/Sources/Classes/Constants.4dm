/*  Constants ()
 Created by: Kirk as Designer, Created: 05/23/21, 15:34:31
 ------------------
Allows you to make constants from 4D code. Based on work Cannon Smith
and David Adams released earlier. 

The class is self contained and doesn't require any other methods. 

` EXAMPLE
var $class : cs.Constants

$class:=cs.Constants.new("name")

$class.add_item("My First Group"; "DS_k_1"; "a")
$class.add_item("My_Group"; "DS_k_5"; "b")
$class.add_item("My First Group"; "DS_k_2"; "b")
$class.add_item("My First Group"; "DS_k_3"; "c")
$class.add_item("My_Group"; "DS_k_4"; "a")
$class.add_item("My_Group"; "DS_k_6"; "c")
$class.add_item("zzz"; "DS_k_6"; "c")

$class.add_item("My_Group"; "DS_k_7"; 700.05)
$class.add_item("My_Group"; "DS_k_8"; "700.05")
$class.add_item("My First Group"; "DS_account_id"; "id")
$class.add_item("My_Group"; "DS_k_9"; 700)

$class.add_item("My First Group"; "DSlorem"; "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dol"+"or in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

$class.save()

*/

Class constructor($fileName : Text)
	
	If (Count parameters:C259=0)
		This:C1470.fileName:="constants.xlf"
	Else 
		This:C1470.fileName:=$fileName
	End if 
	
	This:C1470.groups:=New object:C1471()
	This:C1470.i:=0
	This:C1470.hash:=New object:C1471()
	
Function save
	This:C1470._parse()
	This:C1470._create_file()
	
	CONFIRM:C162("Restart 4D?\r\rThese constants won't be availble until you do."; "Restart"; "Not now")
	If (ok=1)
		RESTART 4D:C1292()
	End if 
	
Function add_group($name : Text)
	This:C1470.groups[$name]:=New object:C1471("id"; Generate UUID:C1066; "items"; New object:C1471)
	
Function add_item($groupName : Text; $name : Text; $value : Variant)
	ASSERT:C1129(Count parameters:C259=3)
	
	If (This:C1470.hash[$name]=Null:C1517)
		
		If (This:C1470.groups[$groupName]=Null:C1517)
			This:C1470.add_group($groupName)
		End if 
		
		This:C1470.groups[$groupName].items[$name]:=$value
		
		This:C1470.hash[$name]:=True:C214
		
	Else 
		ALERT:C41("The constant '"+$name+"' is already used.")
	End if 
	// --------------------------------------------------------
Function _create_file
	var $file_o : 4D:C1709.File
	
	$file_o:=File:C1566(This:C1470.fileName)
	$file_o:=Folder:C1567(fk resources folder:K87:11; *).file($file_o.name+".xlf")
	
	DOM EXPORT TO FILE:C862(This:C1470.root; $file_o.platformPath)
	DOM CLOSE XML:C722(This:C1470.root)
	
Function _parse
	var $i; $thm : Integer
	var $root; $xmlRef; $groupRef; $bodyRef; $k_ref; $name; $groupName : Text
	var $grp_o : Object
	
	$root:=DOM Create XML Ref:C861(\
		"xliff"; ""; \
		"version"; "1.0"; \
		"xmlns:d4"; "http://www.4d.com/d4-ns")
	
	$xmlRef:=DOM Create XML element:C865($root; \
		"file"; \
		"datatype"; "x-4DK#"; \
		"original"; "x-undefined"; \
		"source-language"; "x-none"; \
		"target-language"; "x-none")
	
	$bodyRef:=DOM Create XML element:C865($xmlRef; "body")
	
	$groupRef:=DOM Create XML element:C865($bodyRef; "group"; "resname"; "themes")
	
	For each ($groupName; This:C1470.groups)
		$grp_o:=This:C1470.groups[$groupName]
		
		//  groups
		$xmlRef:=DOM Create XML element:C865($groupRef; "trans-unit"; \
			"id"; "thm_"+String:C10($thm); \
			"resname"; $grp_o.id; \
			"translate"; "no")
		
		$xmlRef:=DOM Create XML element:C865($xmlRef; "source")
		DOM SET XML ELEMENT VALUE:C868($xmlRef; $groupName)
		
		
		//  constants
		$k_ref:=DOM Create XML element:C865($bodyRef; "group"; \
			"d4:groupName"; $grp_o.id; \
			"restype"; "x-4DK#")
		
		For each ($name; $grp_o.items)
			This:C1470._set_value($k_ref; $name; $grp_o.items[$name])
			
			This:C1470.i:=This:C1470.i+1
		End for each 
		
		$thm:=$thm+1
	End for each 
	
	This:C1470.root:=$root
	
Function _set_value($k_ref : Text; $name : Text; $value : Variant)
/*  manage setting the value and source for an element
value has to be rendered as a string
	
*/
	var $valueStr; $xmlRef : Text
	
	Case of 
		: (Value type:C1509($value)=Is real:K8:4)
			$valueStr:=String:C10($value)
			
			If (Int:C8($value)=$value)
				$valueStr:=$valueStr+":L"
			Else 
				$valueStr:=$valueStr+":R"
			End if 
			
		Else 
			$valueStr:=String:C10($value)+":S"
			
	End case 
	
	$xmlRef:=DOM Create XML element:C865(\
		$k_ref; "trans-unit"; \
		"d4:value"; $valueStr; \
		"id"; "k_"+String:C10(This:C1470.i))
	
	$xmlRef:=DOM Create XML element:C865($xmlRef; "source")
	DOM SET XML ELEMENT VALUE:C868($xmlRef; $name)
	