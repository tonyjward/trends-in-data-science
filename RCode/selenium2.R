# https://ropensci.org/tutorials/rselenium_tutorial/

library(RSelenium)
library(XML)
library(dplyr)


###########################################################################################
#### 1. Navigating using Selenium


remDr <- remoteDriver(remoteServerAddr = "192.168.99.100",
                      port = 4445L)

# Connect to remote server (silently)
remDr$open(silent = TRUE)
remDr$navigate("http://www.google.com/ncr")
remDr$getTitle()


# print screen in viewer tab of Rstudio
remDr$screenshot(display = TRUE)

# get current url
remDr$getCurrentUrl()

# navigate to new url
remDr$navigate("http://www.bbc.co.uk")

remDr$getCurrentUrl()

# go back and forwards
remDr$goBack()
remDr$getCurrentUrl()
remDr$goForward()
remDr$getCurrentUrl()

###########################################################################################
#### 1. Accessing elements in the DOM

# Useful to use firefox developer to navigate to a website, right click and inspect element
# there will be lots of id's that we can use to serach by
#    - id (unique)
#    - class
#    - css-selectors
#    - name (not necesarily unique)
#    - xpath

# search box has this html code

# input type="text" value="" autocomplete="off" name="q" 
# class="gbqfif" id="gbqfq" style="border: medium none; padding: 0px; margin: 
# 0px; height: auto; width: 100%; 
# background: url(&quot;data:image/gif;base64,R0lGODlhAQABAID/AMDAwAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw%3D%3D&quot;) 
# repeat scroll 0% 0% transparent; position: absolute; z-index: 6; left: 0px; outline: medium none;" dir="ltr" spellcheck="false">

# <input class="gsfi" id="lst-ib" maxlength="2048" name="q" autocomplete="off" title="Search" value="" aria-label="Search" 
# aria-haspopup="false" role="combobox" aria-autocomplete="list" style="border: medium none; padding: 0px; margin: 0px; 
# height: auto; width: 100%; background: transparent url(&quot;data:image/gif;base64,R0lGODlhAQABAID/AMDAwAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw%3D%3D&quot;) 
# repeat scroll 0% 0%; position: absolute; z-index: 6; left: 0px; outline: medium none currentcolor;" dir="ltr" spellcheck="false" type="text">

### search by ID

  remDr$navigate("http://www.google.com/ncr")
  
  webElem <- remDr$findElement(using = "id", value = "lst-ib")
  
  webElem$getElementAttribute("id")
  webElem$getElementAttribute("class")

### search by Class
  webElem <- remDr$findElement(using = 'class name', "gsfi")

  webElem$getElementAttribute("class")

  webElem$getElementAttribute("type")
  
### search by css-selectors
# The class is denoted by . when using css selectors. To search on class using css selectors we would use
  webElem <- remDr$findElement(using = 'css selector', "input.gsfi")
  
  webElem <- remDr$findElement(using = 'css selector', "input#gsfi")
  
  
### search by name
  webElem <- remDr$findElement(using = 'name', "q")
  
  webElem$getElementAttribute("name")
  webElem$getElementAttribute("class")
  
### search by xpath
  webElem <- remDr$findElement(using = 'xpath', "//*/input[@id = 'lst-ib']")
  webElem$getElementAttribute("class")
  webElem$getElementAttribute("name")

###########################################################################################
#### 1. Sending events to elements (text, key presses)
  
# navigate to google
  remDr$navigate("http://www.google.com")
  remDr$screenshot(display = TRUE)

  # select search box using xpath  
  webElem <- remDr$findElement(using = 'xpath', "//*/input[@id = 'lst-ib']")
  
# sending text to elements
  webElem$sendKeysToElement(list("R Cran"))
  remDr$screenshot(display = TRUE)
  remDr$goBack()

# It is not very easy to remember UTF-8 codes for appropriate keys 
# so a mapping has been provided in RSelenium. `?selkeys' will bring 
# up a help page explaining the mapping. The UTF-8 codes have been 
# mapped to easy to remember names.
  
# press return
  webElem$sendKeysToElement(list("R Cran", "\uE007"))
  remDr$screenshot(display = TRUE)

###########################################################################################
#### 1. Sending events to elements (mouse clicks) INCOMPLETE
  
  remDr$navigate("http://www.google.co.uk")
  webElem <- remDr$findElement(using = 'xpath', "//*/input[@id = 'lst-ib']")
  webElem$sendKeysToElement(list("R Cran", "\uE007"))

  webElems <- remDr$findElements(using = 'id', 'main')
  resHeaders <- unlist(lapply(webElems, function(x){
    x$getElementText()
  }))
  
  resHeaders %>% htmlParse()

# The header for each link is contained in a <h3 class = "r"> tag. 
# We will access the h3 headers first. It will be succinct to 
# find these elements using  css selectors.

###########################################################################################
#### 5. Frames and Windows
  
  remDr$navigate("http://www.r-project.org/")
  
  # We can see the content is contained in three frames and we dont 
  # appear to have access to the content within a frame. 
  # Put in the browser we see all the content:
  
  htmlParse(remDr$getPageSource()[[1]])
  
  remDr$maxWindowSize()
  remDr$screenshot(display = TRUE)
  
  webElems <- remDr$findElements(using = "tag name", "frame")
  # webElems <- remDr$findElements(value = "//frame") # using xpath
  # webElems <- remDr$findElements("css", value = "frame") # using css
  
  sapply(webElems, function(x){x$getElementAttribute("src")})
  
  
  class(webElems)
  length(webElems)
   