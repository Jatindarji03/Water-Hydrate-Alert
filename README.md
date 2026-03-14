# 💧 Water Hydrate Alert — Linux

> Popup reminder to drink water. Stays open until you click OK!  
> Works on Ubuntu, Debian, Fedora, Arch, Mint and more...

---

## ⚡ Install (One Command)
```bash
curl -fsSL https://raw.githubusercontent.com/Jatindarji03/Water-Hydrate-Alert/main/install.sh -o /tmp/install.sh && bash /tmp/install.sh
```

During install it will ask:
```
  How often do you want a reminder?
    1) Every 30 minutes
    2) Every 45 minutes
  Enter 1 or 2:
```

---

## ❌ Uninstall
```bash
curl -fsSL https://raw.githubusercontent.com/Jatindarji03/Water-Hydrate-Alert/main/uninstall.sh | bash
```

---

## 🛠️ Useful Commands
```bash
# Test popup right now
bash ~/.local/bin/water-alert.sh

# Check timer status
systemctl --user status water-alert.timer

# Stop reminders
systemctl --user stop water-alert.timer

# Start again
systemctl --user start water-alert.timer
```

---
