usePackage<-function(p){
  # load a package if installed, else load after installation.
  # Args: p: package name in quotes
  if (!is.element(p, installed.packages()[,1])){
    print(paste('Package:',p,'Not found, Installing Now...'))
    suppressMessages(install.packages(p, dep = TRUE))
  }
  print(paste('Loading Package :',p))
  require(p, character.only = TRUE)  
}

enUSBaseFilePath <- "/Users/smallwes/develop/academic/coursera/datascience/c10-capstone/data/final/en_US/"
enUSBlogsFilepath <- paste0(enUSBaseFilePath,"en_US.blogs.txt")
enUSNewsFilepath <- paste0(enUSBaseFilePath,"en_US.news.txt")
enUSTwitterFilepath <- paste0(enUSBaseFilePath,"en_US.twitter.txt")

dBlogs <- readLines(enUSBlogsFilepath)
dNews <- readLines(enUSNewsFilepath)
dTwitter <- readLines(enUSTwitterFilepath)

head(dBlogs)

#Q1
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/file.info.html
file.info(enUSBlogsFilepath)$size / 1024^2

#Q2
length(twitter)

#Q3
max(nchar(dBlogs))
max(nchar(dNews))
max(nchar(dTwitter))

#Q4
#http://www.endmemo.com/program/R/grep.php
lines_with_love <- sum( grepl("love", dTwitter) )
lines_with_hate <- sum( grepl("hate", dTwitter) )
lines_with_love / lines_with_hate

#Q5
biostats <- grep("biostats", dTwitter)
dTwitter[biostats]

#Q6
sum( grepl("A computer once beat me at chess, but it was no match for me at kickboxing", dTwitter) )

