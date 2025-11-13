# Contributing to Versioner Documentation

Thank you for your interest in improving Versioner's documentation! This guide will help you get started.

## 🚀 Quick Start

### Prerequisites
- Python 3.11 or higher
- pip
- Git

### Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/versioner-io/versioner-docs.git
   cd versioner-docs
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Start the development server**
   ```bash
   mkdocs serve
   ```

4. **Open your browser**
   
   Visit `http://localhost:8000` to see your changes live.

## 📝 Making Changes

### Documentation Structure

All documentation lives in the `public/` directory:

```
public/
├── index.md                    # Homepage
├── getting-started.md          # Getting started guide
├── concepts/                   # Core concepts
│   ├── index.md
│   ├── products.md
│   ├── versions.md
│   ├── deployments.md
│   └── ...
├── api/                        # API reference
├── cli/                        # CLI documentation
├── integrations/               # Integration guides
└── guides/                     # How-to guides
```

### Writing Guidelines

#### Style
- Use clear, concise language
- Write in second person ("you") when addressing users
- Use active voice
- Break up long paragraphs
- Use headings to organize content

#### Formatting
- Use `#` for page titles (only one per page)
- Use `##`, `###`, etc. for section headings
- Use code blocks with language tags:
  ````markdown
  ```bash
  versioner deploy --version 1.0.0
  ```
  ````
- Use admonitions for important notes:
  ```markdown
  !!! note
      This is an important note.
  
  !!! warning
      This is a warning.
  ```

#### Code Examples
- Keep examples realistic and runnable
- Include expected output when helpful
- Use placeholder values that are clearly fake (e.g., `your-api-key-here`)
- Test all code examples before submitting

#### Links
- Use relative links for internal pages: `[Deployments](../concepts/deployments.md)`
- Use absolute URLs for external links: `[GitHub](https://github.com)`
- Link to related concepts when first mentioned

### Testing Your Changes

1. **Preview locally**
   ```bash
   mkdocs serve
   ```
   Check that:
   - All links work
   - Images display correctly
   - Code blocks render properly
   - Navigation is correct

2. **Build the site**
   ```bash
   mkdocs build --strict
   ```
   This will fail if there are any warnings (broken links, missing files, etc.)

## 🔄 Submitting Changes

### Workflow

1. **Create a branch**
   ```bash
   git checkout -b improve-deployment-docs
   ```

2. **Make your changes**
   
   Edit files in the `public/` directory.

3. **Test locally**
   ```bash
   mkdocs serve
   mkdocs build --strict
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Improve deployment documentation"
   ```

5. **Push to your fork**
   ```bash
   git push origin improve-deployment-docs
   ```

6. **Open a pull request**
   
   Go to GitHub and create a pull request from your branch.

### Pull Request Guidelines

- **Title:** Use a clear, descriptive title
- **Description:** Explain what you changed and why
- **Screenshots:** Include screenshots for visual changes
- **Testing:** Confirm you've tested locally
- **Links:** Reference any related issues

Example PR description:
```markdown
## Changes
- Added troubleshooting section to deployment guide
- Fixed broken links in API reference
- Updated CLI examples to use latest syntax

## Testing
- [x] Ran `mkdocs serve` and verified changes
- [x] Ran `mkdocs build --strict` with no errors
- [x] Tested all code examples

## Screenshots
[Include if relevant]
```

## 📋 Types of Contributions

### Documentation Improvements
- Fix typos or grammatical errors
- Clarify confusing sections
- Add missing information
- Update outdated content
- Improve code examples

### New Content
- Add how-to guides
- Document new features
- Create tutorials
- Add troubleshooting tips

### Structure & Organization
- Improve navigation
- Reorganize content
- Add cross-references
- Create new sections

## 🎨 MkDocs Features

### Admonitions

```markdown
!!! note "Optional Title"
    This is a note.

!!! tip
    This is a helpful tip.

!!! warning
    This is a warning.

!!! danger
    This is critical information.
```

### Tabs

```markdown
=== "Python"
    ```python
    import requests
    response = requests.get("https://api.versioner.io/health")
    ```

=== "JavaScript"
    ```javascript
    const response = await fetch("https://api.versioner.io/health");
    ```

=== "cURL"
    ```bash
    curl https://api.versioner.io/health
    ```
```

### Tables

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Value 1  | Value 2  | Value 3  |
```

### Task Lists

```markdown
- [x] Completed task
- [ ] Incomplete task
```

## ❓ Questions?

- **Found a bug?** Open an issue on GitHub
- **Have a question?** Start a discussion on GitHub
- **Need help?** Reach out to support@versioner.io

## 📄 License

By contributing to Versioner documentation, you agree that your contributions will be licensed under the same terms as the project.

---

Thank you for helping make Versioner's documentation better! 🎉
