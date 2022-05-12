nextflow.enable.dsl = 2

params.ref = 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/primer_schemes/artic/nCoV-2019/V1200/nCoV-2019.reference.fasta'

process dragen_index {
  label 'dragen'
  memory '4 GB'
  container 'ubuntu'
  secret 'DRAGEN_USERNAME'
  secret 'DRAGEN_PASSWORD'
  input: 
    path fasta
  output: 
    path 'dragen_index'
  """
    mkdir dragen_index
    /opt/edico/bin/dragen \
      --build-hash-table true \
      --output-directory dragen_index \
      --ht-reference $fasta \
      --lic-server=\$DRAGEN_USERNAME:\$DRAGEN_PASSWORD@license.edicogenome.com
  """
}

process dragen_map {
  label 'dragen'
  memory '4 GB'
  container 'ubuntu'
  secret 'DRAGEN_USERNAME'
  secret 'DRAGEN_PASSWORD'
  input: 
    path index
  output: 
    path '*.bam'
  """
    wget -L https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/illumina/amplicon/sample2_R1.fastq.gz
    wget -L https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/illumina/amplicon/sample2_R2.fastq.gz

    /opt/edico/bin/dragen \
        $index \
        --output-directory ./ \
        --output-file-prefix SAMPLE2_PE \
        --lic-server=\$DRAGEN_USERNAME:\$DRAGEN_PASSWORD@license.edicogenome.com \
        -1 sample2_R1.fastq.gz -2 sample2_R2.fastq.gz \
        --RGID SAMPLE2_PE \
        --RGSM SAMPLE2_PE
  """
}

workflow {
  dragen_index(params.ref)

  dragen_map(dragen_index.out)
}
