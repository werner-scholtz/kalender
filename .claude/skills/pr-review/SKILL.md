---
name: pr-review
description: Reviews an open kalender pull request after CI and leaves the findings as a pending GitHub review that only the owner can see and submit. Use for round two of a change, for a contributor's pull request, or when asked to review a PR number.
---

# Pull request review

A pending review is private to the account that created it until it is submitted. The owner submits or discards it. Never submit it yourself.

## Steps

1. Read the pull request: `gh pr view <number> --json title,body,baseRefName,headRefOid,author`, `gh pr diff <number>`, and `gh pr checks <number>`. Note any benchmark comparison comment from the `profile` label. Fetch the commits so the reviewer can read them: `git fetch origin main pull/<number>/head`.
2. Check for an existing pending review by the owner: `gh api repos/{owner}/{repo}/pulls/<number>/reviews --jq '.[] | select(.state == "PENDING") | .id'`. GitHub allows one per account, so stop and report it when one exists.
3. Start the `reviewer` agent with `origin/<baseRefName>` as the base, the fetched `headRefOid` as the head, and the pull request body. Pass the CI result and the benchmark comment as facts. Do not pass the pull request's conversation or the author's reasoning. When the author is not the owner, tell the reviewer to read the branch and not run it.
4. Turn each finding into a comment on its line. A comment can only sit on a line in the diff, and one outside it makes GitHub reject the whole review. When a finding points to another line of a changed file, put it on the nearest changed line and name the real line. When it points to a file the pull request does not touch, put it in the review body. Keep `suggestion` blocks as the agent wrote them.
5. Write the review as a file in the scratchpad:

```json
{
  "commit_id": "<headRefOid>",
  "body": "Tier: 2, internal widget change.\n\n<verdict line>",
  "comments": [
    {"path": "lib/src/widgets/month/month_body.dart", "line": 184, "side": "RIGHT", "body": "..."}
  ]
}
```

6. Create it with no `event`, which leaves it pending: `gh api repos/{owner}/{repo}/pulls/<number>/reviews --input <file>`.
7. Report the tier, the verdict, the number of comments, and that the review is pending for the owner to submit.

## Rules

- A contributor's branch is read, not run, unless the owner says to run it. The reviewer is told so in step 3.
- Questions stay questions. Nothing unverified is stated as a fact.
- No comment on writing style, comment density or line length.
