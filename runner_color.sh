#!/bin/bash

# File to store the default directory and executable
DEFAULTS_FILE="$HOME/.valgrind_runner_defaults"

# Colors
BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[32m"
BLUE="\033[34m"
CYAN="\033[36m"
RED="\033[31m"
MAGENTA="\033[35m"
YELLOW="\033[33m"

# Styled dividers
DIVIDER="${CYAN}=========================${RESET}"
PROMPT_BORDER="${MAGENTA}➤➤➤${RESET}"

# Function to save the defaults
save_defaults() {
    echo -e "\n${DIVIDER}"
    echo -e "${GREEN}Saving defaults...${RESET}"
    echo "PROJECT_DIR=$project_dir" > "$DEFAULTS_FILE"
    echo "EXECUTABLE=$executable" >> "$DEFAULTS_FILE"
    echo -e "${GREEN}Defaults saved successfully!${RESET}"
}

# Function to load the saved defaults
load_defaults() {
    if [[ -f "$DEFAULTS_FILE" ]]; then
        source "$DEFAULTS_FILE"
        echo -e "\n${DIVIDER}"
        echo -e "${GREEN}Defaults loaded:${RESET}"
        echo -e "${PROMPT_BORDER} ${BOLD}Project Directory:${RESET} ${BLUE}$PROJECT_DIR${RESET}"
        echo -e "${PROMPT_BORDER} ${BOLD}Executable:${RESET} ${BLUE}$EXECUTABLE${RESET}"
    fi
}

# Ask the user with a styled prompt
ask_user() {
    echo -e "\n${PROMPT_BORDER} ${BOLD}$1${RESET}"
    read -p ">> " "$2"
}

# Start script
echo -e "${DIVIDER}"
echo -e "${BOLD}${CYAN}42 Code Runner - Interactive Script By Msalim${RESET}"
echo -e "${DIVIDER}"

# Ask if the user is in the executable directory
ask_user "Are you in the executable directory? (y/n)" in_out

if [[ "$in_out" == "y" ]]; then
    load_defaults
    ask_user "Do you want to use these defaults? (y/n)" use_defaults
    if [[ "$use_defaults" == "y" ]]; then
        project_dir="$PROJECT_DIR"
        executable="$EXECUTABLE"
    else
        unset project_dir executable
        ask_user "Provide the name of the executable:" executable
    fi
    if [[ ! -f "$PWD/$executable" ]]; then
        echo -e "${RED}Error: Executable '${BLUE}$executable${RED}' not found in the current directory.${RESET}"
        exit 1
    fi
    project_dir="$PWD"
    [[ "$executable" != /* ]] && executable="./$executable"
    save_defaults
    echo -e "${CYAN}Running Valgrind...${RESET}"

else
    load_defaults
    ask_user "Do you want to use these defaults? (y/n)" use_defaults
    if [[ "$use_defaults" == "y" ]]; then
        project_dir="$PROJECT_DIR"
        executable="$EXECUTABLE"
    else
        unset project_dir executable
    fi

    if [[ -z "$project_dir" ]]; then
        ask_user "Enter the name of the directory relative to your home (e.g., 'directory'):" project_dir_name
        project_dir="$HOME/$project_dir_name"
        if [[ ! -d "$project_dir" ]]; then
            echo -e "${RED}Error: Directory '${BLUE}$project_dir${RED}' not found.${RESET}"
            exit 1
        fi

        executables=$(find "$project_dir" -maxdepth 2 -type f -executable)
        if [[ -z "$executables" ]]; then
            echo -e "${RED}No executables found in the directory '${BLUE}$project_dir${RED}'.${RESET}"
            exit 1
        fi

        echo -e "\n${CYAN}Found the following executables:${RESET}"
        select exe in $executables; do
            if [[ -n "$exe" ]]; then
                executable="$exe"
                echo -e "${GREEN}Selected: ${BLUE}$executable${RESET}"
                break
            else
                echo -e "${RED}Invalid choice. Please try again.${RESET}"
            fi
        done

        ask_user "Do you want to save this directory and executable as the default? (y/n)" save_as_default
        [[ "$save_as_default" == "y" ]] && save_defaults
    fi
fi

ask_user "Run full Valgrind check with additional flags? (y/n)" full_check
ask_user "Provide the arguments if any (e.g., ./philo 4 200 4300 500):" ARGS

echo -e "\n${CYAN}Running Valgrind on ${BLUE}$executable${RESET}..."
if [[ -z "$ARGS" ]]; then
    if [[ "$full_check" == "y" ]]; then
        bash -c "valgrind --leak-check=full --track-origins=yes --track-fds=yes --show-leak-kinds=all $executable"
    else
        bash -c "valgrind --leak-check=full $executable"
    fi
else
    if [[ "$full_check" == "y" ]]; then
        bash -c "valgrind --leak-check=full --track-origins=yes --track-fds=yes --show-leak-kinds=all $executable $ARGS"
    else
        bash -c "valgrind --leak-check=full $executable $ARGS"
    fi
fi

echo -e "\n${GREEN}Valgrind execution completed!${RESET}"

