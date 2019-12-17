library(data.table)
library(ggplot2)


ggplot(data = optimalSettings, aes(x = k, y = perplexity)) + geom_line()


# calculate acceleration as per https://pdfs.semanticscholar.org/8353/09966a880c656d59fe29664ae03db09d56ab.pdf
optimalSettings[, perplexityLag := shift(perplexity, type = "lag")]
optimalSettings[, perplexityLead := shift(perplexity, type = "lead")]
optimalSettings[, acceleration := round((perplexityLead - perplexity) - (perplexity - perplexityLag),2)]

# identify optimal topic size
optimalK <- optimalSettings[which.max(acceleration), k]
