BEGIN { FS=OFS="," }

FNR==NR {
    a[$1]=$2
    next
}

FNR {
    $3 = a[$1]
}1