# Git Diff Build Script #

### Summary: ###

A shell script to create "deploy" and "restore" folders based off of a git diff of 2 branches.

### Instructions (running from bash): ###

1) Open up a shell terminal, and make a new directory:

    mkdir new_folder  

2) Now move to that directory:

    cd new_folder

3) Checkout the project from git:

    git clone git://github.com/skratchdot/Git-Diff-Build-Script.git

4) Now move to the build directory:

    cd Git-Diff-Build-Script/build/

5) Run the shell script:

    git_diff_build.sh

6) When prompted, enter the following information:

    Input the name of the build directory:
    my_build
    Input the name of the source/deployment branch:
    origin/dev
    Input the name of the destination/restore branch:
    origin/prod

7) Now the "DEPLOY" and "RESTORE" directories have been created. Check them out:

    cd my_build
    ls -la

### Instructions (running from Eclipse/Ant): ###

1) Make sure you have Eclipse with eGit installed.  Clone the following repository:

    git://github.com/skratchdot/Git-Diff-Build-Script.git

NOTE: instructions for eGit are found here:

    http://wiki.eclipse.org/EGit/User_Guide#Starting_from_existing_Git_Repositories

2) Once the project is checked out in Eclipse, expand the "build" directory.

3) Open the git_diff_build.xml file.  Make sure "bash" property is set correctly, and save the file:

    Win32: 	<property name="bash" value="C:\Program Files\Git\bin\sh.exe" description="Path to sh.exe" />
    Win64: 	<property name="bash" value="C:\Program Files (x86)\Git\bin\sh.exe" description="Path to sh.exe" />
    UNIX: 	<property name="bash" value="sh" description="Path to sh" />

4) Now you can run the ant build.  For the "Eclipse Refresh" to work properly, you
need to run the build in the same JRE as Eclipse.  To do this:

    a) right-click on the "git_diff_build.xml" file.
    b) Choose "Run As"->"External Tools Configurations".
    c) In the new window that pops open, click on the "JRE" tab.
    d) Click the radio button: "Run in the same JRE as the workspace".
    e) Now click the "RUN" button.
