#Extract and analyse menu items from the cheesecake factory menu
getMenuItems <- function(url){
  library(rvest);
  library(stringr);
  
  #Save html from cheescake factory menu page
  #"http://www.thecheesecakefactory.com/menu"
  ckf_menu <- html(url);
  
  #Extract menu item titles based on css class
  menu_titles <- ckf_menu %>%
    html_nodes(".item-title") %>%
    html_text();
  
  #Extract menu item descriptions based on css class
  menu_descriptions <- ckf_menu %>%
    html_nodes(".item-description") %>%
    html_text();
  
  #Save titles and descriptions to data frame
  ckf_items <- data.frame(name=menu_titles, description=menu_descriptions);
  
  #Remove apostrophes from title and descriptions (messes up indexing)
  ckf_items$name<-str_replace_all(ckf_items$name,"'","");
  ckf_items$description<-str_replace_all(ckf_items$description,"'","");
  
  #Remove whitespace from descriptions
  ckf_items$description<-str_replace_all(ckf_items$description,"[\t\r\n]","");
  
  #Remove cutoff words at end of sentences
  ckf_items$description<-str_replace_all(ckf_items$description,"\\s+\\w*\\W+$","")
  
  #Remove other weird characters from title and descriptions (Only for testing!)
  ckf_items$name<-str_replace_all(ckf_items$name,"[^[:alnum:]^[:space:]]","");
  ckf_items$description<-str_replace_all(ckf_items$description,"[^[:alnum:]^[:space:]]","");
  
  #Remove duplicate records
  ckf_items<-unique(ckf_items);
  ckf_items;
}

#Process menu title and descriptions into list of feautures
getFeatures <- function(menu){
  library(tm);
  library(reshape);
  
  titles<-as.character(menu[,1]);
  descriptions<-menu[,2];
  
  #stem descriptions
  #descriptions<-stemDocument(descriptions);
  
  #convert to lower case
  titles<-tolower(titles);
  descriptions<-tolower(descriptions);
  
  #remove IP symbols from titles
  titles<-str_replace_all(titles,"[™®]","");
  
  #append titles to front of descriptions to make key word list
  features<-paste(titles,descriptions);
  
  #Remove punctuation
  features<-removePunctuation(features);
  
  #Remove stop words
  stopWords <- readLines(system.file("stopwords", "english.dat",package = "tm"));
  features<-removeWords(features,stopWords);

  #Stem and Tokenize
  features<-lapply(features,scan_tokenizer);
  features<-lapply(features,unique);
  names(features)<-as.character(menu[,1]);
  features<-melt.list(features);
  names(features)<-c("feature", "item");
  features$feature<-as.character(features$feature);
  features;
}