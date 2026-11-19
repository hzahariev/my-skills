---
name: itso-score
description: >-
  Score a draft the way Hristo (Itso) would have said it, and rewrite it in his
  voice. Three questions: does it sound like him, is it to the point, and does it
  say so what. Six dimensions (Length, Lead, So what, Wording, Specifics, Shape), a
  verdict (SEND / TRIM / REWRITE), quoted evidence, and the version Itso would
  send. Works on anything Claude drafts for him or sends him: Slack messages,
  emails, Notion/Linear prose, headlines, statements, comments, replies in this
  chat. Use when Hristo says "itso-score this", "would I say it like that?",
  "score the tone", "make it sound like me", "is this to the point?", "what's the
  so what?", "too flowery", or invokes /itso-score; and run it silently on any
  draft that will go out under his name before showing it. It judges how a text
  says it and whether it says why it matters. Whether the facts are right, or a
  ticket or doc has the right sections, belongs to ticket-writer, doc-writer and
  the content skills.
---

# Itso Score: would Hristo have said it this way?

Hristo Zahariev ("Itso" to everyone at Cubby) is the Core FMS PM. His written voice is
short, plain, decisive and human. The benchmark he names is how his head of product and
his CEO write. The failure he rejects most often is Claude's default: three times longer
than needed, bulleted, hedged, with a "what I changed" coda. This skill measures a draft
against his real writing and hands back the version he would send.

## The three questions

He uses the score to answer three things about a text. Every dimension serves one of them.

1. **Does it sound like him?** His words, the way he would say them to a colleague.
   Explicit, never flowery. *Wording.*
2. **Is it to the point?** The point first, nothing to cut, a shape that fits the reader.
   *Length, Lead, Shape.* The rules and structures come from the "Magic Words" talk his
   head of product assigned, and from the North Star he wrote by them. They are in
   `references/plain-words.md`.
3. **Does it say so what?** What it means for the reader, and what happens next. A fact
   with nothing following from it is half a sentence. *So what, Specifics.*

It does not judge whether the facts are right, the ticket is scoped, or the doc has the
right sections. That is someone else's job (ticket-writer, doc-writer, the content skills).

## Workflow

1. **Identify the reader and the channel.** Squad or engineer on Slack, cross-team Slack,
   customer or partner in a shared channel, external email, an exec, a hiring note,
   Linear/Notion prose, a headline or statement in a direction doc, or a reply to Hristo
   himself in chat. Expectations shift by channel (see `references/voice-profile.md`,
   "By channel"). If the draft does not say, infer from content and state the assumption
   in one line.

2. **Load the voice and the rules.** Read `references/voice-profile.md` (the traits, the
   structural bar for longer replies, the red flags) and `references/plain-words.md`
   (explicit wording, the structures, the so what). If `references/local/` exists, read
   `voice-examples.md` there as well: his real lines for each trait and his own
   corrections. `local/samples.md` holds full messages for when a judgment call needs one.

3. **Score the six dimensions** with `references/rubric.md`. Quote the draft's own lines
   as evidence for every judgment. Vague praise is useless: name the sentence that is
   padding, the line that sounds like a slogan, the number with no conclusion.

4. **Rewrite.** Produce the version Itso would send. Rewriting is not optional for TRIM or
   REWRITE, and even a SEND gets its one or two cuts applied. Keep his facts, his decisions
   and his ask. Change only the words, the length and the shape. On exec notes, pushback
   and partner decisions, hold the shape to the structural bar in `voice-profile.md`:
   verdict first, bold leads that assert, pushback as a trade-off ledger, depth to an
   appendix. Never invent a fact, a date, a consequence or a commitment to make the
   rewrite sound better. If the so what is missing and the draft does not contain it, say
   what is missing and ask him. Do not make one up.

5. **Deliver** in the output format below. When this skill runs silently before a draft
   goes to Hristo, skip the review and show only the rewritten draft.

## Output format

Use this structure exactly:

```
# Itso Score: [what the draft is, in a few words]

**Verdict: [SEND / TRIM / REWRITE]** · reader: [who] · channel: [where]

## Length — [Strong / Adequate / Weak]
[1-3 sentences. Word count against the channel's norm. Quote the padding.]

## Lead — [Strong / Adequate / Weak]
[1-3 sentences. Is the first line the answer, decision or ask? Quote the preamble if any.]

## So what — [Strong / Adequate / Weak]
[1-3 sentences. Does the reader know what it means for them and what happens next?
Quote the fact or number that has no conclusion.]

## Wording — [Strong / Adequate / Weak]
[1-3 sentences. His words, plain and explicit? Quote hedges, AI tells, hype, slogans,
stand-in words or stiffness.]

## Specifics — [Strong / Adequate / Weak]
[1-3 sentences. Names, numbers, dates, links, decisions? Quote the abstractions.]

## Shape — [Strong / Adequate / Weak]
[1-3 sentences. Does the structure fit the channel? Bullets, headers, emoji, codas?]

## What Itso would say
[One line, his gut reaction, in his voice. e.g. "3x too long. The answer is the second
paragraph." or "ok but so what? say what we do about it."]

## Cuts
[Numbered, most important first. Each: the line, the change, why. For SEND, one or two.]

## How Itso would say it
[The rewritten draft, ready to send. Nothing after it.]
```

### Verdict meanings

- **SEND**: he would send it with at most a cosmetic cut. All six Strong, or five Strong
  and one Adequate that a single cut fixes.
- **TRIM**: the content and the decision are right, the words are not. Any dimension Weak,
  or two or more Adequate. The rewrite keeps the structure and loses the fat.
- **REWRITE**: wrong wording or wrong shape for the reader, or no point the reader can act
  on. Length Weak together with Wording or Shape Weak. Or Lead Weak together with So what
  Weak. Or a draft that answers a question he did not ask. Start again from his ask and
  his facts.

Tie-break: "If Itso read this before sending, would he hit send, delete half of it, or
write it himself from scratch?"

Be honest. He rejected drafts that were three times too long, so a review that calls
padding "Adequate" is the padding problem in another form. When in doubt, cut.

## Guardrails

- Keep every fact, number, name, date and commitment exactly as the draft had them. The
  score never changes what is being said, only how, and whether it says why it matters.
- The so what is usually one clause, not a paragraph. Do not add significance he did not
  claim, and do not close on a moral.
- Terse is not cryptic. When he answers "what? explain", the text was compressed past a
  full sentence. A short draft still needs each line to be a plain, whole sentence.
- Do not add warmth he did not put there. One line of thanks is his register. A paragraph
  of appreciation is not.
- Do not fake his Slack typos or lowercase. Write clean, plain sentences. Lowercase
  openers and abbreviations are allowed on Slack, never required.
- Customer- and prospect-facing text follows the plain-language rule: no ticket IDs,
  class names, DTOs or internal process words.

## Files

- `references/voice-profile.md`: who he is on the page, the traits, the structural bar,
  by channel, the red flags.
- `references/plain-words.md`: explicit wording, the structures he writes in, the so what.
- `references/rubric.md`: the six dimensions and how they combine into a verdict.
- `references/local/` (private, never committed): his real lines by trait, full message
  samples, the benchmark he names, and his own corrections.
