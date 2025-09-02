# extract-test-titles

ZSH script to extract test titles from within a project that uses a BDD style testing framework.

## Usage: 
```./extract-test-titles.zsh [root_dir] [output_file] [file_pattern]```

### Example: 
```./extract-test-titles.zsh ./cypress/e2e test_titles.txt *.cy.ts```

### Defaults root_dir: .
- root_dir: .
- output_file: test_titles.txt
- file_pattern: *.cy.ts
>>>>>>> main
