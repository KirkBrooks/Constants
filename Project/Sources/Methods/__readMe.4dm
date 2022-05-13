//%attributes = {}
/*
There are only 3 lines of code required to create a constant: 

$class:=cs.Constants.new("name")
$class.add_item("My First Group"; "DS_k_1"; "a")
$class.save()

Key points you need to know: 
1)  the existing constant file, if any, is overwitten. 
2)  there is no value in running this compiled
3)  you can have as many constants files as you like -- but why?

*/


var $class : cs.Constants

//  default name of file is 'constants.xlf'
$class:=cs.Constants.new("name")  // 'name' is the name of the constants file

$class.add_group("My First Group")  //  it's optional to formally install the group
$class.add_item("My First Group"; "DS_k_1"; "a")
$class.add_item("My_Group"; "DS_k_5"; "b")  //  and you can make up groups on the fly
$class.add_item("My First Group"; "DS_k_2"; "b")
$class.add_item("My First Group"; "DS_k_3"; "c")

//  it's more readable if you list the groups together in your code
$class.add_group("My_Group")
$class.add_item("My_Group"; "DS_k_4"; "a")
$class.add_item("My_Group"; "DS_k_6"; "c")
$class.add_item("My_Group"; "DS_k_7"; 700.05)
$class.add_item("My_Group"; "DS_k_8"; "700.05")
$class.add_item("My_Group"; "DS_k_9"; 700)

//  but it doesn't matter if the groups aren't listed together
$class.add_item("My First Group"; "DS_account_id"; "id")
$class.add_item("My First Group"; "DSlorem"; "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dol"+"or in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

/*  throws an alert indicating you have duplicated a constant 
doesn't matter which group
 */
$class.add_item("zzz"; "DS_k_6"; "c")

$class.save()

SHOW ON DISK(Folder(fk resources folder))
