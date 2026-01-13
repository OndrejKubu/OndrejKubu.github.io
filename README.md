# Academic Website

Personal academic website for Ondřej Kubů, hosted on GitHub Pages.

## Site Structure

- `index.html` - Home page with bio and contact information
- `publications.html` - List of publications with DOI and arXiv links
- `talks.html` - Conference presentations and posters
- `teaching.html` - Teaching experience and international exchanges
- `cv.html` - CV page with downloadable PDF
- `style.css` - Custom styling inspired by professional academic websites
- `Full CV 2025.pdf` - Downloadable CV

## Local Development

To preview the site locally, simply open `index.html` in your web browser.

Alternatively, you can use a simple HTTP server:
```bash
# Python 3
python -m http.server 8000

# Then visit http://localhost:8000
```

## Deployment to GitHub Pages

1. Create a new GitHub repository named `username.github.io` (replace `username` with your GitHub username)
2. Push this code to the repository:
   ```bash
   cd personal-website
   git remote add origin https://github.com/username/username.github.io.git
   git branch -M main
   git push -u origin main
   ```
3. Your site will be automatically available at `https://username.github.io`

Alternatively, if you want to keep this as a project site:
1. Create any GitHub repository (e.g., `academic-website`)
2. Push the code
3. Go to Settings > Pages
4. Select the branch (main) and folder (root or /docs)
5. Your site will be at `https://username.github.io/academic-website`

## Updating the Site

1. Make changes to the HTML/CSS files
2. Commit and push:
   ```bash
   git add .
   git commit -m "Update website content"
   git push
   ```
3. Changes will be live within a few minutes

## Updating Your CV

Replace `Full CV 2025.pdf` with your latest CV (keep the same filename or update the link in `cv.html`).
