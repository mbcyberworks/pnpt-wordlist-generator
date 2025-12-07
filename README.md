# PNPT Wordlist Generator – MB Cyberworks

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg) ![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white) ![Kali](https://img.shields.io/badge/Kali-268BEE?style=for-the-badge&logo=kalilinux&logoColor=white)

A professional, engagement-ready **wordlist generator** designed for penetration testers.  
Generates **high-quality**, **realistic**, and **efficient** wordlists for:

- Active Directory Password Spraying  
- Kerberos / AS-REP Roasting  
- SMB / LDAP / RDP low-noise spraying  
- Web login brute forcing (Hydra / Burp Suite)  
- SSH / FTP brute forcing  
- Offline cracking (hashcat)

All wordlists are English-only, optimized for **PNPT-level engagements**, CTFs, and real-world pentests.

---

## 📋 Requirements
- Linux/Unix system (Kali Linux recommended)
- Bash 4.0+
- Optional: RockYou wordlist (`/usr/share/wordlists/rockyou.txt`)

---

## 📦 Installation
```bash
git clone https://github.com/mbcyberworks/pnpt-wordlist-generator
cd pnpt-wordlist-generator
chmod +x pnpt-wordlist-generator.sh
```

---

## 🛠 Usage
Simple version:
```bash
./pnpt-wordlist-generator.sh <CompanyName>
```
Examples:
```bash
./pnpt-wordlist-generator.sh Capstone
./pnpt-wordlist-generator.sh Marvel
```
Optional: specify RockYou path:
```bash
./pnpt-wordlist-generator.sh Capstone /usr/share/wordlists/rockyou.txt
```

Output directory:
```
pnpt-wordlists/
├── pnpt_spray.txt
├── pnpt_bruteforce.txt
├── pnpt_ultimate.txt
└── component files
```

---

## 📊 Generated Wordlist Stats (example: "Marvel")
| File | Entries | Use Case |
|------|---------|----------|
| pnpt_spray.txt | ~120 | AD spraying (safe) |
| pnpt_bruteforce.txt | ~4000 | Web/SSH brute force |
| pnpt_ultimate.txt | ~4500 | Offline cracking |

---

## 📂 Output Overview
### **1. pnpt_spray.txt — Small & Safe**
Used for:
- Kerberos password spraying  
- AS-REP roasting username validation  
- SMB / LDAP spraying  
- RDP low-noise attempts  

Contains:
- base weak passwords  
- seasons & years  
- company patterns  
- department names  
- complexity strings  

Safe by design to prevent lockouts and SIEM alerts.

---

### **2. pnpt_bruteforce.txt — Medium Power**
Best for:
- Hydra login brute forcing  
- Burp Suite Intruder  
- SSH / FTP brute forcing  
- Weak password testing in labs

Includes:
- everything from the spraylist  
- custom high-value words  
- curated RockYou top-3500

---

### **3. pnpt_ultimate.txt — Full Combined List**
Best for offline cracking or extended brute forcing.

---

## 🧪 Pentest Usage Examples
### Hydra – Web Login
```bash
hydra -l admin -P pnpt-wordlists/pnpt_bruteforce.txt \
  10.10.10.10 http-post-form \
  "/login:username=^USER^&password=^PASS^:Invalid"
```

### NetExec – SMB / AD Spray
```bash
netexec smb 10.10.10.0/24 -u users.txt \
  -p pnpt-wordlists/pnpt_spray.txt \
  --continue-on-success
```

### Kerberos Password Spraying
```bash
kerbrute passwordspray -d marvel.local users.txt pnpt-wordlists/pnpt_spray.txt
```

### SSH Brute Force
```bash
hydra -l root -P pnpt-wordlists/pnpt_bruteforce.txt <target> ssh
```

### Hashcat
```bash
hashcat -m 3200 hashes.txt pnpt-wordlists/pnpt_ultimate.txt
```

---

## 🔧 Troubleshooting

> **Note:** `<CompanyName>` is *always required* as the first argument, even when troubleshooting RockYou. The script will not run without it.


### **Issue:** `RockYou not found`
The script could not locate the RockYou wordlist at the default path:
```
/usr/share/wordlists/rockyou.txt
```
This is optional — the script will still run without it.

### ✅ **Solution 1: Install SecLists (recommended)**
```bash
sudo apt install seclists
```
The RockYou file will then be available at:
```
/usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt
```
Tell the script where it is:
```bash
./pnpt-wordlist-generator.sh MyCompany \
  /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt
```

### ✅ **Solution 2: Specify ANY custom RockYou path**
```bash
./pnpt-wordlist-generator.sh MyCompany /path/to/rockyou.txt
```

### ✅ **Solution 3: Skip RockYou entirely**
If you don't need RockYou entries, simply run the script without providing a path:
```bash
./pnpt-wordlist-generator.sh MyCompany
```
The spraylist and bruteforce list will still be fully functional.

---

## 🤝 Contributing
Found a bug or want to add patterns? PRs and issues are welcome!
- Bug fixes
- New patterns for industries
- Performance improvements

---

## ✨ Credits
Created by **MB Cyberworks**.

---

## 🛡 License
MIT License — Use responsibly.

