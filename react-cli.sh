#!/bin/bash
pwd=$(pwd)
GREEN='\033[0;32m'
NC='\033[0m'
help_action='--help'
load_action='--load'
init_action='--init'
about_action='--about'
function_flag='-f'
arrow_flag='-a'
class_flag='-c'
component_action='component'
container_action='container'
page_action='page'
rootpath='src'
compath='src/components'
hookpath='src/hooks'
contpath='src/containers'
# greet the user
buildRoute() {
	newpath=$1
	action=$2
	if [ ! -z $newpath ];
		then echo "$rootpath/$newpath"
	else
		case $action in
		"$container_action")
			echo $contpath
			;;
		"$component_action")
			echo $compath
			;;
		*)
			echo $rootpath
			;;
		esac
  	fi
}

loadModule() {
	echo -ne '\n'
	echo -ne '🚚 #                         (5%)\r'
	sleep 1
	echo -ne '🚚 #######                   (33%)\r'
	sleep 1
	echo -ne '🚚 ###############           (66%)\r'
	sleep 1
	echo -ne '🚚 ######################### (100%)\r'
	echo -ne '\n'
}

writeIndexFile(){
	path_name=$2;
	file_name=$1;
	file_path_name=$path_name/$file_name/index.js
	echo 'import' $file_name 'from' "'./$file_name';" >> $file_path_name
	echo '' >> $file_path_name
	echo $file_name'.defaultProps = {' >> $file_path_name
	echo '' >> $file_path_name
	echo " displayName:' $file_name'," >> $file_path_name
	echo '' >> $file_path_name
	echo '};' >> $file_path_name
	echo '' >> $file_path_name
	echo 'export default' $file_name >> $file_path_name
}
writeArrowFile(){
	path_name=$2;
	file_name=$1;
	file_path_name=$path_name/$file_name/$file_name.jsx
	echo "import React from 'react';" >> $file_path_name
	echo "import Style from './$file_name.style.js';" >> $file_path_name
	echo '' >> $file_path_name
	echo "const" $file_name "= (props) => {" >> $file_path_name
	echo "  return( <h1> Hello $file_name </h1> );" >> $file_path_name
	echo "}" >> $file_path_name
	echo '' >> $file_path_name
	echo 'export default' $file_name >> $file_path_name
}
writeFunctionFile(){
	path_name=$2;
	file_name=$1;
	file_path_name=$path_name/$file_name/$file_name.jsx
	echo "import React from 'react';" >> $file_path_name
	echo "import Style from './$file_name.style.js';" >> $file_path_name
	echo '' >> $file_path_name
	echo "function" $file_name "(props) {" >> $file_path_name
	echo "  return( <h1> Hello $file_name </h1> );" >> $file_path_name
	echo "}" >> $file_path_name
	echo '' >> $file_path_name
	echo 'export default' $file_name >> $file_path_name
}
writeClassFile(){
	path_name=$2;
	file_name=$1;
	file_path_name=$path_name/$file_name/$file_name.jsx
	echo "import React from 'react';" >> $file_path_name
	echo "import Style from './$file_name.style.js';" >> $file_path_name
	echo '' >> $file_path_name
	echo "class" $file_name "extends React.Component {" >> $file_path_name
	echo '' >> $file_path_name
	echo '	constructor(props) {' >> $file_path_name
	echo '		super(props);' >> $file_path_name
	echo '	}' >> $file_path_name
	echo '' >> $file_path_name
	echo "	render() {" >> $file_path_name
	echo "  	return( <h1> Hello $file_name </h1> );" >> $file_path_name
	echo "	}" >> $file_path_name
	echo "}" >> $file_path_name
	echo '' >> $file_path_name
	echo 'export default' $file_name >> $file_path_name
}
switchWrite() {
	flag=$1
	name=$2
	path=$3
	if [ -z $flag ];
		then writeArrowFile $name $path
	else
		case $flag in
		"$arrow_flag")
			writeArrowFile $name $path
			;;
		"$class_flag")
			writeClassFile $name $path
			;;
		"$function_flag")
			writeFunctionFile $name $path
			;;
		*)
			echo "Error: 🧨  Flag not found"
			;;
		esac
  	fi
}
createFilesFoldersComponent() {
	name=$1;
	path=$2;
	flag=$3;
	mkdir -p $path/$name
	touch $path/$name/index.js
	writeIndexFile $name $path
	touch $path/$name/$name.jsx
	switchWrite $flag $name $path
	touch $path/$name/$name.style.js
	echo -ne '\n'
	echo -e "🎉 ${GREEN} The Component $name was created 🎉 ${NC}"
}
createFilesFoldersContainer() {
	name=$1;
	path=$2;
	flag=$3;
	mkdir -p $path/$name
	touch $path/$name/index.js
	writeIndexFile $name $path
	touch $path/$name/$name.jsx
	switchWrite $flag $name $path
	echo -ne '\n'
	echo -e "🎉 ${GREEN} The Container $name was created 🎉 ${NC}"
}
createInitProject() {
	path=$1
	mkdir -p $path/$rootpath/'components';
	mkdir -p $path/$rootpath/'containers';
	mkdir -p $path/$rootpath/'pages';
	mkdir -p $path/$rootpath/'app';
	mkdir -p $path/$rootpath/'hooks';
	mkdir -p $path/$rootpath/'utils';
	mkdir -p $path/$rootpath/'services';
	mkdir -p $path/$rootpath/'redux';
	mkdir -p $path/$rootpath/'providers';
	createFilesFoldersComponent 'Hellow' "$1/src/components" '-f'
	createFilesFoldersContainer 'HellowActions' "$1/src/containers" '-f'
	echo -ne '\n'
	echo -e "🎉 ${GREEN} The Project was built, Happy Hack 🎉 ${NC}"
}
switchAction() {
	action=$1
	component_name=$2
	final_path=$3
	flag=$4
	case $action in
	"$container_action")
		createFilesFoldersContainer $component_name $final_path $flag;
		;;
	"$component_action")
		createFilesFoldersComponent $component_name $final_path $flag;
		;;
	*)
		echo "Error: 🧨  Something was wrong"
		;;
	esac
}
handlerCreator () {
	action=$1
	flag=$2
	name=$3
	path=$4
	final_path=$(buildRoute "$path" "$action");
	component_name="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"
	if [ -d ${final_path} ]
	then
		if [ ! -z $component_name ];
		then echo "Status: 👩‍💻 Checking if the $action already exist..."
		if [ ! -d ${final_path}/${component_name} ]
			then
			echo -e "Status: ${GREEN}✔ Successfully check${NC}"
			echo "Status: 👨‍💻 Creating $action"
			loadModule
			switchAction $action $component_name $final_path $flag;
		else
			echo "Warning: 👮‍♂ The $action alreay exist"
		fi
		else
			echo "Error: 🧨  The $action name can not be empty"
		fi
	else
		echo "Error: 🧨  The path does not exist"
	fi
}
handlerInit() {
	component_name=$1
	if [ ! -z $component_name ];
	then
		echo -e "Status: 👨‍💻 ${GREEN} Starting project...${NC}"
		npx create-react-app "$component_name"
		createInitProject "$component_name"
	else
		echo "Error: 🧨 reactlt --init needs the project name"
	fi
}
printListCommands() {
	echo -ne '\n'
	echo "Commands:"
	echo "	component [flag]* [ name ]* [ custom_path ]  for create presentational elements"
	echo "	container [flag]* [ name ]* [ custom_path ]  for create funcional elements"
	echo -ne '\n'
	echo "Flags:"
	echo "	-f  for create function element"
	echo "	-a  for create arrow function element"
	echo "	-c  for create class element"
	echo -ne '\n'
	echo "Options:"
	echo "	--help   Print all commands and options"
	echo "	--load   Load any file with your element template"
	echo "	--init   Build your custom element rules"
	echo "	--about  Print info about creator"
	echo -ne '\n'
}



if [ ! -z $1 ];
	then
		case $1 in
		"$container_action")
			handlerCreator "$1" "$2" "$3" "$4"
			;;
		"$component_action")
			handlerCreator "$1" "$2" "$3" "$4"
			;;
		"$help_action")
			printListCommands
			;;
		"$init_action")
			handlerInit "$2"
			;;
		"$load_action")
			echo '🧞‍ Hey!: reactlt load'
			;;
		"$about_action")
			echo '🧞‍ Hey!: reactlt about'
			;;
		*)
			echo 'Error: 🧨  command' $1 'not found'
			;;
		esac
else
	echo '🧞‍ Hey!: reactlt needs some command'
	echo '   Check the commands list with reactlt --help'
fi
