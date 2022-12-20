                    ######################################
                    # XMAPTOOLS 3 - directory /Addons #
                    ######################################

This directory /Addons is used to store XMapTools add-ons (see https://www.xmaptools.com/add-ons/)

When it starts, XMapTools checks the content of this directory and makes a list of the subdirectories that are treated as potential add-on.

An add-on package such as /XaddTest must contain a MATLAB program file called XaddTest.m (or XaddTest.p) that is the main function called to run the add-on. The files XaddTest_Install.m and XaddTest_Update.m must also be provided (see user guide). In this file it is possible to block the add-on use if requirements are not meet (e.g. if a setup is required).

This directory should never be used to store any data. Additional details concerning the use of this special directory are given in the user guide. 



--------------------------
Pierre Lanari (Last updated 11.12.2019)