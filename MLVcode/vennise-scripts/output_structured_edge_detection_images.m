function output_structured_edge_detection_images
    % script to compute the output images of the structured edge detection code
    % (have to run on windows 10)
    
    
    tic; % Start timer at the beginning of script

    % Open log file for writing
    logFile = fullfile('C:\Users\MLVToolbox\MATLAB\Projects\published-toolbox\MLVcode\vennise-scripts', 'processing_log_SED.txt');
    fid = fopen(logFile, 'w'); % Open file in write mode
    if fid == -1
        error('Could not open log file for writing.');
    end

    % Define input and output folders
    inputFolder = 'C:\Users\MLVToolbox\MATLAB\Projects\published-toolbox\MLVcode\vennise-scripts\input_images';  % Folder with test images
    outputFolder = 'C:\Users\MLVToolbox\MATLAB\Projects\published-toolbox\MLVcode\vennise-scripts\output_images_SED'; % Folder to save results

    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder); % Create output folder if it doesn't exist
    end

    % Get all images in the input folder
    imageFiles = dir(fullfile(inputFolder, '*.jpg')); 
    disp({imageFiles.name});
    fprintf(fid, 'Images found: %s\n', strjoin({imageFiles.name}, ', ')); % Save to log file

    % Process each image with SED
    for i = 1:length(imageFiles)
        fprintf('Image Number: %d \n', i);
        fprintf(fid, 'Image Number: %d \n', i); % Save to log file

        fileName = imageFiles(i).name;
        imgPath = fullfile(inputFolder, fileName);

        % Process image with SED
        vecLD = traceLineDrawingFromRGB(imgPath);

        figure;
        drawLinedrawing(vecLD);
        
        % Display progress
        fprintf('Processed %s. \n', fileName);
        fprintf(fid, 'Processed %s. \n', fileName);

        % Log elapsed time
        elapsedTime = toc; % Get elapsed time in seconds
        fprintf('Elapsed time: %.2f seconds\n', elapsedTime);
        fprintf(fid, 'Elapsed time: %.2f seconds\n', elapsedTime);
    end

    disp('Processing complete. Results saved in output_images_SED/');
    fprintf(fid, 'Processing complete. Results saved in output_images_SED/\n');

    elapsedTime = toc; % Get elapsed time in seconds
    fprintf('Elapsed time: %.2f seconds\n', elapsedTime);
    fprintf(fid, 'Total elapsed time: %.2f seconds\n', elapsedTime);
    
    fclose(fid);
end