# Process Tar Files

## Overview

This repository contains a shell script and GitHub Actions workflow to process `.tar.gz` files. The workflow performs the following tasks:

1. **Unzips** `.tar.gz` files into a directory.
2. **Processes** JSON files within the directory to truncate fields if necessary.
3. **Repackages** the directory into a new `.tar.gz` file.
4. **Uploads** the processed file as an artifact to GitHub Actions.

## Repository Structure

/your-repo
├── .github
│ └── workflows
│ └── process-files.yml
├── input-files
├── process_tar_files.sh
└── README.md


- **`input-files/`**: Directory to place your `.tar.gz` files for processing.
- **`process_tar_files.sh`**: Shell script to process `.tar.gz` files.
- **`.github/workflows/process-files.yml`**: GitHub Actions workflow file.

## Setup

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo

2. Add .tar.gz Files

Place your .tar.gz files in the input-files/ directory.

3. Make the Script Executable

Ensure the shell script is executable:

chmod +x process_tar_files.sh

GitHub Actions Workflow
The GitHub Actions workflow automates the following:

    Unzipping the .tar.gz files in the input-files/ directory.
    Processing JSON files to truncate the login and url fields if they exceed 33 characters.
    Repackaging the processed files into new .tar.gz files.
    Uploading the processed files as artifacts.


Workflow Configuration
The workflow file is located at .github/workflows/process-files.yml. It includes steps to:

    Checkout the repository.
    Install necessary tools.
    Run the shell script.
    List the generated files.
    Upload the processed files as artifacts.

Usage

    Push Changes: Trigger the workflow by pushing changes to the main branch or manually through the GitHub Actions tab.

    Download Artifacts: After the workflow completes, download the processed files from the Actions tab in your GitHub repository.

Example Workflow Execution

Upon successful execution of the workflow, you will see logs indicating:

    Extraction of files.
    Processing of JSON files.
    Creation of new .tar.gz files.
    Upload of artifacts.

Troubleshooting

    Missing Artifacts: Ensure the correct file paths and names are used in the workflow.
    Permission Issues: Verify you have the necessary permissions to view and download artifacts.
    File Not Found: Confirm that .tar.gz files are correctly placed in the input-files/ directory.


License
This project is licensed under the MIT License - see the LICENSE file for details.


### Notes

- **Replace placeholders**: Update `your-username` and `your-repo` with your actual GitHub username and repository name.
- **Add additional sections**: Customize the README to include more details specific to your project or usage.

This `README.md` provides a comprehensive guide to setting up and using the repository, including details on the GitHub Actions workflow and troubleshooting tips.
