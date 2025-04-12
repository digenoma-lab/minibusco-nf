#!/bin/bash

# Usage: ./format_busco_summary.sh summary.txt [output_name]

summary_file="$1"
output_name="${2:-unknown_input.fna}"  # fallback name if not provided

if [[ ! -f "$summary_file" ]]; then
	  echo "❌ Error: Input file '$summary_file' not found."
	    echo "Usage: $0 <summary.txt> [output_filename]"
	      exit 1
fi

# Extract values
S=$(grep -o 'S:[0-9.]*' "$summary_file" | cut -d: -f2)
D=$(grep -o 'D:[0-9.]*' "$summary_file" | cut -d: -f2)
F=$(grep -o 'F:[0-9.]*' "$summary_file" | cut -d: -f2)
M=$(grep -o 'M:[0-9.]*' "$summary_file" | cut -d: -f2)
N=$(grep -o 'N:[0-9]*' "$summary_file" | cut -d: -f2)
LINEAGE=$(grep -o '## lineage: .*' "$summary_file" | cut -d' ' -f3)

# Compute complete percentages and counts
C=$(awk "BEGIN {printf \"%.1f\", $S + $D}")
Complete=$(awk "BEGIN {printf \"%d\", ($S + $D) * $N / 100}")
Single=$(awk "BEGIN {printf \"%d\", $S * $N / 100}")
Duplicated=$(awk "BEGIN {printf \"%d\", $D * $N / 100}")
Fragmented=$(awk "BEGIN {printf \"%d\", $F * $N / 100}")
Missing=$(awk "BEGIN {printf \"%d\", $M * $N / 100}")

# Print BUSCO-style summary block
echo "# BUSCO version is: 5.4.5" > $2
echo "# The lineage dataset is: $LINEAGE (number of BUSCOs: $N)" >>$2
echo "# Summarized benchmarking in BUSCO notation for file $output_name" >>$2
echo "# BUSCO was run in mode: genome" >>$2
echo "# Gene predictor used: metaeuk" >>$2
echo >>$2
echo "	***** Results: *****" >>$2
echo >>$2
echo "	C:${C}%[S:${S}%,D:${D}%],F:${F}%,M:${M}%,n:${N}" >>$2
echo "	$Complete	Complete BUSCOs (C)" >>$2
echo "	$Single	Complete and single-copy BUSCOs (S)" >>$2
echo "	$Duplicated	Complete and duplicated BUSCOs (D)" >>$2
echo "	$Fragmented	Fragmented BUSCOs (F)" >>$2
echo "	$Missing	Missing BUSCOs (M)" >>$2
echo "	$N	Total BUSCO groups searched" >>$2

