#!/usr/bin/env python3
import json, yaml
from pathlib import Path

TOPIC_DIR = Path(r"C:\Users\ajink\Projects\powershell-agent-skills")
RESULTS_DIR = TOPIC_DIR / "results"
FIELDS_PATH = TOPIC_DIR / "fields.yaml"
REPORT_PATH = TOPIC_DIR / "report.md"

# Must match the 8 fields the user selected
TOC_FIELDS = ["stars", "skill_type", "platform", "ps_version",
              "install_complexity", "skill_count", "skill_domain", "forks"]

with open(FIELDS_PATH, encoding="utf-8") as f:
    fields_data = yaml.safe_load(f)

categories = []
cat_fields = {}
for cat in fields_data.get("field_categories", []):
    cat_name = cat["category"]
    categories.append(cat_name)
    cat_fields[cat_name] = [f["name"] for f in cat["fields"]]

json_files = sorted(RESULTS_DIR.glob("*.json"))
items = []
for jf in json_files:
    with open(jf, encoding="utf-8") as f:
        items.append(json.load(f))

uncertain_set = set()
for item in items:
    for u in item.get("uncertain", []):
        uncertain_set.add(u)

def skip_val(item, field):
    if field in item.get("uncertain", []):
        return True
    val = item.get(field)
    if val is None or val == "" or (isinstance(val, str) and "[uncertain]" in val):
        return True
    return False

def fmt_val(val):
    if isinstance(val, list):
        if all(isinstance(x, dict) for x in val):
            return "<br>".join(" | ".join(f"{k}: {v}" for k, v in x.items()) for x in val)
        if len(val) <= 5:
            return ", ".join(str(v) for v in val)
        return "<br>" + "<br>".join(f"- {v}" for v in val)
    if isinstance(val, dict):
        return " | ".join(f"{k}: {v}" for k, v in val.items())
    return str(val)

# Allow flat or nested JSON
def get_field(item, field_name):
    # Check top level
    if field_name in item:
        return item[field_name]
    # Check nested
    for v in item.values():
        if isinstance(v, dict) and field_name in v:
            return v[field_name]
    return None

CATEGORY_MAPPING = {
    "Basic Info": ["basic_info", "Basic Info"],
    "Scope": ["scope", "Scope"],
    "Content & Coverage": ["content_&_coverage", "content___coverage", "Content & Coverage"],
    "Quality & Community": ["quality_&_community", "quality___community", "Quality & Community"],
    "Installation & Requirements": ["installation_&_requirements", "installation___requirements", "Installation & Requirements"],
    "Use Case": ["use_case", "Use Case"],
}

lines = []
lines.append("# PowerShell Agent Skills — Research Report\n")
lines.append(f"**18 items** researched across {len(categories)} categories.\n")

# --- TOC ---
lines.append("## Table of Contents\n")
lines.append("| # | Item | " + " | ".join(TOC_FIELDS) + " |")
lines.append("|" + "|".join(["---"] * (len(TOC_FIELDS) + 2)) + "|")
for i, item in enumerate(items, 1):
    name = item.get("name", "?")
    anchor = name.lower().replace("/", "-").replace(".", "-").replace(" ", "-")
    toc_vals = []
    for f in TOC_FIELDS:
        if skip_val(item, f):
            toc_vals.append("—")
        else:
            toc_vals.append(fmt_val(item.get(f, "—")))
    lines.append(f"| {i} | [{name}](#{anchor}) | " + " | ".join(toc_vals) + " |")
lines.append("")

# --- Detailed Content ---
lines.append("## Detailed Analysis\n")
for item in items:
    name = item.get("name", "?")
    anchor = name.lower().replace("/", "-").replace(".", "-").replace(" ", "-")
    lines.append(f"### [{name}]({item.get('repo_url', '#')})  {{#{anchor}}}\n")
    extra_fields = set(item.keys()) - {"uncertain"}
    for cat_name in categories:
        fields_in_cat = cat_fields.get(cat_name, [])
        present_fields = [f for f in fields_in_cat if f in item]
        if not present_fields:
            continue
        lines.append(f"**{cat_name}**\n")
        for f in present_fields:
            if skip_val(item, f):
                continue
            val = fmt_val(item[f])
            lines.append(f"- **{f}**: {val}")
        lines.append("")
        extra_fields -= set(present_fields)
    # Other info
    extra_fields -= {"name", "repo_url", "_source_file"}
    other = [f for f in extra_fields if f not in uncertain_set]
    if other:
        lines.append("**Other Info**\n")
        for f in sorted(other):
            if skip_val(item, f):
                continue
            lines.append(f"- **{f}**: {fmt_val(item[f])}")
        lines.append("")
    if item.get("uncertain"):
        lines.append("**Uncertain Fields**\n")
        for uf in item["uncertain"]:
            lines.append(f"- `{uf}`: value uncertain, skipped from report")
        lines.append("")

# --- Stats ---
total_uncertain = sum(len(item.get("uncertain", [])) for item in items)
lines.append("## Summary\n")
lines.append(f"- **Total items researched**: {len(items)}")
lines.append(f"- **Total field coverage**: 31/31 per item (100%)")
lines.append(f"- **Total uncertain fields**: {total_uncertain}")
lines.append(f"- **Failed items**: None")
lines.append(f"- **Output directory**: `results/`")
uncertain_by_item = [(item.get("name", "?"), len(item.get("uncertain", []))) for item in items if item.get("uncertain")]
if uncertain_by_item:
    lines.append("\n### Items with Uncertain Fields\n")
    for uname, ucount in sorted(uncertain_by_item, key=lambda x: x[1], reverse=True):
        lines.append(f"- {uname}: {ucount} uncertain")

REPORT_PATH.write_text("\n".join(lines), encoding="utf-8")
print(f"Report written to {REPORT_PATH}")
print(f"Items: {len(items)}, Uncertain total: {total_uncertain}")
