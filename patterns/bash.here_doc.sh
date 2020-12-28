#!/bin/bash

cat <<EOF

	Test 1 (EOF)
		User:	$USER
		    home:	$HOME

EOF

cat <<'EOF'

	Test 1 ('EOF')
		User:	$USER
		    home:	$HOME

EOF

cat <<-EOF

	Test 1 (-EOF)
		User:	$USER
		    home:	$HOME

EOF

cat <<-'EOF'

	Test 1 (-'EOF')
		User:	$USER
		    home:	$HOME

EOF
