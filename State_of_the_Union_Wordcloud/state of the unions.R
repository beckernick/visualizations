##### Scrape State of the Unions for Wordcloud #####
library(rvest)
library(tm)
library(wordcloud)
library(SnowballC) # Provides wordStem() for stemming.

setwd("~/Documents/R Workspace/Wordcloud SOTU")

# reverse sequential order in the doclist (2015, 2014, 2013, ...)
# 2015-1934
doclist = c("http://www.presidency.ucsb.edu/ws/index.php?pid=108031", "http://www.presidency.ucsb.edu/ws/index.php?pid=104596",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=102826", "http://www.presidency.ucsb.edu/ws/index.php?pid=99000",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=88928", "http://www.presidency.ucsb.edu/ws/index.php?pid=87433",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=85753", "http://www.presidency.ucsb.edu/ws/index.php?pid=76301",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=24446", "http://www.presidency.ucsb.edu/ws/index.php?pid=65090",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=58746", "http://www.presidency.ucsb.edu/ws/index.php?pid=29646",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=29645", "http://www.presidency.ucsb.edu/ws/index.php?pid=29644",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=29643", "http://www.presidency.ucsb.edu/ws/index.php?pid=58708",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=57577", "http://www.presidency.ucsb.edu/ws/index.php?pid=56280",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=53358", "http://www.presidency.ucsb.edu/ws/index.php?pid=53091",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=51634", "http://www.presidency.ucsb.edu/ws/index.php?pid=50409",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=47232", "http://www.presidency.ucsb.edu/ws/index.php?pid=20544",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=19253", "http://www.presidency.ucsb.edu/ws/index.php?pid=18095",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=16660", "http://www.presidency.ucsb.edu/ws/index.php?pid=36035",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=34430", "http://www.presidency.ucsb.edu/ws/index.php?pid=36646",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=38069", "http://www.presidency.ucsb.edu/ws/index.php?pid=40205",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=41698", "http://www.presidency.ucsb.edu/ws/index.php?pid=42687",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=43425", "http://www.presidency.ucsb.edu/ws/index.php?pid=33079",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=32657", "http://www.presidency.ucsb.edu/ws/index.php?pid=30856",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=5555", "http://www.presidency.ucsb.edu/ws/index.php?pid=5677",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=4938", "http://www.presidency.ucsb.edu/ws/index.php?pid=4327",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=3996", "http://www.presidency.ucsb.edu/ws/index.php?pid=3396",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=3110", "http://www.presidency.ucsb.edu/ws/index.php?pid=2921",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=29333", "http://www.presidency.ucsb.edu/ws/index.php?pid=28738",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=28338", "http://www.presidency.ucsb.edu/ws/index.php?pid=28015",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=26907", "http://www.presidency.ucsb.edu/ws/index.php?pid=26787",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=9138", "http://www.presidency.ucsb.edu/ws/index.php?pid=9082",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=8045", "http://www.presidency.ucsb.edu/ws/index.php?pid=12061",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=11685", "http://www.presidency.ucsb.edu/ws/index.php?pid=11162",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=11029", "http://www.presidency.ucsb.edu/ws/index.php?pid=10704",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=10416", "http://www.presidency.ucsb.edu/ws/index.php?pid=10096",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=9829", "http://www.presidency.ucsb.edu/ws/index.php?pid=14418",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=14017", "http://www.presidency.ucsb.edu/ws/index.php?pid=13567",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=13293", "http://www.presidency.ucsb.edu/ws/index.php?pid=13005",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=12762", "http://www.presidency.ucsb.edu/ws/index.php?pid=12467",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=16603", "http://www.presidency.ucsb.edu/ws/index.php?pid=16518",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=16386", "http://www.presidency.ucsb.edu/ws/index.php?pid=16253",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=16092", "http://www.presidency.ucsb.edu/ws/index.php?pid=15856",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=15684", "http://www.presidency.ucsb.edu/ws/index.php?pid=15517",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=15336", "http://www.presidency.ucsb.edu/ws/index.php?pid=15095",
            "http://www.presidency.ucsb.edu/ws/index.php?pid=14890", "http://www.presidency.ucsb.edu/ws/index.php?pid=14683"
            )

myStopwords = c(stopwords("english"), "will", "must", "can", "make", "new", "need", "like",
                "sure", "get", "still", "america", "americans", "american", "government", "every",
                "now", "year", "years", "know", "one", "many", "congress", "also",
                "shall", "ask", "people", "world", "nation", "nations", "last", "think",
                "let", "believe", "state", "well", "want", "country", "plan", "say",
                "national", "may", "president", "federal", "tonight", "united", "states",
                "time", "act", "session", "great", "meet", "first", "today")
                
# Building the loop
for (i in doclist) {
  speech = html(i)
  speech = speech %>%
    html_nodes("td span") %>%
    html_text()
  speech = speech[which(nchar(speech) == max(nchar(speech)))]
  speech_corpus = Corpus(VectorSource(speech))

  # cleaning the text, using tm_map
  speech_corpus = tm_map(speech_corpus, content_transformer(tolower))
  speech_corpus = tm_map(speech_corpus, stripWhitespace)
  speech_corpus = tm_map(speech_corpus, removeWords, myStopwords)
  speech_corpus = tm_map(speech_corpus, removePunctuation)

  dtm = DocumentTermMatrix(speech_corpus)
  # convert to normal matrix
  dtm2 = as.matrix(dtm)
  # column sums of the matrix which will give us a named vector
  frequency = colSums(dtm2)
  # sort
  frequency = sort(frequency, decreasing = TRUE)
  words = names(frequency)
  
  # plot top 100 words in our cloud
  path = paste0("wordcloud_sotu", as.character(2016-match(i, doclist)),".jpeg")
  jpeg(path, width=800,height=800)
  layout(matrix(c(1, 2), nrow=2), heights = c(1,4))
  par(mar=rep(0, 4))
  plot.new()
  text(x=0.5, y=0.1, paste0("State of the Union ", as.character(2016-match(i, doclist))), cex = 2.0, font = 4)
  set.seed(100)
  wordcloud(words, frequency, random.order = FALSE, max.words = 200,
           colors = brewer.pal(8, "Spectral"), rot.per = .15, min.freq = 2)
  dev.off()
}


## Convert jpegs to one .gif file using ImageMagick
system("convert -delay 75 *.jpeg Wordcloud_SOTU_gif.mpg")








### Testing stemming and other stuff for future projects
speech = html("http://www.presidency.ucsb.edu/ws/index.php?pid=108031")
speech = speech %>%
  html_nodes("td span") %>%
  html_text()
speech = speech[which(nchar(speech) == max(nchar(speech)))]
speech_corpus = Corpus(VectorSource(speech))

# cleaning the text, using tm_map
myStopwords = c(stopwords("english"), "will", "must", "can", "make", "new", "need", "like",
        "sure", "get", "still")
speech_corpus = tm_map(speech_corpus, content_transformer(tolower))
speech_corpus = tm_map(speech_corpus, stripWhitespace)
speech_corpus = tm_map(speech_corpus, removeWords, myStopwords)
speech_corpus = tm_map(speech_corpus, removePunctuation)

# Stem
speech_corpus_stem = tm_map(speech_corpus, stemDocument)

dtm = DocumentTermMatrix(speech_corpus)
dtm_stem = DocumentTermMatrix(speech_corpus_stem)
# convert to normal matrix
dtm2 = as.matrix(dtm)
dtm_stem2 = as.matrix(dtm_stem)
# column sums of the matri which iwll give us a named vector
frequency = colSums(dtm2)
freq_stem = colSums(dtm_stem2)
# sort
frequency = sort(frequency, decreasing = TRUE)
freq_stem = sort(freq_stem, decreasing = TRUE)
head(frequency, 10)
head(freq_stem, 10)
words = names(freq_stem)

wordcloud(words, freq_stem, random.order = TRUE, max.words = 50,
          colors = brewer.pal(8, "Spectral"), rot.per = .15, min.freq = 2)

