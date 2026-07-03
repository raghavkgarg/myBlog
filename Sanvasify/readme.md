# Sanvasify Blog

> Insights, updates, and articles about macroeconomic trends, public policy shifts, and the geopolitical forces shaping business.

Sanvasify Blog is a static website built using [Hugo](https://gohugo.io/). It serves as a repository for deep dives into specialised investment funds, wealth management, macroeconomics, policy, and global business trends.

---

## 🚀 Quick Start

### Prerequisites

You need [Hugo](https://gohugo.io/) installed on your machine. We recommend the Hugo Extended version.

- **macOS (via Homebrew):**
  ```bash
  brew install hugo
  ```
- **Windows (via Chocolatey):**
  ```powershell
  choco install hugo-extended
  ```

### Local Development

To run the development server locally:

```bash
hugo server -D
```

This will start a local server at `http://localhost:1313/` with live-reloading enabled (including draft content).

### Build for Production

To generate the static site files (output will be in the `public/` directory):

```bash
hugo --gc --minify
```

---

## 📂 Project Structure

- `content/`: Contains markdown files for articles, posts, and pages.
- `layouts/`: Custom HTML layout templates.
- `assets/`: Resources like CSS/Sass, JavaScript, and un-optimized images.
- `static/`: Static assets (images, favicons, robots.txt) served directly at the root.
- `hugo.toml`: The main configuration file for the site.
