#!/usr/bin/env bash

###########################################################################################################################
# In order to use this, you must have chdman in /home/<user>/.local/bin directory, and have ciso installed on your system #
###########################################################################################################################


#############
# Variables #
#####################################################################################################################################################################################################################################

# Define main variables 

opt1="Single File Conversion"
opt2="Batch File Conversion"
opt3="Convert cue, gdi, or toc to chd"
opt4="Convert chd to gdi"
opt5="Extract chd"
opt6="Convert iso to cso"
opt7="Extract cso to iso"



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

# Game organization variables

opt18="GameSystem/GameName/GameName.cue Every cue, gdi, or toc file in its own folder"
opt19="GameSystem/GameName.cue All cue, gdi, or toc files in 1 folder"

#####################################################################################################################################################################################################################################

# Opens box asking for user input, and sets the variable $action1 to $opt1 or $opt2 from user selection

action1=$(zenity --list --title="What kind of conversion?" --text="What kind of conversion?" --radiolist  --column="Pick" --column="Conversion Type" FALSE "$opt1" FALSE "$opt2")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Opens box asking for user input, and sets the variable $action2 to $opt3,$opt4,$opt5,$opt6, or $opt7 from user selection

action2=$(zenity --list --height="300" --width="350" --title="How do you want to convert?" --text="Conversion" --radiolist  --column="Pick" --column="Conversion" FALSE "$opt3" FALSE "$opt4" FALSE "$opt5" FALSE "$opt6" FALSE "$opt7")


#exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


########################################
# Create a function for $opt1 & $$opt3 #
#####################################################################################################################################################################################################################################
# Create a function for single file conversion to chd

single_tochd () {


# Asks the user for input file, and sets the variable for $single_tochd_input

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


# Continue if valid filetype (cue,gdi,toc) or start over.

if [[ $single_tochd_input_basename == *.cue ]] || [[ $single_tochd_input_basename == *.gdi ]] || [[ $single_tochd_input_basename == *.toc ]]
 then
  single_tochd_output=$(zenity --file-selection  --directory --title="Select where you want to save it")


# Exits if user hits cancel button

  if [ "$?" != 0 ]
   then
    exit
  fi

else 
 zenity --error --width=400 --height=200 --text="$single_tochd_input_basename is not a cue, gdi, or toc file. Try again." && single_tochd
fi

 #echo "$single_tochd_input_basename is not a cue, gdi, or toc file" && 
# Starts creating chd if folder is selected

chdman createcd -f -i "$single_tochd_input" -o "$single_tochd_output/$single_tochd_input_basename_no_ext.chd" | zenity --progress --auto-kill --width="400" --pulsate --auto-close --title="Converting $single_tochd_input_basename to chd" --text="Creating $single_tochd_input_basename_no_ext.chd"


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

}
########################################
# Create a function for $opt1 & $$opt4 #
#####################################################################################################################################################################################################################################

# Create a function for single file conversion to chd

single_chdtogdi() {


# Asks the user for input file, and sets the variable for $single_chdtogdi_input

single_chdtogdi_input=$(zenity --file-selection --title="Select a chd file to convert to gdi")


# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


# Takes input variable "$single_chdtogdi_input" (path/game name.chd) , and removes the path creating variable "$single_chdtogdi_input_basename" (game name.chd) 

single_chdtogdi_input_basename="$(basename "$single_chdtogdi_input")"


# Takes variable "$single_chdtogdi_input_basename", and removes the extention (.chd) creating variable "$single_chdtogdi_input_basename_no_ext" (game name)

single_chdtogdi_input_basename_no_ext=${single_chdtogdi_input_basename%.*}


# Continue if valid filetype, or start over (chd)

if [[ $single_chdtogdi_input_basename == *.chd ]]
 then 


# Takes variable "$single_chdtogdi_input_basename", and removes the extention (.chd) creating variable "$single_chdtogdi_input_basename_no_ext" (game name)

   single_chdtogdi_input_basename_no_ext=${single_chdtogdi_input_basename%.*}


# Exits if user hits cancel button

    if [ "$?" != 0 ]
     then
       exit
    fi


# Ask user for file output folder, and sets the variable for "$single_chdtogdi_output"

    single_chdtogdi_output=$(zenity --file-selection  --directory --title="Where do you want to save it? Folder will be created.")

 
# Creates a directory for the extraction
 
    mkdir "$single_chdtogdi_output/$single_chdtogdi_input_basename_no_ext"


# Exits if user hits cancel button
if [ "$?" != 0 ]
 then
  exit
fi

# Set final output path variable

final_single_chdtogdi_save_dir="$single_chdtogdi_output"/"$single_chdtogdi_input_basename_no_ext"/"$single_chdtogdi_input_basename_no_ext.gdi"


# Starts creating gdi from chd

chdman extractcd -f -i "$single_chdtogdi_input" -o "$final_single_chdtogdi_save_dir" | zenity --progress --auto-kill --pulsate --auto-close --title="converting $single_chdtogdi_input_basename_no_ext" --text="Converting $single_chdtogdi_input_basename"
  

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi


else 
 zenity --error --width=400 --height=200 --text="That file is not a chd file. Please try again." && single_chdtogdi
fi

}
########################################
# Create a function for $opt1 & $$opt5 #
#####################################################################################################################################################################################################################################
single_chdextract() {

# Asks the user for input file, and sets the variable for $single_chdextract_input

single_chdextract_input=$(zenity --file-selection --title="Select a chd to extract")

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Takes input variable "$single_chdextract_input" (path/game name.chd) , and removes the path creating variable "$single_chdextract_input_basename" (game name.chd) 

single_chdextract_input_basename="$(basename "$single_chdextract_input"  .chd)"

# Takes variable "$single_chdextract_input_basename", and removes the extention (.chd) creating variable "$single_chdextract_input_basename_no_ext" (game name)

single_chdextract_input_basename_no_ext=${single_chdextract_input_basename%.*}
  
# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Ask user for file output folder, and sets the variable for $single_chdtogdi_output

single_chdextract_output=$(zenity --file-selection  --directory --title="Select where you want to save it")

# Create a directory for the files to be extracted in

mkdir "$single_chdextract_output/$single_chdextract_input_basename_no_ext"

# Set final output path variable

final_single_chdextract_save_dir="$single_chdextract_output/$single_chdextract_input_basename_no_ext/$single_chdextract_input_basename.cue"

# Start extracting from chd

chdman extractcd -f -i "$single_chdextract_input" -o "$final_single_chdextract_save_dir" | zenity --progress --auto-kill --pulsate --auto-close --title "Extracting $single_chdextract_input_basename_no_ext" --text "Extracting $single_chdextract_input_basename"
  
# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

}
########################################
# Create a function for $opt1 & $$opt6 #
#####################################################################################################################################################################################################################################
single_isotocso() {

# Asks the user for input file, and sets the variable for $single_isotocso_input

single_isotocso_input=$(zenity --file-selection --title="Select a file to Compress")

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Takes input variable "$single_isotocso_input" (path/game name.iso) , and removes the path creating variable "$single_isotocso_input_basename" (game name.iso) 

single_isotocso_input_basename="$(basename "$single_isotocso_input")"

# Takes variable "$single_isotocso_input_basename", and removes the extention (.iso) creating variable "$single_isotocso_input_basename_no_ext" (game name)

single_isotocso_input_basename_no_ext=${single_isotocso_input_basename%.*}
  
# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Ask user for file output folder, and sets the variable for $single_isotocso_output

single_isotocso_output=$(zenity --file-selection  --directory --title="Select where you want to save it")


# Opens box asking for user input, and sets the variable $action1 to $opt1 or $opt2 from user selection

action3=$(zenity --list --width="300" --height="400" --title="What compression level?" --radiolist  --column="Pick" --column="Compression Level" FALSE "$opt8" FALSE "$opt9" FALSE "$opt10" FALSE "$opt11" FALSE "$opt12" FALSE "$opt13" FALSE "$opt14" FALSE "$opt15" FALSE "$opt16" FALSE "$opt17")

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Starts converting to cso

ciso "$action3" "$single_isotocso_input" "$single_isotocso_input_basename_no_ext.cso" | zenity --progress --auto-kill --pulsate --auto-close --title "Compressing $single_isotocso_input_basename_no_ext" --text "Compressing $single_isotocso_input_basename"
  
# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

}
########################################
# Create a function for $opt1 & $$opt7 #
#####################################################################################################################################################################################################################################
single_csotoiso() {

# Asks the user for input file, and sets the variable for $single_csotoiso_input

single_csotoiso_input=$(zenity --file-selection --title="Select an iso to Uncompress")

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Takes input variable "$single_csotoiso_input" (path/game name.cso) , and removes the path creating variable "$single_csotoiso_input_basename" (game name.cso) 

single_csotoiso_input_basename="$(basename "$single_csotoiso_input")"

# Takes variable "$single_csotoiso_input_basename", and removes the extention (.cso) creating variable "$single_csotoiso_input_basename_no_ext" (game name)

single_csotoiso_input_basename_no_ext=${single_csotoiso_input_basename%.*}
  
# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Ask user for file output folder, and sets the variable for $single_csotoiso_output

single_csotoiso_output=$(zenity --file-selection  --directory --title="Select where you want to save it")

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Start uncompressing .cso

ciso 0 "$single_csotoiso_input" "$single_csotoiso_output"/"$single_csotoiso_input_basename_no_ext.iso" | zenity --progress --auto-kill --pulsate --auto-close --title "Uncompressing $single_csotoiso_input_basename_no_ext" --text "creating $single_csotoiso_input_basename_no_ext.iso"
  
# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

}

########################################
# Create a function for $opt2 & $$opt3 #
#####################################################################################################################################################################################################################################

batch_tochd() {

# Asks the user for input folder, and sets the variable for $batch_tochd_input

batch_tochd_input=$(zenity --file-selection --directory --title="Select a folder to convert to chd")

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Asks the user for output folder, and sets the variable for $batch_tochd_output

batch_tochd_output=$(zenity --file-selection --directory --title="Select where you want to save them")

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit
fi

# Asks the user how their games are organized

#action4=$(zenity --list --title="How do you keep your games?" --radiolist  --width="700" --height="400" --column="Pick" --column="Organization" FALSE "$opt18" FALSE "$opt19")

#if [ "$action4" ] = [ "$opt18"  ]
 #then 
  for i in "$batch_tochd_input"/*/*.cue; do chdman createcd -f -i "$i" -o "$batch_tochd_output"/"$(basename "${i%.*}")".chd | zenity --progress --pulsate --auto-kill --auto-close --title="Converting to chd" --text="Converting $i to chd" ; done



#elif [ "$action4" ] = [ "$opt19" ]
 #then 
  #for i in "$batch_tochd_input"/*.cue; do chdman createcd -f -i "$i" -o "$batch_tochd_output"/"$(basename "${i%.*}")".chd | zenity --progress --pulsate --auto-close --title="Converting to chd" --text="Converting $i to chd" ; done
  

# Exits if user hits cancel button

if [ "$?" != 0 ]
 then
  exit && killall
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

# If user selected "Single File Conversion", and "Extract chd"

elif [ "$action1" = "$opt1" ] && [ "$action2" = "$opt5" ]
 then
  single_chdextract

# If user selected "Single File Conversion", and "Convert iso to cso"

elif [ "$action1" = "$opt1" ] && [ "$action2" = "$opt6" ]
 then
  single_isotocso

# If user selected "Single File Conversion", and "Convert iso to cso"

elif [ "$action1" = "$opt1" ] && [ "$action2" = "$opt7" ]
 then
  single_csotoiso

# If the user selects "gamesystem/gamename/gamename.cue (with gamename folders)"

elif [ "$action1" = "$opt2" ] && [ "$action2" = "$opt3" ]
 then
  batch_tochd



     
# Exits if user hits cancel button

elif [ "$?" != 0 ]
 then
  exit



fi


$SHELL
###########################################################################################################################################################################################
