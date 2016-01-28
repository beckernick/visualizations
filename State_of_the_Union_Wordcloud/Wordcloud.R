library("wordcloud")
library("tm")

create.wordcloud <- function (directory) {
  text <- Corpus(DirSource(directory))
  text <- tm_map(text, stripWhitespace)
  text <- tm_map(text, content_transformer(tolower))
  text <- tm_map(text, removeWords, stopwords("english"))
  text <- tm_map(text, removeNumbers)
  text <- tm_map(text, removePunctuation)
  wordcloud(text, scale=c(5, .25), random.order=FALSE, max.words = 75, colors=brewer.pal(n = 8,"Accent"))
             #,vfont = c("gothic english", "plain"))
  
}

