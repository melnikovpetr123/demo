#!/bin/sh

# prints all open ports from /proc/net/* 

element () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

arr=()

ip4hex2dec () {
    local ip4_1octet="0x${1%???????????}"

    local ip4_2octet="${1%?????????}"
    ip4_2octet="0x${ip4_2octet#??}"

    local ip4_3octet="${1%???????}"
    ip4_3octet="0x${ip4_3octet#????}"

    local ip4_4octet="${1%?????}"
    ip4_4octet="0x${ip4_4octet#??????}"

    local ip4_port="0x${1##*:}"

    # if not used inverse
    #printf "%d.%d.%d.%d:%d" "$ip4_1octet" "$ip4_2octet" "$ip4_3octet" "$ip4_4octet" "$ip4_port"
    printf "%d.%d.%d.%d:%d" "$ip4_4octet" "$ip4_3octet" "$ip4_2octet" "$ip4_1octet" "$ip4_port"
}


# reoder bytes, byte4 is byte1 byte2 is byte3 ...
reorderByte(){
    if [ ${#1} -ne 8 ]; then echo "missuse of function reorderByte"; exit; fi

    local byte1="${1%??????}"

    local byte2="${1%????}"
    byte2="${byte2#??}"

    local byte3="${1%??}"
    byte3="${byte3#????}"

    local byte4="${1#??????}"

    echo "$byte4$byte3:$byte2$byte1"
}

# on normal intel platform the byte order of the ipv6 address in /proc/net/*6 has to be reordered.
ip6hex2dec(){
    local ip_str="${1%%:*}"
    local ip6_port="0x${1##*:}"
    local ipv6="$(reorderByte ${ip_str%????????????????????????})"
    local shiftmask="${ip_str%????????????????}"
    ipv6="$ipv6:$(reorderByte ${shiftmask#????????})"
    shiftmask="${ip_str%????????}"
    ipv6="$ipv6:$(reorderByte ${shiftmask#????????????????})"
    ipv6="$ipv6:$(reorderByte ${ip_str#????????????????????????})"
    ipv6=$(echo $ipv6 | awk '{ gsub(/(:0{1,3}|^0{1,3})/, ":"); sub(/(:0)+:/, "::");print}')
    printf "%s:%d" "$ipv6" "$ip6_port"
}

for protocol in tcp tcp6 udp udp6 raw raw6; 
do 
    #echo "protocol $protocol" ; 
    for ipportinode in `cat /proc/net/$protocol | awk '/.*:.*:.*/{print $2"|"$3"|"$10 ;}'` ; 
    do 
        #echo "#ipportinode=$ipportinode"
        inode=${ipportinode##*|}
        if [ "#$inode" = "#" ] ; then continue ; fi 

        lspid=`ls -l /proc/*/fd/* 2>/dev/null | grep "socket:\[$inode\]" 2>/dev/null` ; 
        pids=`echo "$lspid" | awk 'BEGIN{FS="/"} /socket/{pids[$3]} END{for (pid in pids) {print pid;}}'` ;  # removes duplicats for this pid
        #echo "#lspid:$lspid  #pids:$pids"

        for pid in $pids; do
            if [ "#$pid" = "#" ] ; then continue ; fi
            exefile=`ls -l /proc/$pid/exe | awk 'BEGIN{FS=" -> "}/->/{print $2;}'`;
            cmdline=`cat /proc/$pid/cmdline`

            local_adr_hex=${ipportinode%%|*}
            remote_adr_hex=${ipportinode#*|}
            remote_adr_hex=${remote_adr_hex%%|*}

            if [ "#${protocol#???}" = "#6" ]; then
                local_adr=$(ip6hex2dec $local_adr_hex)
                remote_adr=$(ip6hex2dec $remote_adr_hex)
            else
        local_adr=$(ip4hex2dec $local_adr_hex)
        remote_adr=$(ip4hex2dec $remote_adr_hex)
            fi 

element "$local_adr" "${arr[@]}"
if [ $? -eq 0 ] ;  then
          echo -n
          else
          echo "$protocol pid:$pid addr: $local_adr $exefile"
          arr+=("$local_adr")
fi
    done
    done  
done
