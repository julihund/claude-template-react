# Project Skills

**Skills** sind modulare Fähigkeiten, die Claude **automatisch** entdeckt und nutzt, wenn sie für deine Anfrage relevant sind.

## 🎯 Skills vs Commands vs Agents

| Feature | Skills | Slash Commands | Subagents |
|---------|--------|----------------|-----------|
| **Aktivierung** | Automatisch (model-driven) | Manuell (`/command`) | Automatisch oder explizit |
| **Komplexität** | Komplexe Workflows | Einfache Prompts | Spezialisierte KI-Assistenten |
| **Struktur** | Verzeichnis + mehrere Dateien | Einzelne .md Datei | Einzelne .md Datei |
| **Context** | Geteilt mit Hauptkonversation | Geteilt | Separates Context-Fenster |
| **Dateien** | Mehrere (Scripts, Templates, Docs) | Eine Datei | Eine Datei |
| **Use Case** | Team-Workflows, Tools | Quick Reminders | Task-Delegation |

## 📁 Skills-Struktur

```
.claude/skills/
└── skill-name/
    ├── SKILL.md                # PFLICHT: Frontmatter + Anweisungen
    ├── REFERENCE.md            # Optional: Detaillierte Referenz
    ├── EXAMPLES.md             # Optional: Konkrete Beispiele
    ├── scripts/                # Optional: Ausführbare Scripts
    │   ├── helper.py
    │   └── validator.sh
    └── templates/              # Optional: Wiederverwendbare Templates
        └── template.txt
```

## ✨ Wann Skills erstellen?

### ✅ Verwende Skills für:

- **Komplexe Workflows** mit mehreren Schritten
- **Automatische Erkennung** (Claude soll selbst aktivieren)
- **Mehrere Support-Dateien** (Scripts, Templates, Referenzen)
- **Team-Standardisierung** von detaillierten Prozessen
- **Progressive Disclosure** (Dateien nur bei Bedarf laden)

### Beispiele:
- PDF-Verarbeitung mit Form-Filling Scripts
- Code-Analyse mit Sicherheits-Checklisten
- API-Contract-Validierung mit Pydantic-Schemas
- Dokumentations-Generierung mit Style Guides

### ❌ Nutze stattdessen Slash Commands für:

- **Schnelle, häufig genutzte Prompts**
- **Einfache Anweisungen** (eine Datei reicht)
- **Explizite Kontrolle** (du willst manuell triggern)
- **Leichtgewichtige Workflows** ohne Support-Dateien

### ❌ Nutze stattdessen Subagents für:

- **Spezialisierte Expertise** für bestimmte Task-Typen
- **Separates Context-Fenster** wichtig (Context Pollution vermeiden)
- **Komplexes, unabhängiges Reasoning**
- **Permission-Isolation** (verschiedene Tools für verschiedene Agent-Typen)

## 📝 Skill erstellen

### 1. Verzeichnis anlegen

```bash
mkdir -p .claude/skills/my-skill
cd .claude/skills/my-skill
```

### 2. SKILL.md erstellen

```yaml
---
name: my-skill                    # PFLICHT: lowercase, hyphens, max 64 chars
description: What this does and when to use it  # PFLICHT: max 1024 chars
allowed-tools: Read, Grep, Glob   # Optional: Tool-Zugriff beschränken
---

# Skill Title

## Instructions
Provide clear, step-by-step guidance for Claude.

## Examples
Show concrete examples of using this skill.

## Reference
For advanced usage, see [REFERENCE.md](REFERENCE.md).
```

### 3. Support-Dateien hinzufügen (optional)

```bash
# Referenz-Dokumentation
touch REFERENCE.md EXAMPLES.md

# Scripts
mkdir scripts
touch scripts/helper.py scripts/validator.sh
chmod +x scripts/*.sh

# Templates
mkdir templates
touch templates/template.txt
```

### 4. Testen

```
"Analyze the API contracts in this codebase"
```

Claude sollte automatisch dein Skill aktivieren, wenn es relevant ist.

## 🎨 Best Practices

### 1. Fokussiert bleiben

**Ein Skill = Eine Fähigkeit**

```yaml
# ❌ Zu breit
description: Document processing

# ✅ Fokussiert
description: Extract text and tables from PDF files using pdfplumber.
Use when working with PDF files, forms, or document extraction.
```

### 2. Klare, spezifische Beschreibungen

Die Description ist **kritisch** für Claude's automatische Erkennung:

```yaml
# ❌ Vage (Claude wird es möglicherweise nicht nutzen)
description: Helps with files

# ✅ Spezifisch (Claude erkennt und nutzt es korrekt)
description: Extract text and tables from PDF files, fill forms, merge documents.
Use when working with PDF files, forms, document extraction, or .pdf file operations.
Requires pdfplumber and pypdf packages.
```

**Inkludiere:**
- **Was es tut** (spezifische Aktionen)
- **Wann nutzen** (Trigger-Keywords)
- **Datei-Typen** oder Formate
- **Dependencies** (erforderliche Packages)

### 3. Progressive Disclosure

Halte SKILL.md leichtgewichtig, verlinke zu Details:

```markdown
# Main SKILL.md - Leichtgewichtiger Einstieg
## Quick Start
Basic usage here...

## Advanced
For detailed patterns, see [REFERENCE.md](REFERENCE.md).
For API reference, see [API.md](API.md).
```

Claude lädt Referenz-Dateien **nur bei Bedarf** → Verhindert Context Pollution.

### 4. Tool-Restriktionen nutzen

Sichere Skills mit `allowed-tools`:

```yaml
---
name: safe-code-reader
description: Read and analyze code without making changes. Use for read-only code analysis.
allowed-tools: Read, Grep, Glob
---
```

**Vorteile:**
- **Sicherheit**: Read-only Skills können keine Dateien ändern
- **Fokus**: Beschränkt Scope auf spezifische Operationen
- **Permission Management**: Keine Benutzer-Genehmigung für allowed tools nötig

### 5. Dependencies dokumentieren

```yaml
description: Analyze Excel spreadsheets with pandas and openpyxl.
Use when working with Excel files. Requires: pandas, openpyxl

---

## Installation

```bash
pip install pandas openpyxl
```
```

## 🚀 Verfügbare Skills in diesem Template

### ui-ux-designer

**Dein persönlicher UI/UX Designer** - Bewertet Designs, entwickelt neue UIs, stellt Accessibility sicher.

**Nutze es wenn:**
- Neues Feature designen
- Bestehendes UI verbessern
- Design-Feedback brauchst
- Accessibility prüfen
- Unsicher bei Layout/Spacing/Colors

**Beispiele:**
```
"Bewerte das Login-Formular Design"
"Design mir eine Settings-Page"
"Ist der Button zu klein?"
"Wie wirkt die Navigation?"
```

**Perfekt für:**
- Designer (ohne Code zu schreiben)
- Entwickler (Design-Validierung)
- Gründer (professionelles UI ohne Designer)

## 📚 Weitere Informationen

- **Offizielle Docs**: [Claude Code Skills](https://code.claude.com/docs/en/skills.md)
- **Slash Commands**: [.claude/commands/README.md](../commands/)
- **Subagents**: [.claude/agents/README.md](../agents/)

## 💡 Workflow-Empfehlung

```
Einfacher Prompt → Slash Command (/command)
         ↓
Komplexer Workflow → Skill (automatisch aktiviert)
         ↓
Separate Expertise → Subagent (python-api-expert, etc.)
```

---

**Erstellt als Teil des MontaVis Template - Agentisches Development Framework**
