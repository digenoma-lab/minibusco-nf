// busco_genomes.nf
nextflow.enable.dsl = 2

//run minibusco to compute genome genome or transcriptome quality

process run_busco {
  tag "${name}"
  publishDir "${params.outdir}/${name}", mode: 'copy'
  cpus 10

  input:
  tuple val(name),file(genome)
  path linage

  output:
  path("${name}/*")
  path("${name}/short_summary_${name}.txt"), emit: summary

  script:
  if(params.debug == true){
  """
  echo minibusco run -a ${genome} -t ${task.cpus} -l ${params.busco_lineage} -o ${name} 
  mkdir ${name}
  mkdir ${name}/mollusca_odb10
  touch ${name}/mollusca_odb10/full_table_busco_format.tsv
  touch ${name}/summary.txt
  cp ${name}/summary.txt ${name}/short_summary_${name}.txt
  """
 }else{
  """
    minibusco run -a ${genome} -t ${task.cpus} -l ${params.busco_lineage} -o ${name}
    cp ${name}/summary.txt ${name}/short_summary_${name}.txt
  """
 }
}

//we generate a report for this workflow
process generate_report {
  publishDir "${params.outdir}/multiqc", mode: 'copy'
  
  input:
  path summaries

  output:
  path("busco_multiqc_report.html")

  script:
  if(params.debug == true){
  """
   echo  multiqc . -n busco_multiqc_report.html
   touch busco_multiqc_report.html

  """
 }else{
  """
  multiqc . -n busco_multiqc_report.html
  """
 }
} 


workflow {
 
lina=file(params.buscodb)

genomes = Channel.fromPath(params.genomes)
    | splitCsv(header: true)
    | map { row -> 
        def genome_file = file(row.path)
        if (!genome_file.exists()) {
          throw new Exception("Genome file not found: ${genome_file}")
        }
        tuple(genome_file.baseName, genome_file) 
      }
// genomes.view()

  run_busco(genomes,lina) 
  generate_report(run_busco.out.summary.collect())

}

workflow.onComplete {
  log.info "BUSCO analysis completed! Results in ${params.outdir}"
}
