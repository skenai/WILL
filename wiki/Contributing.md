# Contributing to WILL Documentation

## Wiki Structure

The WILL documentation is organized using a linked repository structure:

```
SKENAI/
├── WILL/
│   ├── wiki/               # Primary documentation location
│   │   ├── *.md files     # Wiki content
│   │   └── _Sidebar.md    # Navigation
│   ├── docs/              # Technical documentation
│   └── scripts/           # Utility scripts
│       └── update-wiki.bat # Wiki update automation
└── WILL.wiki/             # GitHub Wiki (linked to WILL/wiki)
```

## How to Update Documentation

### Method 1: Using the Automation Script

1. Make your changes in the `WILL/wiki/` directory
2. Run the update script with a commit message:
   ```bash
   scripts/update-wiki.bat "your commit message here"
   ```

### Method 2: Manual Update

1. Edit files in `WILL/wiki/`
2. Commit changes in WILL repository:
   ```bash
   git add wiki/
   git commit -m "docs: your changes"
   git push origin gh-pages
   ```
3. Changes will automatically appear in `WILL.wiki/`
4. Push wiki updates:
   ```bash
   cd ../WILL.wiki
   git add .
   git commit -m "docs: your changes"
   git push origin master
   ```

## Documentation Guidelines

1. **File Organization**
   - Keep all wiki content in `WILL/wiki/`
   - Use descriptive filenames with `-` separators
   - Include related files in appropriate sections

2. **Content Structure**
   - Start each file with a clear title
   - Use proper markdown headings
   - Include a table of contents for longer documents

3. **Links and References**
   - Use relative links when referencing other wiki pages
   - Include links to relevant proposals
   - Reference related documentation when appropriate

4. **Updates and Maintenance**
   - Keep content up to date with latest changes
   - Review and update documentation regularly
   - Remove outdated information promptly

## Technical Details

The wiki uses a junction point to link `WILL/wiki/` to `WILL.wiki/`. This means:
- Changes in `WILL/wiki/` automatically appear in `WILL.wiki/`
- Both repositories maintain their own git history
- Documentation is version-controlled alongside code

## Need Help?

If you encounter any issues or need assistance:
1. Check the existing documentation
2. Review the [Contributing Guidelines](Contributing.md)
3. Open an issue in the WILL repository
4. Contact the development team
