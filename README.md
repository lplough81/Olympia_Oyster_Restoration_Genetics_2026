# Olympia_Oyster_Restoration_Genetics_2026
Repository holding raw data and code for olympia oyster restoration genetics paper

**Data files** \
SNPs_Final.gen and Mhap_FINAL_Filtered.gen are the genepop files used in the paper for analysis of population structure, Fst, etc. These "base" files can be converted to .str (structure files) via PGDSpider for Structure analyses.

A VCF file that precedes the genepop files is also available. It was converted to "raw" format in PLINK via the command ```plink --vcf input.vcf.gz --recode A --out output```, from which it was converted via BASH script to genepop (see code below).  Sample names in the .VCF file (OlyO_depth50nomiss.vcf.gz) are shortened in some cases, but the sample numbers are consistent across file types. "WB" is Willapa bay, "MB" is Mystery Bay, "LS" is Little Skookum Inlet, "BL" is Burley Lagoon, "PGB" is Port Gamble Bay, "Disco" is Discovery Bay, "FB" is Fidalgo Bay, "CS" is Central Sound or Mud Bay. See metadata summary file for GPS coordinates and other site info. 
\
Metadata.OlyOyster.csv shows the metadata (GPS coordinates and other site info). 


**Raw Fastq data** \
Raw fastq files available at SRA archive: PRJXXXXXXX (https://www.ncbi.nlm.nih.gov/sra....) \
\
**Code**\


