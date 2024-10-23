# Eaton Custom Image Base

This repo is the first repo used to create our custom build images, second repo is [edge-build-virtual-environments](https://github.com/etn-ccis/edge-build-virtual-environments).  This repo is a fork from [actions/virtual-environments](https://github.com/actions/virtual-environments) MS repo.  This is the main repo for the images that MS uses for Azure DevOps and GitHub MS hosted agents and runners.  This repo is maintained and updated to support new tool versions on regular cadence.  It would be very time consuming to create and maintain these scripts ourselves, so it is much easier to use this work from MS.  Unfortunately in order to use this we had to make some changes, and syncing in new updates has some manual steps layed out below.

To get the latest updates from MS there are some manual steps that will need to be automated in the future.  This file will lay out the process of for updating for our needs.

1. Run the SyncFork GitHub Action. 
2. Create a Pull request to pull in the latest MS changes from main into the eaton branch.  This will kick off validation workflows that should be stopped right away as there are some manual changes that need to be made before it will use these files.  Complete this PR.
3. There are two files that are updated from MS that we have to manually merge part of the MS file into our version.  The section of the file that needs to get manually merged (copied) is just the  "provisioners" section, which most of the file.  The other sections of the file had to be manually modified to support our workflow. windows-2019.pkr.hcl into windows-2019-etn.pkr.hcl and ubuntu-20.04.pkr.hcl into ubuntu-20.04-etn.pkr.hcl.
4. This should pull in all the latest MS changes so we can start building an updated VM.

There are some other files that have also been modified to support our process.  It is a good idea to check the MS version these files for any changes that might be needed in the -etn version of the file.  Any changes needed will need to be manually merged into these files.

* images\ubuntu\templates\ubuntu-20.04.pkr.hcl -> ubuntu-20.04-etn.pkr.hcl (provisioners section)
* images\windows\templates\windows-2019.pkr.hcl -> windows-2019-etn.pkr.hcl (provisioners section)
* images.CI\linux-and-win\azure-pipelines\ubuntu2004.yml -> ubuntu2004-etn.yml
* images.CI\linux-and-win\azure-pipelines\windows2019.yml -> windows2019-etn.yml
* images.CI\linux-and-win\azure-pipelines\image-generation.yml -> image-generation-etn.yml
* images.CI\linux-and-win\build-image.ps1 -> build-image-etn.ps1
* Note: images/win/scripts/Tests/WindowsFeatures.Tests.ps1: On line 21 keep $minimumFreeSpaceMB = 5 * 1024 to have $availableSpaceMB greater than $minimumFreeSpaceMB

5. After we merge the update into eaton branch, then an update images will be generated with eaton branch. Copy those images and update the MS_LINUX_SOURCE_IMAGE for ubuntu image and MS_WINDOWS_SOURCE_IMAGE for windows in Image Generation Variables located in DevOps/Pipelines/library: https://dev.azure.com/etn-ccis/DevOps/_library?itemType=VariableGroups.

It would be great to eliminate the need for our modified process, but the process MS is using doesn't create images, it just create VM disk.  Hopefully MS will eventually update their process to use images someday.  It is worth taking some time to see if there is a better way to do this that doesn't have any manual steps.

The software being installed is controlled by a couple json files. The first is the [toolsets file](./images/ubuntu/toolsets/toolset-2004.json for Linux and ./images/windows/toolsets/toolset-2019.json for Windows) which is used when multiple versions of a tool are installed.  The second is in the provisioners section of [this file](./images/ubuntu/templates/ubuntu-20.04-etn.pkr.hcl for Linux and ./images/windows/templates/windows-2019-etn.pkr.hcl for Windows).  To see the list of installed software by Microsoft you can see this in this [readme file](./images/ubuntu/Ubuntu2004-Readme.md and ./images/windows/windows2019-Readme.md).
