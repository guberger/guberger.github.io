# Personal website

The site now uses Hugo with the existing Bootstrap design. Edit pages in
`content/`; the homepage is `content/_index.md`. Images and downloads live
in `static/assets/`, CSS in `static/css/`, and templates in `layouts/`.

Preview locally with `hugo server`, or build with `hugo` (output: `public/`).
The deployment workflow pins Hugo to version `0.169.0`; use that version locally
for consistent builds.

Math uses the bundled KaTeX files, with `$...$`, `$$...$$`, `\(...\)`, and
`\[...\]` delimiters. The existing `\R` and `\scal{...}` macros are supported.
Set `math = false` under `[params]` in a page's front matter to disable rendering.
For literal dollar signs when math is enabled, use `&#36;` in prose.

Paper downloads in `static/assets/papers/` use `year-publication-title.pdf`,
with `-slides` or `-poster` before `.pdf` for companion material. The year
and title follow the corresponding entry in `content/publications.md`.

## Deployment

The CV's Google Scholar metrics are saved in `data/scholar.json` and updated
manually from your computer. From the repository root, run:

```powershell
python scripts/update_scholar.py
```

The script uses Python 3 with no extra dependencies. Review the updated
`data/scholar.json`, then commit and push it to `main` to publish the metrics.
If Scholar is unavailable or blocks the request, the script reports an error
and exits with a nonzero status, keeping the saved metrics and retrieval date.
You can also parse a profile page saved from your browser with
`python scripts/update_scholar.py --html path/to/profile.html`.

Deployment uses the committed metrics; it does not fetch Scholar or run on a
weekly schedule.

In GitHub repository Settings > Pages, set Source to **GitHub Actions**.
The workflow in `.github/workflows/deploy.yaml` builds Hugo and deploys `public/`
on pushes to `main`. It can also be started manually from the
Actions tab once the workflow is present on the default branch.
The workflow deploys a Pages artifact directly; it does not update the old
`gh-pages` branch. The `hugo-server` development branch does not deploy on push.
CI downloads the pinned Hugo release archive from GitHub and installs its executable.

The Franklin/Julia build files have been removed. The `franklin-content` CSS
class is retained to preserve the original styling; it has no Franklin dependency.
