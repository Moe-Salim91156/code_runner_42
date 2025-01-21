# code_runner_42

# **Script Usage Guide**

## **Overview**
This guide explains how to use the provided scripts by setting up proper permissions and configuring the system for easy access. Follow the steps below to ensure your scripts are executable and accessible globally.

---

## **Setup**

### **1. Grant Execution Permissions**
Before running the scripts, you need to make them executable. Use the following command:
```bash
chmod +x <script_name>
```
Replace `<script_name>` with the name of the script file (e.g., `code_runner.sh`).

---

### **2. Place Scripts in `/usr/local/bin`** 
If you have **sudo** or root privileges, follow these steps to make the scripts globally accessible:

1. Move the script to `/usr/local/bin`:
   ```bash
   sudo mv <script_name> /usr/local/bin/
   ```
2. Ensure the script is now in your PATH by checking:
   ```bash
   echo $PATH
   ```
3. Run the script from anywhere using its name:
   ```bash
   <script_name>
   ```

---

### **3. If You Don’t Have Root Privileges**
If you cannot use `sudo` or don't have root privileges, you can add the script to your personal `PATH`:

1. **Choose a Directory**  
   Create a custom directory for your scripts (if it doesn't already exist):
   ```bash
   mkdir -p $HOME/bin
   ```

2. **Move the Script**  
   Move the script to this directory:
   ```bash
   mv <script_name> $HOME/bin/
   ```

3. **Add Directory to PATH**  
   Add the `bin` directory to your PATH by editing your shell configuration file (e.g., `.bashrc`, `.zshrc`):
   ```bash
   echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
   ```
   For Zsh users:
   ```bash
   echo 'export PATH=$HOME/bin:$PATH' >> ~/.zshrc
   ```

4. **Reload Configuration**  
   Reload your shell configuration:
   ```bash
   source ~/.bashrc
   ```
   Or for Zsh:
   ```bash
   source ~/.zshrc
   ```

5. **Run the Script**  
   Now you can run the script from anywhere:
   ```bash
   <script_name>
   ```

---

## **Usage Instructions**
After setting up, you can use the scripts by typing their names in the terminal. Ensure the required dependencies (if any) are installed.

### **Example**
For a script named `code_runner.sh`, simply type:
```bash
code_runner.sh
```

If the script expects inputs, follow the prompts to interact with it.

---

## **Additional Notes**
- Ensure you have `bash` installed. If it's not the default shell, run the script explicitly using:
  ```bash
  bash <script_name>
  ```
- If you encounter issues, verify your `$PATH` by running:
  ```bash
  echo $PATH
  ```
- Always check and update your scripts for compatibility with your system.

---

## **Troubleshooting**
- **Error: Permission Denied**  
  Ensure the script has execution permissions:
  ```bash
  chmod +x <script_name>
  ```

- **Command Not Found**  
  Verify the script is in your `PATH`:
  ```bash
  echo $PATH
  ```
  If not, add the directory containing the script to your `PATH`.

- **Dependency Issues**  
  Ensure all required tools (like `valgrind`, `bash`) are installed.

---

By following this guide, your scripts will be ready for use globally or within your user environment. Let me know if further clarification is needed!

