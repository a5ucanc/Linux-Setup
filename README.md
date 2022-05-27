# Linux-Setup
A bash script to setup linux after fresh installation.

What the script does:
  1) Creates a link to a folder in a windows shared partition, makes it permanent.
  2) Downloads and installs additional programs
  3) Open Burp and loader to further activation
  4) Creates KDE shortcuts to: Burp, Firefox, Chrome

Further improvments to come:
  1) Upgrade the link functionality to create a VMs shared folder, in case of VM installation.
  2) Completly remove apt output and read from stderr if error occurs.
  3) Create a file containing the applications list to download and modify the script use it.
