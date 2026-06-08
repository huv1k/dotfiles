---
name: pr-plan
description: Fetch PR comments and reviews from GitHub and prepare an actionable plan to address the feedback. Use when the user wants to act on PR review feedback.
disable-model-invocation: false
user-invocable: true
allowed-tools: Bash(gh *)
argument-hint: [pr-number-or-url]
arguments: [pr]
---

# PR Review Plan

Fetch all comments and reviews for the given pull request and create an actionable plan to address the feedback.

## Step 1: Fetch PR context

Use `gh` to gather all relevant information:

1. PR details: `gh pr view $pr --json title,body,headRefName,baseRefName,state,url`
2. Reviews: `gh pr view $pr --json reviews --jq '.reviews[] | {author: .author.login, state: .state, body: .body}'`
3. Review comments (inline): `gh api repos/{owner}/{repo}/pulls/$pr/comments --jq '.[] | {author: .user.login, path: .path, line: .line, body: .body, created_at: .created_at}'`
4. Issue comments (general): `gh api repos/{owner}/{repo}/pulls/$pr/comments --jq '.[] | {author: .user.login, body: .body, created_at: .created_at}'` and `gh pr view $pr --json comments --jq '.comments[] | {author: .author.login, body: .body, created_at: .created_at}'`

Derive `{owner}/{repo}` from `gh repo view --json nameWithOwner --jq .nameWithOwner`.

## Step 2: Analyze feedback

Categorize every piece of feedback into:
- **Must fix**: Requested changes, blocking comments, explicit change requests
- **Should fix**: Suggestions, improvements, non-blocking but valuable
- **Questions**: Questions that need a response or clarification
- **Resolved**: Comments already marked as resolved or addressed

Ignore bot comments (dependabot, CI bots, etc.) unless they contain actionable failures.

## Step 3: Enter plan mode and create the plan

Enter plan mode and create a structured plan with:

1. A summary of the PR and the overall review sentiment
2. A checklist of action items grouped by category (must fix / should fix / questions)
3. For each item, include:
   - The reviewer and their comment (summarized)
   - The file and line reference if available
   - A concrete proposed action

Prioritize must-fix items first. If there are no actionable comments, say so.
