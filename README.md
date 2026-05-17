# BashIT
A GitHub repository that contains a list of bash scripts that help in automating of tasks on a linux system.

# How to Run Bash Scripts

This guide provides a step-by-step procedure for downloading, preparing, and executing the Bash scripts in this library, followed by common troubleshooting steps.

---

## 🚀 Execution Procedure

Follow these four steps to safely run any script in this repository.

### Step 1: Download the Script
Download the desired `.sh` file from this repository and save it directly into the directory (folder) where you want it to run or manage your tasks.

### Step 2: Navigate to the Directory
To target the script, you need to move your terminal into the folder where the file was saved:
1. Open your file manager and locate the downloaded file.
2. **Right-click** the file or the folder it is in and select **Copy Path** (or "Copy as path") using your mouse.
3. Open your terminal, type `cd `, and **paste** the copied path. 
4. Ensure you are targeting the *directory* containing the file, then press **Enter**:
   ```bash
   cd <path_of_file_s_directory>
   ```

### Step 3: Grant Execution Permissions (The Safe Way)
By default, newly downloaded scripts lack permission to execute. You must grant this permission using the `chmod` command. 

Run the following command to make the script executable:
```
chmod 744 <file_name>.sh
```
**or
```
chmod u+rwx,g+r,o+r <file_name>.sh
```

> 🔒 **Security Note: Why `744` is safer than `777`**
> * **`chmod 744` (Recommended):** This grants full permissions (Read, Write, Execute) **only** to you (the file owner). Everyone else on the system can only read the file. This follows the *Principle of Least Privilege*.
> * **`chmod 777` (Dangerous):** This grants Read, Write, and Execute permissions to *everyone* (Owner, Group, and Public). If a malicious actor or compromised service gains access to your system, they could modify your script to execute harmful code. **Never use 777 in a production or multi-user environment.**

### Step 4: Execute the Script
Once permissions are set, execute the script by passing it to the shell interpreter:
```bash
sh <file_name>.sh
```
*(Alternatively, if you used `chmod` in Step 3, you can also run it using `./<file_name>.sh`)*

---

## 🛠️ Common Debugging Steps

If your script fails to run or throws errors, use these standard sysadmin troubleshooting techniques:

### 1. Enable Bash Debug Mode
If the script runs but behaves unexpectedly, you can look under the hood by running it in debug mode. This prints every command to the screen exactly as it executes.
* **Fix:** Run the script with the `-x` flag:
  ```bash
  sh -x <file_name>.sh
  ```

### 2. Verify Permission Denied Errors
If you see a `Permission denied` error even after running Step 3, you may need administrative privileges to execute specific commands inside the script (like installing packages or modifying system files).
* **Fix:** Run the script with `sudo`:
  ```bash
  sudo sh <file_name>.sh
  ```

### 3. Check the Shebang Line
Ensure the script is being interpreted by the correct shell. Open the file and verify the very first line looks like this:
```bash
#!/bin/bash
```
If your system utilizes a different path for Bash, you can find it by typing `which bash` in your terminal and updating the script's first line accordingly.
