clear all;
close all;
clc;

addpath('../');
addpath('../external/');

rand('state', 1);
randn('state', 1);

options.hgtables = '../config/hgTables_b37.txt'; % human genome annotation table
options.gcdir = '/data/cyau/software/gc/b37/'; % directory of local GC content files
options.outdir = '/data/cyau/temp/'; % output directory
options.tumourStateTable = '../config/tumourStates.txt';

options.seqtype = 'cg'; % sequencing type 'cg' or 'illumina'
options.samplename = 'snps-100'; % sample name
options.infile = '/data/cyau/cg/data/aaron/summary/snps-100.txt'; % input data file
%options.samplename = 'enric'; % sample name
%options.infile = '/data/cyau/Enric/output/oncosnpseq_input/masterVarBeta-PS2_GS000017809-ASM-N1-T1-T2.T2'; % input data file

dbstop if error


%%tic
%%oncoseq( 	'--maxCopy', '10', ...
%%			'--read_depth_range', '[10:40]', ...
%%			'--chr_range', '[1:22]', ...
%%			'--n_train', '30000', ...
%%			'--maxploidy', '5.5', ...
%%			'--minploidy', '1.5', ...
%%			'--seqerror', '0.05', ...
%%			'--readerror', '0.05', ...
%%			'--normalcontamination', ...
%%			'--maxnormalcontamination', '0.5', ...
%%			'--tumourstatestable', options.tumourStateTable, ...
%%			'--hgtable', options.hgtables, ...
%%			'--gcdir', options.gcdir, ...
%%			'--seqtype', 'cg', ...
%%			'--samplename', options.samplename, ...
%%			'--infile', options.infile, ...
%%			'--outdir', options.outdir ...
%%		);
%%toc

%%break;


%options.samplename = 'cll'; % sample name
%options.infile = '/data/cyau/wgs500/cll/snp/AS_CLL_003P1.txt'; % input data file
%options.normalfile = '/data/cyau/wgs500/cll/snp/AS_CLL_003GL.txt'; % input data file

%tic
%oncoseq( 	'--maxcopy', '5', ...
%			'--read_depth_range', '[10:40]', ...
%			'--chr_range', '[1:22]', ...
%			'--n_train', '30000', ...
%			'--maxploidy', '3.5', ...
%			'--minploidy', '1.5', ...
%			'--seqerror', '0.05', ...
%			'--readerror', '0.05', ...
%			'--tumourheterogeneity', ...
%			'--hgtable', options.hgtables, ...
%			'--gcdir', options.gcdir, ...
%			'--seqtype', 'illumina', ...
%			'--samplename', options.samplename, ...
%			'--infile', options.infile, ...
%			'--outdir', options.outdir, ...
%			'--training', ...
%			'--diagnostics' ...
%		);
%toc

%break

% 32-34
options.samplename = 'FH_BLC_4070T_2';
options.infile = '/data/cyau/wgs500/pileup/snp/FH_BLC_4070T.txt.gz'; % input data file
options.normalfile = '/data/cyau/wgs500/pileup/snp/FH_BLC_4070N.txt.gz'; % input data file

%% 24-26
%options.samplename = 'FH_BLC_2010T_2';
%options.infile = '/data/cyau/wgs500/pileup/snp/FH_BLC_2010T.txt.gz'; % input data file
%options.normalfile = '/data/cyau/wgs500/pileup/snp/FH_BLC_2010N.txt.gz'; % input data file

options.samplename = 'it-met-3'; % sample name
options.infile = '/data/cyau/wgs500/pileup/snp/old/IT_Met_3a.txt.gz'; % input data file
options.normalfile = '/data/cyau/wgs500/pileup/snp/old/IT_Met_3b.txt.gz'; % input data file


tic
oncoseq( 	'--read_depth_range', '[10:30]', ...
			'--chr_range', '[1:22]', ...
			'--n_train', '30000', ...
			'--maxploidy', '5.5', ...
			'--minploidy', '1.5', ...
			'--seqerror', '0.05', ...
			'--readerror', '0.05', ...
			'--training', ...
			'--normalcontamination', ...
			'--maxnormalcontamination', '0.5', ...
			'--tumourstatestable', options.tumourStateTable, ...
			'--hgtable', options.hgtables, ...
			'--gcdir', options.gcdir, ...
			'--seqtype', 'illumina', ...
			'--samplename', options.samplename, ...
			'--infile', options.infile, ...
			'--normalfile', options.normalfile, ...
			'--outdir', options.outdir ...
		);
toc


%break;

%						
%			



%options.seqtype = 'illumina'; % sequencing type 'cg' or 'illumina'
%options.samplename = 'it-met-3'; % sample name
%options.infile = '/data/cyau/wgs500/pileup/snp/IT_Met_3a.txt.gz'; % input data file
%options.normalfile = '/data/cyau/wgs500/pileup/snp/IT_Met_3b.txt.gz'; % input data file

%%options.samplename = 'FH_BLC_745T';
%%options.infile = '/data/suzaku/yau/wgs500/pileup/snp/FH_BLC_745T.txt'; % input data file

%%options.samplename = 'cll-2'; % sample name
%%options.infile = '/data/suzaku/yau/wgs500/cll/snp/AS_CLL_077D.txt'; % input data file
%%options.infile = '/data/suzaku/yau/wgs500/cll/snp/AS_CLL_003P1.txt'; % input data file

%oncoseq( 	'--read_depth_range', '[10:40]', ...
%			'--chr_range', '[1:22]', ...
%			'--n_train', '30000', ...
%			'--maxploidy', '6.5', ...
%			'--minploidy', '1.5', ...
%			'--normalcontamination', ...
%			'--maxnormalcontamination', '0.5', ...
%			'--tumourstatestable', options.tumourStateTable, ...
%			'--hgtable', options.hgtables, ...
%			'--seqtype', 'illumina', ...
%			'--samplename', options.samplename, ...
%			'--infile', options.infile, ...
%			'--normalfile', options.normalfile, ...
%			'--outdir', options.outdir		);
%		
%		
%%					'--training', ...
%%			'--normalcontamination', ...
%%			'--maxnormalcontamination', '0.5', ...
