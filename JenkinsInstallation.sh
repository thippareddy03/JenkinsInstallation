###################################
# NAME : V.THIPPAREDDY
# DATE : 20-06/2024
# Script : JenkiknsInstallation.sh
# Description : This script i am writing install jenkins on Redhat or Ubunut Linux OS
# $# - Used to check for no of arguments $? - represents result count $(!!) - represents previous results command
# Example of variable is Name="ThippaReddy" && Arguments is Name="$1"
# Arrays are used to write multiple strings in the same variable synta is ARRAY = (name,thippa,reddy)
###############################################

function Wget_Download {
    echo "Checking if Wget is available or not"
    wget --version
        if [ $? -eq 0 ];
        then
            echo "Wget is already available"
            echo "Calling function to download Java & Jenkins"
            JavaPackage_Download
        else
            echo "Installing Wget package"
                if [ "$(grep -Ei 'centos|redhat' /etc/*release)" ];
                then
                    echo "Downloading Wget for Redhat package"
                    sudo yum install wget -y
                        if [ $? -eq 0 ];
                        then
                            echo "Downloaded Wget package for Redhat OS"
                            echo "Calling function to download Java package & Jenkins"
                            JavaPackage_Download
                        else
                            echo "Unable to download Wget package for Redhat OS"
                            exit 1
                        fi
                elif [ "$(grep -Ei 'debian|ubuntu|mint' /etc/*-release)" ];
                then
                    echo "Downloading Wget for Ubuntu Package"
                    sudo apt install wget -y
                        if [ $? -eq 0 ];
                        then
                            echo "Downloaded Wget package for Ubuntu OS"
                            echo  "Calling function to download Java package & Jenkins"
                            JavaPackage_Download
                        else
                            echo "Unable to download wget package for ubunut OS"
                            exit 1
                        fi
                else
                    echo "Unsupported OS"
                    exit 1
                fi
        fi
}

function JavaPackage_Download {
    echo "Checking if Java is available or not"
    java --version
        if [ $? -eq 0 ];
        then
            echo "Java package is already available"
            echo "Calling Jenkins installation function"
            Jenkins_Installation
        else
            echo "Installing java"
                if [ "$(grep -Ei 'debian|ubuntu|mint' /etc/*-release)" ];
                then
                    echo "Installing Jdk 11 on Ubuntu OS"
                    sudo apt update -y
                    sudo apt install openjdk-11-jdk -y
                        if [ $? -eq 0 ];
                        then
                            echo "Java installed successfully"
                            echo "Calling function to download Jenkins "
                            Jenkins_Installation
                        else
                            echo "Unable to download Java"
                            exit 1
                        fi
                elif [ "$(grep -Ei 'centos|redhat' /etc/*release)" ];
                then
                    echo "Installing Jdk 11 on RHEL OS"
                    sudo apt update -y
                    sudo yum install java-11-openjdk-devel -y
                        if [ $? -eq 0 ];
                        then
                            echo "Java installed successfully"
                            echo "Calling function to download jenkins"
                            Jenkins_Installation
                        else
                            echo "Unable to download Java"
                            exit 1
                        fi
                else
                    echo "Unsupported OS"
                    exit 1
                fi
        fi
}

function Jenkins_Installation {
    echo "Checking if Jenkins version is available or not"
    if [ "$(grep -Ei 'debian|ubuntu|mint' /etc/*-release)" ];
    then
        java -jar jenkins.war --version
        if [ $? -eq 0 ];
        then
            echo "Jenkins is already available"
            exit 0
        else
            echo "Downloading jenkins for Ubuntu OS"
            sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
                https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
            echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
                https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null
            sudo apt-get update -y
            sudo apt-get install jenkins -y
                if [ $? -eq 0 ];
                then
                    echo "Jenkins Downloaded successfully"
                    exit 0
                else
                    echo "Unable to download Jenkins"
                    exit 1
                fi
        fi
    elif [ "$(grep -Ei 'centos|redhat' /etc/*release)" ];
    then
        java -jar jenkins.war --version
        if [ $? -eq 0 ];
        then
            echo "Jenkins is already available"
            exit 0
        else
            sudo wget -O /etc/yum.repos.d/jenkins.repo \
                 https://pkg.jenkins.io/redhat-stable/jenkins.repo
            sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
            sudo yum upgrade -y
                if [ $? -eq 0 ];
                then
                    echo "Jenkins downloaded successfully"
                    exit 0
                else
                    echo "Unable to download jenkins" 
                    exit 1
                fi
        fi
    else
        echo "Unsupported OS version"
        exit 1
    fi            
}

echo "Downloading Jenkins"
Wget_Download