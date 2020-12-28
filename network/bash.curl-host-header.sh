function request_https_host1_from_host2(){
    local host="$1";
    local target="$2";
    local outfile="${3:-/dev/null}"
    local ip=$(dig +short $target | head -n1);
    echo $'\n\n'"## Requesting the resources of Host: $host from IP: $ip obtained for: $target"$'\n\n';
    curl -svko "${outfile}" --resolve $host:443:$ip https://$host;
}

function request_http_host1_from_host2(){
    local host="$1";
    local target="$2";
    local outfile="${3:-/dev/null}"
    local ip=$(dig +short $target | head -n1);
    echo $'\n\n'"## Requesting the resources of Host: $host from IP: $ip obtained for: $target"$'\n\n';
    curl -svko "${outfile}" --resolve $host:80:$ip http://$host;
}

function dns_lookup_host_record_from_source(){
    local host="${1}"
    local record="${2:-}"
    local source="${3:-}"; [[ -n "$source" ]] && source="@$source"
    (
        set -x
        dig +nocmd +nocomments +noquestion +noauthority +noadditional +nostats +identify $host $record $source
    )
}

ns=(
    ns-475.awsdns-59.com
    ns-1574.awsdns-04.co.uk
    ns-921.awsdns-51.net
    ns-1241.awsdns-27.org
)

host=careers.roomstogo.com
target=jobappnetwork.com


## Check that the NS servers are ready to answer for host
for s in 8.8.8.8 "${ns[@]}"; do dns_lookup_host_record_from_source $host NS    $s; done

## Check that the NS servers are ready to resolve the host
for s in 8.8.8.8 "${ns[@]}"; do dns_lookup_host_record_from_source $host A     $s; done
for s in 8.8.8.8 "${ns[@]}"; do dns_lookup_host_record_from_source $host CNAME $s; done

## Check (via HTTPS) that the `$target` server (jobappnetwork.com) is ready to answer for the host
request_https_host1_from_host2 $host $target

