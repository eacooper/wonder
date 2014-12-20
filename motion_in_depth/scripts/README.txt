Experiment:

	-If the experiment crashes, you will need to press command+c twice(?) to get the keyboard control back

	-Note the differences between specifying a *step* (in arcminutes of disparity) versus a ramp (in monocular degrees per second). So the ending disparity of a 3D ramp will be 2x the number you input, in degrees. The magnitude of a 2D step will be 1/2x the number you input, in arcminutes. During analysis everything is converted to degrees


	GUI:
		-You can't record and provide feedback at the same time

		-Expected duration is based on some assumed inter-trial break duration, around 5 seconds

		-Once a new value is changed, press enter to update GUI info

		-IPDS: you can enter a subject's initials and IPD in the options ipd script to make it autoload when you click enter






Analysis:

	-New data need to be manually copied to the analysis machine (Denali)

	-If there are session you no longer want to look at but want to keep just in case, you can move them to a different directory and then reprocess all data without them (see below)


	GUI:

		-"Reprocess" button reprocesses all data. This can take a long time and the button will tell you when done. You have the close and re-open the GUI to have access to the new data. You can alternatively call load_data(1) from the terminal prompt.

		-"Process New Session" allows you to select and process just the latest data. Each time you can select the files for one subject, one experiment type

	Plots:

		-We compute velocity using an sgolay filter and then averaging trials


