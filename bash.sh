function create_folder(){
    if [ -d "$1" ]; then
        echo "Folder $1 already exists"
    else
        mkdir "$1"
        echo "Folder $1 was created!"
    fi
}


read -p "Enter your full name: " full_name
create_folder "$full_name"
cd "$full_name"
create_folder "src"
create_folder "docs"
create_folder "assets"
main_folder=$(dirname "./")

read -p "Do you want a backup folder with timestamp created too? (y/n) " backup
while [ "$backup" != "y" ] && [ "$backup" != "n" ]; do
    read -p "Invalid input. Please enter y or n: " backup
done

if [ "$backup" == "y" ]; then
    read -p "What subfolder do you wish to back up? : " folder_to_backup    
    if [ ! -d "$folder_to_backup" ]; then
        echo "Error: The folder '$folder_to_backup' does not exist."
    else
        backup_location="$main_folder/backup_$(date "+%Y-%m-%d_%H-%M-%S")"
        create_folder  "$backup_location"
        cp -r "$folder_to_backup" "$backup_location/"
        echo "Backup of '$folder_to_backup' completed successfully into '$backup_location/'."
    fi

elif [ "$backup" == "n" ]; then
  echo "Creating a Backup with Timestamp was skipped"
fi


read -p "Do you want to analyze a folder? (y/n)" analyze_folder
while [ "$analyze_folder" != "y" ] && [ "$analyze_folder" != "n" ]; do
    read -p "Invalid input. Please enter y or n: " analyze_folder
done

if [ "$analyze_folder" == "n" ]; then
  echo "Analyzing was Skipped"
elif [ "$analyze_folder" == "y" ]; then
    read -p "Enter folder to analyze (or press Enter to use the main project folder): " dir
    dir="${dir:-$main_folder}"

    if [ ! -d "$dir" ]; then
        echo "Folder '$dir' does not exist. Please check the path."
    else

        txt_count=$(find "$dir" -type f -name "*.txt" | wc -l)
        sh_count=$(find "$dir" -type f -name "*.sh" | wc -l)
        jpg_count=$(find "$dir" -type f -name "*.jpg" | wc -l)

        echo "In the Folder '$dir' are:"
        echo ".txt files: $txt_count"
        echo ".sh files: $sh_count"
        echo ".jpg files: $jpg_count"

        organized_dir="$dir/organized"
        create_folder "$organized_dir"

        create_folder "$organized_dir/txt"
        create_folder "$organized_dir/sh"
        create_folder "$organized_dir/jpg"
        find "$dir" -type f -name "*.txt" -exec mv {} "$organized_dir/txt/" \;
        find "$dir" -type f -name "*.sh" -exec mv {} "$organized_dir/sh/" \;
        find "$dir" -type f -name "*.jpg" -exec mv {} "$organized_dir/jpg/" \;
        echo "Files have been organized by type into the 'organized' folder."

    fi
fi

read -p "Enter a file extension (e.g., .txt) or a keyword to search for:" prompt
if [[ "$prompt" == .* ]]; then
    echo "Searching for files with the '$prompt' extension..."
    find . -type f -name "*$prompt"

elif [[ -n "$prompt" ]]; then
    echo "Searching for the keyword '$prompt' in files..."
    grep -r "$input" .
else
    echo "No search term provided. Skipping search."
fi
