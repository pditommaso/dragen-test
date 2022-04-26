nextflow.enable.dsl = 2

params.ref = 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/primer_schemes/artic/nCoV-2019/V1200/nCoV-2019.reference.fasta'

process dragen {
  label 'dragen'
  memory '4 GB'
  secret 'DRAGEN_USERNAME'
  secret 'DRAGEN_PASSWORD'
  input: 
    path x
  output: 
   path 'dragen_index'
  """
    mkdir dragen_index
    /opt/edico/bin/dragen \
      --build-hash-table true \
      --output-directory dragen_index \
      --ht-reference $x \
      --lic-server=\$DRAGEN_USERNAME:\$DRAGEN_PASSWORD@license.edicogenome.com
    """
}

workflow {
  dragen(params.ref)
}
