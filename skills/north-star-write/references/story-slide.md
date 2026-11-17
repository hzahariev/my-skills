# The one-slide story

Product leadership asks each PM to tell the story of the North Star, with the doc as the
fallback. The format that worked is one 16:9 image, about 145 words, that can sit on screen while
he talks.

## What is on it

In reading order:

1. **Header line.** The brand mark and "<Area> · North Star <year>", with a hairline under it.
2. **The statement on one row.** One word in the brand colour: the word the whole page rests on.
3. **The "we win" line on the second row.** "If we make this statement true, we win. It is how we
   make ...". One row.
4. **Left column, three beats.** Each is a bold line with one sentence under it:
   - what was built last year, with the short list;
   - what was learned, with the one prerequisite;
   - the skeptic's question and its one-word answer, with the consequence.
5. **Right column, "So, in <year>".** The headlines as numbered rows, word for word from the
   page. The last row is the enabling move, drawn as the solid base the others stand on.
6. **Footer.** Copyright and date on the left, the logo on the right.

Every line on the slide is a sentence from the page or from what he said. Nothing new is written
for the slide. Speaker notes, if a deck is built as well, are a talk track in his own words.

## Layout rules

- **Let it breathe.** Wide side margins (120px on a 1920 canvas), clear gaps between the header,
  the two top rows and the columns, and free space above the footer.
- **Find room in the layout, not in the copy.** The title on one row and the supporting line on
  one row free enough height for the three beats to keep their sentences. Do not delete his
  content to make space.
- **Rows, not a diagram.** A hub-and-spoke version was built and he preferred the rows.
- **One colour family.** Tints of one brand colour for the rows, the solid colour for the base
  row, neutrals for text.
- **Sizes that worked on 1920×1080:** title 58px semi-bold, supporting line 28px light, beat
  heads 28px bold, beat sentences 26px light, rows 26px, rounded corners 20px.

## Brand

Use the company brand skill for the rules (fonts, colours, logo use) and its official logo files.
Copy the logo files next to the HTML at build time, into a `brand/` folder. Do not redraw the
logo and do not commit logo files to this repo.

Where the brand guide and a deck he likes disagree on font or colour, follow the brand guide and
keep the deck's layout cues. Say which came from where.

## Build

1. Copy `assets/story-image.html` to a working folder and fill in the text. Keep the classes.
2. Copy the unit mark and the full-colour logo into `brand/` beside it, named as the template
   expects.
3. Render: `scripts/render-story.sh story-image.html story-check.png 1`, look at the image,
   fix what overflows or crowds, repeat.
4. Render the final at double size: `scripts/render-story.sh story-image.html story.png 2`
   (3840×2160).
5. Save the PNG where he can open it and send it to him. Keep the HTML beside it so the next
   edit is one line.

Check on every render: the title stays on one row, no row wraps to a third line, nothing touches
the footer, and the brand colour appears in exactly one family.

## If he wants a deck as well

Build one slide from the Slides type with the same content. Keep it in step with the image, or
say that it is not. A private artifact has to be shared from its own Share menu before anyone
else can open it.
