%==========================================================================
%                   MATLAB Data Structures Tutorial
%
% This program demonstrates fundamental MATLAB data structures and operations
% through a practical example of student grade management. It covers:
% 1. Basic data structures (arrays, matrices, cell arrays, structures)
% 2. File I/O operations (reading/writing Excel files)
% 3. Data analysis and visualization
% 4. Programming constructs (loops, conditionals)
%
%@Objective             Introduce data structures in MATLAB
%@Author                Swapnil Singh
%==========================================================================

% Clear workspace and command window for a fresh start
clc         % Clears the command window
clear all   % Removes all variables from workspace

%% Part 1: Data Creation and Storage
% This section demonstrates how to create and manipulate different data types
% and structures in MATLAB

% --- Student Basic Information Setup ---
num_students = 30;  % Define number of students in class
% Create sequential ID numbers using array generation
% 1001:1030 - demonstrates array creation using colon operator
student_ids = 1001:1000+num_students;  

% --- Name Creation using Cell Arrays ---
% Cell arrays allow storage of text data (strings) in MATLAB
% Create two cell arrays containing possible first and last names
first_names = {'John', 'Emma', 'Michael', 'Sophia', 'William', ...
               'Olivia', 'James', 'Ava', 'Benjamin', 'Isabella'};
last_names = {'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', ...
              'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez'};

% Set random seed for reproducible results
rng(42);  % Same random numbers generated each time code runs

% Initialize empty cell array for student names
% cell(rows, columns) creates empty cell array
student_names = cell(num_students, 2);  % 30 students × 2 (first, last name)

% Randomly assign names to students
for i = 1:num_students
    % randi generates random integer indices
    % Uses curly braces {} for cell array content access
    student_names{i,1} = first_names{randi(length(first_names))};
    student_names{i,2} = last_names{randi(length(last_names))};
end

% --- Grade Generation using Matrices ---
num_assignments = 4;
num_exams = 2;
% Generate random grades using randi
% randi([min max], rows, cols) generates random integers in specified range
assignments = randi([70 100], num_students, num_assignments);  % Assignment grades
exams = randi([60 100], num_students, num_exams);             % Exam grades

% --- Calculate Final Grades using Array Operations ---
% Demonstrate matrix operations and weighted averages
assignment_weight = 0.4;
exam_weight = 0.6;
% mean(X,2) calculates mean along rows (for each student)
final_grades = assignment_weight * mean(assignments, 2) + ...
               exam_weight * mean(exams, 2);

% --- Combine Data for Excel Export ---
% Create header row as cell array
header = {'Student ID', 'First Name', 'Last Name', ...
          'Assignment 1', 'Assignment 2', 'Assignment 3', 'Assignment 4', ...
          'Midterm', 'Final', 'Final Grade'};

% Initialize cell array for all data
% Size: num_students rows × length(header) columns
data = cell(num_students, length(header));

% Fill data cell array combining numeric and text data
for i = 1:num_students
    % Notice how we can store both numbers and text in cell array
    data{i,1} = student_ids(i);          % Student ID (number)
    data{i,2} = student_names{i,1};      % First name (text)
    data{i,3} = student_names{i,2};      % Last name (text)
    data{i,4} = assignments(i,1);        % Assignment grades (numbers)
    data{i,5} = assignments(i,2);
    data{i,6} = assignments(i,3);
    data{i,7} = assignments(i,4);
    data{i,8} = exams(i,1);             % Exam grades (numbers)
    data{i,9} = exams(i,2);
    data{i,10} = final_grades(i);       % Final grade (number)
end

% --- Write Data to Excel File ---
filename = 'student_grades.xlsx';
% writecell writes cell arrays to Excel
% 'Range' specifies starting cell in Excel
writecell(header, filename, 'Range', 'A1');    % Write header row
writecell(data, filename, 'Range', 'A2');      % Write data starting row 2

%% Part 2: Data Reading and Analysis
% This section demonstrates how to read and process data from Excel

% Read Excel file - xlsread returns three arrays:
% num_data: numeric values
% txt_data: text values
% raw_data: everything as cell array
[num_data, txt_data, raw_data] = xlsread(filename);

% Extract components using array indexing
% 2:end skips header row
student_names_read = raw_data(2:end, 2:3);  % Get names (text)
grades_read = num_data(:, 4:end);           % Get grades (numeric)


% Calculate basic statistics
assignment_means = mean(grades_read(:, 1:4));  % Mean for each assignment
exam_means = mean(grades_read(:, 5:6));        % Mean for each exam
final_mean = mean(grades_read(:, 7));          % Overall final grade mean
final_std = std(grades_read(:, 7));            % Standard deviation

%% Part 3: Data Visualization
% This section demonstrates various plotting techniques in MATLAB

% Create figure window with specific size
figure('Position', [100 100 1200 800]);  % [left bottom width height]


% --- Assignment Grade Distributions ---
subplot(2,2,1)  % 2×2 grid, first positio
boxplot(grades_read(:,1:4), 'Labels', {'Assign 1', 'Assign 2', 'Assign 3', 'Assign 4'})
title('Assignment Grade Distributions')
ylabel('Grades')
xlabel('Assignments')
grid on


% --- Exam Grade Distributions ---
subplot(2,2,2)  % 2×2 grid, second position
boxplot(grades_read(:,5:6), 'Labels', {'Midterm', 'Final'})
title('Exam Grade Distributions')
ylabel('Grades')
grid on

% --- Final Grade Distribution ---
subplot(2,2,3)  % 2×2 grid, third position
histogram(grades_read(:,7), 10, 'FaceColor', 'b', 'EdgeColor', 'w')
title('Final Grade Distribution')
xlabel('Grade')
ylabel('Number of Students')
grid on

% --- Student Performance Ranking ---
subplot(2,2,4)  % 2×2 grid, fourth position
% Plot sorted grades and class average
plot(1:num_students, sort(grades_read(:,7), 'descend'), 'b-o', 'LineWidth', 1.5)
hold on  % Allow multiple plots on same axes
plot([1 num_students], [final_mean final_mean], 'r--', 'LineWidth', 1.5)
title('Student Performance Ranking')
xlabel('Student Rank')
ylabel('Final Grade')
legend('Individual Grades', 'Class Average', 'Location', 'best')
grid on

% Add text box with summary statistics
dim = [.15 .05 .3 .1];  % [left bottom width height]
str = sprintf(['Class Statistics:\n' ...
              'Mean Final Grade: %.1f\n' ...
              'Std Dev: %.1f\n' ...
              'Max Grade: %.1f\n' ...
              'Min Grade: %.1f'], ...
              final_mean, final_std, max(final_grades), min(final_grades));
annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', ...
           'BackgroundColor', 'white', 'EdgeColor', 'black');



%% Part 4: Structure Arrays
% This section demonstrates MATLAB structure arrays for organized data storage

% Create structure array for each student
students = struct();  % Initialize empty structure
for i = 1:num_students
    % Each student gets a structure with fields:
    students(i).id = data{i,1};                    % ID number
    students(i).name = strcat(data{i,2}, ' ', data{i,3});  % Full name
    students(i).assignments = [data{i,4:7}];       % Assignment grades
    students(i).exams = [data{i,8:9}];            % Exam grades
    students(i).final_grade = data{i,10};          % Final grade
end

% Find and display top 3 students
% sort returns sorted values and indices
[~, top_indices] = sort([students.final_grade], 'descend');
fprintf('\nTop 3 Students:\n');
for i = 1:3
    idx = top_indices(i);
    fprintf('%s: %.1f\n', students(idx).name, students(idx).final_grade);
end


