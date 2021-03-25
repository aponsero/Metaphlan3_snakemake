configfile: "config/config.yml"

rule all:
    input:
        "input/list_samples_downloaded.txt",
        expand("results/fastqc/{sample}_fastqc.html", sample=config["samples"]),
        expand("input/{sample}_trimmed.fq", sample=config["samples"]),
        expand("results/metaphlan/{sample}_profiles.txt", sample=config["samples"]),        

##### workflow starts here

rule irods:
    input:
        f="input/list_samples.txt", 
    params:
        download_dir="/xdisk/bhurwitz/mig2020/rsgrps/bhurwitz/alise/my_scripts/Metaphlan3_snakemake",
    output:
        "input/list_samples_downloaded.txt",
    shell:
        """
        set +eu
        source ~/.bashrc
        
        cd {params.download_dir}
        icd /
 
        while IFS= read -r line; do
            iget $line input
        done < {input.f}


        find . -name "*.fastq.gz" >> {output}
        """

rule fastq:
    input:
        f="input/{base}.fastq.gz",
    params:
        outdir="results/fastqc",
    output:
        "results/fastqc/{base}_fastqc.html",
    shell:
        """
        set +eu
        source ~/.bashrc
        conda activate metaphlan3

        fastqc -o {params.outdir} {input.f}
        """

rule trimGalore:
    input:
        f="input/{base}.fastq.gz",
    params:
        qvalue=20,
        length=20,
        download_dir="/xdisk/bhurwitz/mig2020/rsgrps/bhurwitz/alise/my_scripts/Metaphlan3_snakemake",
    output:
        "input/{base}_trimmed.fq",
    shell:
        """
        set +eu
        source ~/.bashrc
        conda activate metaphlan3
     
        trim_galore --dont_gzip -o {params.download_dir} {input.f}
        """

rule metaphlan:
    input:
        f="input/{base}_trimmed.fq",
    output:
        "results/metaphlan/{base}_profiles.txt",
    shell:
        """
        set +eu
        source ~/.bashrc
        conda activate metaphlan3

        metaphlan {input.f} --input_type fastq > {output}
        """





