# Linux-Setup
A bash script to setup kali linux after fresh installation.

## Requirements
- Bare metal Kali installed with KDE DE
- A shared folder with Burp folder
- nVidia GPU (for driver installation)

## What the script does
1. Creates a link to a folder in a windows shared partition, makes it permanent.
2. Downloads and installs additional programs and drivers
3. Open Burp and loader to further activation
4. Creates KDE shortcuts to: Burp, Firefox, Chrome

## Further improvments to come
- [ ] Upgrade the link functionality to create a VMs shared folder, in case of VM installation.
- [ ] Completly remove apt output and read from stderr if error occurs.
- [ ] Create a file containing the applications list to download and modify the script use it.
- [ ] Improvement of the README
