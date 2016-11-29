Version History (Change Log)
0.0 {StrainMeasurement}
    -Original Program (All Rights Belong to S. Frank)
    
0.1
    -Changed Threshold to automatically update
    
1.0 {OSM}
    -Complete GUI/Program Overhaul (New Program)
    -Added abiltiy to Load Videos
    -Added ability to Rotate Frames/Images
    -Added ability to Invert Black and White (Negative)
    -Added ability to load all matlab supported image formats
    -Changed boundries to be individually set
    -Changed initiallization to be set individually
    -Changed initiallization to be called guesses
    -Changed curve fit to use only 2-point-fitting
    
1.1
    -Added use of local temporary folder to store image data
    -Added output folder with name selection
    -Added saving copy of video Frames for faster loading later
    -Added button control; allowing certain buttons to become enabled after certain steps
    -Added clear button in boundries
    -Changed color scheme on the 'Negative' button when pressed

1.2
    -Added percent of video loaded as a warning dialog box
    -Added percent completed to the anaysis as a warning dialog bx
    -Fixed Rotate bug; where rotating the image caused the bounds to break past the edge of the image
    -Fixed error on closing or canceling the loading window by reopening it for the user
    -Fixed bug; where the temporary folder would not delete itself
    
1.3
    -Added Auto guessing button that finds the first and last points where the intensity is above 0.8 times the maximum intensity value
    -Changed closing or canceling the loading window to return the GUI but not advance the current state of the GUI
    
1.4
    -Added Auto-Bounding by performing blob anaysis
    -Changed the percent loaded/completed warning dialog boxes with a text box displaying the percent

1.5
    -Added Adaptive Processing which allows the boundries to be adjusted as the tracked edges move
    -Added increasing auto boundry size by repeated pressing the auto bound button
    
2.0 {OSM_NT}
    -Removed conversion of Image to black and white (remains as grayscale)
    -Removed Threshold Slider and Textbox 
    -Changed from 2 point to 6 point curve fitting
    -Fixed bug; where clear did not reset auto-bounding bounds

2.1
    -Added ability to use multiple cores to load video files
    
2.2
    -Added ability to use hyper-threading (effectivly doubles number of cores available)

2.3
    -Added Dualcore mode to limit the number of cores to use

2.4
    -Added check for number of threads compared to cores to determine if hyperthreading is available

2.5
    -Added Weighting to the average intensity calculation
    -Added textbox that shows the maximum number cores available
    -Added textbox that shows the current number of cores to be used
    
2.5.1
    -Added red text to the current number of cores to be used when the current equals the maximum

3.0 {OSM_V3_0}
    -Added Button for live video loading, currently does nothing when pressed
    -Changed Text 'Max. Cores' to more accurately read 'Max. Threads'
    -Changed Text 'Curr. Cores' to more accurately read 'Curr. Threads'
    -Removed use of global variables

3.0.1
    -Added feature that embeds the video creation date into first image
    -Added text displaying current image's folder name
    -Added text displaying Image/Video Creation DateTime
    -Added listbox containing all available video devices
    -Changed Button for live video loading to link to video device listbox
    
3.0.2
    -Changed listbox into popup menu to display available devices
    -Added Visual from selected camera
    -Added textbox to input how long to take video for
    -Added textbox and slider to adjust framerate
    -Added Cancel button to live video
    -Added start button to live video

3.0.3
    -Added 'Data.mat' to output files, which contains all outputted data
    -Added Start button actually aquires video now
    -Added process for loading Captured images from camera
    -Fixed Powershell bug where 'enter' needed to be pressed otherwise program would freeze on windows 7
    -Changed Slider and textbox for framerate into popup menu with all valid framerates for the selected device
    
3.0.4
    -Added FrameRate cap to live video such that no errors due to insufficent memory occure
    -Fixed bug; where loading a second video after rotating the first causing errors
    
3.0.5
    -Changed Live Video display to be a Video preview rather than a still picture

4.0.0 {OSM_V4_0}
    -Significant improvements in speed of processing
    -Parallel Processing removal started
    
5.0.0 {OSM_Classic}
    -Complete rewrite of the program resulting in more than 35% reduction in code length, while facilitating a significant improvement in the speed of the program's procressing
    
5.1.0
    - Improved feedback provided during the processing by including a live display of the current strain and strain vs image number
    
5.1.1
    - Added Save and Quit Button to Allow the stopping a test midway, without the loss of Data
    