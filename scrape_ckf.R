#Extract menu items from the online cheesecake factory menu
getMenuItems <- function(url){
  library(rvest);
  
  #url<-"http://www.thecheesecakefactory.com/menu"
  
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
  
  #This stuff should be taken out in real versions - its just to clean up test data
  #remove IP symbols from titles
  ckf_items$name<-str_replace_all(ckf_items$name,"[™®]","");
  
  #Remove apostrophes from title and descriptions (messes up indexing)
  ckf_items$name<-str_replace_all(ckf_items$name,"'","");
  ckf_items$description<-str_replace_all(ckf_items$description,"'","");
  
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
  library(stringr);
  
  titles<-as.character(menu[,1]);
  descriptions<-menu[,2];
  
  #append titles to front of descriptions to make key word list
  features<-paste(titles,descriptions);
  
  #Remove cutoff words at end of sentences
  features<-str_replace_all(features,"\\s+\\w*\\W+$","")
  
  #Process text with tm
  corp <- VCorpus(VectorSource(features))
  corp <- tm_map(corp, content_transformer(tolower))
  corp <- tm_map(corp, removePunctuation)
  corp <- tm_map(corp, removeWords, stopwords("english"))
  corp <- tm_map(corp, stripWhitespace)
  corp <- tm_map(corp, stemDocument)
  features<-as.character(unlist(sapply(corp, `[`, "content")), stringsAsFactors=F)

  #Tokenize
  features<-lapply(features,scan_tokenizer);
  features<-lapply(features,unique);
  names(features)<-as.character(menu[,1]);
  features<-melt.list(features);
  names(features)<-c("feature", "item");
  features$feature<-as.character(features$feature);
  features;
}