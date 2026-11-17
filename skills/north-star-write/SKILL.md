---
name: north-star-write
description: >-
  Write or rework a product-area North Star (direction / vision doc) with Hristo
  in the shape that worked for the Core FMS North Star: one statement on top, a
  Tesla-Master-Plan style page (last year's plan in four lines, the skeptic's
  question, four or five moves that each open on their reason, "So, in short"),
  drafted from his own words, every claim checked against evidence, the squad
  Notion page edited only on a go, plus a one-slide branded story image. Use
  whenever Hristo asks to write, draft, restructure, shorten, sense-check or
  iterate a North Star, vision, strategy or direction doc, a statement, move or
  headline inside one, or the "story" slide or image for it, or says "north
  star", "squad page", "so, in short", "Tesla shape", or invokes
  /north-star-write. NOT for scoring an existing draft only (use the local
  reviewer and voice rubric skills), and NOT for tickets or concept docs
  (ticket-writer, doc-writer).
---

# North Star Write

Hristo is a PM at Cubby. A North Star is his statement of where the value lies for his product
area next year and why. It is read by product leadership in a short review session, so it has to
do two jobs: fit on one page that reads in about five minutes, and be clear enough that a reviewer
can say "yes, I believe that" or "no, I don't" to each part.

The doc is his. This skill is the method for getting his thinking onto the page, not for writing
it for him. Product leadership has said plainly that an AI-written ten-pager defeats the purpose,
so every step below keeps his sentences his and uses Claude for structure, evidence and questions.

## Start here

1. **Read the private context if it exists:** `references/local/context.md` (not in the public
   repo). It names the reviewers, the page, the previous North Star, the rubric skills and the
   memory notes. Follow it.
2. **Read the live material before writing a word:** the current page (fetch it, never work from
   memory, he edits it live), the brief or template from product leadership, the other squads'
   drafts, his recent calls with the reviewers, and the backlog or usage data behind the claims.
3. **Work out where he is.** A blank page, raw notes per section, a draft to tighten, one line
   that is not landing, or the story slide. Do only that part. He works one section at a time.

## Whose words

- Draft from his own material: his typed notes, what he said on calls (transcripts are often
  where his best sentences are), his earlier drafts and his chat messages. Lift, then compress.
- He switches between two modes. "I write, you sort and flag", and "give me a good draft I can
  review". Follow whichever he is in. In both, when he edits a sentence, hand it back lightly
  cleaned and **name every touch** in a short list. When he pastes his own wording back after a
  cleaning, his wording stands. Do not swap it a second time.
- Mark sentences that are yours and not yet confirmed. Keep that list honest until he says they
  are fine, especially for anything that goes on the page.
- Never change a fact or a number quietly. Flag it, show the corrected sentence, let him choose.
- Do not cut his content to make something fit. Change the layout or the structure and say what
  moved. If something must fall out, list it so he can put it back.

## The page

Six parts, about 1,500 words. Full skeleton, word budgets and the reasons are in
`references/page-shape.md`. Read it before drafting or restructuring.

1. **The statement.** One sentence, the user as the subject, first line of the page.
2. **The line that ties it to the company goal.** "If we make this statement true, we win. It is
   how we make ..." Written as "we", because it is what the team is asked to agree to.
3. **Last year's plan.** When it was set, where it stands, how simple it was, then four
   verb-first lines.
4. **The skeptic's question, answered.** The honest question a reviewer would ask, a one-word
   answer, the strategy, and the one thing he cares about most.
5. **The moves.** Four or five. Each has an explicit headline and three beats: the reason today,
   next year told as working, why it holds.
6. **"So, in short".** The headlines as a numbered list. The last line is the enabling work and
   starts with "While doing the above,".

There is no separate problem section. The first full draft had one, and it read like a status
report: a third of the page before any direction. Each problem now opens the move that answers
it, which is also how the Tesla plans do it.

## Writing a move

- **Beat one, the reason.** What is true today, in his words, with the evidence that proves it.
  Two to four sentences.
- **Beat two, next year told as working.** Present tense, from the user's chair, opened with the
  year ("By the end of 2027 ..." or "In 2027 ..."). One concrete scene beats three capabilities.
- **Beat three, why it holds.** The punch line first: what this changes for the business. Then
  one sentence on why a competitor cannot copy it quickly.
- About 150 words a move. One number at most, only if it settles an argument, with its
  assumption in the same sentence ("assuming it is paid by card").
- No feature names where a plain description works. A reviewer's test: if a sentence could be
  pasted into a ticket as it stands, it is too concrete for this doc.
- Moves should chain. The enabling move comes last and should make the others stand on it.

## Headlines and the statement

He rejected more headlines than anything else. The pattern behind the ones that survived:

- **Say what the user gets, literally.** A verb, a concrete object, a concrete benefit, in words
  the user would say out loud. This is the "what is it to the user" test from the NFX "Magic
  Words" talk his head of product assigned.
- **No slogans and no aphorisms.** Three-beat rhythm, "X is the line", "without surprises" and
  similar read as copywriting. If a line sounds quotable, rewrite it as a plain statement.
- **Separate the thing from the value.** "Build a model that supports ..." is the thing. The
  headline is the value. The thing can still close the "So, in short" list.
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
- When he asks "is that true?" about how the product works, check the code, not the docs, and
  report the freshness of the checkout.
- Check the other squads' drafts for the same idea. If two or three pages claim it, tell him and
  say which part only his page has. Their stated needs are also his dependency evidence.
- Each move needs a reason that is stated on the page. If a move answers a problem the page never
  states, say so and offer the sentence.
- A number that rests on an assumption carries the assumption. If the data in front of you
  contradicts his number, say it once, plainly, with the corrected sentence, then follow his call.
- Keep proof out of the page body. One sentence of evidence per beat. The rest stays in the notes.

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

## The Notion page

- Edit the page only on an explicit go for that change. "Ok" right after "say go and I do X" is
  a go. A bare "ok" after a list of options is not: ask which.
- Fetch immediately before every edit. He changes icons, heading levels and spacing himself.
  Keep his formatting.
- Prefer targeted replacements. Replace the whole page only when he asked for a new structure.
- After each edit, report what is on the page now, what is not, and which sentences of yours are
  on it without his confirmation.

## The story slide

Leadership asks each PM to tell the story, with the doc as the fallback. The format that worked
is one branded 16:9 image of about 145 words. Recipe, layout rules and build steps are in
`references/story-slide.md`. The template is `assets/story-image.html` and the renderer is
`scripts/render-story.sh`.

## How to answer him

- Lead with the outcome, then the block he can paste, then a short list of touches and checks.
- Short sentences, bold lead-ins, no filler. When he says "what? explain", the bullets were too
  compressed: answer in full plain sentences.
- Give a recommendation, not a survey. When he asks for references, he wants concrete examples he
  can copy, not frameworks or books.
- Keep running notes in memory as the doc moves, so a long session survives a context reset: his
  raw notes verbatim, each decision, and what is and is not on the page.

## Files

- `references/page-shape.md`: the skeleton, word budgets and why each part is there.
- `references/lessons.md`: what he corrected and the rule behind each correction.
- `references/story-slide.md`: the one-slide story, layout rules, build steps.
- `references/sources.md`: public examples worth imitating, for docs, stories and visuals.
- `assets/story-image.html`: the slide template.
- `scripts/render-story.sh`: HTML to PNG.
- `references/local/` (private, never committed): context, the finished page, verbatim notes.
