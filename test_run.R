#Test Run
source("~/GitHub/cheesecakeFactoryGraph/queryCheesecakeFactoryGraph.R");


#---------Test run--------
#Initialize on 2 random menu items
testRun <- function(graph){
  session <- createSession(graph);
  print(session$id);
  options<-getRandomMenuItemNames(graph,2);
  featureScores <- list();
  for (i in 1:10) {
    #Select between 2 menu items
    choice<-options[readline(paste("Please select either (1) ",options[1,], 
                                   " or (2) ", options[2,], ": ", sep="")),];
    print(paste("Choice is ",choice, sep=""));
    saveChoiceToSession(graph, session, choice);
    nonChoice<-options[options!=choice];
    print(paste("Choice is not ",nonChoice, sep=""));
    
    chosenFeatures<-getMenuItemDifference(graph, choice, nonChoice);
    #Use this option to store preference scores in memory
    #featureScores<-addOrIncrementList(chosenFeatures, featureScores, 1)
    #Use this option to store preference scores in database
    assignMultipleFeaturePreferencesToSession(graph, session, chosenFeatures, 1)
    
    nonChosenFeatures<-getMenuItemDifference(graph, nonChoice, choice);
    #Use this option to store preference scores in memory
    #featureScores<-addOrIncrementList(nonChosenFeatures, featureScores, -1)
    #Use this option to store preference scores in database
    assignMultipleFeaturePreferencesToSession(graph, session, nonChosenFeatures, -1)
    
    options<-getSomeRelatedMenuItemNames(graph, choice, 2);
  }
}