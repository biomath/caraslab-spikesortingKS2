 function compile_data_for_analyses(Savedir)
%
% This function loops through recording folders and extracts all relevant
% files into a folder called Data inside the parent directory. The purpose
% is to centralize all subjects' data into common directories
%


%Prompt user to select folder
datafolders_names = uigetfile_n_dir(Savedir,'Select data directory');
datafolders = {};
for i=1:length(datafolders_names)
    [~, datafolders{end+1}, ~] = fileparts(datafolders_names{i});
end


% Create data analysis folders in parent directory
full_path_split = split(Savedir, "/");
parent_path = strjoin(full_path_split(1:end-1), "/");
    
behavior_targetSource_paths =       {fullfile(parent_path, 'Data', 'Behavioral performance'), ...
                                        fullfile(Savedir, 'Behavior')};

%For each data folder...
for i = 1:numel(datafolders)
    cur_path.name = datafolders{i};
    cur_savedir = fullfile(Savedir, cur_path.name);
    
    % Declare all files you want to copy here
    breakpoints_targetSource_paths =    {fullfile(parent_path, 'Data', 'Breakpoints'), ...  % Target
                                            fullfile(cur_savedir, 'CSV files', '*breakpoints.csv')};  % Source
    keyFiles_target_path =              {fullfile(parent_path, 'Data', 'Key files'), ...
                                            fullfile(cur_savedir, 'CSV files', '*trialInfo.csv')};
    qualityMetrics_target_path =        {fullfile(parent_path, 'Data', 'Quality metrics'), ...
                                            fullfile(cur_savedir, 'CSV files', '*quality_metrics.csv')};
    shankWaveform_target_path =         {fullfile(parent_path, 'Data', 'Quality metrics'), ...
                                            fullfile(cur_savedir, '*shankWaveforms*.pdf')};
    spikeTimes_target_path =            {fullfile(parent_path, 'Data', 'Spike times'), ...
                                            fullfile(cur_savedir, '*cluster*.txt')};
    waveormMeasurements_target_path =   {fullfile(parent_path, 'Data', 'Waveform measurements'), ...
                                            fullfile(cur_savedir, 'CSV files', '*waveform_measurements.csv')};
    dacFiles_target_path =              {fullfile(parent_path, 'Data', 'DAC files'), ...
                                            fullfile(cur_savedir, 'CSV files', '*DAC*.csv')};
    waveformFiles_target_path =              {fullfile(parent_path, 'Data', 'Waveform samples'), ...
                                        fullfile(cur_savedir, 'CSV files', '*_waveforms.csv')};
                                    
    % Combine to loop and copy
	all_paths = {breakpoints_targetSource_paths, ...
        keyFiles_target_path, qualityMetrics_target_path, shankWaveform_target_path, ...
        spikeTimes_target_path, waveormMeasurements_target_path, dacFiles_target_path, waveformFiles_target_path};
    
    for path_idx = 1:length(all_paths)
        cur_paths = all_paths{path_idx};
        copy_data_files_from_dir(cur_paths{1}, cur_paths{2})
    end
    
end

% Lastly copy behavior files
copy_data_files_from_dir(behavior_targetSource_paths{1}, behavior_targetSource_paths{2})

function copy_data_files_from_dir(target_path, file_paths)
    mkdir(target_path);
    if isfolder(file_paths)
        filedirs = caraslab_lsdir(file_paths);
        filedirs = {filedirs.name};
    else
        filedirs = dir(file_paths);
    end
    for file_idx=1:length(filedirs)
        if ~isempty(filedirs)
            if isfolder(file_paths)
                cur_filedir = fullfile(file_paths, filedirs{file_idx});
                copyfile(cur_filedir, fullfile(target_path, filedirs{file_idx}));
            else
                cur_filedir = filedirs(file_idx);
                copyfile(fullfile(cur_filedir.folder, cur_filedir.name), fullfile(target_path, cur_filedir.name));
            end
        end
    end
