#!/bin/bash

# File to store the default directory and executable
DEFAULTS_FILE="$HOME/.valgrind_runner_defaults"

# Function to save the defaults
save_defaults() {
    echo "Saving defaults..."
    echo "PROJECT_DIR=$project_dir" > "$DEFAULTS_FILE"
    echo "EXECUTABLE=$executable" >> "$DEFAULTS_FILE"
    echo "Defaults saved. You can edit $DEFAULTS_FILE to update them."
}

# Function to load the saved defaults
load_defaults() {
    if [[ -f "$DEFAULTS_FILE" ]]; then
        source "$DEFAULTS_FILE"
        echo "Defaults loaded:"
        echo "Project Directory: $PROJECT_DIR"
        echo "Executable: $EXECUTABLE"
    fi
}

# Ask if the user is in the executable directory
read -p "Are you in the executable directory? (y/n): " in_out

# If the user is in the executable directory, skip searching for it
if [[ "$in_out" == "y" ]]; then
    load_defaults
    # Ask if the user wants to use the saved defaults
    read -p "Do you want to use these defaults? (y/n): " use_defaults
    if [[ "$use_defaults" == "y" ]]; then
        project_dir="$PROJECT_DIR"
        executable="$EXECUTABLE"
    else
        unset project_dir executable
        read -p "Provide the name of the executable: " executable
    fi
    if [[ ! -f "$PWD/$executable" ]]; then
        echo "Executable '$executable' not found in the current directory."
        exit 1
    fi

    project_dir="$PWD"  # Set the project directory to the current directory
    # Only prepend './' if the executable is not an absolute path
    if [[ "$executable" != /* ]]; then
        executable="./$executable"
    fi
    save_defaults
    echo "You are in the executable directory. Running Valgrind..."

else
    # Check if defaults exist
    load_defaults

    # Ask if the user wants to use the saved defaults
    read -p "Do you want to use these defaults? (y/n): " use_defaults
    if [[ "$use_defaults" == "y" ]]; then
        project_dir="$PROJECT_DIR"
        executable="$EXECUTABLE"
    else
        unset project_dir executable
    fi

    # If defaults are not set, prompt the user for input
    if [[ -z "$project_dir" ]]; then
        # Prompt user for the name of the directory containing their projects
        read -p "Enter the name of the directory relative to your home (e.g., 'directory'): " project_dir_name
        project_dir="$HOME/$project_dir_name"

        # Check if the directory exists
        if [[ ! -d "$project_dir" ]]; then
            echo "Directory '$project_dir' not found in your home directory."
            exit 1
        fi

        # Search for executables in the specified directory
        executables=$(find "$project_dir" -maxdepth 2 -type f -executable)

        if [[ -z "$executables" ]]; then
            echo "No executables found in the directory '$project_dir'."
            exit 1
        fi

        # Display executables and prompt the user to choose one
        echo "Found the following executables:"
        select exe in $executables; do
            if [[ -n "$exe" ]]; then
                executable="$exe"
                break
            else
                echo "Invalid choice. Please try again."
            fi
        done

        # Ask the user if they want to save this as the default
        read -p "Do you want to set this directory and executable as the default? (y/n): " save_as_default
        if [[ "$save_as_default" == "y" ]]; then
            save_defaults
        fi
    fi
fi

# Ask if the user wants to run a full Valgrind check
read -p "Run full Valgrind check with additional flags? (y/n): " full_check

# Ask for any additional arguments if necessary
read -p "Provide the arguments if any (e.g., ./philo 4 200 4300 500): " ARGS

# Run Valgrind with the appropriate options
echo "Running Valgrind on $executable..."

if [[ -z "$ARGS" ]]; then
    # Handle full Valgrind check
    if [[ "$full_check" == "y" ]]; then
        bash -c "valgrind --leak-check=full --track-origins=yes --track-fds=yes --show-leak-kinds=all $executable"
    else
        bash -c "valgrind --leak-check=full $executable"
    fi
else
    # Handle full Valgrind check with arguments
    if [[ "$full_check" == "y" ]]; then
        bash -c "valgrind --leak-check=full --track-origins=yes --track-fds=yes --show-leak-kinds=all $executable $ARGS"
    else
        bash -c "valgrind --leak-check=full $executable $ARGS"
    fi
fi

