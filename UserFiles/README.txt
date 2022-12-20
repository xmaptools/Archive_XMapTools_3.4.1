                    ######################################
                    # XMAPTOOLS 3 - directory /UserFiles #
                    ######################################

This directory /UserFiles can be used to store user’s external functions of XMapTools and
the new definition file: ListFunction_USER.txt

When XMapTools is launching, it checks the content of this directory and made two changes:
  (1)   /UserFiles is added to the MATLAB path until user closes the program. All the 
        MATLAB functions stored in this directory are available in XMapTools
  (2)   If ListFunction_User.txt exists, this file is read instead of ListFunction.txt
        stored in /program 

This directory should not be used to store any data. More details concerning the use of 
this special directory are given in the user guide. 

It is strongly recommended to update this file when a new release becomes available in 
order to benefit from the last external functions distributed with XMapTools.


--------------------------
Pierre Lanari (25.02.2015; last changed 30.01.2019)