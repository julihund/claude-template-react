Perform comprehensive security audit by spawning the fix-security-issue agent.

The agent will:
1. **Automated scans**:
   - `npm audit` (frontend dependencies)
   - `safety check` (Python dependencies)
   - Search for dangerous patterns (raw SQL, hardcoded secrets, eval())

2. **Manual OWASP Top 10 review**:
   - SQL injection vulnerabilities
   - Broken authentication (plaintext passwords, weak hashing)
   - Sensitive data exposure (missing Pydantic response models)
   - Broken access control (missing authorization checks)
   - XSS (dangerouslySetInnerHTML without sanitization)
   - Security misconfiguration (debug=True in production)
   - Insecure deserialization (pickle usage)
   - Insufficient logging

3. **Generate security report**:
   - High/Medium/Low severity issues
   - File:line references for each vulnerability
   - Recommended fixes with code examples

4. **Optionally fix issues** if user approves

Deliverables:
- Security audit report markdown file
- List of vulnerabilities with severity
- Verification that critical issues are addressed
