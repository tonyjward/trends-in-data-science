dtmPlot <- function(dtm, records, title) {
  freq <- dtm %>%
    #removeSparseTerms(sparse) %>%
    col_sums() %>%
    sort(decreasing = TRUE) %>%
    data.frame(word = names(.), freq = .)
  
  # BAR PLOT
  ggplot(freq[records,],
         aes(x = reorder(word, freq), y = freq)) +  geom_bar(stat= "identity", 
                                                             fill = "blue",
                                                             alpha = 0.6) + coord_flip() + ggtitle(title)
}