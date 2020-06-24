#!/usr/bin/env bash


##################################
#  Created by Ed Houseman Jr     #            
#                                #
#  email - Justme488@gmail.com   #
#                                #
#  discord - justme488#6127      #
#                                #
##################################

######################################################################################
# In order to use this, you must have Zenity, chdman,  ciso installed on your system #
######################################################################################


#############
# Variables #
#####################################################################################################################################################################################################################################

# Define main variables 

opt1="Single File Conversion"
opt2="Batch File Conversion"
opt3="Convert cue, gdi, or toc to chd"
opt4="Convert chd to gdi"
opt5="Convert chd to bin/cue"
opt6="Convert iso to cso"
opt7="Convert cso to iso"



# Define cso compression variables

opt8="1 (fast, poor compression)"
opt9="2"
opt10="3"
opt11="4"
opt12="5"
opt13="6"
opt14="7"
opt15="8"
opt16="9"
opt17="10 (slow, high compression)"


#####################################################################################################################################################################################################################################

# Opens box asking for user input, and sets variable $action1 to $opt1 or $opt2 from user selection

action1=$(zenity --list --title="What kind of conversion?" --text="What kind of conversion?" --radiolist  --column="Pick" --column="Conversion Type" FALSE "$opt1" FALSE "$opt2")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Opens box asking for user input, and sets variable $action2 to $opt3,$opt4,$opt5,$opt6, or $opt7 from user selection

action2=$(zenity --list --height="300" --width="350" --title="How do you want to convert?" --text="How do you want to convert?" --radiolist  --column="Pick" --column="Conversion Type" FALSE "$opt3" FALSE "$opt4" FALSE "$opt5" FALSE "$opt6" FALSE "$opt7")


#exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


########################################
# Create a function for $opt1 & $opt3 #
#####################################################################################################################################################################################################################################

# Create a function for single file conversion to chd

single_tochd () {


# Asks the user for input file, and creates $single_tochd_input

single_tochd_input=$(zenity --file-selection --title="Select a file to convert to chd - Must be cue, gdi, or toc")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Takes input variable "$single_tochd_input" (path/game name.cue) , and removes the path creating variable "$single_tochd_input_basename" (game name.cue) 

single_tochd_input_basename="$(basename "$single_tochd_input")"


# Takes variable "$single_tochd_input_basename", and removes the extention (.cue) creating variable "$single_tochd_input_basename_no_ext" (game name)

single_tochd_input_basename_no_ext=${single_tochd_input_basename%.*}


# Continue to select file output directory if valid filetype (cue,gdi,toc) creating variable "$single_tochd_output", and run the rest, or go to "else" in function

if [[ $single_tochd_input_basename == *.cue ]] || [[ $single_tochd_input_basename == *.gdi ]] || [[ $single_tochd_input_basename == *.toc ]]
 then
  single_tochd_output=$(zenity --file-selection  --directory --title="Select where you want to save it")


# Exits if user hits cancel button

  if [ "$?" != 0 ]
   then
    exit
  fi


  final_single_tochd_save_dir="$single_tochd_output"/"$single_tochd_input_basename_no_ext.chd"


  # Starts creating chd if folder is selected

chdman createcd -f -i "$single_tochd_input" -o "$final_single_tochd_save_dir" | zenity --progress --pulsate --auto-kill --width="500"  --auto-close --title="Converting $single_tochd_input_basename_no_ext to chd" --text="Creating $single_tochd_input_basename_no_ext.chd"

  # Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# error pop up box if not valid filetype, and start over

else
 zenity --error --width=400 --height=200 --title="That file is not a chd file. Please try again." --text="$single_tochd_input_basename is not a cue, gdi, or toc file. Try again." && single_tochd
fi


}
########################################
# Create a function for $opt1 & $opt4 #
#####################################################################################################################################################################################################################################

# Create a function for single file conversion to chd

single_chdtogdi () {


# Asks the user for input file, and creates $single_chdtogdi_input

single_chdtogdi_input=$(zenity --file-selection --title="Select chd file to convert to gdi")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Takes input variable "$single_chdtogdi_input" (path/game name.chd) , and removes the path creating "$single_chdtogdi_input_basename" (game name.chd) 

single_chdtogdi_input_basename="$(basename "$single_chdtogdi_input")"


# Takes variable "$single_chdtogdi_input_basename", and removes the extention (.chd) creating "$single_chdtogdi_input_basename_no_ext" (game name)

single_chdtogdi_input_basename_no_ext=${single_chdtogdi_input_basename%.*}


# Continue to select file output directory if valid filetype (chd) creating "single_chdtogdi_output" and run the rest, or go to "else" in function 

if [[ $single_chdtogdi_input_basename == *.chd ]]
 then 
  single_chdtogdi_output=$(zenity --file-selection  --directory --title="Where do you want to save it? Folder will be created automatically.")

 
# Exits if user hits cancel button
if [ "$?" != 0 ]
 then
  exit
fi


# Creates a directory for the conversion
 
mkdir "$single_chdtogdi_output/$single_chdtogdi_input_basename_no_ext"


# Create final output path variable

final_single_chdtogdi_save_dir="$single_chdtogdi_output"/"$single_chdtogdi_input_basename_no_ext"/"$single_chdtogdi_input_basename_no_ext.gdi"


# Starts creating gdi from chd

chdman extractcd -f -i "$single_chdtogdi_input" -o "$final_single_chdtogdi_save_dir" | zenity --progress --auto-kill --pulsate --auto-close --width="500" --title="converting $single_chdtogdi_input_basename_no_ext" --text="Converting $single_chdtogdi_input_basename_no_ext"
  

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# error pop up box if not valid filetype, and then start over function

else 
 zenity --error --width=400 --height=200 --text="That file is not a chd file. Please try again." && single_chdtogdi
fi

}
########################################
# Create a function for $opt1 & $opt5 #
###################restartfunction##################################################################################################################################################################################################################

# Create a function for single coversion from chd to cue

single_chdtocue () {


# Asks the user for input file, creates "$single_chdtocue_input"

single_chdtocue_input=$(zenity --file-selection --title="Select chd to convert")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Takes input variable "$single_chdtocue_input" (path/game name.chd) , and removes the path creating "$single_chdtocue_input_basename" (game name.chd) 

single_chdtocue_input_basename="$(basename "$single_chdtocue_input")"


# Takes variable "$single_chdtocue_input_basename", and removes the extention (.chd) creating "$single_chdtocue_input_basename_no_ext" (game name)

single_chdtocue_input_basename_no_ext=${single_chdtocue_input_basename%.*}
  

# Continue to select file output directory if valid filetype (chd) creating "$single_chdtocue_output" and run the rest, or go to "else" in function 

if [[ $single_chdtocue_input_basename == *.chd ]]
 then
  single_chdtocue_output=$(zenity --file-selection  --directory --title="Where do you want to save it? Folder will be created automatically.")


if [ "$?" != 0 ]
 then
  exit
fi


# Create a directoryrestartfunction for the files to be extracted in

mkdir "$single_chdtocue_output"/"$single_chdtocue_input_basename_no_ext"


# Set final output path

final_single_chdtocue_save_dir="$single_chdtocue_output"/"$single_chdtocue_input_basename_no_ext"/"$single_chdtocue_input_basename_no_ext.cue"

  
# Start extracting from chd
  
chdman extractcd -f -i "$single_chdtocue_input" -o "$final_single_chdtocue_save_dir" | zenity --progress --auto-kill --pulsate --width="400" --auto-close --title "Converting $single_chdtocue_input_basename_no_ext" --text="Converting $single_chdtocue_input_basename_no_ext"

  
# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# error pop up box if not valid filetype, and then start over function

else 
 zenity --error --width=400 --height=200 --text="That file is not a chd file. Please try again." && single_chdtocue
fi

}
########################################
# Create a function for $opt1 & $opt6 #
#####################################################################################################################################################################################################################################

# Create a function for single iso to cso conversion

single_isotocso () {


# Asks the user for input file, and creates "$single_isotocso_input"

single_isotocso_input=$(zenity --file-selection --title="Select iso file to convert")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Takes input "$single_isotocso_input" (path/game name.iso) , and removes the path creating "$single_isotocso_input_basename" (game name.iso) 

single_isotocso_input_basename="$(basename "$single_isotocso_input")"


# Takes "$single_isotocso_input_basename", and removes the extention (.iso) creating "$single_isotocso_input_basename_no_ext" (game name)

single_isotocso_input_basename_no_ext=${single_isotocso_input_basename%.*}
  

if [[ $single_isotocso_input_basename == *.iso ]]
 then


# Ask user for file output folder, and creates "$single_isotocso_output"

single_isotocso_output=$(zenity --file-selection  --directory --title="Where do you want to save it?")


# Opens box asking for compression level, and sets "$action1" to "$opt8" - "$opt17" from user selection

action3=$(zenity --list --width="300" --height="400" --title="What compression level?" --text="Select compression level" --radiolist  --column="Pick" --column="Compression Level" FALSE "$opt8" FALSE "$opt9" FALSE "$opt10" FALSE "$opt11" FALSE "$opt12" FALSE "$opt13" FALSE "$opt14" FALSE "$opt15" FALSE "$opt16" FALSE "$opt17")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Starts converting to cso

ciso "$action3" "$single_isotocso_input" "$single_isotocso_output"/"$single_isotocso_input_basename_no_ext.cso" | zenity --progress --auto-kill --pulsate --width="400" --auto-close --title="Converting $single_isotocso_input_basename_no_ext" --text "Creating $single_isotocso_input_basename_no_ext.cso"
  
# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


else 
 zenity --error --width=400 --height=200 --text="That file is not a iso file. Please try again." && single_isotocso
fi

}
########################################
# Create a function for $opt1 & $opt7 #
#####################################################################################################################################################################################################################################

# Create a function for single cso to iso conversion

single_csotoiso () {


# Asks the user for input file, and creates "$single_csotoiso_input"

single_csotoiso_input=$(zenity --file-selection --title="Select cso file to convert")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Takes input variable "$single_csotoiso_input" (path/game name.cso) , and removes the path creating "$single_csotoiso_input_basename" (game name.cso) 

single_csotoiso_input_basename="$(basename "$single_csotoiso_input")"


# Takes variable "$single_csotoiso_input_basename", and removes the extention (.cso) creating "$single_csotoiso_input_basename_no_ext" (game name)

single_csotoiso_input_basename_no_ext=${single_csotoiso_input_basename%.*}
  

if [[ $single_csotoiso_input_basename == *.cso ]]
 then


# Ask user for file output folder, and creates "$single_csotoiso_output"

single_csotoiso_output=$(zenity --file-selection  --directory --title="Where do you want to save it?")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Start uncompressing .cso

ciso 0 "$single_csotoiso_input" "$single_csotoiso_output"/"$single_csotoiso_input_basename_no_ext.iso" | zenity --progress --auto-kill --pulsate --auto-close --title "Converting $single_csotoiso_input_basename_no_ext" --text "creating $single_csotoiso_input_basename_no_ext.iso"
  
# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


else 
 zenity --error --width=400 --height=200 --text="That file is not a cso file. Please try again." && single_csotoiso
fi

}
########################################
# Create a function for $opt2 & $opt3 #
#####################################################################################################################################################################################################################################

# Create a function for batch conversion to chd

batch_tochd () {


# Asks the user for input folder, and creates "$batch_tochd_input"

batch_tochd_input=$(zenity --file-selection --directory --title="Select your main folder to convert to chd")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Asks the user for output folder, and creates "$batch_tochd_output"

batch_tochd_output=$(zenity --file-selection --directory --title="Where do you want to save them?")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Loop through games folder recursively looking for cue, gdi, and toc files
 
for batch_tochd_file in "$batch_tochd_input"/*/*.{cue,gdi,toc}; do


# Removes path for file in loop, creating "$batch_chdtogdi_file_basename" (filename.chd)

batch_tochd_file_basename="$(basename "$batch_tochd_file")"


# Takes the basename "batch_tochd_file_basename", and removes extension (cue, gdi, or toc) creating "$batch_tochd_file_basename_no_ext" (filename)

batch_tochd_file_basename_no_ext=${batch_tochd_file_basename%.*}

# Create a smaller output path "$final_batch_tochd_output". (output path = output folder selected / input file basename with no extension) and adds .chd

final_batch_tochd_output="$batch_tochd_output"/"$batch_tochd_file_basename_no_ext.chd"


# Start converting to chd

chdman createcd -f -i "$batch_tochd_file" -o "$final_batch_tochd_output" | zenity --progress --pulsate --auto-kill --auto-close --title="Converting files to chd" --text="Converting $batch_tochd_file_basename_no_ext to chd"; done


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

}
########################################
# Create a function for $opt2 & $opt4 #
#####################################################################################################################################################################################################################################


# Create a function for batch Convertion from chd to gdi

batch_chdtogdi() {


# Asks the user for input folder, and creates "$batch_tochd_input"

batch_chdtogdi_input=$(zenity --file-selection --directory --title="Select the folder where you keep your chd files")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Asks the user for output folder, and creates "$batch_tochd_output"

batch_chdtogdi_output=$(zenity --file-selection --directory --title="Where you want to save all of these folders?")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Loop through games folder recursively looking for chd files
 
for batch_chdtogdi_file in "$batch_chdtogdi_input"/*.chd; do


# Removes path for file in loop, creating "$batch_chdtogdi_file_basename" (filename.chd)

batch_chdtogdi_file_basename="$(basename "$batch_chdtogdi_file")"


# Takes the basename "batch_chdtogdi_file_basename", and removes extension (.chd) creating "$batch_chdtogdi_file_basename_no_ext" (filename)

batch_chdtogdi_file_basename_no_ext=${batch_chdtogdi_file_basename%.*}


# Create a smaller output path "$final_batch_chdtogdi_output". (output path = output folder selected / input file basename with no extension / input file basename with no extension)

final_batch_chdtogdi_output="$batch_chdtogdi_output"/"$batch_chdtogdi_file_basename_no_ext"/"$batch_chdtogdi_file_basename_no_ext.gdi"


# Create a directory so all files have their own folder

mkdir "$batch_chdtogdi_output"/"$batch_chdtogdi_file_basename_no_ext"


# Start converting to gdi

chdman extractcd -f -i "$batch_chdtogdi_file" -o "$final_batch_chdtogdi_output" | zenity --progress --pulsate --auto-kill --auto-close --title="converting chd files to gdi" --text="Converting $batch_chdtogdi_file_basename_no_ext to gdi"; done


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

}
########################################
# Create a function for $opt2 & $opt5 #
#####################################################################################################################################################################################################################################

# Create a function for batch Convertion from chd to bin/cue

batch_chdtocue() {


# Asks the user for input folder, and creates "$batch_chdtocue_input"

batch_chdtocue_input=$(zenity --file-selection --directory --title="Select the folder where you keep your chd files")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Asks the user for output folder, and creates "$batch_chdtocue_output"

batch_chdtocue_output=$(zenity --file-selection --directory --title="Where you want to save all of these folders?")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Loop through games folder recursively looking for chd files
 
for batch_chdtocue_file in "$batch_chdtocue_input"/*.chd; do


# Removes path for file in loop, creating "$batch_chdtocue_file_basename" (filename.chd)

batch_chdtocue_file_basename="$(basename "$batch_chdtocue_file")"


# Takes the basename "batch_chdtocue_file_basename", and removes extension (.chd) creating "$batch_chdtocue_file_basename_no_ext" (filename)

batch_chdtocue_file_basename_no_ext=${batch_chdtocue_file_basename%.*}


# Create a smaller output path "$final_batch_chdtocue_output". (output path = output folder selected / input file basename with no extension / input file basename with no extension)

final_batch_chdtocue_output="$batch_chdtocue_output"/"$batch_chdtocue_file_basename_no_ext"/"$batch_chdtocue_file_basename_no_ext.cue"


# Create a directory so all files have their own folder

mkdir "$batch_chdtocue_output"/"$batch_chdtocue_file_basename_no_ext"


# Start converting to bin/cue

chdman extractcd -f -i "$batch_chdtocue_file" -o "$final_batch_chdtocue_output" | zenity --progress --pulsate --auto-kill --auto-close --title="converting chd files to bin/cue" --text="Converting $batch_chdtocue_file_basename_no_ext to bin/cue"; done


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

}
########################################
# Create a function for $opt2 & $opt6 #
#####################################################################################################################################################################################################################################

# Create a function for batch iso to cso conversion

batch_isotocso() {


# Asks the user for input folder, and creates "$batch_isotocso_input"

batch_isotocso_input=$(zenity --file-selection --directory --title="Select the folder where you keep your iso files")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Asks the user for output folder, and creates "$batch_isotocso_output"

batch_isotocso_output=$(zenity --file-selection --directory --title="Where do you want to save them?")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Opens box asking for compression level, and sets "$action4" to "$opt8" - "$opt17" from user selection

action4=$(zenity --list --width="300" --height="400" --title="What compression level?" --text="Select compression level" --radiolist  --column="Pick" --column="Compression Level" FALSE "$opt8" FALSE "$opt9" FALSE "$opt10" FALSE "$opt11" FALSE "$opt12" FALSE "$opt13" FALSE "$opt14" FALSE "$opt15" FALSE "$opt16" FALSE "$opt17")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Loop through games folder recursively looking for iso files
 
for batch_isotocso_file in "$batch_isotocso_input"/*.iso; do


# Removes path for file in loop, creating "$batch_isotocso_file_basename" (filename.iso)

batch_isotocso_file_basename="$(basename "$batch_isotocso_file")"


# Takes the basename "batch_isotocso_file_basename", and removes extension (.iso) creating "$batch_isotocso_file_basename_no_ext" (filename)

batch_isotocso_file_basename_no_ext=${batch_isotocso_file_basename%.*}


# Start converting to cso

ciso "$action4" "$batch_isotocso_file" "$batch_isotocso_output"/"$batch_isotocso_file_basename_no_ext.cso" | zenity --progress --auto-kill --pulsate --width="400" --auto-close --title="Converting iso to cso" --text "Creating $batch_isotocso_file_basename_no_ext.cso"; done


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

}
########################################
# Create a function for $opt2 & $opt7 #
#####################################################################################################################################################################################################################################

# Create a function for batch cso to iso conversion

batch_csotoiso() {


# Asks the user for input folder, and creates "$batch_csotoiso_input"

batch_csotoiso_input=$(zenity --file-selection --directory --title="Select the folder where you keep your cso files")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Asks the user for output folder, and creates "$batch_csotoiso_output"

batch_csotoiso_output=$(zenity --file-selection --directory --title="Where you want to save them")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Loop through games folder recursively looking for cso files
 
for batch_csotoiso_file in "$batch_csotoiso_input"/*.cso; do


# Removes path for file in loop, creating "$batch_csotoiso_file_basename" (filename.cso)

batch_csotoiso_file_basename="$(basename "$batch_csotoiso_file")"


# Takes the basename "batch_csotoiso_file_basename", and removes extension (.cso) creating "$batch_csotoiso_file_basename_no_ext" (filename)

batch_csotoiso_file_basename_no_ext=${batch_csotoiso_file_basename%.*}


# Start converting to iso

ciso 0 "$batch_csotoiso_file" "$batch_csotoiso_output"/"$batch_csotoiso_file_basename_no_ext.iso" | zenity --progress --auto-kill --pulsate --width="400" --auto-close --title="Converting cso to iso" --text "Creating $batch_csotoiso_input_basename_no_ext.iso"; done


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

}
################################
# Create a function to restart #
#####################################################################################################################################################################################################################################

restartfunction() {

zenity --question --text "Do you have more files to convert?"
if [ "$?" = 0 ]
 then
  Game-Converter.sh
else
 exit
fi

}
########  
# Main #
#####################################################################################################################################################################################################################################

# If user selected "Single File Conversion", and " Convert to chd"

if [ "$action1" = "$opt1" ] && [ "$action2" = "$opt3" ]
 then
  single_tochd

# If user selected "Single File Conversion", and "Convert chd to gdi"

elif [ "$action1" = "$opt1" ] && [ "$action2" = "$opt4" ]
 then
  single_chdtogdi

# If user selected "Single File Conversion", and "Convert chd to bin/cue""

elif [ "$action1" = "$opt1" ] && [ "$action2" = "$opt5" ]
 then
  single_chdtocue

# If user selected "Single File Conversion", and "Convert iso to cso"

elif [ "$action1" = "$opt1" ] && [ "$action2" = "$opt6" ]
 then
  single_isotocso

# If user selected "Single File Conversion", and "Convert iso to cso"

elif [ "$action1" = "$opt1" ] && [ "$action2" = "$opt7" ]
 then
  single_csotoiso

# If user selected "batch Conversion", and " Convert to chd"

elif [ "$action1" = "$opt2" ] && [ "$action2" = "$opt3" ]
 then
  batch_tochd

# If user selected "batch Conversion", and "Convert chd to gdi"

elif [ "$action1" = "$opt2" ] && [ "$action2" = "$opt4" ]
 then
  batch_chdtogdi

# If user selected "batch Conversion", and "Convert chd to bin/cue""

elif [ "$action1" = "$opt2" ] && [ "$action2" = "$opt5" ]
 then
  batch_chdtocue

# If user selected "batch Conversion", and "Convert iso to cso"

elif [ "$action1" = "$opt2" ] && [ "$action2" = "$opt6" ]
 then
  batch_isotocso

# If user selected "batch Conversion", and "Convert cso to iso"

elif [ "$action1" = "$opt2" ] && [ "$action2" = "$opt7" ]
 then
  batch_csotoiso
fi

restartfunction
    

exit
###########################################################################################################################################################################################
