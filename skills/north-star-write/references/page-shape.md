# The page shape

Modelled on Tesla's two Master Plans: one page, plain words, a recap of the last plan, the reason
for the next one, a few moves, and "So, in short". About 1,800 words above the appendices, a
seven-minute read. The proof sits in collapsed appendices underneath.

If `references/local/` holds a finished page, read it as the worked example before drafting.

## Skeleton

```
<The story image.>

## <The statement. One sentence, the user as the subject.>

If we make this statement true, we win. It is how we make <company goal>.

---

A year ago we set out to <last year's aim>. That plan is almost complete. It was not
complicated, and came down to four things:

1. <Verb-first line.>
2. <Verb-first line.>
3. <Verb-first line.>
4. <Verb-first line.>

## <The skeptic's question?>

No. <Why the obvious play loses.>

<The strategy: where we position, and for whom.>

<The one thing I care about most, and what it protects.>

Everything we did was valuable, yes. It also showed us <what gets in the way today>. Here is
what we plan to do about them, starting with <the foundation>, because the other <n> depend
on it.

## Where we will be in <year>

#### 1. <Headline of the foundation move: what the user gets from it.>

<The reason today. Two or three short scenes where the gap shows, one sentence each.>

<In <year> ... what can be trusted, who uses it, where the exceptions land.>

<The punch line. Why it takes long to build. Which squads build on it.>

#### 2. <Headline: what the user gets.>

<The reason today, with the evidence.>

<In <year> ... told as working, present tense, the user's chair, one scene.>

<How we get there, which part is ours, and why it holds or why we need it.>

#### 3. ... #### 4. ...

## So, in short

1. <The foundation, stated as the thing.>
2. <Headline 2.>
3. <Headline 3.>
4. <Headline 4.>

> Appendix A - Evidence                                   (collapsed)
- <Source, linked>, <what it is and whose>. <What it shows, in one to three sentences, with
  the date it was checked.> Backs move <n>.

> Appendix B - <A theme held for later>                   (collapsed)
For future consideration, not part of this North Star.
<Its text, kept.>

> Appendix C - <A theme that turned out to be a feature>  (collapsed)
A functionality we add, not part of this North Star. <For whom, and how far.>
<Its text, kept.>
```

## Word budgets

| Part | Words | Notes |
|---|---|---|
| Statement and the "we win" line | 30 | Two lines. Nothing else above the divider. |
| Last year's plan | 120 | Three short sentences, four lines. |
| The question and the strategy | 270 | Three paragraphs and a hand-off sentence. |
| Each move | 300 | Three paragraphs of about 100. |
| "So, in short" | 45 | The headlines again, nothing new. |
| Appendices | not counted | Evidence runs long. That is what it is for. |

The first version had moves of 150 words. They doubled in the review rounds, as each one took a
second half, a proof or an answer to a reviewer. That growth was earned. Still count the words on
every pass and say the count, because growth nobody asked for looks the same.

## Why each part is there

- **The statement first.** The first review comment on an early draft was that there was no
  statement, only themes. One sentence on line one answers that before it is asked.
- **The "we win" line.** A statement and a company goal in two different places make the reader
  guess which one is the North Star. Joined, the statement is the means and the goal is the end.
  "We" is deliberate: it brings the team together.
- **Last year's plan, Musk-style.** A lead-in that only introduces a list feels light. Say when
  the plan was made, where it stands and how simple it was, then list the steps as verbs. It
  also mirrors "So, in short" at the end: last year's plan in four lines, next year's in four.
- **The skeptic's question.** The candid answer is what makes the page sound like a person. Keep
  his blunt sentences blunt.
- **The hand-off sentence.** It replaces a whole problem section. It says the work was valuable,
  that it exposed what is in the way, and that the moves are the answer. It also names the first
  move and gives the reason it is first, so the order needs no defending later.
- **The foundation first.** It used to be the last move, done "while doing the above". A reviewer
  read the numbers as priority and said it belonged much higher, and when he told the story
  aloud he began with it anyway. The page now follows the logic he speaks.
- **Three beats a move.** Reason, then the future told as working, then why it holds. A reviewer
  who disagrees can point at the exact beat.
- **"So, in short".** The headlines are the plan. If the list does not read as a plan on its
  own, the headlines are wrong.
- **The appendices.** Evidence in the body made the moves read like a report. In an appendix it
  is one click away, and each bullet says which move it backs. A theme that left the moves stays
  on the page under an honest status line, so the thinking is not lost and nobody mistakes it
  for a commitment.

## The foundation move

The first move is the work underneath the others (the model, the platform, the API). It is the
hardest to headline because the thing is obvious and the value is not.

- State the value in the headline and keep the thing for its "So, in short" line.
- Open with scenes, not with architecture: the moment a customer or a colleague hits the gap.
- Say plainly what it is: what is modelled, who can use it (the company's own products and
  outside tools), for which work the product does not do itself, and where the exceptions land.
- Its punch line is that the promise of the other moves then holds for everything the user runs,
  not only for the part inside the product.
- Say who builds on it and that the work is planned with them. Reviewers and the squad both
  asked who owns it.
- Keep it distinct from the move it enables. The foundation is what can be trusted and acted on.
  The move on top is what the user configures and what becomes someone's task. Told in the same
  words, they are heard as one move.

## The appendices

- **Evidence.** One bullet per source: the link, what the source is and whose, what it shows in
  one to three sentences, the date checked, and "Backs move n". Put the source for the newest or
  most questioned move first. When moves are renumbered, renumber these endings.
- **For future consideration.** A theme with a real story that the year can do without. One line
  on top: "For future consideration, not part of this North Star." Drop year words such as
  "In 2027" from its text, since it is no longer a commitment. One sentence of the idea may stay
  in the move it supports.
- **A functionality we add.** A theme that turned out small and bounded. One line on top that
  says so, for whom, and how far it goes. Keep its example concrete.
- Use collapsed toggle headings, so the page still opens on the statement and the moves.

## What usually goes wrong

- A problem list that takes a third of the page. Weave each problem into its move.
- A headline that names the mechanism. Name the outcome.
- Several numbers in one sentence. Keep one, with its assumption.
- Inside words. Each one costs a reader outside the squad a second.
- A page with no "I" anywhere, when he wants it to feel personal. Two or three, where it counts.
- A move that restates last year's recap. Open it with what is still done by hand.
- Two moves that make the same promise. Give each one a sentence only it can claim.
- A theme kept as a move because its story is good, when skipping it for a year costs little.
- An absolute claim that was checked on one page of the product.
- The foundation left for last, because it is the least exciting to describe.
- A page that grows with every pass. Count words each time and say the count.
