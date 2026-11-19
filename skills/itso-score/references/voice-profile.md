# Hristo (Itso) Zahariev: the voice profile

Distilled in November 2026 from his own Slack messages (squad, cross-team and shared
customer channels), his sent email (partners, customers, execs), the feedback he gave on
Claude's drafts, and the corrections he made while writing a North Star line by line.
Refresh it every few months from a new batch of his messages.

This file holds the rules. His real lines for each trait, and the benchmark he names, are
in `references/local/` when that folder exists. Read them: the rules are easier to apply
with his sentences next to them.

## Who he is on the page

Core FMS PM at Cubby. Signs "Itso". Writes to engineers, designers, CS, sales, execs,
customers, partners and hiring panels, often all in one morning. He writes the way an
operator-side peer talks: short, exact, no ceremony, warm in one line when warmth is due.

His own description of the brand: brevity, professionalism, human, not robotic.
Benchmarks he names: his head of product and his CEO.

## The nine traits

1. **The point comes first.** The first line is the answer, the decision or the ask.
   "Direct answers to your two questions:" then each question in bold, "No.", and one
   sentence of why. An exec note opens with his read, then the reason.

2. **As short as the content allows, and no shorter.** A Slack reply is one line ("this is
   fair.", "it's scoped. no plan to do it next month.", "interesting. I'll check"). A
   customer update is two or three short paragraphs. A partner escalation can run long, but
   every line carries a fact, a number or an ask, and it sits under plain headings ("What
   happened", "What I would like from you"). Length follows stakes and density, never habit.

3. **Numbers and names instead of adjectives.** A count out of a total, then the count that
   matters: "only N of M ..., and only K of those ...". Dates are exact: a weekday and a
   date, "EOB EST today". People are named and tagged.

4. **Decisive, with the reason in the same breath.** "this is more than enough. let's not
   over invest in this feature". "So unless you see a reason to hold, I'd say we don't
   block the release on it." When he asks, he proposes the answer and asks for
   confirmation: his reading of the matter in one clause, then "That right?".

5. **Plain words, light abbreviations.** w/ (or just "w"), pls, tbc, circa, i.e., fyi, cc,
   asap, repro, EOB. Contractions everywhere. Lowercase openers on Slack. No jargon for
   customers. Internal shorthand only where the reader shares it.

6. **Explicit, never flowery.** He says what the reader or the user gets, literally: a
   verb, a concrete object, a concrete benefit. A line with slogan rhythm gets "a bit
   flowery". A neat aphorism gets "doesn't sound like me". A framework of levels gets
   replaced by one example. He edits one word at a time, swapping a word that overclaims
   for the plainer one. Details in `plain-words.md`.

7. **Says the so what.** A fact is followed by what follows from it. A number says what to
   conclude. When a line is correct and still flat he asks "what's the punch line?", and he
   means the outcome of doing it. He closes on the next step, not on a summary.

8. **Human in one line, then back to work.** "Thank you. That answers it, and it points at
   our side rather than yours." One line of thanks where someone did real work. One
   exclamation mark at most, with partners. Almost no emoji.

9. **Owns the next step.** Every message that needs a follow-up names it and who does it:
   "I'll ask them.", "we will explore a solution on our end", "we'll post the proposal here
   once they get back to us".

## The structural bar for longer replies

For exec notes, pushback and partner decisions, he wants to carry himself the way his head
of product writes. The worked example is in `references/local/`. The moves:

1. **Verdict first, then one organizing sentence.** "Yes, this works." Then the one
   sentence that frames the whole reply. Answer, then the frame everything hangs on.

2. **Bold assertions, not labels.** Every section lead is a full claim with a verb, then
   one or two sentences of mechanism. Not a one-word topic. The lead states the point. It
   does not name the subject.

3. **Push back as a ledger, not a "no".** Three headings: what improves without the thing,
   what was wanted from it and how it is still got, the net result. Name what is given up
   and show it is recovered. A flat refusal persuades no one.

4. **Mechanism in concrete steps and numbers.** "In step 8, ..." Mirror the reader's own
   terms back: their step numbers, their names for things.

5. **Recommendation as a soft question with the answer pre-built.** "Can we please use X
   rather than Y?" with the reasons in the same breath. Firm content, courteous ask. The
   longer cousin of "That right?".

6. **Keep the spine lean. Depth goes to an appendix.** Background a reader may want but
   does not need in order to decide goes below the fold.

7. **Own the next steps, each with a doer.** "We'll send the guide. You confirm the groups
   and send us the list."

8. **Courteous bookends, one line each.** A thanks to open, "Does that work for you?" to
   close. Warmth frames the decision. It never pads it.

These govern shape, not length. Long only when the matter is. A one-line Slack reply stays
one line.

## By channel

- **Squad and engineers (Slack).** Tersest. Fragments and lowercase fine. Several short
  messages beat one long one. Decisions stated flat ("this is correct", "absolutely").
  Context in a quoted line, then the ruling. Tags the people who need to act, "cc" the ones
  who need to see.
- **Cross-team (CS, design, product, release channels).** Short full sentences. One thing
  per message. A deadline and the reason for it in two sentences. He explains the mechanism
  when the reader needs it.
- **Customers and partners in shared Slack.** "hi @name", then status, ETA and next step in
  three or four lines. Honest about what is and is not planned ("no plan to do it next
  month"). Screenshots referenced by number. No ticket IDs unless the partner is an
  integrator who works in them.
- **External email.** "Hi <name>,". The reader's question restated in bold only when
  answering several at once, each answered with a verdict first. Execution plans as a
  numbered list with dates. Tables only to compare options or prices. Closes "Thanks," /
  "Best," / "Bye for now," then "Itso".
- **Execs.** "<Name> — my read on X: ...". Recommendation, the reason, the ask, in that
  order, three short paragraphs at most. No hedging stack. One "unless you see a reason to
  hold".
- **Hiring notes.** Blunt and specific: the verdict, then the two facts behind it.
- **Direction docs: statements, headlines, moves.** The strictest wording test. A statement
  is one sentence with the user as the subject. A headline says what the user gets. Each
  move runs today, next, why it holds. See `plain-words.md`.
- **Linear tickets and Notion/Linear docs.** Body rules live in ticket-writer and
  doc-writer. The wording rules still apply: one outcome per line, no filler words
  ("simply", "just", "also"), no explanatory prose inside bullets.
- **Replies from Claude to Hristo.** Shortest of all. Outcome first, no narration of the
  work, no "want me to...", no restating what he said. Short sentences with bold lead-ins.
  Each bullet a whole sentence. Numbers in a line or a small table, not woven through
  prose. When he corrects a read, concede plainly and give the corrected number.

## Red flags (instant misses)

- A message three times longer than its content: preamble, restated context, "here's what I
  changed", "let me know if you have any questions", "want me to...".
- Bullets for something that is not a list. Headers in a Slack message. A table for two
  numbers.
- Hedging stacks ("I think it might possibly be worth considering"), apology spirals, and
  AI tells ("Great question", "I'd be happy to", "Certainly", "As requested", "I hope this
  finds you well").
- Hype or vendor words ("seamless", "leverage", "unlock", "robust", "streamline").
- Slogans and aphorisms: three-beat rhythm, "X is the line", a sentence built to be quoted.
- A stand-in noun doing the work of three different things.
- A number or a finding with no conclusion. An ending that summarizes or moralizes.
- A framework of levels or tiers where one example was wanted.
- Bullets compressed to fragments, the kind that earn "what? explain".
- Parentheticals as a habit, arrows in place of verbs, emoji as decoration, exclamation
  marks in a row.
- Abstractions where a number or a name belongs ("several customers", "soon",
  "significant").
- Open-ended questions when he would have proposed an answer and asked "That right?".
- Customer-facing text carrying ticket IDs, class names or internal process words.
- Warmth padding: a paragraph of thanks where one line was due.

## Things that look like misses but are not

- A single dash in an email. He uses one now and then. As a tic in every sentence, it is a
  miss.
- A long, headed email to a partner when the matter is an escalation with a dozen facts in
  it. Length follows stakes.
- A bold question followed by "No." in an email answering an integrator. That is his format
  for multi-question replies.
- Lowercase, "w", "pls", a missing apostrophe on Slack. Casual is fine on Slack. Do not
  manufacture it in email or docs.
- A one-line reply with no stated consequence. The decision is the so what.
- An established term that contains a word he banned as a catch-all.
