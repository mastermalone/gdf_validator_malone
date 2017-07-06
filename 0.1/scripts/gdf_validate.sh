#!/bin/bash
CID=$1
#GTYPE=$2
#GDFV=$3
HOME=~
ASSETDIR=$2
TESTLOCATION="Documents/Development/gdf_validation/0.1"
VALIDATION_PASSED="false"

#run this script before this line: if ! [[ -d "${HOME}/gdf_packets/" && -x "${HOME}/gdf_packets/" ]]; then of the build_game script in /usr/local/bin 
function init_validation() {
	default_path=default/path/to/source.txt
	#echo "List the file path" 
	#read file_path
	#if [ "$file_path" ];
	#then 
		#read file_path
		#echo "The file path is: $file_path" 
	#else
		#echo "You did not specify a path.  Using default path of $default_path"
 		#echo "The file path is: $file_path" 
	#fi
	validate_affirmation
	validate_background
	validate_gameplay
}

function validate_affirmation() {
	#Read the text file
	echo "The CID $CID"
	echo "The HOME $HOME"
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
    val="$line"
    #Find occurance of required_object
    if [[ "$val" =~ "$required_object" ]];
    then
    	echo "Found the required Object, called $required_object."
    	referenced_obj_line="$required_object"
    fi
    #Find occurance of frame_aff
    if [[ "$val" =~ "$frame_aff" ]];
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
  	#exit with error code 101 which can be mapped to specified string not found in animation.js: $frame_aff
  fi
  
  #echo "The Target Line: $targetLine"TODO remove this
  
  #Iterate through the long string to match the occurance of the affirmation string
  IFS=","
  for item in $targetLine; do
  #for item in ${validationArray[@]}; do
  	if [[ "$item" =~ "$frame_aff" ]];
  	then
  		#echo "The item: $item"
  		#echo "Found Affirmation:  $item" | sed 's/{//' | sed 's/}//' | sed 's/);//'

  		#echo ": $item" | sed 's/{//' | sed 's/}//' | sed 's/);//' | cut -d ':' -f 2

  		#Strip the characters after the ':' from the string that matches the frame_aff variable
  		cleanItem=$(echo ':'$item | sed 's/{//' | sed 's/}//' | sed 's/);//' | cut -d ':' -f 2) 
  		
  		echo "Clean Item $cleanItem"
  		#echo "Found Affirmation entry:  $item"
  		
  		if [[ "${validationArray[occurance]}" == "$cleanItem" ]];
  		then
  			echo "Found affirmation : ${validationArray[occurance]}"
  			unset validationArray[occurance]
  		fi
  		
  		echo "The validationArray: ${validationArray[occurance]}"
  		occurance=`expr $occurance + 1`
  	fi
  done
  #Run acceptance function to raise an error if needed.  Create gdf_error.log file to print the error code and the the 
  echo $occurance
}

function validate_background() {
	fileName="$HOME/$TESTLOCATION/tmp/games/$CID/assets/SOURCE/animations/background/animation.js"
	required_obj="lib._animation_Background"
	required_line_obj=""
		
	while IFS='' read -r line
	do 
		if [[ "$line" =~ "$required_obj" ]];
		then
			echo "found the line with the value $line"
			required_line_obj="$line"
		fi
	done < "$fileName" 
		
	if [[ "$required_line_obj" == "" ]];
	then
		echo "No occurances of $required_obj we found in background/animation.js"
		#exit 102 Map to error message
	fi
}


function validate_gameplay() {
	fileName="$HOME/$TESTLOCATION/tmp/games/$CID/assets/SOURCE/animations/gameplay/animation.js"
	required_lib_obj_gameplay="lib._animation_Gameplay"
	required_lib_obj_CountdownAnimationIntro="lib._animation_CountdownAnimationIntro"
	required_lib_obj_CountdownAnimationPayoff="lib._animation_CountdownAnimationPayoff"
	required_lib_obj_CountdownAnimationTimer="lib._animation_CountdownAnimationTimer"
	required_lib_obj_CountDownBar="lib._animation_CountDownBar"
	required_lib_obj_CountdownIdle="lib._animation_CountdownIdle"
	required_lib_obj_CountdownIdleLoop="_frame_CountdownIdleLoop"
	required_lib_obj_CurrentRoundDisplay="lib._animation_CurrentRoundDisplay"
	required_lib_obj_ScoreBar="lib._animation_ScoreBar"
	frame_obj_Countdown="_frame_Countdown"
	frame_obj_CountdownComplete="_frame_CountdownComplete"
	frame_obj_frame_CountdownIdleLoop="_frame_CountdownIdleLoop"
	frame_obj_CountdownLoopStart="_frame_CountdownLoopStart"
	frame_obj_CountdownLoopEnd="_frame_CountdownLoopEnd"
	required_line_obj=""
	
	validationArray=(
	$required_lib_obj_gameplay 
	$required_lib_obj_CountdownAnimationIntro 
	$required_lib_obj_CountdownAnimationPayoff
	$required_lib_obj_CountdownAnimationTimer
	$required_lib_obj_CountDownBar
	$required_lib_obj_CountdownIdle
	$required_lib_obj_CountdownIdleLoop
	$required_lib_obj_CurrentRoundDisplay
	$required_lib_obj_ScoreBar
	$frame_obj_Countdown
	$frame_obj_CountdownComplete
	$frame_obj_frame_CountdownIdleLoop
	$frame_obj_CountdownLoopStart
	$frame_obj_CountdownLoopEnd
	)
	while IFS='' read -r line
	do
		if [[ "$line" =~ "$required_lib_obj_gameplay " ]];
		then
			echo "Found the $required_lib_obj_gameplay object"
			unset validationArray[0]
		fi
		if [[ "$line" =~ "$required_lib_obj_CountdownAnimationIntro" ]];
		then
			echo "Found the $required_lib_obj_CountdownAnimationIntro object"
			unset validationArray[1]
		fi
		if [[ "$line" =~ "$required_lib_obj_CountdownAnimationPayoff" ]];
		then
			echo "Found the $required_lib_obj_CountdownAnimationPayoff object"
			unset validationArray[2]
		fi
		if [[ "$line" =~ "$required_lib_obj_CountdownAnimationTimer" ]];
		then
			echo "Found the $required_lib_obj_CountdownAnimationTimer object"
			unset validationArray[3]
		fi
		if [[ "$line" =~ "$required_lib_obj_CountDownBar" ]];
		then
			echo "Found the $required_lib_obj_CountDownBar object"
			unset validationArray[4]
		fi
		if [[ "$line" =~ "$required_lib_obj_CountdownIdle" ]];
		then
			echo "Found the $required_lib_obj_CountdownIdle object"
			unset validationArray[5]
		fi
		if [[ "$line" =~ "$required_lib_obj_CountdownIdleLoop" ]];
		then
			echo "Found the $required_lib_obj_CountdownIdleLoop object"
			unset validationArray[6]
		fi
		if [[ "$line" =~ "$required_lib_obj_CurrentRoundDisplay" ]];
		then
			echo "Found the $required_lib_obj_CurrentRoundDisplay object"
			unset validationArray[7]
		fi
		if [[ "$line" =~ "$required_lib_obj_ScoreBar" ]];
		then
			echo "Found the $required_lib_obj_ScoreBar object"
			unset validationArray[8]
		fi
		if [[ "$line" =~ "$frame_obj_Countdown" ]];
		then
			echo "Found the $frame_obj_Countdown object"
			unset validationArray[9]
		fi
		if [[ "$line" =~ "$frame_obj_CountdownComplete" ]];
		then
			echo "Found the $frame_obj_CountdownComplete object"
			unset validationArray[10]
		fi
		if [[ "$line" =~ "$frame_obj_frame_CountdownIdleLoop" ]];
		then
			echo "Found the $frame_obj_frame_CountdownIdleLoop object"
			unset validationArray[11]
		fi
		if [[ "$line" =~ "$frame_obj_CountdownLoopStart" ]];
		then
			echo "Found the $frame_obj_CountdownLoopStart object"
			unset validationArray[12]
		fi		
		if [[ "$line" =~ "$frame_obj_CountdownLoopEnd" ]];
		then
			echo "Found the $frame_obj_CountdownLoopEnd object"
			unset validationArray[13]
		fi
	done < "$fileName"
	
	#echo "The validationArray ${validationArray[@]}"
	if [[ "${validationArray[@]}" == "" ]];
	then
		VALIDATION_PASSED=true
	else
		VALIDATION_PASSED=false
		echo "The missing values from $CID/assets/SOURCE/animations/gameplay/animation.js are: ${validationArray[@]}"
	fi
	echo "VALIDATION_PASSED:  $VALIDATION_PASSED"
}
#accept the CID and the asset directory if needed....maybe not needed for now
init_validation $CID $ASSETDIR