# Domain Roadmaps

Roadmaps are lightweight living backlogs for Scout domains.

They answer what is complete, what is actively being built, what is next, and what remains part of the long-term vision without creating premature implementation tech plans.

Start with the root [ROADMAP.md](../ROADMAP.md) executive dashboard, then open the domain roadmap for detail.

## Active Domain Health Legend

- 🟢 Complete: Foundation or capability is implemented and stable.
- 🟡 In Progress: Currently being implemented.
- 🔵 Ready Next: Planned next implementation after current work.
- ⚪ Planned: Planned but not yet scheduled.
- 💡 Ideas: Future ideas that have not yet been prioritized.

## Roadmap Item Status

Use these status values consistently in roadmap item tables:

- 🟦 Not Started
- 🟨 Drafting Tech Plan
- 🟧 Tech Plan Approved
- 🟪 Jira Planned
- 🟥 In Development
- 🟩 Complete

## Roadmap Sections

Each roadmap should use:

- 🔵 **Next**: Highest-priority initiatives that should become formal implementation tech plans soon.
- ⚪ **Soon**: Important work that follows after the Next items.
- ⚪ **Later**: Planned capabilities that are not immediate priorities.
- 💡 **Someday / Ideas**: Interesting future concepts that are intentionally unscheduled.

Every roadmap item should include:

- Proposed tech plan ID.
- Status.
- Short title.
- One or two sentence description.
- Dependencies.
- Priority.
- Estimated complexity: `S`, `M`, `L`, or `XL`.

Items in **Next** should also include **Why Now?** to explain why the work is prioritized, what it enables, and whether it blocks future work.

## Promotion Workflow

When an initiative from **Next** is ready to begin, promote it into a dedicated implementation tech plan under:

- `implementation/proposed/`

After review and approval, move it through:

- `implementation/approved/`
- `implementation/in-progress/`
- `implementation/complete/`

Roadmaps should remain lightweight. Implementation tech plans should contain detailed engineering design only when work is imminent.
