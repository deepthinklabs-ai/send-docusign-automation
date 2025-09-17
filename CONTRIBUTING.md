# Contributing to Send DocuSign Automation

We welcome contributions to the Send DocuSign Automation project! This document provides guidelines for contributing.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/send-docusign-automation.git
   cd send-docusign-automation
   ```
3. **Create a branch** for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

1. **Copy environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Update `.env`** with your DocuSign credentials

3. **Start development environment:**
   ```bash
   docker-compose up -d
   ```

4. **Import the workflow** into n8n at http://localhost:5678

5. **Test your changes:**
   ```bash
   ./scripts/test-webhook.sh
   ```

## Types of Contributions

### 🐛 Bug Fixes
- Fix issues with the workflow logic
- Improve error handling
- Correct documentation errors

### 🚀 Features
- Add new workflow nodes or functionality
- Enhance validation logic
- Add new DocuSign features support
- Improve monitoring and logging

### 📚 Documentation
- Improve setup instructions
- Add usage examples
- Fix typos and formatting
- Add troubleshooting guides

### 🧪 Testing
- Add new test cases
- Improve test coverage
- Add integration tests

## Coding Standards

### n8n Workflow Guidelines

1. **Node Naming:**
   - Use descriptive names: "Validate Client Email" not "If"
   - Follow PascalCase for node names
   - Include purpose in name when possible

2. **Error Handling:**
   - Always include error handling paths
   - Provide meaningful error messages
   - Log errors appropriately

3. **Data Validation:**
   - Validate all input data
   - Sanitize user inputs
   - Use proper regex patterns for validation

4. **Documentation:**
   - Add notes to complex nodes
   - Document any custom expressions
   - Explain business logic in comments

### Code Style

1. **JSON Files:**
   - Use 2-space indentation
   - Sort keys alphabetically where logical
   - Include trailing commas in arrays/objects

2. **Documentation:**
   - Use clear, concise language
   - Include code examples
   - Follow Markdown standards

3. **Scripts:**
   - Include proper shebang lines
   - Add error handling with `set -e`
   - Include usage comments
   - Make scripts executable

## Workflow Modification Guidelines

### Before Making Changes
1. **Backup existing workflow:**
   ```bash
   ./scripts/backup.sh
   ```

2. **Test current functionality:**
   ```bash
   ./scripts/test-webhook.sh
   ```

3. **Document your changes** in the workflow notes

### Making Changes
1. **Use n8n's built-in version control** when possible
2. **Test each node individually** before connecting
3. **Validate with sample data** at each step
4. **Update workflow version** in metadata

### After Changes
1. **Export updated workflow:**
   - Go to n8n → Settings → Export
   - Save as `workflows/send-docusign-automation.json`

2. **Update documentation** if workflow behavior changed

3. **Test thoroughly:**
   ```bash
   ./scripts/test-webhook.sh
   ```

4. **Update examples** if API changed

## Testing Guidelines

### Manual Testing
1. **Test all happy paths**
2. **Test error conditions**
3. **Verify data validation**
4. **Check DocuSign integration**

### Automated Testing
1. **Use the test script:**
   ```bash
   ./scripts/test-webhook.sh http://localhost:5678/webhook/send-docusign
   ```

2. **Test with different data types**
3. **Verify error responses**
4. **Check webhook response format**

### Test Cases to Cover
- Valid email and name inputs
- Invalid email formats
- Missing required fields
- Empty string inputs
- Special characters in names
- Different template IDs
- DocuSign API errors
- Network connectivity issues

## Submitting Changes

### Before Submitting
1. **Ensure all tests pass**
2. **Update documentation** if needed
3. **Add examples** for new features
4. **Update CHANGELOG.md**

### Pull Request Process
1. **Create descriptive PR title**
2. **Fill out PR template** (if available)
3. **Include screenshots** for workflow changes
4. **Reference related issues**
5. **Add testing instructions**

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Manual testing completed
- [ ] Automated tests pass
- [ ] Edge cases considered

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)
```

## Code Review Process

### For Reviewers
1. **Test the workflow** in your environment
2. **Check for security issues**
3. **Verify documentation accuracy**
4. **Ensure backward compatibility**

### For Contributors
1. **Respond to feedback promptly**
2. **Make requested changes**
3. **Test after modifications**
4. **Update PR description** if scope changes

## Release Process

### Version Numbers
- **Major** (1.0.0): Breaking changes
- **Minor** (0.1.0): New features, backward compatible
- **Patch** (0.0.1): Bug fixes, backward compatible

### Release Checklist
1. Update version in workflow metadata
2. Update CHANGELOG.md
3. Create release notes
4. Tag the release
5. Update documentation

## Getting Help

### Resources
- [n8n Documentation](https://docs.n8n.io/)
- [DocuSign API Docs](https://developers.docusign.com/)
- [Project Issues](https://github.com/deepthinklabs-ai/send-docusign-automation/issues)

### Communication
- **Create an issue** before starting major work
- **Ask questions** in issue comments
- **Provide context** when reporting bugs

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

Thank you for contributing to Send DocuSign Automation! 🎉
