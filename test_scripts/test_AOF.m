addpath(genpath('scripts'))
addpath(genpath('lib'))

LD = 'beaches_00108_DN.png';

parameters.threshold = 0.25;
parameters.area_threshold = 20;

MAT = computeMAT(LD,parameters);
