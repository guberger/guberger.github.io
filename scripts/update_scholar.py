"""Refresh public Scholar metrics; retain the saved snapshot on fetch failure."""
import argparse
from datetime import datetime, timezone
from html import unescape
from pathlib import Path
import json
import re
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
PROFILE = "https://scholar.google.com/citations?user=z_q7fV0AAAAJ&hl=en"


def parse_page(html):
    table = re.search(r'<table\b[^>]*id="gsc_rsb_st"[^>]*>(.*?)</table>', html, re.S)
    if not table:
        raise ValueError("Scholar statistics table not found")
    metrics = {}
    for row in re.findall(r'<tr\b[^>]*>(.*?)</tr>', table[1], re.S):
        values = re.findall(r'<td\b[^>]*class="gsc_rsb_std"[^>]*>(.*?)</td>', row, re.S)
        label = unescape(re.sub(r'<[^>]+>', '', row)).lower()
        for key, text in (("citations", "citations"), ("h_index", "h-index"), ("i10_index", "i10-index")):
            if text in label and values:
                metrics[key] = int(values[0].replace(',', ''))
    if len(metrics) != 3:
        raise ValueError("Incomplete Scholar indices")
    return metrics


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--html', type=Path, help='Parse a previously retrieved profile for offline verification')
    args = parser.parse_args()
    destination = ROOT / 'data' / 'scholar.json'
    try:
        if args.html:
            html = args.html.read_text(encoding='utf-8-sig')
        else:
            request = Request(PROFILE, headers={'User-Agent': 'Mozilla/5.0'})
            with urlopen(request, timeout=20) as response:
                html = response.read().decode('utf-8')
        metrics = parse_page(html)
        snapshot = dict(metrics, profile_url=PROFILE,
                        retrieved_at=datetime.now(timezone.utc).date().isoformat())
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(json.dumps(snapshot, indent=2) + '\n', encoding='utf-8')
        print(f"Scholar metrics updated: {metrics['citations']} citations, h-index {metrics['h_index']}, i10-index {metrics['i10_index']}.")
    except Exception as error:
        if not destination.exists():
            raise
        print(f"WARNING: Scholar refresh failed ({error}); retaining the saved snapshot and its date.")


if __name__ == '__main__':
    main()
