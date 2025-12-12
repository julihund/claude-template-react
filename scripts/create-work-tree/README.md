# Quick Usage Guide - wt

## 🎯 Standard Usage (Öffnet neues Terminal)

```powershell
wt feature-login
```

✅ Erstellt Worktree  
✅ **Öffnet neues Terminal** im Worktree  
✅ **Aktuelles Terminal bleibt wo es ist**

---

## 🚀 Alle Optionen

```powershell
# Standard: Neues Terminal öffnen
wt feature-name
# → Neues Terminal im Worktree
# → Aktuelles Terminal bleibt unverändert

# Auch VS Code öffnen
wt feature-name --code
wt feature-name -c
# → Neues Terminal + VS Code

# Nur VS Code, kein neues Terminal
wt feature-name --code --no-terminal
# → Nur VS Code öffnet sich

# Aktuelles Terminal wechselt zum Worktree (altes Verhalten)
wt feature-name --here
# → Aktuelles Terminal wechselt den Pfad
# → Kein neues Terminal
```

---

## 💡 Typische Workflows

### Neues Feature parallel arbeiten

```powershell
# Du bist in: montavis-template/
wt feature-payment

# Ergebnis:
# - Neues Terminal öffnet sich im Worktree
# - Du bist immer noch in montavis-template/
# - Du kannst in beiden Terminals arbeiten! 🎉
```

### Mit VS Code arbeiten

```powershell
wt feature-dashboard --code

# Ergebnis:
# - Neues Terminal im Worktree
# - VS Code öffnet sich im Worktree
# - Aktuelles Terminal bleibt unverändert
```

### Nur VS Code (kein neues Terminal)

```powershell
wt bugfix-navbar --code --no-terminal

# Ergebnis:
# - Nur VS Code öffnet sich
# - Kein neues Terminal
# - Aktuelles Terminal bleibt wo es ist
```

### Aktuelles Terminal wechseln (wie früher)

```powershell
wt review-code --here

# Ergebnis:
# - Aktuelles Terminal wechselt zum Worktree
# - Kein neues Terminal öffnet sich
```

---

## 🎬 Beispiel-Session

```powershell
PS C:\Projects\myapp> wt feature-auth
Creating worktree for branch: feature-auth
✓ Worktree created successfully!
Opening new terminal in worktree...
Current terminal stays in: C:\Projects\myapp

# Neues Terminal öffnet sich automatisch!
# Du bist immer noch in C:\Projects\myapp
# Kannst weiter im Hauptprojekt arbeiten

PS C:\Projects\myapp> # Du bist immer noch hier!
PS C:\Projects\myapp> git status
# Zeigt Status vom Hauptprojekt

# Im NEUEN Terminal:
PS C:\Projects\myapp-worktrees\feature-auth> git status
# Zeigt Status vom Worktree
```

---

## 📊 Option Übersicht

| Befehl                            | Neues Terminal? | VS Code? | Aktuelles Terminal? |
| --------------------------------- | --------------- | -------- | ------------------- |
| `wt feature`                      | ✅ Ja           | ❌ Nein  | Bleibt              |
| `wt feature --code`               | ✅ Ja           | ✅ Ja    | Bleibt              |
| `wt feature --code --no-terminal` | ❌ Nein         | ✅ Ja    | Bleibt              |
| `wt feature --here`               | ❌ Nein         | ❌ Nein  | Wechselt            |
| `wt feature --code --here`        | ❌ Nein         | ✅ Ja    | Wechselt            |

---

## 🔧 Setup (Einmalig)

### PowerShell (Empfohlen)

```powershell
.\.scripts\setup.ps1
. $PROFILE
```

### CMD

```cmd
.scripts\setup-improved.bat
REM Terminal neu starten
```

---

## 📋 Git Worktree Befehle

```bash
# Liste alle Worktrees
git worktree list

# Entferne Worktree (schließe zuerst das Terminal!)
git worktree remove feature-name

# Entferne Worktree + Branch
git worktree remove feature-name
git branch -D feature-name

# Aufräumen
git worktree prune
```

---

## 💡 Pro Tips

### 1. Mehrere Features parallel entwickeln

```powershell
wt feature-1
wt feature-2
wt bugfix-3
# → 3 neue Terminals, alle parallel nutzbar!
```

### 2. Code Review vorbereiten

```powershell
wt review-pr-123 --code
# → VS Code + Terminal zum Testen
# → Hauptprojekt bleibt intakt
```

### 3. Quick Hotfix

```powershell
wt hotfix-urgent --code
# → Schnell fixen, testen, committen
# → Hauptprojekt wird nicht gestört
```

### 4. Windows Terminal mit Tabs

Wenn du Windows Terminal hast, öffnen sich neue Tabs automatisch!

- Jeder Worktree = Eigener Tab
- Einfach zwischen Features wechseln

---

## ⚡ Keyboard Shortcuts

Nach `wt feature-name --code`:

Im VS Code:

- `Ctrl+` ` → Integriertes Terminal
- `Ctrl+Shift+` ` → Neues Terminal
- `Ctrl+P` → Quick Open

Im Windows Terminal:

- `Ctrl+Shift+T` → Neuer Tab
- `Ctrl+Tab` → Zwischen Tabs wechseln
- `Alt+Shift+D` → Pane duplizieren

---

## ❓ FAQ

**Q: Warum öffnet sich ein neues Terminal und nicht das aktuelle wechselt?**  
A: So kannst du parallel im Hauptprojekt UND im Worktree arbeiten!

**Q: Ich will das alte Verhalten (Terminal wechselt)?**  
A: Nutze `wt feature-name --here`

**Q: Kann ich das Standard-Verhalten ändern?**  
A: Ja, editiere die Scripts und ändere die Flags.

**Q: Terminal öffnet sich nicht?**  
A: Script nutzt Windows Terminal (`wt.exe`) falls verfügbar, sonst normale PowerShell/CMD.

Happy Coding! 🚀
