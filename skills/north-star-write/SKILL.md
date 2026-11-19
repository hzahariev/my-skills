---
name: north-star-write
description: >-
  Write, rework or defend a product-area North Star (direction / vision doc) with Hristo
  in the shape that worked for the Core FMS North Star: one statement on top, a
  Tesla-Master-Plan style page (last year's plan in four lines, the skeptic's
  question, three to five moves that each open on their reason with the foundation
  first, "So, in short", evidence in an appendix), drafted from his own words, every
  claim checked against code or data, the squad Notion page edited only on a go, plus a
  one-slide branded story image. Also covers the rounds after the first draft:
  answering reviewers' written comments, moving a theme to an appendix, keeping comment
  threads through a restructure, preparing how he tells it, and reading a review session
  or team sync from its transcript against the page. Use whenever Hristo asks to write,
  draft, restructure, shorten, sense-check or iterate a North Star, vision, strategy or
  direction doc, a statement, move or headline inside one, its evidence or appendix, the
  "story" slide or image for it, or asks how a North Star session went, or says "north
  star", "squad page", "so, in short", "Tesla shape", "reviewer comments", or invokes
  /north-star-write. NOT for scoring an existing draft only (use the local reviewer and
  voice rubric skills), and NOT for tickets or concept docs (ticket-writer, doc-writer).
---

# North Star Write

Hristo is a PM at Cubby. A North Star is his statement of where the value lies for his product
area next year and why. Product leadership reads it in a short review session, and he later tells
it to his own squad. So it has to do two jobs: fit on one page that reads in a few minutes, and
be clear enough that a reader can say "yes, I believe that" or "no, I don't" to each part.

The doc is his. This skill is the method for getting his thinking onto the page, not for writing
it for him. Product leadership has said plainly that an AI-written ten-pager defeats the purpose,
so every step below keeps his sentences his and uses Claude for structure, evidence and questions.

## Start here

1. **Read the private context if it exists:** `references/local/context.md` (not in the public
   repo). It names the reviewers, the page, the previous North Star, the rubric skills and the
   memory notes. Follow it.
2. **Read the live material before writing a word:** the current page with its comments (fetch
   it, never work from memory, he edits it live), the brief or template from product leadership,
   the other squads' drafts, his recent calls with the reviewers, and the backlog or usage data
   behind the claims.
3. **Work out which round this is.** Each one needs something different.
   - *First draft.* A blank page, raw notes per section, or a draft to tighten. Use "The page"
     and "Writing a move" below.
   - *Reviewers have commented.* Read every comment and his replies first, then
     `references/review-rounds.md`.
   - *It has been told in a session.* Read the transcript against the page, then
     `references/telling.md`.
4. **Do only the part he is on.** He works one section, one sentence or one word at a time.

## Whose words

- Draft from his own material: his typed notes, what he said on calls (transcripts are often
  where his best sentences are), his replies to reviewers, his earlier drafts and his chat
  messages. Lift, then compress.
- He switches between two modes. "I write, you sort and flag", and "give me a good draft I can
  review". Follow whichever he is in. In both, when he edits a sentence, hand it back lightly
  cleaned and **name every touch** in a short list. When he pastes his own wording back after a
  cleaning, his wording stands. Do not swap it a second time. When he says you can refine his
  language, fix grammar and flow and still name each touch.
- Mark sentences that are yours and not yet confirmed. Keep that list honest until he says they
  are fine, especially for anything that goes on the page.
- For a restructure or a full pass, give him a **review copy** as a local file before the page
  changes, with marks that show whose each sentence is. He cannot review a draft if he cannot
  see which sentences are his. The legend is in `references/review-rounds.md`.
- Never change a fact or a number quietly. Flag it, show the corrected sentence, let him choose.
- Do not cut his content to make something fit. Change the layout or the structure and say what
  moved. If something must fall out, list it so he can put it back.
- A decision of his closes a flag. Once he has ruled on who owns something or on what a move
  does not need to answer, record it and do not raise it again.

## The page

Seven parts. The first six run to about 1,800 words, and the seventh is the appendices. Full
skeleton, word budgets and the reasons are in `references/page-shape.md`. Read it before
drafting or restructuring.

1. **The statement.** One sentence, the user as the subject, first line of the page.
2. **The line that ties it to the company goal.** "If we make this statement true, we win. It is
   how we make ..." Written as "we", because it is what the team is asked to agree to.
3. **Last year's plan.** When it was set, where it stands, how simple it was, then four
   verb-first lines.
4. **The skeptic's question, answered.** The honest question a reviewer would ask, a one-word
   answer, the strategy, and the one thing he cares about most. It ends on a hand-off sentence
   that names the first move and why it comes first.
5. **The moves.** Three to five. The version that passed review had four. Each has an explicit
   headline and three beats: the reason today, next year told as working, why it holds. Readers
   take the order as the priority, so the move the others depend on goes first.
6. **"So, in short".** The headlines as a numbered list, nothing new.
7. **Appendices, collapsed.** Evidence first. Then any theme that was a move and no longer is,
   with one honest line on its status.

There is no separate problem section. The first full draft had one, and it read like a status
report: a third of the page before any direction. Each problem now opens the move that answers
it, which is also how the Tesla plans do it.

## Writing a move

- **Beat one, the reason.** What is true today, in his words, with the evidence that proves it.
  If last year's recap already claims this area, open with what is still done by hand today, so
  no reader has to ask how the move differs from now.
- **Beat two, next year told as working.** Present tense, from the user's chair, opened with the
  year ("By the end of 2027 ..." or "In 2027 ..."). One concrete scene beats three capabilities.
- **Beat three, why it holds.** The punch line first: what this changes for the business. Then
  the reason, in whichever form survives a skeptic: why a competitor cannot copy it quickly, or
  plainly why the work is needed. If "they cannot copy it" would not survive "why not?", do not
  claim it.
- **A fix also says what it unlocks.** A move that only made something reliable was read as
  defensive. A paragraph on what the reliable thing lets the product become answered that.
- **Say whose it is.** When another squad or a company initiative carries part of a move, name
  it and say which part is this squad's. Unowned overlap is the first thing a reviewer presses.
- About 300 words a move, three paragraphs. Few numbers, each proving the sentence it sits in,
  with its assumption in the same sentence ("assuming it is paid by card"). The rest belong in
  the evidence appendix.
- One concrete example beats a framework. Asked how far something goes, answer with the example,
  not with levels or tiers.
- No feature names where a plain description works. A reviewer's test: if a sentence could be
  pasted into a ticket as it stands, it is too concrete for this doc.
- Moves should chain, and each must make a promise only it can make. If two moves can be told in
  the same words, readers and listeners hear one.

## Headlines and the statement

He rejected more headlines than anything else. The pattern behind the ones that survived:

- **Say what the user gets, literally.** A verb, a concrete object, a concrete benefit, in words
  the user would say out loud. This is the "what is it to the user" test from the NFX "Magic
  Words" talk his head of product assigned.
- **No slogans and no aphorisms.** Three-beat rhythm, "X is the line", "without surprises" and
  similar read as copywriting. If a line sounds quotable, rewrite it as a plain statement.
- **Separate the thing from the value.** "Build a model that supports ..." is the thing. The
  headline is the value. The thing can still be the foundation's line in "So, in short".
- **Read it for what it implies.** A headline can be true and still say the wrong thing about the
  product (that users must do work they should not have to, or that the product does less than it
  does). Ask what a skeptical reader would infer.
- **One theme, one headline.** Do not let two moves headline the same idea.
- **When he asks "what is the punch line?"** he means the outcome of doing it. Give the outcome
  for the user's business, for the user's team and for the company, let him pick, and put it at
  the top of beat three.
- **"I" and "we".** The top line is "we". Use "I" in two or three places where someone could
  disagree with a call he is making. More than that thins it out.

## Evidence

- Every load-bearing sentence gets a source or a flag: tickets, usage data, call transcripts, the
  other squads' pages, the codebase. Say what is counted and what is not.
- **Check every sentence about how the product works today before it goes on the page, his own
  included.** Use the code and the data, not the docs and not a ticket title, and report the
  freshness of the checkout. One of his own sentences turned out false in the code, and the
  corrected one was sharper.
- **Scope the absolutes.** "Never", "no", "all" and "every" are claims about the whole product.
  Say where the claim was checked and keep it that size.
- When the data in front of you contradicts his number, first find what his number covers: which
  date, which population, open work or delivered work too. Then say it once, plainly, with the
  corrected sentence, and follow his call.
- Attribute a public count to whoever counted it, and say what the count includes. Keep a short
  list of what the sources do not show, so a claim that did not hold cannot return in a later
  draft or in the telling.
- Check the other squads' drafts for the same idea. If two or three pages claim it, tell him and
  say which part only his page has. Their stated needs are also his dependency evidence.
- Each move needs a reason that is stated on the page. If a move answers a problem the page never
  states, say so and offer the sentence.
- Keep proof out of the body: one sentence of evidence per beat. The rest goes to the evidence
  appendix, one bullet per source, each ending with the move it backs.
- A linked doc or dashboard that only he can open is not evidence to a reviewer. Remind him to
  share it.

## What the reviewers will ask

Run these before showing a draft. If the local reviewer and voice rubric skills are installed
(see `references/local/context.md`), apply them silently as well.

- Can he say it in one sentence, and is that sentence the first line of the page?
- Is it unrealized value, or a description of what already exists? What is new against last
  year's recap?
- Is each move framed as what the user and the user's customer get?
- Does each section lead with its conclusion? Does each number carry its conclusion?
- Why now, and what survives a competitor's catch-up?
- Is it shorter and clearer than the last version?
- Which part is his squad's, when other squads say something similar?

Once reviewers had read the page, their written questions were sharper. Ask them of every move:

- What stops the market leader from doing the same?
- What does this sentence mean? Any abstract line draws it.
- How is this different from today?
- What happens if we skip it next year?
- Is this direction, or a feature we simply add? How big is it?
- Is the order the priority?
- Is this move only a fix?
- Whose bet is it, ours or another squad's?

What each answer does to the page is in `references/review-rounds.md`.

## After the reviewers comment

- Read all the comments and his replies before proposing anything. His replies are decisions and
  raw material: lift his sentences from them.
- A reviewer's "keep this out" is a decision. Record it and stop proposing the topic.
- A theme that does not survive "what if we skip it" or "is it just a feature" leaves the moves
  and goes to an appendix. Its text is kept, not deleted, under one line that says what it now is.
- When the structure changes, carry every comment thread onto its matching text, so reviewers
  can still resolve them. A rewrite that drops their comments reads as ignoring them.
- A reorder breaks sentences elsewhere: the hand-off, any "that is why I put X first", the
  closing list, the evidence endings, the slide. Go through the checklist in the reference.

## Telling it, and reading the session afterwards

- Assume nobody has read the page. The slide has to carry the whole plan, and its rows are the
  "So, in short" lines word for word.
- Help him prepare about fifteen minutes with stops: after the statement, then after each move.
  One sentence per move that only that move can claim. Competitor lines and numbers exactly as
  the page and the evidence have them.
- Afterwards, read the transcript against the page: where the telling matched, where it drifted,
  which facts differ from the evidence, what he promised in the room that the page does not
  carry, what was asked, who stayed silent. Time the presentation and the discussion separately.
- Build any new sentence for the page from what he said in the room, and say that it is his,
  cleaned or translated.

Details and the scoring rules are in `references/telling.md`.

## The Notion page

- Edit the page only on an explicit go for that change. "Ok" right after "say go and I do X" is
  a go. A bare "ok" after a list of options is not: ask which.
- A go that names no change is not a go for a deletion. Say which single change is pending and
  the word that triggers it.
- Fetch immediately before every edit. He changes icons, heading levels and spacing himself.
  Keep his formatting.
- Prefer targeted replacements. Replace the whole page only when he asked for a new structure,
  and then carry the comment threads (`references/review-rounds.md`).
- After each edit, report what is on the page now, what is not, which sentences of yours are on
  it without his confirmation, and that every comment thread and reaction is still attached.

## The story slide

Leadership asks each PM to tell the story, with the doc as the fallback. The format that worked
is one branded 16:9 image of about 145 words. Recipe, layout rules and build steps are in
`references/story-slide.md`. The template is `assets/story-image.html` and the renderer is
`scripts/render-story.sh`. When the moves change, the slide changes in the same pass.

## How to answer him

- Lead with the outcome, then the block he can paste, then a short list of touches and checks.
- Short sentences, bold lead-ins, no filler. When he says "what? explain", the bullets were too
  compressed: answer in full plain sentences.
- Give a recommendation, not a survey. When he asks for references, he wants concrete examples he
  can copy, not frameworks or books.
- When he corrects your read, concede plainly, give the corrected number and move on. Do not
  defend the first version.
- Keep running notes in memory as the doc moves, so a long session survives a context reset: his
  raw notes verbatim, each decision, and what is and is not on the page.

## Files

- `references/page-shape.md`: the skeleton, word budgets and why each part is there.
- `references/review-rounds.md`: reviewers' comments, appendices, the review copy, comment threads.
- `references/telling.md`: preparing the telling, reading a session transcript, scoring it.
- `references/lessons.md`: what he corrected and the rule behind each correction.
- `references/story-slide.md`: the one-slide story, layout rules, build steps.
- `references/sources.md`: public examples worth imitating, for docs, stories and visuals.
- `assets/story-image.html`: the slide template.
- `scripts/render-story.sh`: HTML to PNG.
- `references/local/` (private, never committed): context, the finished page, verbatim notes.
