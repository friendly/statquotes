# Columns in the quotes.csv file

- topic: the general topic with which the quote relates (e.g., Science, Statistics, etc)
- subtopic (optional): the subtopic with which the quote relates within topic (e.g., Data Visualization might have 
  Pictures, Movies, etc)
- text: plain text containing the quote. Will be displayed as is in R (should follow a markdown style)
- source: the source of the quote

# Special LaTeX fields

- TeXsource (optional): Same as source, however used if special LaTeX formatting is required (e.g., \citep[p.45]{person95}). Not used in R print-out