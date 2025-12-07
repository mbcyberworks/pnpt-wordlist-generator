#!/usr/bin/env bash
# PNPT Wordlist Generator - Production Ready (English-only)
# Usage: ./pnpt-wordlist-generator.sh <CompanyName> [rockyou_path]
# Author: MB Cyberworks
# Version: 1.1
#
# Generates:
#   pnpt-wordlists/pnpt_spray.txt      → small, safe spray list (AD / Kerberos / SMB spraying)
#   pnpt-wordlists/pnpt_bruteforce.txt → compact but strong bruteforce list (web/SSH/FTP)
#   pnpt-wordlists/pnpt_ultimate.txt   → everything combined

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <CompanyName> [rockyou_path]" >&2
    echo "Example: $0 Capstone"
    exit 1
fi

COMPANY="$1"
ROCKYOU_DEFAULT="/usr/share/wordlists/rockyou.txt"
ROCKYOU_PATH="${2:-$ROCKYOU_DEFAULT}"

OUTDIR="pnpt-wordlists"
mkdir -p "$OUTDIR"

# Variants of the company name
LOWER=$(echo "$COMPANY" | tr '[:upper:]' '[:lower:]')
UPPER=$(echo "$COMPANY" | tr '[:lower:]' '[:upper:]')
TITLE=$(echo "$LOWER" | sed 's/.*/\u&/')

echo "[+] Generating PNPT wordlists for: $TITLE"
echo "    LOWER = $LOWER"
echo "    UPPER = $UPPER"
echo "    OUTDIR = $OUTDIR"
echo

#########################################
# 1) BASE PASSWORDS (common weak values)
#########################################
cat > "$OUTDIR/base.txt" << 'EOF'
admin
administrator
root
user
test
demo
guest
service
it
itadmin
sysadmin
support
helpdesk
password
password1
password01
password123
Password123
Password123!
welcome
welcome1
welcome01
changeme
changeme123
ChangeMe123!
letmein
qwerty
qwerty123
Qwerty123!
default
login
access
EOF

#########################################
# 2) YEARS
#########################################
cat > "$OUTDIR/years.txt" << 'EOF'
2026
2025
2024
2023
2022
2021
2020
EOF

#########################################
# 3) SEASONS (with some year combos)
#########################################
cat > "$OUTDIR/seasons.txt" << 'EOF'
Winter
Summer
Spring
Autumn
Fall
Winter2024
Winter2025
Summer2024
Summer2025
Spring2024
Autumn2024
Fall2024
EOF

#########################################
# 4) DEPARTMENTS / ROLES
#########################################
cat > "$OUTDIR/departments.txt" << 'EOF'
IT
IT01
IT2024
HR
HR01
Finance
Finance01
Finance2024
Admin
Admin01
Sales
Sales01
Marketing
Marketing01
Security
Security01
Support
Helpdesk
EOF

#########################################
# 5) COMPANY-SPECIFIC PATTERNS
#########################################
cat > "$OUTDIR/company.txt" << EOF
$TITLE
$LOWER
$UPPER
${TITLE}1
${TITLE}01
${TITLE}123
${TITLE}123!
${TITLE}2024
${TITLE}2024!
${TITLE}2025
${TITLE}2025!
${TITLE}2026
${TITLE}2026!
${TITLE}@2024
${TITLE}@2025
${TITLE}@2026
${TITLE}#2024
${TITLE}#2025
${TITLE}#2026
${LOWER}1
${LOWER}01
${LOWER}123
${LOWER}2024
${LOWER}2025
${LOWER}2026
${UPPER}1
${UPPER}123
${UPPER}2024
${UPPER}2025
${UPPER}2026
EOF

#########################################
# 6) CUSTOM HIGH-VALUE WORDS (theme / lab)
#########################################
cat > "$OUTDIR/custom.txt" << 'EOF'
student
training
course
academy
pnpt
pentest
hacker
cybersecurity
network
server
database
backup
lab
training2024
training2025
security2024
security2025
password321
qwerty321
maria
paris
cheesecake
captain1
captain01
login123
newyork1
london1
april2024
april2025
EOF

#########################################
# 7) COMPLEXITY PATTERNS
#########################################
cat > "$OUTDIR/complexity.txt" << 'EOF'
Password1!
Password01!
Password123!
Password2024!
Password2025!
Password2026!
Welcome01!
Welcome123!
Welcome2024!
Welcome2025!
Admin2024!
Admin2025!
Admin2026!
Spring2024!
Summer2024!
Autumn2024!
Winter2024!
Winter2025!
Winter2026!
EOF

#########################################
# 8) CURATED ROCKYOU (TOP 3500)
#########################################
ROCKYOU_CURATED="$OUTDIR/rockyou_curated.txt"

if [ -f "$ROCKYOU_PATH" ]; then
    echo "[+] Using RockYou from: $ROCKYOU_PATH"
    head -3500 "$ROCKYOU_PATH" > "$ROCKYOU_CURATED"
else
    echo "[-] RockYou not found at $ROCKYOU_PATH, skipping curated RockYou subset" >&2
    : > "$ROCKYOU_CURATED"
fi

#########################################
# 9) SPRAY LIST (SMALL + SAFE)
#########################################
echo "[+] Creating spray list..."
cat "$OUTDIR/base.txt" \
    "$OUTDIR/company.txt" \
    "$OUTDIR/seasons.txt" \
    "$OUTDIR/departments.txt" \
    "$OUTDIR/complexity.txt" \
    "$OUTDIR/years.txt" \
    | sort -u \
    > "$OUTDIR/pnpt_spray.txt"

#########################################
# 10) BRUTE FORCE LIST (COMPACT + STRONG)
#########################################
echo "[+] Creating brute force list..."
cat "$OUTDIR/pnpt_spray.txt" \
    "$OUTDIR/custom.txt" \
    "$OUTDIR/rockyou_curated.txt" \
    | sort -u \
    > "$OUTDIR/pnpt_bruteforce.txt"

#########################################
# 11) ULTIMATE LIST (EVERYTHING COMBINED)
#########################################
echo "[+] Creating ultimate list..."
cat "$OUTDIR/base.txt" \
    "$OUTDIR/years.txt" \
    "$OUTDIR/seasons.txt" \
    "$OUTDIR/departments.txt" \
    "$OUTDIR/company.txt" \
    "$OUTDIR/custom.txt" \
    "$OUTDIR/complexity.txt" \
    "$OUTDIR/rockyou_curated.txt" \
    | sort -u \
    > "$OUTDIR/pnpt_ultimate.txt"

#########################################
# 12) STATS + USAGE TIPS
#########################################
echo
for f in pnpt_spray.txt pnpt_bruteforce.txt pnpt_ultimate.txt; do
    count=$(wc -l < "$OUTDIR/$f")
    echo "[+] $f: $count entries"
done

echo
echo "[+] Wordlists written to: $OUTDIR/"
echo
echo "Usage examples (copy/paste and adapt):"
echo
echo "# SMB / AD spray (NetExec)"
echo "netexec smb <target> -u users.txt -p $OUTDIR/pnpt_spray.txt --continue-on-success"
echo
echo "# Web login brute force with Hydra"
echo "hydra -l admin -P $OUTDIR/pnpt_bruteforce.txt <target> http-post-form '/login:user=^USER^&pass=^PASS^:Invalid'"
echo
echo "# SSH brute force"
echo "hydra -l root -P $OUTDIR/pnpt_bruteforce.txt <target> ssh"
echo
echo "# Example offline hash cracking with hashcat (bcrypt = mode 3200)"
echo "hashcat -m 3200 hashes.txt $OUTDIR/pnpt_bruteforce.txt"
echo
echo "Ready for PNPT. 💥"
echo "Tip: keep the component files in $OUTDIR/ if you want to tweak patterns per engagement."
