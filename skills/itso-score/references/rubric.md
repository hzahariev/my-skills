# Scoring rubric

Rate each dimension **Strong**, **Adequate** or **Weak**. Quote the draft for every
judgment. The question under all six: would Itso have said it this way?

The six serve his three questions. To the point: Length, Lead, Shape. So what: So what,
Specifics. Sounds like him: Wording.

## 1. Length

Is every sentence earning its place for this reader and channel?

- **Strong**: nothing to cut. Slack reply one to three lines. Slack ask two short
  paragraphs and one question. Customer update three or four lines. External email
  under five short paragraphs unless it is an escalation or a spec. Exec note three
  paragraphs. Reply to Hristo in chat as short as the answer allows.
- **Adequate**: one or two sentences of padding (a restated question, a courtesy line,
  a summary of what was just said).
- **Weak**: the content would survive at half the length or less. Preamble, context he
  already has, "what I changed" codas, options he did not ask for.

Judgment note: measure against need, not against a word limit. A twelve-item escalation
to a vendor is allowed to be long. A one-question Slack ping is not. And terse is not
cryptic: a line cut down to fragments that needs "what? explain" is a Wording miss, not a
Length win.

## 2. Lead

Is the first line the answer, the decision or the ask?

- **Strong**: the first sentence carries the point. A reader who stops there knows what
  happened or what is wanted. In a longer text, each section does the same.
- **Adequate**: the point arrives in the second sentence, after a short run-up.
- **Weak**: the point is buried under context, a greeting paragraph, or a narrative of
  how the answer was found.

## 3. So what

After reading, does the reader know what it means for them and what happens next?

- **Strong**: the outcome is stated. Each finding is followed by what follows from it.
  Each number says what to conclude. The text ends on the ask or the next step, with its
  owner. A future is set against what is true today.
- **Adequate**: the point is there, and in one place the reader has to infer the
  consequence: a number without its conclusion, a finding with no "so", an ending that
  summarizes where it should ask.
- **Weak**: a description or a status. Facts are listed and nothing follows from them.
  The reader's next message would be "so what?", "what does this mean?" or "what do you
  need from me?".

Judgment notes: the so what is usually one clause, so do not reward a paragraph about
significance. In a one-line reply the decision is the so what ("this is fair." is
complete). If the consequence is not in the draft and cannot be derived from its facts,
mark it and ask him. Never supply one.

## 4. Wording

His words, plain and explicit? Would he say it out loud to a colleague?

- **Strong**: everyday words, contractions, decisions stated flat, one line of warmth
  where due, abbreviations he uses on the channels he uses them. Lines say what the reader
  gets with a verb and a concrete object. No hedging stack, no hype, no AI tells, no
  slogan, no stand-in noun.
- **Adequate**: mostly right, with one of these: a hedge too many, a stiff phrase ("please
  be advised"), a touch of vendor language, a line that sounds quotable, a word that
  overclaims, an abstract noun where the thing should be named, warmth that runs a
  sentence long.
- **Weak**: reads as generated or as copywriting. "Great question", "I'd be happy to",
  "Certainly", "I hope this finds you well", apology spirals, emoji decoration,
  exclamation runs. Or three-beat slogans and aphorisms. Or a framework of levels where
  one example was wanted. Or a customer-facing line that leaks ticket IDs and class names.

Judgment notes: one dash or one "pls" is not a signal. A pattern is. An established term
that contains a word he banned as a catch-all is fine. Apply his rules as he stated them,
not wider. The tests are in `plain-words.md`, part 1.

## 5. Specifics

Names, numbers, dates, links and decisions instead of adjectives and abstractions?

- **Strong**: the people are named and tagged, the counts and dates are exact, the next
  step and its owner are stated, a proposed answer replaces an open question.
- **Adequate**: one abstraction where a figure or a name belongs ("a few customers",
  "soon", "the team").
- **Weak**: mostly abstractions and qualifiers. The reader has to ask what, who, when.

Judgment note: specifics are not the same as volume. One count out of a total is a
specific. A table of twenty figures in a Slack message is not. And a specific without its
conclusion is a So what miss.

## 6. Shape

Does the structure fit the channel and the content?

- **Strong**: Slack as plain sentences, several short messages for several points. Email
  with a greeting, direct answers, a numbered plan when there is a plan, a sign-off.
  Escalations under plain headings. Tables only to compare. Bullets only for lists, each a
  whole sentence. Bold leads that assert. A closing list that repeats and adds nothing.
- **Adequate**: one structural reflex that does not fit: a bulleted list of two, a bold
  label where a sentence would do, a parenthetical habit, an arrow in place of a verb.
- **Weak**: headers in a Slack message, a bulleted spec where a reply was wanted, a wall of
  prose where a numbered list of asks was wanted, or a format copied from the wrong
  channel.

Judgment note: on exec notes and pushback the bar is the structural one in
`voice-profile.md`. A bold lead that only labels the topic, or a flat "no" where a
trade-off ledger was needed, is the Shape miss to catch. Mark it Adequate at best and fix
it in the rewrite.

## Combining into a verdict

- **SEND**: all Strong, or five Strong and one Adequate fixed by one cut.
- **TRIM**: any Weak, or two or more Adequate. Keep the structure, lose the fat.
- **REWRITE**: Length Weak together with Wording or Shape Weak. Or Lead Weak together with
  So what Weak: the text has no point the reader can act on. Or the draft answers a
  question he did not ask. Start from his ask and his facts.

Tie-break: "Would Itso hit send, delete half, or write it himself?"
