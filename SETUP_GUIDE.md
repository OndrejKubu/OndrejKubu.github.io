# Setup Guide for Your Academic Website

## What's Been Created

Your professional academic website is ready with the following structure:

- **Home page** (`index.html`) - Bio, research interests, awards, and contact info
- **Publications** (`publications.html`) - All your publications organized by type
- **Teaching** (`teaching.html`) - Teaching experience and international exchanges
- **CV** (`cv.html`) - Online CV with downloadable PDF
- **Styling** (`style.css`) - Clean, professional design inspired by Clara Torres' site

## Preview Locally

Before deploying, you can preview the site:

1. Open `index.html` directly in your web browser, or
2. Use a simple HTTP server:
   ```bash
   cd personal-website
   python -m http.server 8000
   # Visit http://localhost:8000
   ```

## Deploy to GitHub Pages (Recommended)

### Option 1: Personal GitHub Site (username.github.io)

This gives you a clean URL like `ondrejkubu.github.io`

1. Create a GitHub account if you don't have one
2. Create a new repository named exactly: `[your-username].github.io`
   - Example: if your username is `ondrejkubu`, name it `ondrejkubu.github.io`
3. In the `personal-website` directory:
   ```bash
   git add .
   git commit -m "Initial website commit"
   git remote add origin https://github.com/[your-username]/[your-username].github.io.git
   git branch -M main
   git push -u origin main
   ```
4. Wait a few minutes - your site will be live at `https://[your-username].github.io`

### Option 2: Project Site

If you want to keep it as a project under a different repository:

1. Create a new GitHub repository (any name, e.g., `academic-website`)
2. Push your code:
   ```bash
   git add .
   git commit -m "Initial website commit"
   git remote add origin https://github.com/[your-username]/academic-website.git
   git branch -M main
   git push -u origin main
   ```
3. Go to repository Settings > Pages
4. Under "Source", select branch `main` and folder `/ (root)`
5. Your site will be at `https://[your-username].github.io/academic-website`

## Making Updates

### Updating Content

1. Edit the HTML files as needed
2. Commit and push:
   ```bash
   git add .
   git commit -m "Update content"
   git push
   ```
3. Changes appear within 1-5 minutes

### Updating Your CV

Replace `Full CV 2025.pdf` with your new CV (or update the link in `cv.html`)

### Adding New Sections

You can add new pages (e.g., `blog.html`, `personal.html`) by:
1. Creating a new HTML file following the same structure
2. Adding a link in the navigation of all pages
3. Creating corresponding CSS if needed

## Next Steps

1. **Preview locally** - Check everything looks good
2. **Choose your GitHub username** - This will be part of your URL
3. **Deploy to GitHub** - Follow Option 1 or 2 above
4. **Share your site** - Add the link to your email signature, ORCID, etc.

## Optional Enhancements (Future)

- Add a photo to the home page
- Create a blog/notes section
- Add a "Talks & Posters" section with slides/posters
- Include research diagrams or visualizations
- Add Google Analytics to track visitors

## Support

- GitHub Pages documentation: https://pages.github.com/
- For technical issues with GitHub Pages, see: https://docs.github.com/en/pages

Your website is professional, portable, and will follow you throughout your career!
