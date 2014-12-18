Experiment:

	-If the experiment crashes, you will need to press command+c twice(?) to get the keyboard control back


	GUI:
		-You can't record and provide feedback at the same time

		-Expected duration is based on some assumed inter-trial break duration

		-"Settings changed" warning is okay if you just changed the repeats

		-Once a new value is entered, click in another field to see the update.

		-IPDS: you can enter a subject's initials and IPD in the options ipd script to make it autoload when you click the IPD field






Analysis:

	-New data need to be manually copied to the analysis machine (Denali)

	-If there are session you no longer want to look at but want to keep just in case, you can move them to a different directory and then reprocess all data without them (see below)


	GUI:

		-"Reprocess" button reprocesses all data. This can take a long time and the button will tell you when done. You have the close and re-open the GUI to have access to the new data. You can alternatively call load_data(1) from the terminal prompt.

		-"Process New Session" allows you to select and process just the latest data. Each time you can select the files for one subject, one experiment type

	Plots:

		-Plotted prediction lines always return to zero at the end of the trial, this is incorrect

