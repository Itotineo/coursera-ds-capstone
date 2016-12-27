usePackage<-function(p){
  # load a package if installed, else load after installation.
  # Args: p: package name in quotes
  if (!is.element(p, installed.packages()[,1])){
    #print(paste('Package:',p,'Not found, Installing Now...'))
    suppressMessages(install.packages(p, dep = TRUE))
  }
  #print(paste('Loading Package :',p))
  require(p, character.only = TRUE)  
}