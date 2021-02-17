#!/usr/bin/env bash
##################################
#  Created by Ed Houseman Jr     #
#  email - Justme488@gmail.com   #
#  discord - justme488#6127      #
##################################
##################################################################################################
# In order to use this, you must have ciso, libsdl1.2debian, and zenity installed on your system #
##################################################################################################
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
# Define chdman version variables
opt_chdman4="chdman version 4 (0.145)"
opt_chdman5="chdman version 5 (0.221)"
# Define cso compression variables
ciso1="1 (fast, poor compression)"
ciso2="2"
ciso3="3"
ciso4="4"
ciso5="5"
ciso6="6"
ciso7="7"
ciso8="8"
ciso9="9 (slow, high compression)"
#######################################
# Create a function for $opt1 & $opt3 #
#####################################################################################################################################################################################################################################
# Create a function for single file conversion to chd
single_tochd () {
  # Asks the user for input file, and creates $single_tochd_input
  single_tochd_input=$(zenity --file-selection --filename="Desktop" --title="Select a file to convert to chd - Must be cue, gdi, or toc")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Takes input variable "$single_tochd_input" (path/game name.cue) , and removes the path creating variable "$single_tochd_input_basename" (game name.cue)
  single_tochd_input_basename="$(basename "$single_tochd_input")"
  # Takes variable "$single_tochd_input_basename", and removes the extention (.cue) creating variable "$single_tochd_input_basename_no_ext" (game name)
  single_tochd_input_basename_no_ext=${single_tochd_input_basename%.*}
  # Continue to select file output directory if valid filetype (cue,gdi,toc) creating variable "$single_tochd_output", and run the rest, or go to "else" in function
  if [[ "$single_tochd_input_basename" == *.cue ]] || [[ "$single_tochd_input_basename" == *.gdi ]] || [[ "$single_tochd_input_basename" == *.toc ]]; then
    # Opens box asking which version of chdman, and sets variable "$chdman_ver" to "$chdman4" or "$chdman5"
    chdman_ver=$(zenity --list --height="200" --width="350" --title="Which version of chdman do you want to use?" --text="Which version of chdman?" --radiolist --column="Pick" --column="chd version" FALSE "$opt_chdman4" FALSE "$opt_chdman5")
      # exits if user hits cancel button
      if [[ "$?" != 0 ]]; then
        exit
      fi
    single_tochd_output=$(zenity --file-selection --directory --filename="Desktop" --title="Select where you want to save it")
      # Exits if user hits cancel button
      if [[ "$?" != 0 ]]; then
        exit
      fi
    # Create final output path
    final_single_tochd_output="$single_tochd_output"/"$single_tochd_input_basename_no_ext.chd"
    # Don't overwrite if file exists
    if [[ ! -f "$final_single_tochd_output" ]]; then
      # If chdman4 was selected, start creating chd
      if [[ "$chdman_ver" == "$opt_chdman4" ]]; then
        (chdman4 -createcd "$single_tochd_input" "$final_single_tochd_output" | zenity --progress --pulsate --auto-kill --width="400" --auto-close --title="Converting $single_tochd_input_basename_no_ext" --text="Creating: $single_tochd_input_basename_no_ext.chd")
        # Cancel conversion, and delete incomplete file if cancel is pressed
        if [[ "$?" != 0 ]]; then
          rm "$final_single_tochd_output"
          pkill chdman4
        fi
      # If chdman5 was selected, start creating chd
      elif [[ "$chdman_ver" == "$opt_chdman5" ]]; then
        (chdman5 createcd -i "$single_tochd_input" -o "$final_single_tochd_output"| zenity --progress --pulsate --auto-kill --width="400" --auto-close --title="Converting $single_tochd_input_basename_no_ext" --text="Creating: $single_tochd_input_basename_no_ext.chd")
        # Cancel conversion, and delete incomplete file if cancel is pressed.
        if [[ "$?" != 0 ]]; then
          rm "$final_single_tochd_output"
          pkill chdman5
        fi
      fi
    else
      # Display error box stating the output file already exists
      zenity --error --width="300" --title="File already exists!" --text="$single_tochd_input_basename_no_ext.chd already exists!"
    fi
  else
    # Error pop up box if not valid filetype, and start over
    zenity --error --width="500" --height="200" --title="That file is not a cue, gdi, or toc file. Please try again." --text="$single_tochd_input_basename is not a cue, gdi, or toc file. Try again." && single_tochd
  fi
}
#######################################
# Create a function for $opt1 & $opt4 #
#####################################################################################################################################################################################################################################
# Create a function for single file conversion to gdi
single_chdtogdi () {
  # Asks the user for input file, and creates $single_chdtogdi_input
  single_chdtogdi_input=$(zenity --file-selection --filename="Desktop" --title="Select chd file to convert to gdi")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Takes input variable "$single_chdtogdi_input" (path/game name.chd) , and removes the path creating "$single_chdtogdi_input_basename" (game name.chd)
  single_chdtogdi_input_basename="$(basename "$single_chdtogdi_input")"
  # Takes variable "$single_chdtogdi_input_basename", and removes the extention (.chd) creating "$single_chdtogdi_input_basename_no_ext" (game name)
  single_chdtogdi_input_basename_no_ext=${single_chdtogdi_input_basename%.*}
  # Continue to select file output directory if valid filetype (chd) creating "single_chdtogdi_output" and run the rest, or go to "else" in function
  if [[ "$single_chdtogdi_input_basename" == *.chd ]]; then
    single_chdtogdi_output=$(zenity --file-selection --directory --filename="Desktop" --title="Where do you want to save it? Folder will be created automatically.")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
    # If output directory doesn't exist
    if [[ ! -d "$single_chdtogdi_output"/"$single_chdtogdi_input_basename_no_ext" ]]; then
      # Creates a directory for the conversion
      mkdir "$single_chdtogdi_output/$single_chdtogdi_input_basename_no_ext"
      # Create final output path variable
      final_single_chdtogdi_output="$single_chdtogdi_output"/"$single_chdtogdi_input_basename_no_ext"/"$single_chdtogdi_input_basename_no_ext.gdi"
      # Starts creating gdi from chd
      (chdman5 extractcd -i "$single_chdtogdi_input" -o "$final_single_chdtogdi_output" | zenity --progress --auto-kill --pulsate --auto-close --width="500" --title="converting $single_chdtogdi_input_basename_no_ext" --text="Creating: $single_chdtogdi_input_basename_no_ext.gdi")
        # Cancel conversion, and delete incomplete file if cancel is pressed
        if [[ "$?" != 0 ]]; then
          rm -r "$final_single_chdtogdi_output"
          pkill chdman5
        fi
    else
      # Display error box stating the output folder already exists
      zenity --error --width="400" --title="Folder already exists!" --text="$single_chdtogdi_output/$single_chdtogdi_input_basename_no_ext already exists!"
    fi
  else
    # error pop up box if not valid filetype, and then start over function
    zenity --error --width="500" --height="200" --title="That file is not a chd file. Please try again." --text="$single_chdtogdi_input_basename is not a chd file. Please try again." && single_chdtogdi
  fi
}
#######################################
# Create a function for $opt1 & $opt5 #
#####################################################################################################################################################################################################################################
# Create a function for single coversion from chd to cue
single_chdtocue () {
  # Asks the user for input file, creates "$single_chdtocue_input"
  single_chdtocue_input=$(zenity --file-selection --filename="Desktop" --title="Select chd to convert")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Takes input variable "$single_chdtocue_input" (path/game name.chd) , and removes the path creating "$single_chdtocue_input_basename" (game name.chd)
  single_chdtocue_input_basename="$(basename "$single_chdtocue_input")"
  # Takes variable "$single_chdtocue_input_basename", and removes the extention (.chd) creating "$single_chdtocue_input_basename_no_ext" (game name)
  single_chdtocue_input_basename_no_ext=${single_chdtocue_input_basename%.*}
  # Continue to select file output directory if valid filetype (chd) creating "$single_chdtocue_output" and run the rest, or go to "else" in function
  if [[ "$single_chdtocue_input_basename" == *.chd ]]; then
    single_chdtocue_output=$(zenity --file-selection --directory --filename="Desktop" --title="Where do you want to save it? Folder will be created automatically.")
    if [[ "$?" != 0 ]]; then
      exit
    fi
    # Don't overwrite if folder exists
    if [[ ! -d "$single_chdtocue_output"/"$single_chdtocue_input_basename_no_ext" ]]; then    
      # Create a directory for the files to be extracted in
      mkdir "$single_chdtocue_output"/"$single_chdtocue_input_basename_no_ext"
      # Set final output path
      final_single_chdtocue_output="$single_chdtocue_output"/"$single_chdtocue_input_basename_no_ext"/"$single_chdtocue_input_basename_no_ext.cue"
      # Start extracting bin/cue from chd
      (chdman5 extractcd -i "$single_chdtocue_input" -o "$final_single_chdtocue_output" | zenity --progress --auto-kill --pulsate --width="500" --auto-close --title="Converting $single_chdtocue_input_basename_no_ext" --text="Creating:  $single_chdtocue_input_basename_no_ext.cue")
        # Cancel conversion, and delete incomplete file if cancel is pressed
        if [[ "$?" != 0 ]]; then
          rm -r "$single_chdtocue_output"/"$single_chdtocue_input_basename_no_ext"
          pkill chdman5
        fi
    else
      # Display error box stating the output folder already exists
      zenity --error --width="400" --title="Folder already exists!" --text="$single_chdtocue_output/$single_chdtocue_input_basename_no_ext already exists!"
    fi
  else
    # error pop up box if not valid filetype, and then start over function
    zenity --error --width="500" --height="200" --title="That file is not a chd file. Please try again." --text="$single_chdtocue_input_basename is not a chd file. Please try again." && single_chdtocue
  fi
}
#######################################
# Create a function for $opt1 & $opt6 #
#####################################################################################################################################################################################################################################
# Create a function for single iso to cso conversion
single_isotocso () {
  # Asks the user for input file, and creates "$single_isotocso_input"
  single_isotocso_input=$(zenity --file-selection --filename="Desktop" --title="Select iso file to convert")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Takes input "$single_isotocso_input" (path/game name.iso) , and removes the path creating "$single_isotocso_input_basename" (game name.iso)
  single_isotocso_input_basename="$(basename "$single_isotocso_input")"
  # Takes "$single_isotocso_input_basename", and removes the extention (.iso) creating "$single_isotocso_input_basename_no_ext" (game name)
  single_isotocso_input_basename_no_ext=${single_isotocso_input_basename%.*}
  if [[ "$single_isotocso_input_basename" == *.iso ]]; then
    # Ask user for file output folder, and creates "$single_isotocso_output"
    single_isotocso_output=$(zenity --file-selection --directory --filename="Desktop" --title="Where do you want to save it?")
    # Opens box asking for compression level, and sets "$action1" to "$opt9" - "$opt17" from user selection
    action3=$(zenity --list --width="300" --height="400" --title="What compression level?" --text="Select compression level \n " --radiolist --column="Pick" --column="Compression Level" FALSE "$ciso1" FALSE "$ciso2" FALSE "$ciso3" FALSE "$ciso4" FALSE "$ciso5" FALSE "$ciso6" FALSE "$ciso7" FALSE "$ciso8" TRUE "$ciso9")
      # Exits if user hits cancel button
      if [[ "$?" != 0 ]]; then
        exit
      fi
    # Reassign variables to correct value
    if [[ "$action3" == "1 (fast, poor compression)" ]]; then
      action3="1"
    elif [[ "$action3" == "9 (slow, high compression)" ]]; then
      action3="9"
    fi
    # Create final output path
    final_single_isotocso_output="$single_isotocso_output"/"$single_isotocso_input_basename_no_ext.cso"
    # Don't overwrite if file exists
    if [[ ! -f "$final_single_isotocso_output" ]]; then
      # Starts converting to cso
      (ciso "$action3" "$single_isotocso_input" "$final_single_isotocso_output" | zenity --progress --auto-kill --pulsate --width="500" --auto-close --title="Converting $single_isotocso_input_basename_no_ext" --text="Creating: $single_isotocso_input_basename_no_ext.cso")
        # Cancel conversion, and delete incomplete file if cancel is pressed
        if [[ "$?" != 0 ]]; then
          rm "$final_single_isotocso_output"
          pkill ciso
        fi
    else
      # Display error box stating the output file already exists
      zenity --error --width="400" --title="File already exists!" --text="$final_single_isotocso_output already exists!"
    fi
  else
    # error pop up box if not valid filetype, and then start over function
    zenity --error --width="500" --height="200" --title="That file is not a iso file. Please try again." --text="$single_isotocso_input_basename is not a iso file. Please try again." && single_isotocso
  fi
}
#######################################
# Create a function for $opt1 & $opt7 #
#####################################################################################################################################################################################################################################
# Create a function for single cso to iso conversion
single_csotoiso () {
  # Asks the user for input file, and creates "$single_csotoiso_input"
  single_csotoiso_input=$(zenity --file-selection --filename="Desktop" --title="Select cso file to convert")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Takes input variable "$single_csotoiso_input" (path/game name.cso) , and removes the path creating "$single_csotoiso_input_basename" (game name.cso)
  single_csotoiso_input_basename="$(basename "$single_csotoiso_input")"
  # Takes variable "$single_csotoiso_input_basename", and removes the extention (.cso) creating "$single_csotoiso_input_basename_no_ext" (game name)
  single_csotoiso_input_basename_no_ext=${single_csotoiso_input_basename%.*}
    if [[ $single_csotoiso_input_basename == *.cso ]]; then
    # Ask user for file output folder, and creates "$single_csotoiso_output"
    single_csotoiso_output=$(zenity --file-selection --directory --filename="Desktop" --title="Where do you want to save it?")
      # Exits if user hits cancel button
      if [[ "$?" != 0 ]]; then
        exit
      fi
    # Create final output path
    final_single_csotoiso_output="$single_csotoiso_output"/"$single_csotoiso_input_basename_no_ext.iso"
    # Don't overwrite if file exists
    if [[ ! -f "$final_single_csotoiso_output" ]]; then
      # Start uncompressing .cso
      (ciso 0 "$single_csotoiso_input" "$final_single_csotoiso_output" | zenity --progress --auto-kill --pulsate --width="500" --auto-close --title="Converting $single_csotoiso_input_basename_no_ext" --text="creating: $single_csotoiso_input_basename_no_ext.iso")
        # Cancel conversion, and delete incomplete file if cancel is pressed
        if [[ "$?" != 0 ]]; then
          rm "$final_single_csotoiso_output"
          pkill ciso
        fi
    else
      # Display error box stating the output file already exists
      zenity --error --width="400" --title="File already exists!" --text="$final_single_csotoiso_output already exists!"
    fi
  else
    zenity --error --width="500" --height="200" --title="That file is not a cso file. Please try again." --text="$single_csotoiso_input_basename is not a cso file. Please try again." && single_csotoiso
  fi
}
#######################################
# Create a function for $opt2 & $opt3 #
#####################################################################################################################################################################################################################################
# Create a function for batch conversion to chd
batch_tochd () {
  # Asks the user for input folder, and creates "$batch_tochd_input"
  batch_tochd_input=$(zenity --file-selection --directory --filename="Desktop" --title="Select your main folder to convert to chd")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Opens box asking which version of chdman, and sets variable "$chdman_ver" to "$chdman4" or "$chdman5"
  chdman_ver=$(zenity --list --height="200" --width="350" --title="Which version of chdman do you want to use?" --text="Which version of chdman?" --radiolist --column="Pick" --column="chd version" FALSE "$opt_chdman4" FALSE "$opt_chdman5")
    # exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Asks the user for output folder, and creates "$batch_tochd_output"
  batch_tochd_output=$(zenity --file-selection --filename="Desktop" --directory --title="Where do you want to save them?")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Set initial variables for progress bar
  percentage="1"
  tochd_division="0"
  # Loop through games folder recursively looking for cue, gdi, and toc files in a subshell
  (for batch_tochd_file in "$batch_tochd_input"/*/*.{cue,gdi,toc}; do
    # Removes path for file in loop, creating "$batch_chdtogdi_file_basename" (filename.chd)
    batch_tochd_file_basename="$(basename "$batch_tochd_file")"
    # Takes the basename "batch_tochd_file_basename", and removes extension (cue, gdi, or toc) creating "$batch_tochd_file_basename_no_ext" (filename)
    batch_tochd_file_basename_no_ext=${batch_tochd_file_basename%.*}
    # Create final output path
    final_batch_tochd_output="$batch_tochd_output"/"$batch_tochd_file_basename_no_ext.chd"
    # echo variable outside subshell to tmp file
    echo $final_batch_tochd_output > "/usr/share/game-converter/temp.tmp"
    # reassign variable percentage
    percentage=$(( $percentage + $tochd_division ))
    # Find the total number of matching files
    total_files=$(ls  "$batch_tochd_input"/*/*.{cue,gdi,toc} 2> /dev/null | wc -l)
    # echo percentage for progress bar
    echo $percentage
    # Echo text for progress bar
    echo "# Creating: $batch_tochd_file_basename_no_ext.chd \n \n Total batch progress: $percentage%"
    # Create varibale with division for progress bar increments
    tochd_division=$(( 100 / $total_files ))
    # Don't overwrite if file exists
    if [[ ! -f "$final_batch_tochd_output" ]]; then
      # Starts creating chd if folder is selected
      if [[ "$chdman_ver" == "$opt_chdman4" ]]; then
        chdman4 -createcd "$batch_tochd_file" "$final_batch_tochd_output"
      elif [[ "$chdman_ver" == "$opt_chdman5" ]]; then
        chdman5 createcd -i "$batch_tochd_file" -o "$final_batch_tochd_output"
      fi
    fi   # Pipe to progress while in subshell, but after the loop
  done | zenity --progress --width="500" --auto-close --auto-kill --title="Converting selected items to chd" --text="Creating: $batch_tochd_file_basename_no_ext.chd \n \n Total batch progress: $percentage%" --percentage="1")
  # Cancel conversion, delete incomplete file, and delete temp files if cancel is pressed
    if [[ "$?" != 0 ]]; then
      pkill chdman4 && pkill chdman5
      final_batch_tochd_output=$(cat "/usr/share/game-converter/temp.tmp")
      rm "$final_batch_tochd_output" && rm "/usr/share/game-converter/temp.tmp"
      exit
    fi
# remove Tmp file if conversion completed successfully
rm "/usr/share/game-converter/temp.tmp"
}
#######################################
# Create a function for $opt2 & $opt4 #
#####################################################################################################################################################################################################################################
# Create a function for batch Convertion from chd to gdi
batch_chdtogdi() {
  # Asks the user for input folder, and creates "$batch_tochd_input"
  batch_chdtogdi_input=$(zenity --file-selection --directory --filename="Desktop" --title="Select the folder where you keep your chd files")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Asks the user for output folder, and creates "$batch_tochd_output"
  batch_chdtogdi_output=$(zenity --file-selection --directory --filename="Desktop" --title="Where you want to save all of these folders?")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Set initial variables for progress bar
  percentage="1"
  chdtogdi_division="0"
  # Loop through games folder recursively looking for chd files in a subshell
  (for batch_chdtogdi_file in "$batch_chdtogdi_input"/*.chd; do
    # Removes path for file in loop, creating "$batch_chdtogdi_file_basename" (filename.chd)
    batch_chdtogdi_file_basename="$(basename "$batch_chdtogdi_file")"
    # Takes the basename "batch_chdtogdi_file_basename", and removes extension (.chd) creating "$batch_chdtogdi_file_basename_no_ext" (filename)
    batch_chdtogdi_file_basename_no_ext=${batch_chdtogdi_file_basename%.*}
    # Create a smaller output path "$final_batch_chdtogdi_output". (output path = output folder selected / input file basename with no extension / input file basename with no extension)
    final_batch_chdtogdi_output="$batch_chdtogdi_output"/"$batch_chdtogdi_file_basename_no_ext"/"$batch_chdtogdi_file_basename_no_ext.gdi"
    # echo variable outside subshell to tmp file
    echo $final_batch_chdtogdi_output > "/usr/share/game-converter/temp.tmp"
    echo $batch_chdtogdi_file_basename_no_ext > "/usr/share/game-converter/temp1.tmp"
    # reassign variable percentage
    percentage=$(( $percentage + $chdtogdi_division ))
    # Find the total number of matching files
    total_files=$(ls  "$batch_chdtogdi_input"/*.chd 2> /dev/null | wc -l)
    # echo percentage for progress bar
    echo $percentage
    # Echo text for progress bar
    echo "# Creating: $batch_chdtogdi_file_basename_no_ext.gdi \n \n Total batch progress: $percentage%"
    # Create varibale with division for progress bar increments
    chdtogdi_division=$(( 100 / $total_files ))
    # Don't overwrite if folder exists
    if [[ ! -d "$batch_chdtogdi_output"/"$batch_chdtogdi_file_basename_no_ext" ]]; then
      # Create a directory so all files have their own folder
      mkdir "$batch_chdtogdi_output"/"$batch_chdtogdi_file_basename_no_ext"
      # Start converting to gdi
      chdman5 extractcd -i "$batch_chdtogdi_file" -o "$final_batch_chdtogdi_output"
    fi
  done | zenity --progress --width="500" --auto-close --auto-kill --title="Converting selected items to gdi" --text="Creating: $batch_chdtogdi_file_basename_no_ext.gdi \n \n $percentage%" --percentage="1")
        # Cancel conversion, delete incomplete file, and delete temp files if cancel is pressed
        if [[ "$?" != 0 ]]; then
          pkill chdman5
          final_batch_chdtogdi_output=$(cat "/usr/share/game-converter/temp.tmp")
          batch_chdtogdi_file_basename_no_ext=$(cat "/usr/share/game-converter/temp1.tmp")
          rm -r "$batch_chdtogdi_output"/"$batch_chdtogdi_file_basename_no_ext"
          rm -f "/usr/share/game-converter/temp.tmp"
          rm -f "/usr/share/game-converter/temp1.tmp"
        fi
# remove Tmp files if conversion completed successfully
rm -f "/usr/share/game-converter/temp.tmp"
rm -f "/usr/share/game-converter/temp1.tmp"
}
#######################################
# Create a function for $opt2 & $opt5 #
#####################################################################################################################################################################################################################################
# Create a function for batch Convertion from chd to bin/cue
batch_chdtocue() {
  # Asks the user for input folder, and creates "$batch_chdtocue_input"
  batch_chdtocue_input=$(zenity --file-selection --directory --filename="Desktop" --title="Select the folder where you keep your chd files")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Asks the user for output folder, and creates "$batch_chdtocue_output"
  batch_chdtocue_output=$(zenity --file-selection --directory --filename="Desktop" --title="Where you want to save all of these folders?")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Set initial variables for progress bar
  percentage="1"
  chdtocue_division="0"
  # Loop through games folder recursively looking for chd files in a subshell
  (for batch_chdtocue_file in "$batch_chdtocue_input"/*.chd; do
    # Removes path for file in loop, creating "$batch_chdtocue_file_basename" (filename.chd)
    batch_chdtocue_file_basename="$(basename "$batch_chdtocue_file")"
    # Takes the basename "batch_chdtocue_file_basename", and removes extension (.chd) creating "$batch_chdtocue_file_basename_no_ext" (filename)
    batch_chdtocue_file_basename_no_ext=${batch_chdtocue_file_basename%.*}
    # Create final output path
    final_batch_chdtocue_output="$batch_chdtocue_output"/"$batch_chdtocue_file_basename_no_ext"/"$batch_chdtocue_file_basename_no_ext.cue"
    # echo variable outside subshell to tmp file
    echo $final_batch_chdtocue_output > "/usr/share/game-converter/temp.tmp"
    echo $batch_chdtocue_file_basename_no_ext > "/usr/share/game-converter/temp1.tmp"
    # reassign variable percentage
    percentage=$(( $percentage + $chdtocue_division ))
    # Find the total number of matching files
    total_files=$(ls  "$batch_chdtocue_input"/*.chd 2> /dev/null | wc -l)
    # echo percentage for progress bar
    echo $percentage
    # Echo text for progress bar
    echo "# Creating: $batch_chdtocue_file_basename_no_ext.cue \n \n Total batch progress: $percentage%"
    # Create varibale with division for progress bar increments
    chdtocue_division=$(( 100 / $total_files ))
    # Don't overwrite if folder exists
    if [[ ! -d "$batch_chdtocue_output"/"$batch_chdtocue_file_basename_no_ext" ]]; then
      # Create a directory so all files have their own folder
      mkdir "$batch_chdtocue_output"/"$batch_chdtocue_file_basename_no_ext"
      # Start converting to bin/cue
      chdman5 extractcd -i "$batch_chdtocue_file" -o "$final_batch_chdtocue_output"
    fi
  done | zenity --progress --width="500" --auto-close --auto-kill --title="Converting selected items to cue" --text="Creating: $batch_chdtocue_file_basename_no_ext.cue \n \n $percentage%" --percentage="1")
  # Cancel conversion, delete incomplete file, and delete temp files if cancel is pressed
  if [[ "$?" != 0 ]]; then
    pkill chdman5
    final_batch_chdtocue_output=$(cat "/usr/share/game-converter/temp.tmp")
    batch_chdtocue_file_basename_no_ext=$(cat "/usr/share/game-converter/temp1.tmp")
    rm -r "$batch_chdtocue_output"/"$batch_chdtocue_file_basename_no_ext"
    rm -f "/usr/share/game-converter/temp.tmp"
    rm -f "/usr/share/game-converter/temp1.tmp"
  fi
  # remove Tmp files if conversion completed successfully
  rm -f "/usr/share/game-converter/temp.tmp"
  rm -f "/usr/share/game-converter/temp1.tmp"
}
#######################################
# Create a function for $opt2 & $opt6 #
#####################################################################################################################################################################################################################################
# Create a function for batch iso to cso conversion
batch_isotocso() {
  # Asks the user for input folder, and creates "$batch_isotocso_input"
  batch_isotocso_input=$(zenity --file-selection --directory --filename="Desktop" --title="Select the folder where you keep your iso files")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Asks the user for output folder, and creates "$batch_isotocso_output"
  batch_isotocso_output=$(zenity --file-selection --directory --filename="Desktop" --title="Where do you want to save them?")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Opens box asking for compression level, and sets "$action4" to "$opt8" - "$opt17" from user selection
  action4=$(zenity --list --width="300" --height="400" --title="What compression level?" --text="Select compression level" --radiolist --column="Pick" --column="Compression Level" FALSE "$ciso1" FALSE "$ciso2" FALSE "$ciso3" FALSE "$ciso4" FALSE "$ciso5" FALSE "$ciso6" FALSE "$ciso7" FALSE "$ciso8" TRUE "$ciso9")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Reassign variables to correct value
    if [[ "$action4" == "1 (fast, poor compression)" ]]; then
      action3="1"
    elif [[ "$action4" == "9 (slow, high compression)" ]]; then
      action3="9"
    fi
  # Set initial variables for progress bar
  percentage="1"
  isotocso_division="0"
  # Loop through games folder recursively looking for iso files
  (for batch_isotocso_file in "$batch_isotocso_input"/*.iso; do
    # Removes path for file in loop, creating "$batch_isotocso_file_basename" (filename.iso)
    batch_isotocso_file_basename="$(basename "$batch_isotocso_file")"
    # Takes the basename "batch_isotocso_file_basename", and removes extension (.iso) creating "$batch_isotocso_file_basename_no_ext" (filename)
    batch_isotocso_file_basename_no_ext=${batch_isotocso_file_basename%.*}
    # Create final output path
    final_batch_isotocso_output="$batch_isotocso_output"/"$batch_isotocso_file_basename_no_ext.cso"
    # echo variable outside subshell to tmp file
    echo $final_batch_isotocso_output > "/usr/share/game-converter/temp.tmp"
    # reassign variable percentage
    percentage=$(( $percentage + $isotocso_division ))
    # Find the total number of matching files
    total_files=$(ls  "$batch_isotocso_input"/*.iso 2> /dev/null | wc -l)
    # echo percentage for progress bar
    echo $percentage
    # Echo text for progress bar
    echo "# Creating: $batch_isotocso_file_basename_no_ext.cso \n \n Total batch progress: $percentage%"
    # Create varibale with division for progress bar increments
    isotocso_division=$(( 100 / $total_files ))
      # Don't overwrite if file exists
      if [[ ! -f "$final_batch_isotocso_output" ]]; then
        # Start converting to cso
        ciso "$action4" "$batch_isotocso_file" "$final_batch_isotocso_output"
      fi
  done | zenity --progress --width="500" --auto-close --auto-kill --title="Converting selected items to cso" --text="Creating: $batch_isotocso_file_basename_no_ext.cso \n \n $percentage%" --percentage="1")
  # Cancel conversion, delete incomplete file, and delete temp file if cancel is pressed
  if [[ "$?" != 0 ]]; then
    rm "$final_batch_isotocso_output"
    pkill ciso
    final_batch_isotocso_output=$(cat "/usr/share/game-converter/temp.tmp")
    rm "$final_batch_isotocso_output" && rm "/usr/share/game-converter/temp.tmp"
    exit
  fi
  # remove Tmp file if conversion completed successfully
  rm -f "/usr/share/game-converter/temp.tmp"
}
#######################################
# Create a function for $opt2 & $opt7 #
#####################################################################################################################################################################################################################################
# Create a function for batch cso to iso conversion
batch_csotoiso() {
  # Asks the user for input folder, and creates "$batch_csotoiso_input"
  batch_csotoiso_input=$(zenity --file-selection --directory --filename="Desktop" --title="Select the folder where you keep your cso files")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Asks the user for output folder, and creates "$batch_csotoiso_output"
  batch_csotoiso_output=$(zenity --file-selection --directory --filename="Desktop" --title="Where you want to save them")
    # Exits if user hits cancel button
    if [[ "$?" != 0 ]]; then
      exit
    fi
  # Set initial variables for progress bar
  percentage="1"
  csotoiso_division="0"
  # Loop through games folder recursively looking for cso files
  (for batch_csotoiso_file in "$batch_csotoiso_input"/*.cso; do
    # Removes path for file in loop, creating "$batch_csotoiso_file_basename" (filename.cso)
    batch_csotoiso_file_basename="$(basename "$batch_csotoiso_file")"
    # Takes the basename "batch_csotoiso_file_basename", and removes extension (.cso) creating "$batch_csotoiso_file_basename_no_ext" (filename)
    batch_csotoiso_file_basename_no_ext=${batch_csotoiso_file_basename%.*}
    # Create final output path
    final_batch_csotoiso_output="$batch_csotoiso_output"/"$batch_csotoiso_file_basename_no_ext.iso"
    # echo variable outside subshell to tmp file
    echo $final_batch_csotoiso_output > "/usr/share/game-converter/temp.tmp"
    # reassign variable "percentage"
    percentage=$(( $percentage + $csotoiso_division ))
    # Find the total number of matching files
    total_files=$(ls  "$batch_csotoiso_input"/*.cso 2> /dev/null | wc -l)
    # echo percentage for progress bar
    echo $percentage
    # Echo text for progress bar
    echo "# Creating: $batch_csotoiso_file_basename_no_ext.iso \n \n Total batch progress: $percentage%"
    # Create varibale with division for progress bar increments
    csotoiso_division=$(( 100 / $total_files ))
    # Don't overwrite if file exists
    if [[ ! -f "$final_batch_csotoiso_output" ]]; then
      # Start converting to iso
      ciso 0 "$batch_csotoiso_file" "$final_batch_csotoiso_output"
    fi
  done | zenity --progress --width="500" --auto-close --auto-kill --title="Converting selected items to iso" --text="Creating: $batch_csotoiso_file_basename_no_ext.iso \n \n $percentage%" --percentage="1")
  # Cancel conversion, delete incomplete file, and delete temp file if cancel is pressed
  if [[ "$?" != 0 ]]; then
    rm "$final_batch_csotoiso_output"
    pkill ciso
    final_batch_csotoiso_output=$(cat "/usr/share/game-converter/temp.tmp")
    rm "$final_batch_csotoiso_output" && rm "/usr/share/game-converter/temp.tmp"
    exit
  fi
  # remove Tmp file if conversion completed successfully
  rm -f "/usr/share/game-converter/temp.tmp"
}
########
# Main #
#####################################################################################################################################################################################################################################
# Opens box asking for user input, and sets variable $action1 to $opt1 or $opt2 from user selection
action1=$(zenity --list --title="What kind of conversion?" --text="What kind of conversion?" --radiolist --column="Pick" --column="Conversion Type" FALSE "$opt1" FALSE "$opt2")
# Exits if user hits cancel button
if [[ "$?" != 0 ]]; then
  exit
fi
# Opens box asking for user input, and sets variable $action2 to $opt3,$opt4,$opt5,$opt6, or $opt7 from user selection
action2=$(zenity --list --height="300" --width="350" --title="How do you want to convert?" --text="How do you want to convert?" --radiolist --column="Pick" --column="Conversion Type" FALSE "$opt3" FALSE "$opt4" FALSE "$opt5" FALSE "$opt6" FALSE "$opt7")
  #exits if user hits cancel button
  if [[ "$?" != 0 ]]; then
    exit
  fi
# If user selected "Single File Conversion", and " Convert to chd"
if [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt3" ]]; then
  single_tochd
# If user selected "Single File Conversion", and "Convert chd to gdi"
elif [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt4" ]]; then
  single_chdtogdi
# If user selected "Single File Conversion", and "Convert chd to bin/cue"
elif [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt5" ]]; then
  single_chdtocue
# If user selected "Single File Conversion", and "Convert iso to cso"
elif [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt6" ]]; then
  single_isotocso
# If user selected "Single File Conversion", and "Convert iso to cso"
elif [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt7" ]]; then
  single_csotoiso
# If user selected "batch Conversion", and " Convert to chd"
elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt3" ]]; then
  batch_tochd
# If user selected "batch Conversion", and "Convert chd to gdi"
elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt4" ]]; then
  batch_chdtogdi
# If user selected "batch Conversion", and "Convert chd to bin/cue"
elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt5" ]]; then
  batch_chdtocue
# If user selected "batch Conversion", and "Convert iso to cso"
elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt6" ]]; then
  batch_isotocso
# If user selected "batch Conversion", and "Convert cso to iso"
elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt7" ]]; then
  batch_csotoiso
fi
# Ask user if they have more files to convert. If yes, start over. If no, exit
if zenity --question --text "Do you have more files to convert?"; then
  exec "$0"
else
  # Check if any temp files remain, and if so delete them
  if [ -f "/usr/share/game-converter/temp.tmp" ]; then
    rm -f "/usr/share/game-converter/temp.tmp"
  fi
  if [ -f "/usr/share/game-converter/temp1.tmp" ]; then
    rm -f "/usr/share/game-converter/temp1.tmp"
  fi
  exit
fi
###########################################################################################################################################################################################
