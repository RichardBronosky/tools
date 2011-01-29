choose_from_array(){
    # The arguments passed are prompted to the user 1 per line with indexes.
    # examples:
    # echo "Which public key?"
    #     choose_from_array ~/.ssh/*.pub
    #
    # echo "Which private key?"
    #    ids=($(ls ~/.ssh/id_* | grep -v '\.pub$'))
    #    choose_from_array "${ids[@]}" #<-- That quote-brace-bracket pattern is important!
    #
    # echo "Where should output be logged?"
    #    choose_from_array -o "Enter alternative path" "$PWD" "/tmp/"
    OTHER_PROMPT=""
    while [[ $1 == -* ]]; do
        case "$1" in
            -o|--other)
                OTHER_PROMPT=$2; shift 2 ;;
            --) shift; break;;
        esac
    done
    ARRAY=("$@");
    ARRAY_LENGTH=${#ARRAY[*]}
    i=0;
    while [[ $i -lt $ARRAY_LENGTH ]];
    do
        echo "[$((i+1))] ${ARRAY[$i]}"
        ((i++))
    done
    if [[ -n $OTHER_PROMPT ]]; then
        echo "[$((i+1))] $OTHER_PROMPT"
    fi
    CHOICE=""
    while [[ -z $CHOICE ]]; do
        read CHOICE
        if [[ $CHOICE -gt 0 && $CHOICE -le $ARRAY_LENGTH ]]; then
            CHOICE="${ARRAY[$((CHOICE-1))]}"
        elif [[ $CHOICE -gt 0 && $CHOICE -eq $((ARRAY_LENGTH+1)) && -n $OTHER_PROMPT ]]; then
            # -e allows tab completion of filenames if readline is available
            read -e -p "$OTHER_PROMPT? " CHOICE
            # expand ~, ~root, $vars, etc. (remove ; and \ to sanitize)
            CHOICE=$(eval "echo ${CHOICE//[;\\]/ }")
        else
            echo "Invalid choice. Try again."
            CHOICE=""
        fi
    done
}; export CHOICE

# BEGIN examples:
echo "Which public key?"
    choose_from_array ~/.ssh/*.pub

echo "Which private key?"
   ids=($(ls ~/.ssh/id_* | grep -v '\.pub$'))
   choose_from_array "${ids[@]}" #<-- That quote-brace-bracket pattern is important!

echo "Where should output be logged?"
   choose_from_array -o "Enter alternative path" "$PWD" "/tmp/"
