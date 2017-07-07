#!/bin/bash
CID=$1
#GTYPE=$2
#GDFV=$3
HOME=~
ASSETDIR=$2
TESTLOCATION="Documents/Development/gdf_validator_malone/0.1"
PASS_FAIL="FAILED"
exception=1
Red='\033[0;31m'
Green='\033[0;32m'
Blue='\033[0;34m'
normal='\e[0m'

#run this script before this line: if ! [[ -d "${HOME}/gdf_packets/" && -x "${HOME}/gdf_packets/" ]]; then of the build_game script in /usr/local/bin 
function init_validation() {
	default_path=default/path/to/source.txt
	validate_affirmation
	validate_background
	validate_gameplay
	validate_instructions
}

function validate_affirmation() {
	#Read the text file
	echo "Validating affirmations...."
  fileName="$HOME/$TESTLOCATION/tmp/games/$CID/assets/SOURCE/animations/affirmation/animation.js"
  referenced_obj_line=""
  targetLine=""
  frame_aff="_frame_Affirmation"
  required_object="lib._animation_Affirmation"
  occurance=0;
  cleanItem=""
  
  validationArray=(
  "_frame_Affirmation01"
	"_frame_Affirmation02"
	"_frame_Affirmation03"
	"_frame_Affirmation04"
	"_frame_Affirmation05"
	"_frame_Affirmation06"
	"_frame_Affirmation07"
	"_frame_Affirmation08"
	"_frame_Affirmation09"
  )
  
  #Find the line that contains the text matching the 'frame_aff and required_object' variables above
  while IFS='' read -r line
  do
    #Find occurance of required_object
    if [[ "$line" =~ "$required_object" ]];
    then
    	referenced_obj_line="$line"
    fi
    #Find occurance of frame_aff
    if [[ "$line" =~ "$frame_aff" ]];
      then 
        targetLine="$line"
    fi
  done < "$fileName"
  
  if [[ "$targetLine" == "" ]];
  then
  	echo "No occurances of $frame_aff* were found in the affirmation/animation.js file."
  	#exit with error code 100 which can be mapped to specified string not found in animation.js: $frame_aff
  fi
  
  if [[ "$referenced_obj_line" == "" ]];
  then
  	echo "No occurances of $required_object* were found in the affiration/animation.js file."
  else
  	echo "Found the required $required_object object"
  	#exit with error code 101 which can be mapped to specified string not found in animation.js: $frame_aff
  fi
    
  #Iterate through the long string to match the occurance of the affirmation string
  IFS=","
  for item in $targetLine; do
  #for item in ${validationArray[@]}; do
  	if [[ "$item" =~ "$frame_aff" ]];
  	then
  		#Strip the characters after the ':' from the string that matches the frame_aff variable
  		cleanItem=$(echo ':'$item | sed 's/{//' | sed 's/}//' | sed 's/);//' | cut -d ':' -f 2) 
  		  		
  		if [[ "${validationArray[occurance]}" == "$cleanItem" ]];
  		then
  			echo "Found affirmation : ${validationArray[occurance]}"
  			unset validationArray[occurance]
  		fi
  		occurance=`expr $occurance + 1`
  	fi
  done
  
  if [[ "${validationArray[@]}" == "" && "$referenced_obj_line" != "" ]];
  then 
  	PASS_FAIL="PASSED"
  else
  	PASS_FAIL="FAILED"
  fi
  #Run acceptance function to raise an error if needed.  Create gdf_error.log file to print the error code and the the 
  echo -e "VALIDATION FOR $CID/assets/SOURCE/animations/affirmation/animation.js HAS $PASS_FAIL\n"
}

function validate_background() {
	echo "Validating background...."
	fileName="$HOME/$TESTLOCATION/tmp/games/$CID/assets/SOURCE/animations/background/animation.js"
	required_obj="lib._animation_Background"
	required_line_obj=""
		
	while IFS='' read -r line
	do 
		if [[ "$line" =~ "$required_obj" ]];
		then
			echo "Found the $required_obj object"
			required_line_obj="$line"
		fi
	done < "$fileName" 
		
	if [[ "$required_line_obj" == "" ]];
	then
		PASS_FAIL="FAILED"
		echo "No occurances of $required_obj we found in $CID/assets/SOURCE/animations/background/animation.js"
	else
		PASS_FAIL="PASSED"
		#exit 102 Map to error message
	fi
	#echo "No occurances of $required_obj we found in background/animation.js.  "
	echo -e "VALIDATION FOR $CID/assets/SOURCE/animations/background/animation.js HAS $PASS_FAIL\n"
}


function validate_gameplay() {
	echo "Validating gameplay...."
	i=0;
	
	fileName="$HOME/$TESTLOCATION/tmp/games/$CID/assets/SOURCE/animations/gameplay/animation.js"
	required_line_obj=""
	validationArray=(
	"lib._animation_Gameplay"
	"lib._animation_CountdownAnimationIntro"
	"lib._animation_CountdownAnimationPayoff"
	"lib._animation_CountdownAnimationTimer"
	"lib._animation_CountDownBar"
	"lib._animation_CountdownIdle"
	"_frame_CountdownIdleLoop"
	"lib._animation_CurrentRoundDisplay"
	"lib._animation_ScoreBar"
	"_frame_Countdown"
	"_frame_CountdownComplete"
	"_frame_CountdownIdleLoop"
	"_frame_CountdownLoopStart"
	"_frame_CountdownLoopEnd"
	)
	
	while IFS='' read -r line
	do
		#Scan each line for these reqirements and remove entry from the array if found
		if [[ "$line" =~ "${validationArray[0]}" ]];
    then
      echo "Found the ${validationArray[0]} object"
      unset validationArray[0]
    fi
    if [[ "$line" =~ "${validationArray[1]}" ]];
    then
      echo "Found the ${validationArray[1]} object"
      unset validationArray[1]
    fi
    if [[ "$line" =~ "${validationArray[2]}" ]];
    then
      echo "Found the ${validationArray[2]} object"
      unset validationArray[2]
    fi
    if [[ "$line" =~ "${validationArray[3]}" ]];
    then
      echo "Found the ${validationArray[3]} object"
      unset validationArray[3]
    fi
    if [[ "$line" =~ "${validationArray[4]}" ]];
    then
      echo "Found the ${validationArray[4]} object"
      unset validationArray[4]
    fi
    if [[ "$line" =~ "${validationArray[5]}" ]];
    then
      echo "Found the ${validationArray[5]} object"
      unset validationArray[5]
    fi
    if [[ "$line" =~ "${validationArray[6]}" ]];
    then
      echo "Found the ${validationArray[6]} object"
      unset validationArray[6]
    fi
    if [[ "$line" =~ "${validationArray[7]}" ]];
    then
      echo "Found the ${validationArray[7]} object"
      unset validationArray[7]
    fi
    if [[ "$line" =~ "${validationArray[8]}" ]];
    then
      echo "Found the ${validationArray[8]} object"
      unset validationArray[8]
    fi
    if [[ "$line" =~ "${validationArray[9]}" ]];
    then
      echo "Found the ${validationArray[9]} object"
      unset validationArray[9]
    fi
    if [[ "$line" =~ "${validationArray[10]}" ]];
    then
      echo "Found the ${validationArray[10]} object"
      unset validationArray[10]
    fi
    if [[ "$line" =~ "${validationArray[11]}" ]];
    then
      echo "Found the ${validationArray[11]} object"
      unset validationArray[11]
    fi
    if [[ "$line" =~ "${validationArray[12]}" ]];
    then
      echo "Found the ${validationArray[12]} object"
      unset validationArray[12]
    fi    
    if [[ "$line" =~ "${validationArray[13]}" ]];
    then
      echo "Found the ${validationArray[13]} object"
      unset validationArray[13]
    fi
		
	done < "$fileName"
	
	#echo "The validationArray ${validationArray[@]}"
	if [[ "${validationArray[@]}" == "" ]];
	then
		PASS_FAIL="PASSED"
	else
		PASS_FAIL="FAILED"
		echo "The missing values from $CID/assets/SOURCE/animations/gameplay/animation.js are: ${validationArray[@]}"
	fi
	echo -e "VALIDATION FOR $CID/assets/SOURCE/animations/gameplay/animation.js has $PASS_FAIL\n"
}

function validate_instructions() {
	echo "Validating instructions...."
	i=0
	j=0
	fileName="$HOME/$TESTLOCATION/tmp/games/$CID/assets/SOURCE/animations/instructions/animation.js"
	required_object_instructions="lib._animation_Instructions"
	required_object_playbutton="lib._animation_PlayButton"
	target_line=""
	target_item=""
	
	required_object_array=(
	$required_object_instructions
	$required_object_playbutton
	)
	
	validationArray=(
		"_frame_Intro"
		"_frame_Loop"
		"_frame_Outro"
	)
	
	while IFS='' read -r line
	do
		#Locate the items in the required_object_array
		if [[ "$line" =~ "${required_object_array[i]}" ]];
		then
			echo "Found the ${required_object_array[i]}"
			unset required_object_array[i]
			i=`expr $i + 1`
		fi
		
		#Find the target line which contains the _frame_* text
		if [[ "$line" =~ "${validationArray[0]}" ]];
		then
			echo "Found the instructions line:  The Array: ${validationArray[0]}"
			target_line="$line"
			#j=`expr $j + 1`
		fi
	done < "$fileName" 
	
	#Isolate the _frame_* items from the animation.js script
	IFS="{}"
	for item in $target_line; do
		if [[ "$item" =~ "${validationArray[0]}" ]];
		then
			echo "Matches: $item"
			target_item="$item"
		fi
	done
	
	#iterate through item line  to find matching validation array items
	IFS=","
	for frameItem in $target_item; do
		if [[ "$frameItem" =~ "${validationArray[$j]}" ]];
		then
			echo "Found required items: $frameItem"
			unset validationArray[j]
		fi
		j=`expr $j + 1`
	done

if [[ "${required_object_array[@]}" == "" && ${validationArray[@]} == "" ]];
	then
		PASS_FAIL="PASSED"
	else
		PASS_FAIL="FAILED"
		echo "These are the missing elements from $CID/assets/SOURCE/animations/instructions/animation.js: ${required_object_array[@]} ${validationArray[@]}"
	fi
	echo  -e "VALIDATION FOR $CID/assets/SOURCE/animations/instructions/animation.js has $PASS_FAIL\n"
}
#accept the CID and the asset directory if needed....maybe not needed for now
init_validation $CID $ASSETDIR