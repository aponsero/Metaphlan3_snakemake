configfile: "config/config.yml"

rule all:
    input:
        expand("results/fastqc/{sample}_fastqc.html", sample=config["samples"]),
        expand("input/{sample}_trimmed.fq", sample=config["samples"]),
        expand("results/metaphlan/{sample}_profiles.txt", sample=config["samples"]),        

##### workflow starts here


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





