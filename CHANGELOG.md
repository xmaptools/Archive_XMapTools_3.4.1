## CHANGELOG

# XMapTools 3.4.1 (10-06-2020)
This XMapTools 3.4.1 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update

Adds a new module the ‘Histogram Tool’ for generating histograms from compositional maps based on different normalisation schemes (counts, probability, probability density function, cumulative counts, cumulative probability function). The module also includes several tools for exporting data (tables, histogram); automatic binning algorithms; for plotting any gaussian distribution on top of the histogram
Adds a new module the ‘EPMA Converter’ that readily converts raw data from JEOL microprobe (both SUN and WINDOWS) into XMapTools-compatible format. Several files containing maps and standard data can be converted at the same time. Detailed explanations are provided in the user guide
Adds a new mode to the functionality ‘Transfer to Quanti’ that converts maps of element wt% to oxide wt%. This allows SEM users to import compositional maps of element wt% (Si, Al, etc.) and to transform them to oxide wt% (SiO2, Al2O3, etc.) to be used with the external functions in Quanti
Adds a subroutine ‘XMT_StructuralFormula’ for quick calculation of a general structural formulas using oxide name detection. The efficiency of the external functions using this subroutine is significantly improved. External functions will be progressively upgraded in a near future (see below)
Adds a general structural formula function ‘StructForm (all elem.)’ performing the normalisation based on every map (element) available. The old function will be removed in a future update
Provides an improved external function for biotite (StructFctBiotite) fixing a few issues in the site repartition model and adding Ti and Mn end-members
Adds a new oxybarometer for epidote-garnet (by Jesse Walters)
Adds new help functionalities for downloading tutorial data or the user-guide directly from the server
Other changes:

Fixes a major issue in the auto-update module preventing XMapTools to be updated in MATLAB 2014b
Fixes several minor stability issues of the interface (especially when XMapTools starts)
Fixes a minor issue that affected the behaviour of the option ‘Delete’ in Quanti
Fixes a minor issue affecting the display while ‘none’ is selected in the workspace ‘Quanti’
Fixes a minor zoom issue in the workspace ‘Results’ that resulted in a reset of the zoom options while changing the element
Fixes a stability issue in the functionality ‘transfer to quanti’
Fixes several minor formating issues for the text displayed in exported figures
Notes

Adds the first public version of the add-on XThermoTools including the petrological software Bingo-Antidote. You can obtain XThermoTools via the Extension Manager (see user-guide)

# XMapTools 3.3.1 (12-12-2019)
This XMapTools 3.3.1 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update

Adds a tool ‘Manage extension’ to download official add-ons from the XMapTools’ server (see the comment below)
Adds an option for displaying image information of the plotted map (size, resolution, etc.)
Adds an option for displaying the information of the selected Mask File
Adds a tool for adjusting the image resolution in the Quanti workspace. The new map is generated using a gridded interpolant performing a linear interpolation on the selected map. The interpolated values are based on linear interpolation of the values at neighboring grid points in each respective dimension.
Adds a mode ‘convert from ppm of element to wt% of oxide’ in the function Transfer to quanti. This correction is based on the inverse of the conversion factors listed in the file XMap_ConversionFactors.txt
Improves the image display module allowing maps with different sizes and resolutions generated within the same project to be manipulated and processed. The functions of the workspaces ‘Quanti’ and ‘Results’ have been improved to compatibility
Improves ‘spot mode’ for external functions. New features include an approximation of computation time and optimised waiting bar in area mode; the figure is now displayed in full screen
Improves the information displayed while opening an existing project
Improves significantly the behaviour of the interface while switching between workspaces
Other changes:

Removes the warning message while a project is opened in a new directory
Fixes an issue in the import map function causing the interface to crash when the element was not automatically recognised
Fixes an issue in the tool ‘Transfer to Quanti’ that prevented it to be used to create the first Quanti dataset
Fixes an issue preventing new external functions with a single output variable to work in spot mode
Fixes an issue in the tool to merge results; this function only worked if all results were selected
Fixes a minor display issue in the function ‘Export local composition: variable size rectangle’
Improves the behaviour of the main GUI while switching between the workspaces
Additional bug fixes
Note:

You must use the Extension manager to get the add-ons if you updated to XMapTools 3.3.1 via MATLAB (i.e. without downloading the full package)

# XMapTools 3.2.2 (27-09-2019)
This XMapTools 3.2.2 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Add a new feature to the standardization function Manual (homogeneous phase) to detect cases for which the median position does not match the peak position of the distribution. Note that a warning is displayed in the Command windows if a mismatch is observed for an element and the corresponding figure saved in Standardization/
Provide an improved mask image using the selected color palette. Note that the colour of the mask image is automatically adjusted if the color scheme is changed via the left menu
Provide a scale bar and the XMapTools’ logo on the exported mask image
Add an option to filter NaN out when importing a map via the Import Tool
Improve the compatibility of the external functions
Make the precision maps compatible with the color palette module
Other changes:

Fix an issue in the interface of XMapTools 3.2.1 that did not work normally on some WINDOWS computers
Fix an issue preventing in some instances to delete the selected mask file
A few button/functionality names in the module Binary were slightly adjusted
The name of a calibrated map and the merge map are now set automatically and can be edited in the workspace Quanti
Additional bug fixes

# XMapTools 3.2.1 (02-08-2019)
This XMapTools 3.2.1 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Improve significantly the compatibility and stability of the Graphical User Interface
Improve the integration of XMapTools’ add-ons – XMapTools 3.2 is fully compatible with add-on independent setup and auto update. These changes anticipates the deployment of XThermoTools 1.1 beta scheduled later this month
Introduce a new set of colourblind friendly colormaps based on perceptual palettes with smoother and more linear profiles than the palettes originally used in XMapTools. Consequently, it is no longer recommended to use neither JET or ColdWarm color palettes. There is a good chance that both of them will be removed in a future version. Additional details concerning the choice of the color palette are provided in the user guide
The color palette and the scale settings (logarithmic or linear) can now be accessed directly via the left menu. However, saving these as default settings requires going to the menu File > Preferences
Add an option to flip up and down the colours of the selected color palette. This option is accessible via the menu File > Preferences. Note that this feature is only compatible with the new color palettes which are defined in /Dev/XMap_ColorMaps.txt
Improve the compatibility of the modules with the new color palettes. The active color palette and filters are transfered and used in the modules displaying maps (expect RGB)
Add to the advanced Standardisation method a subroutine generating a file containing the theoretical limits of detection (LOD) for each element. Note that these limits are robust only for X-ray maps if the background value is > 1, otherwise a generic minimal uncertainty is assumed
Add a new functionality to filter in Quanti the concentrations below detection limit. This feature requires either a file LOD.txt in the working directory containing the element names and the detection limits (same unit as the map), or a LOD file generated by the advanced standardisation module in the folder LOD (more details concerning the format of these files are given in the user guide)
Add a new correction in the workspace Quanti to re-normalise the mixing pixels having an unrealistically high sum of oxide. These pixels can be generated by the advance standardisation method for element concentrations close to detection limit in the phase of interest (e.g. Si in calcite) but highly concentrated in the surrounding phase (e.g. Si in quartz). In this case, concentrations > 100 % are generated for the mixing pixels as Si is calibrated with the calibration curve of calcite. The correction can renormalise the composition of the mixing pixels having a sum above a given threshold. Auto and manual modes are available
Add a mode Convert from wt% of oxide to ppm of element in the function Transfer to quanti. This correction is based on the conversion factors listed in the file /XMapTools/Program/Dev/XMap_ConversionFactors.txt
Add a menu Workspace for quick access to the workspaces. Note that the buttons of the tab remains active in this version
Provide a new external function for the structural formula of titanite by Jesse Walters
Provide a new external function for Ti-in-Qz thermobarometry based on the calibration of Thomas et al. (2010) by Regiane Andrade Fumes
Other changes:

The Mn map has been corrected in the function StructFctGarnet.m – Note: Xsps was ok but not Mn expressed in apfu; thanks to Francesco Giuntoli for catching this error
Add Ti_M2 to the external functions StructFctAmphiboles.m and StructFctAmphiboles3.m; thanks to Michael Jentzer for this suggestion
The name of the button Apply in the TRC module has been changed to Paste
The following map names were changed for improving compatibility (raw data -> calibrated): Fe3 -> Fe2O3; F -> F_m; CL_Ti -> TiO2_Cl
The XMapTools logo was updated
Additional bug fixes

# XMapTools 3.1.2 (15-05-2019)
This XMapTools 3.1.2 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Make the Spider module available in all workspaces
Other changes:

Fix an issue in the setup program (Install_XMapTools) preventing the setup to be completed if the path to the setup directory contains space(s)
Fix an issue in the function Transfer to Results that was introduced in XMapTools 3.1.1 preventing this functionality to be used
Fix a minor issue to prevent all the corrected maps to be displayed while the TRC module is closed

# XMapTools 3.1.1 (09-05-2019)
This XMapTools 3.1.1 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Provide a major update to the graphical user interface (GUI) to improve the user experience. Changes include a new menu in the main XMapTools window and several graphical improvements to speed up the program. Many buttons have been removed compared to XMapTools 2 and the corresponding functions transferred to the menu. In XMapTools 3, the following functionalities are only available via the XMapTools’ menu: (1) Chemical modules; (2) the sampling tools …
Provide enhanced sampling tools including a new path mode. All sampling mode can be used for single or multiple maps with or without saving data and figures
Provide a mosaic tool to assemble separate datasets into map mosaic. This functionality is useful to compare several maps of the same mineral within a single dataset
Introduce a high-definition (HD) mode for a better compatibility with high-resolution screens; This mode can be activated using the command >> XMapTools HD. Note that this functionality is fully compatible with other XMapTools commands (e.g. >> XMapTools HD open MyProject | this command activates the HD mode and open the project MyProject.mat).
Introduce a new function that approximates the diameter of the interaction volume; this is a test version is only valid for an accelerating voltage of 15 KeV and a beam diameter of 1 micron (see Lanari & Picolli, 2019)
Introduce a copy function (available in the menu or using PC: Ctrl+C; MAC: Cmd+C) that copy the displayed figure (as an image) to the clipboard. A message is displayed when the data are transferred. The figure can be pasted in any other program able to manipulate images. Note that you can also export the image and then use the default copy function of MATLAB (in the menu) to obtain an image with layers for further editing in Illustrator.
Provide the pixel fraction of the groups obtained via the k-means classification in the module Binary
Add a new functionality About available in the menu File; it displays the last release notes and a short description of the program
Other changes:

Fix several issues in the zoom/pan functions including the possibility to reset to the full map view when the displayed element was changed
Display a warning box before filtering data in Quanti and Results
Fix an issue in the function to merge mask files causing display issues if the last group ‘unselected_pixels’ was present; thanks to Thereza Yogi for reporting this error
Fix an issue that prevented the IDC module to apply vertical intensity-drift correction
Fix several minor issue with button sizing and positioning in the main XMapTools’ window
Fix minor display issues of the average map density; the program detects the unit used and updates the display accordingly
Improve the merge function in QUANTI to be compatible with LA-ICP-MS maps
Improve the function reading the file Standards.txt to deal with unusual formatting practices
Update the program XConvert_JEOL_SUN (1) the file O-cnd containing the dwell time is saved in the folder /Info/ (2) a special mode [-s] prevents the program to generate the files Classifications.txt and Standards.txt by using the command: XConvert_JEOL_SUN -s
Additional bug fixes

# XMapTools 2.6.4 (06-02-2019)
This XMapTools 2.6.4 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Provide a new merge function in the workspace “Results” that can be used to merge results. Use the Generator to combine variables within a merged results.
Provide three new external functions created by Julien Reynes: StructFctGarnetH2O_OctOpti; StructFctGarnetH2O_ChargeOpti; StructFctGarnetH2O_MoSub to calculate structural formulas and speciation of garnet based on several methods. Note that these functions can handle water in garnet.
Other changes:

Resolve an issue with the density function in BINARY and TRIPLOT that prevented the density diagram to be displayed
Additional bug fixes

# XMapTools 2.6.3 (04-02-2019)
This XMapTools 2.6.3 update is strongly recommended for all users as it fixes a minor issue related to the display of the spot analyses used as internal standards introduced in XMapTools 2.6.2

# XMapTools 2.6.2 (30-01-2019)
This XMapTools 2.6.2 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Provide a major update to the TRIPLOT module including: an optimised interface with larger figures and a high-resolution density map plotted using a logarithmic color scale (note that this density map is not the same as the new scatter plots provided in the binary module, see below)
Provide new density functions in BINARY and TRIPLOT including an instantaneously density map and a new scatter plots showing both the points and their corresponding density. Thanks to Julian Reynes for this suggestion
Improve the functionality “transfer to quanti” with adding an optional conversion from wt% to ppm (and vice versa). This function aims to convert trace elements maps to ppm in order to use the spider module
Optimise the scale and size of the main GUI after starting XMapTools
Perform a directory check when a project is loaded. If the working directory is not properly set, XMapTools can now fix it for you (note that the warning message will be removed in a further release if no major issue is reported)
Other changes:

Resolve an issue with the reading of the file Xmap_SpiderColors.txt that prevented XMapTools from being updated
Resolve an issue with the add-on run button if there is no add-on available
Resolve an issue with the zoom function during and after classification
Resolve a display issue with the k-means function of the Binary module where cluster centroids were not visible in the figure
Additional bug fixes

# XMapTools 2.6.1 (18-12-2018)
This XMapTools 2.6.1 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Provide a new starting function preparing the migration to XMapTools 2.7. Starting with the next major XMapTools release, MATLAB R2014b or a more recent version will be required. XMapTools will not longer receive updates if used within old MATLAB environments (pre-R2014b). Please consider upgrading your MATLAB to ensure full compatibility with the most advanced version of XMapTools!
Provide a new zoom and pan module including: buttons to switch between the two modes and to reset the original view. This image display module has been extended to be compatible with most of the original XMapTools functions, e.g. the field of view does not change when a new element is selected for display. Note: the zoom is not activated when XMapTools starts. It is necessary to click on the zoom button to activate the zoom mode (see the user guide for a complete description)
Provide a classification tool in the Binary module. A quick classification using the k-means technique (three different procedures are implemented: sqEuclidean, city block, cosine) can be performed and saved in any binary diagram. Then the group can be displayed in any different binary for comparaison. This technique can be used to investigate the correlations and miscorrelations between several groups
Provide an improved function to export the displayed image that is compatible with the new module. The new export function includes a dynamic scale bar, the XMapTools logo and the name of the corresponding map
Provide improved sampling functions, including: labelling of X and Y axes in binary diagrams; a new color mode for binary plots; the ‘multi maps/areas’ mode has been added to the sampling mode ‘area’; the option to save the corresponding figure is available for all the sampling modes
Provide a new structural formula function for magnetite (Mgt-StructForm)
Provide a new structural formula function for garnet with a better approximation of XFe3+ (Grt-StructForm-Fe3-Advanced(slow)). Note that this optimisation involves loops making the function quite slow (5-10 minutes for a map of 500×500 pixels). This function was developed by Julien Reynes
Improve the mode [8] of the function ‘Export compositions’ providing the total for the analysis in oxide and the associated uncertainty
Improve the functions ‘Add map(s)’ and ‘Classification’ to detect additional formatting issues in the files to be read
Other changes:

Resolve an issue with the Generator module when addition and subtractions are used. Each undefined pixel has a value of zero in the generated map
Resolve an issue with the plot auto-contrast and median filter functions in the workspace Results that were not working while a new map was selected
Resolve an issue with the auto-contrast function that was not working after switching between workspaces
Resolve an issue with the function ‘transfer to quanti’ that was not working with maps created by the Generator module
Resolve a minor display issue in the function generating the sum of oxide map
Resolve a minor display issue with the XMapTools’ logo
Resolve minor issues with the function reading the internal standard file; formatting error detection has been improved
The files Xmap_SpiderColors.txt and Xmap_Spider.txt are now read while the Spider module opens; there is no need anymore to restart XMapTools after editing these files, but just close and restart the Spider module
The sampling method ‘integrated line’ has been made compatible with the new zoom capabilities
The sampling function ‘area’ displays the mean and standard deviation (1s); these results can be selected as text (and copied).
The sampling functions have beed improved, especially to avoid errors while users click other buttons at the same time
The classification method “file” was set as default method in the classification method menu
The rotate function has been improved to prevent misbehaviour in some computers
Additional bug fixes

# XMapTools 2.5.2 (08-08-2018)
This XMapTools 2.5.2 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Improve the mask files generated by XMapTools; an info file containing the mask names and defining which masks are selected (or not) is automatically generated by XMapTools and the modules Binary and TriPlot3D.
Improve the functions to save and open an existing project. The map orientation is saved and automatically restored
Provide an updated export function in QUANTI asking if the active figure must be saved in all the export modes
Improve the update module that is now recommending to restart MATLAB after XMapTools’ core update; note that this procedure will be applied for future updates only
Other changes:

Fixes an issue with the delete function in Quanti while the selected map cannot be deleted
The equation to recalculate Fe2O3 has been corrected in the external functions StructFctCpxFe3.m and StructFctCpxWFe3.m, StructFctGarnetFe3.m
Additional bug fixes

# XMapTools 2.5.1 (28-06-2018)
This XMapTools 2.5.1 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Provide a map view in the standardization module and add visual warnings to avoid too high concentration to be applied to mixing pixels
Provide a new tool to select or reject standards in the calibration diagram of the standardization module
Provide a major update to the Binary module (former Chem2D) including: a new free shape mode for both pixel identification and multi-groups; log scales for x or/and y axes; a logarithmic color bar for density diagrams (optional); an auto-scaling mode; an improved GUI with optimised plots; pixels of each groups are now plotted with different colours
Provide a new module Generator, which generate new maps from the existing maps using array operations. Classical operations for maps of major element, oxide and trace elements are defined in /Program/Dev/Xmap_VarDefinition.txt
Provide a new settings option to display the color bar using logarithmic scale and to set the colormap resolution; the default value has been increased from 64 to 128
Provide a new correction function RM1 to clean map pixels in the X-ray workspace
Provide several new features in the Spider module including new color maps, a hold on mode, and a function that saves movies
Provide an updated precision function exporting the precision map using linear and logarithmic color scales
Provide an updated export function that can extract information from histogram and density probability plots
Provide a debug function to unfreeze the interface if the program is stuck
Mineral names of the structural formula functions have been updated following the recommendations of Whitney & Evans (2010), American Mineralogist 95, 185-187, DOI:10.2138/am.2010.3371
Other changes:

Resolve an issue with the function “load project” when EDS maps are not recognized for standardization
Resolve an issue with text display in the legend of the RGB module
Resolve an issue with the zoom function of the advanced standardization module
Resolve an issue when switching between modes in the standardization module
Resolve an issue with the check quality of std/map position function when the button cancel used
Resolve an issue with the auto-contrast and median-filter buttons to restore the unselected mode when a new map is plotted
Resolve an issue with the delete function in the workspace “Quanti” including a smart selection within the new list of map
Resolve an issue with the correction mode that did not work properly with the add-on button
Resolve an issue in the external function Gar-StructForm-Ti that prevented the waiting bar to appear when the function was used
Additional bug fixes
User-guide version 2.5:

The function descriptions have bee updated, including the description of the new modules

# XMapTools 2.4.3 (10-01-2018)
This XMapTools 2.4.3 update is strongly recommended for all users as it fixes a major issue in the deadtime correction function

It is strongly recommended to all users to re-import the X-ray maps with XMapTools 2.4.3. There was an error in the deadtime correction function of the import tool. The deadtime correction in the previous versions (probably since 2.4.1) was overestimated by a factor of 1000/dwelltime. In most cases, this error did not affect the standardized maps, if the standardization was good and the quality checks were correctly performed.

Other changes:

Provide a new colormap FreezeWarm (created by S. Centrella)
Several minor issues have been fixed in the advanced standardization module
Additional bug fixes

# XMapTools 2.4.2 (20-09-2017)
This XMapTools 2.4.2 update is strongly recommended for all users as it fixes an issue with the new XMapTools menu introduced in XMapTools 2.4.1.

XMapTools 2.4.1 (28-08-2017)
This XMapTools 2.4.1 update is strongly recommended for all users and contains several new features as well as improvements to stability and compatibility. This update:

Provide an advanced standardization method with a new graphical user interface module
Provide a new module for time-dependent intensity drift correction (IDC)
Provide a new external function to generate maps of Mean-Atomic-Number
Provide a new external function to compute maps of structural formulas for antigorite
Improve the detection of errors of the function used to load the file Standards.txt
Improve the TOPO-related correction to avoid negative pixel values
Improve the positioning of XMapTools GUI by adding a function that align any additional module to the position of the main window
Improve the function to select/unselect the spot analyses used as internal standards
Other changes:

Resolve an issue with the function used to transfer maps from the Xray workspace to Quanti
Resolve an issue with the tool to display live coordinates in the workspace Quanti and Results (VER_804)
Resolve an issue with the use of oxide concentration maps exported from CAMECA microprobes
Resolve an issue with the display XMapTools’ logo
Resolve small issues with the function generate a density map that appeared when user pressed cancel
Resolve an issue with the result plot from the external function (P-T spot mode)
Resolve an issue with the closing function of some external modules
Correct the external function ThermoFctChlBourdelle.m
Add several elements and isotopes to the default file Xmap_Default.txt
Add several equations to the default file Xmpa_Variables.txt; Mathematical symbols should not be used in the variable name
Additional bug fixes
User-guide version 2.4:

The function descriptions have bee updated, including the description of the new modules
The first tutorial “electron microprobe X-ray maps processing” has been expended and includes the instructions to apply the advanced standardisation procedure

# XMapTools 2.3.1 (30-08-2016)
This XMapTools 2.3.1 update is strongly recommended for all users and contains new features together with improvements to stability and compatibility. This update:

Add an engine to incorporate XMapTools add-ons in the main GUI. For example XThermoTools, an add-on for thermodynamic modelling will be available in the futur.
Improve the import function (automatic indexation; introduce map types; load vector map) and provide a new module: the Import Tool (background correction; rotation; scaling). This new function allows importing LA-ICP-MS maps.
Provide a module to plot RGB images (XMTModRGB)
Provide a module to generate spider diagrams from maps (XMTModSpider)
Provide a function to explore the variations in local compositions within a domain
Provide a function to export mask files generated in XMapTools and to save them as *.txt file
Incorporate a new type of external function (5) to calculate density (chlorite, cpx and garnet – work in progress)
Provide a new function Transfert2Result in Quanti workspace (external functions module)
Provide a new function in the workspace Results to generate and plot relative variation maps to a reference pixel
Improve the function to export the bulk composition from any domain with uncertainty
Provide a ‘multi map mode’ for the sampling function: line
Other changes:

Resolve an issue where Density data are not provided in Classification.txt
Resolve an issue with the manual standardization where negative values are selected
Resolve an issue in the external function StructFctGarnetFe3
Resolve an issue with colorbars in MATLAB 2016a.
Improve the function to calculate new variables in Results
Improve the setup routine, which automatically generates the two directories /UserFiles and /Addons
Improve the compatibility with XThermoTools (future add-on)
Additional bug fixes

# XMapTools 2.2.1 (15-11-2015)
Many any useful tools are included, such as new exporting functions and a way to extrapolate 2D compositions into 3D and a density correction to calculate local compositions.

New function to export mean phase composition and standard deviation from
an area + structural formula with Monte-Carlo simulation
New function to extrapolate 2D compositions into 3D using ellipses and ellipsoids
New functions to delete a domain of a standardized map
New function to generate a density map
New function to generate y density-corrected standardized map
New function to duplicate a Quanti file
New external function: StrcutFormNepheline.m
Improved the setup program
Resolved troubles with the setup program
Fixed an issue that crash the program during update check (network not connected to internet)
Fixed crash of Chem2D on MATLAB 2015a
Fixed issue that made the diary not work
Fixed an issue with end-member proportions calculation on biotite

# XMapTools 2.1.7 (30-06-2015)
First public version of XMapTools 2. The following new features have been introduced:

New Graphic User Interface fully compatible with the new MATLAB© graphic engine
New corrections: Border-removing correction (BRC); Topo-related correction (TRC); Map position correction (MPC); Standard position correction (SPC); Intensity drift correction (IDC)
New starting options such as open (>> XMapTools open ProjectName)
New manual classification method: the masks generated with the chemical modules may be imported and merged in the main program in order to create a new mask file
Major update of the sampling functions, including a new sampling mode: integrated lines
Chem2D and TriPlot3D are available in all the workspaces (X-ray, Quanti, Results)
New function to test the positions of the spot analyses and the X-ray maps
A scale bar and the date have been added to the exported map
New user settings window and options
New histogram mode
The size of the main figure may be changed (three sizes are available)
More than twenty minor bugs have been fixed

# XMapTools 2.1.4 (01-06-2015)
Private version . XMapTools 2 gold master used to introduce the new program during workshop PETROCHRO-2015

# XMapTools 2.1.1 (10-06-2014)
Private version used to implement the new interface and the new features of XMapTools 2

# XMapTools 1.6.5 (27-12-2013)
Public release. New functions available to compute variables from output of results. The classification function can read external files reporting the coordinates of the initial pixels compositions used by the k-means function. New external functions: NThermoGC-pRavna2000Fe3, ThermoFctBioHenry, and structural formulas of epidote, allanite, staurolite and olivine. Fixed bugs and updated GUI button names

# XMapTools 1.6.4 (12-08-2013)
Public release. The function that read and execute external functions has been updated. The ‘P, T and P-T / spot mode (3)’ functions have been updated accordingly. Update of the external function StructFctBiotite with new end-members. New structural formulas functions: Cordierite and Mg-Fe Spinel. Fixed bugs in the standardization function and the bulk composition estimates

# XMapTools 1.6.3 (18-07-2013)
Public release. Fixed bug in the rotate function

# XMapTools 1.6.2 – (17-07-2013)
Public release. XMapTools_Launcher (download / setup / auto-updates); Zoom tool; new function rotate; std can be selected / deselected; New functions; New GUI XMapTools info functions; New function to test the standardization. This version doesn’t require any MATLAB© Toolbox

# XMapTools 1.6.1 – (07-01-2013)
Public release. New tool: Panel; new options

# XMapTools 1.5.4 – (01-11-2012)
Beta release of XMapTools 1.6.1 tested during the short course Bern 2012. Private release. This version must be updated

# XMapTools 1.5.2 – (17-09-2012)
This release does not require the MATLAB© “statistic toolbox”

# XMapTools 1.5.1 – (03-09-12)
First public release. New button for filtering. Warning: requires the MATLAB© Statistic Toolbox

# XMapTools 1.4.3 – Forsterite formation (french)
Version utilisée pour la formation forstérite. Attention, cette version doit être mise à jour afin de bénéficier de toutes les fonctionnalitées de MATLAB© V1.5




