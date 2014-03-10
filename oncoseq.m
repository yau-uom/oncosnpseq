function oncoseq(varargin)
%
% main oncoseq function
%
disp('OncoSNP-SEQ v2.0');
disp('---');
disp(' ');
disp('Copyright (c) 2014 University of Oxford.');
disp(' ');
disp('Developed by: Dr Christopher Yau, Wellcome Trust Centre for Human Genetics, University of Oxford.');
disp(' ');
disp(' ');

%% default settings
options.maxCopy = 10; %% maximum copy number
options.read_depth_range = [10:60]; % range of haploid read coverages to scan
options.chrRange = [1:22]; % number of chromosomes to process
options.N_train = 30000; % number of training data points to use
options.maxploidy = 4.5; % maximum ploidy (max average copy number)
options.minploidy = 1.5; % minimum ploidy (min average copy number)
options.normalcontamination = 0;
options.tumourheterogeneity = 0;
options.u0_levels = linspace(1e-3, 0.9+1e-3, 10);
options.u_levels = [ 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 ];
options.maxnormalcontamination = 0.5;
options.lambda_1_range = [500 250 100 50 30];
options.lambda_2 = 30;
options.training = 0;
options.read_error = 0.01;
options.seq_error = 0.01;
options.u_alpha = 1.1;
options.u0_alpha = 0.5;
options.u0_beta = 5;
options.alpha = [ 1 20 ];
options.beta = [ 100 20 ];
options.diagnostics = 0;
options.paired = 0;

options.tumourStateTable = [];
options.gcdir = [];
options.mapdir = [];
options.hgtables = [];

foundHgtable = 0;
foundInfile = 0;
foundOutdir = 0;
foundSampleName = 0;
foundSeqType = 0;

for i = 1 : nargin

	if strmatch(lower(varargin{i}), '--maxcopy') 
		options.maxCopy = str2num(varargin{i+1});
	end

	if strmatch(lower(varargin{i}), '--read_depth_range') 
		options.read_depth_range = eval(varargin{i+1});
	end

	if strmatch(lower(varargin{i}), '--chr_range') 
		options.chrRange = eval(varargin{i+1});
	end

	if strmatch(lower(varargin{i}), '--n_train') 
		options.N_train = str2num(varargin{i+1});
	end

	if strmatch(lower(varargin{i}), '--u_levels') 
		options.u_levels = eval(varargin{i+1});
	end

	if strmatch(lower(varargin{i}), '--u0_levels') 
		options.u0_levels = eval(varargin{i+1});
	end

	if strmatch(lower(varargin{i}), '--seqerror') 
		options.seqerror = str2num(varargin{i+1});
	end
	
	if strmatch(lower(varargin{i}), '--readerror') 
		options.readerror = str2num(varargin{i+1});
	end	

	if strmatch(lower(varargin{i}), '--maxploidy') 
		options.maxploidy = str2num(varargin{i+1});
	end

	if strmatch(lower(varargin{i}), '--minploidy') 
		options.minploidy = str2num(varargin{i+1});
	end

	if strmatch(lower(varargin{i}), '--normalcontamination') 
		options.normalcontamination = 1;
	end

	if strmatch(lower(varargin{i}), '--tumourheterogeneity') 
		options.tumourheterogeneity = 1;
	end

	if strmatch(lower(varargin{i}), '--maxnormalcontamination') 
		options.maxnormalcontamination = str2num(varargin{i+1});
		loc = find(options.u0_levels <= options.maxnormalcontamination );
		options.u0_levels = options.u0_levels(loc);
	end

	if strmatch(lower(varargin{i}), '--training') 
		options.training = 1;
	end

	if strmatch(lower(varargin{i}), '--gcdir') 
		options.gcdir = varargin{i+1};
		if ~exist(options.gcdir) 
			disp(['Error! Cannot find Local GC content directory: ' options.gcdir ]);
			return;
		end
	end

	if strmatch(lower(varargin{i}), '--mapdir') 
		options.mapdir = varargin{i+1};
		if ~exist(options.mapdir) 
			disp(['Error! Cannot find mappability directory: ' options.mapdir ]);
			return;
		end
	end
	
	if strmatch(lower(varargin{i}), '--hgtable') 
		options.hgtables = varargin{i+1};
		if exist(options.hgtables, 'file')
			foundHgtable = 1;
		end
	end

	if strmatch(lower(varargin{i}), '--tumourstatestable') 
		options.tumourStateTable = varargin{i+1};
		if ~exist(options.tumourStateTable, 'file')
			disp(['Error!: The specified tumour states file does not exist: ' options.tumourStateTable ]);
			return;
		end
	end
	
	if strmatch(lower(varargin{i}), '--seqtype') 
		options.seqtype = varargin{i+1};
		if ~isempty( strmatch(options.seqtype, 'cg', 'exact') )
			foundSeqType = 1;
			options.paired = 1;				
		end
		if ~isempty( strmatch(options.seqtype, 'illumina', 'exact') )
			foundSeqType = 1;		
		end
	end

	if strmatch(lower(varargin{i}), '--samplename') 
		options.samplename = varargin{i+1};
		foundSampleName = 1;
	end

	if strmatch(lower(varargin{i}), '--infile') 
		options.infile = varargin{i+1};
		if ~exist(options.infile, 'file')
			disp(['Error! Input file not found: ' options.infile]); 
			return;
		else
			foundInfile = 1;
		end
	end

	if strmatch(lower(varargin{i}), '--normalfile') 
		options.normalfile = varargin{i+1};
		if exist(options.normalfile, 'file')
			options.paired = 1;
		else
			disp(['Error!: The specified normal file does not exist: ' options.normalfile ]);
			return;
		end
	end

	if strmatch(lower(varargin{i}), '--outdir') 
		options.outdir = varargin{i+1};
		if exist(options.outdir, 'dir')
			foundOutdir = 1;
		end
	end

	if strmatch(lower(varargin{i}), '--diagnostics') 
		options.diagnostics = 1;
	end

end

if foundHgtable == 0
	disp(['Error! HG data table not found: ' options.hgtables]); 
	return;
end

if foundSeqType == 0
	disp('Error! No sequencing type supplied.'); 
	return;
end

if foundSampleName == 0
	disp('Error! No sample name supplied.'); 
	return;
end

if foundInfile == 0
	disp(['Error! Input file not found: ' options.infile]); 
	return;
end

if foundOutdir == 0
	disp(['Error! Output directory not found: ' options.outdir]); 
	return;
end


% set up output directories
if ~exist(options.outdir, 'dir')
	disp(['Creating output directory: ' options.outdir]);
	success = mkdir(options.outdir);
	if ~success 
		disp(['Could not create output directory: ' options.outdir]);
		return;
	end
end

options.outfile = [ options.outdir '/' options.samplename '.cnvs' ];
options.outfile_all = [ options.outdir '/' options.samplename '.cnvall' ];
options.outfile_cost = [ options.outdir '/' options.samplename '.cost.ps' ];	
options.matfile = [ options.outdir '/' options.samplename '.mat' ];	
options.outfile_qc = [ options.outdir '/' options.samplename '.qc' ];	
options.outfile_scan = [ options.outdir '/' options.samplename '.scan' ];	
options.outfile_diagnostics = [ options.outdir '/' options.samplename '-diagnostics.mat' ];	

oncoseq_run(options);

