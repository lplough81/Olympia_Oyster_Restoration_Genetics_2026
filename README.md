# Olympia_Oyster_Restoration_Genetics_2026
Repository holding raw data and code for olympia oyster restoration genetics paper

**Data files** \
SNPs_Final.gen and Mhap_FINAL_Filtered.gen are the genepop files used in the paper for analysis of population structure, Fst, etc. These "base" files can be converted to .str (structure files) via PGDSpider for Structure analyses.

VCF files that precede the genepop files are also available in the repository. they can be converted to "raw" format in PLINK via the command ```plink --vcf input.vcf.gz --recode A --out output```, from which it can be converted via BASH script to genepop format (see code).  

Sample names in the .VCF files (*thin350.Filtered.vcf.gz* or *OlyO_depth50nomiss.vcf.gz*) are shortened in some cases, but the sample numbers are consistent across file types. "WB" is Willapa bay, "MB" is Mystery Bay, "LS" is Little Skookum Inlet, "BL" is Burley Lagoon, "PGB" is Port Gamble Bay, "Disco" is Discovery Bay, "FB" is Fidalgo Bay, "CS" is Central Sound or Mud Bay. See metadata summary file for GPS coordinates and other site info. Note that the "thin350" file is filtered to just one SNP per amplicon (and filtered for missingness etc) while the "OlyO_depth50" file has all 8000 variants across amplicons with minimal filtereing (i.e. is closer to a raw file). 
\
Metadata.OlyOyster.csv shows the metadata (GPS coordinates and other site info).

Primer Sequences (OlyO_GTseq375_Primers.xlsx - with and without Illumina adaptors) are the sequences of each primer for each amplicon. OlyO_GTseq375_Primers-notag.csv is the file used int he microhaplotype processing script.


**Raw Fastq data** \
Raw fastq files available at SRA archive: PRJXXXXXXX (https://www.ncbi.nlm.nih.gov/sra....) \
\
**Code**\
"Plink to genepop code" is a simple set of BASH commands to convert PLINK raw format to genepop. 
"CLUMPP-style_Structure_convergence%20statistics.R" calculates convergence statistics for structure runs at various Ks. Used to assess how well Structure runs converged for SNP dataset and microhaplotype dataset. 

