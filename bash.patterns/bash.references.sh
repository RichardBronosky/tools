
a(){ read $1 <<< $(($1+1)); echo "${!1}"; }

echo -e "\n## bb";
a bb; a bb; 
echo -e "\n## cc";
a cc; a cc; a cc; 
echo -e "\n## dd";
a dd; a dd; a dd; a dd; 

echo -e "\nbb:$bb cc:$cc dd:$dd"
