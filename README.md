
# 🧬 minBUSCO-nf

A simple and scalable **Nextflow pipeline** to compute genome or transcriptome quality metrics using [`minibusco`](https://github.com/ablab/minibusco). This pipeline is designed for high-throughput assessments of genome assemblies and outputs BUSCO metrics as well as a MultiQC report.

---

## 🚀 Features

- Parallel BUSCO analysis using [`minibusco`](https://github.com/huangnengCSU/compleasm)
- Support for multiple genome files via CSV input
- Generates standardized BUSCO summary files
- Optionally includes a MultiQC report
- Compatible with **SLURM HPC clusters** (e.g., Kütral, Leftraru)
- Singularity support for containerized reproducibility

---

## 📦 Installation

```bash
git clone https://github.com/digenoma-lab/minbusco-nf.git
cd minbusco-nf
```

Ensure you have:

- [`Nextflow`](https://www.nextflow.io/) installed
- [`minibusco`](https://github.com/huangnengCSU/compleasm) installed or available in your environment/module
- (optional) [`multiqc`](https://multiqc.info/) installed for report generation
- Singularity module (if using cluster profiles)

---

## 📂 Input

### 1. Genome CSV file

You must provide a CSV file with a header and a column named `path`, where each row is the full path to a genome or transcriptome file:

```csv
path
/path/to/genome1.fasta
/path/to/genome2.fasta
```

### 2. Lineage database

The path to the BUSCO lineage directory (e.g., `mollusca_odb10`).

---

## ⚙️ Parameters

| Parameter         | Description                                              | Default           |
|-------------------|----------------------------------------------------------|-------------------|
| `--genomes`       | CSV file with genome paths (required)                   | -                 |
| `--busco_lineage` | Lineage dataset name (e.g., `mollusca_odb10`)           | `mollusca_odb10`  |
| `--buscodb`       | Path to lineage datasets folder                          | `mb_downloads`    |
| `--busco_mode`    | BUSCO mode (`genome`, `transcriptome`, `proteins`)      | `genome`          |
| `--outdir`        | Output directory for results                             | `busco_results`   |
| `--debug`         | Enable dry-run mode with fake outputs                    | `false`           |

---

## 🧪 Example Run

```bash
nextflow run busco_genomes.nf \
  --genomes genomes.csv \
  --busco_lineage mollusca_odb10 \
  --buscodb /path/to/mb_downloads \
  --outdir results \
  -profile kutral
```

---

## 🖥️ Cluster Profiles

The pipeline includes predefined profiles for:

- `kutral` – UOH HPC cluster with Singularity and SLURM
- `leftraru` – NLHPC cluster configuration

Use `-profile kutral` or `-profile leftraru` to enable them.

---

## 📈 Outputs

For each genome:

```
busco_results/
├── genome1/
│   ├── mollusca_odb10/
│   ├── full_table_busco_format.tsv
│   ├── summary.txt
│   └── short_summary_genome1.txt
├── genome2/
│   └── ...
└── multiqc/
    └── busco_multiqc_report.html
```

Additionally:

- `pipeline_info/` folder contains timeline, trace, and DAG reports.

---

## 🧠 Developer Notes

- The pipeline supports a `--debug` mode that simulates execution with placeholder files (for testing).
- `minibusco` must be accessible in the environment or container.
- The lineage folder (e.g., `mollusca_odb10`) should be downloaded or mounted before execution.

---

## 👤 Author

Alex Di Genova – [@adigenova](https://github.com/adigenova)  
[Di Genoma Lab](https://digenoma-lab.cl) – Universidad de O’Higgins

---

## 📄 License

MIT License.

---

## 🌐 Links

- [BUSCO](https://busco.ezlab.org/)
- [minibusco](https://github.com/huangnengCSU/compleasm)
- [Nextflow](https://www.nextflow.io/)
```
