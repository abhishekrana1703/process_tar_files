@echo off

REM Set variables
set PEM_FILE=your-key.pem
set EC2_USER=ec2-user
set EC2_HOST=your-ec2-public-dns
set LOCAL_CSV_PATH=./export.csv
set REMOTE_CSV_PATH=/home/ec2-user/export.csv
set CONTAINER_NAME=gl-exporter
set EXPORT_FILE_PATH=/home/ec2-user/abhishek

REM Copy the export.csv file to EC2 instance
echo Copying export.csv to EC2 instance...
scp -i %PEM_FILE% %LOCAL_CSV_PATH% %EC2_USER%@%EC2_HOST%:%REMOTE_CSV_PATH%

REM Run the Docker container
echo Running Docker container...
ssh -i %PEM_FILE% %EC2_USER%@%EC2_HOST% "docker run -d --name %CONTAINER_NAME% gl-exporter"

REM Check if container is running
echo Checking if container is running...
ssh -i %PEM_FILE% %EC2_USER%@%EC2_HOST% "while [ \$(docker ps -q -f name=%CONTAINER_NAME%) ]; do sleep 20; done"

REM Copy export.csv into the Docker container
echo Copying export.csv into the container...
ssh -i %PEM_FILE% %EC2_USER%@%EC2_HOST% "docker cp %REMOTE_CSV_PATH% %CONTAINER_NAME%:/path/in/container/export.csv"

REM Run gl_exporter command inside the container
echo Running gl_exporter inside the container...
ssh -i %PEM_FILE% %EC2_USER%@%EC2_HOST% "docker exec %CONTAINER_NAME% gl_exporter -f /path/in/container/export.csv -o /path/in/container/migration-archive.tar.gz"

REM Copy migration-archive.tar.gz to local machine
echo Copying migration-archive.tar.gz to local machine...
scp -i %PEM_FILE% %EC2_USER%@%EC2_HOST%:/home/ec2-user/abhishek/migration-archive.tar.gz %LOCAL_CSV_PATH%

REM Execute shell script on EC2
echo Executing shell script...
ssh -i %PEM_FILE% %EC2_USER%@%EC2_HOST% "sh /home/ec2-user/abhishek"

REM Wait for shell script to complete
echo Waiting for shell script to complete...
sleep 20

REM Check for latest .tar.gz file
echo Checking for latest .tar.gz file...
ssh -i %PEM_FILE% %EC2_USER%@%EC2_HOST% "ls -lt /home/ec2-user/abhishek/*.tar.gz | head -n 1"

REM Copy the file from EC2 to local machine
echo Copying file from EC2 to local machine...
scp -i %PEM_FILE% %EC2_USER%@%EC2_HOST%:/home/ec2-user/abhishek/latest-file.tar.gz %LOCAL_CSV_PATH%

echo Done
