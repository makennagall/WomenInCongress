install.packages("rvest")
install.packages("stringr")
install.packages("readr")
install.packages("dplyr")
install.packages("plotly")
install.packages("lubridate")
install.packages("forcats") # for processing categorical data
library(plotly)
library(rvest)
library(stringr)
library(readr)
library(dplyr)
library(lubridate)
library(forcats)

#Old Bill Data:
OldAllOutput <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/AllOutputs.csv")
OldAllBillsNumbers <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/AllBillsNumbers.csv")
OldtermsCount <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/OldData/termsCount.csv')

#New Bill Data:
AllBillsNumbers <- read.csv("https://raw.githubusercontent.com/makennagall/WomenInCongress/main/NewBillNumbers.csv")
Frequency <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/frequency.csv')
WomenPerSession <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/WomenPerSession.csv')
AllOutput <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/compiledNewOutputs.csv')
TermsCount <- read.csv('https://raw.githubusercontent.com/makennagall/WomenInCongress/main/termsCountNew.csv')

#Adjust/Combine Data:
  #Change Congress to integer:
  AllOutput$Congress <- as.integer(AllOutput$Congress)
  #Add Percent Women to AllBillsNumbers:
  AllBillsNumbers <- mutate(AllBillsNumbers, percentWomen = (YesBills/Total)* 100)
  #change LatestAction Date to Date object:
  AllOutput$Date <- as.Date(AllOutput$Date, format = "%m/%d/%y")
  TermsCount$Date <- as.Date(TermsCount$Date, format = "%m/%d/%y")
  #add a DayMonth variable that is only the day and month so they can be displayed on the y axis:
  AllOutput <- mutate(AllOutput, DayMonth = format(as.Date(Date), "%m-%d"))
  TermsCount <- mutate(TermsCount, DayMonth = format(as.Date(Date), "%m-%d"))
  #join data:
  joinedData <- left_join(x = AllOutput, y = WomenPerSession, by = "Congress")

  termDataJoined <- left_join(x = TermsCount, y = WomenPerSession, by = "Congress")
  termDataJoined <- left_join(x = termDataJoined, y = Frequency, by = "Term")
  BillNumbersAndWomenPerSesh <- left_join(x = WomenPerSession, y = AllBillsNumbers, by = "Congress")

#Draw Plotly Graphs:
billPercentPlot <- plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
        x = ~Congress, y = ~percentWomen, color = ~TotalWomen,
        hoverinfo = 'text',
        text = ~paste("Total Bills: ", Total, "<br>", "Women in the Bills: ", YesBills, "<br>Women in Congress: ", TotalWomen))
billPercentPlot <- billPercentPlot %>% layout( 
        legend = list(title = list( text = "<br>Total<br>Women<br>")),
        title = "Congress v. Percentage of Bills", 
        yaxis = list(title = "Bills that Contain Terms Related to Women (Percent)"))

billNumberPlot <- plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
        x = ~Congress, y = ~YesBills, color = ~TotalWomen,
        hoverinfo = 'text',
        text = ~paste("Total Bills: ", Total, "<br>", "Women in the Bills: ", YesBills, "<br>Women in Congress: ", TotalWomen))
billNumberPlot <- billNumberPlot %>% layout(
        legend = list(orientation = 'h', title = list(text = 'Women<br>in Congress<br>'), 
        title = "Congress v. Number of Bills", 
        yaxis = list(title = "Bills that Contain Terms Related to Women")
        ))

numWomenPlot <- plot_ly(data = BillNumbersAndWomenPerSesh, type = "bar",
        x = ~Congress, y = ~TotalWomen, color = ~percentWomen,
        hoverinfo = 'text',
        text = ~paste("Women in the House: ", WomeninHouse, "<br>", "Women in the Senate: ", WomeninSenate))%>%
          layout(title = "Congress v. Women in Congress", yaxis = list(title = "Women in Congress"),
                 legend = list(title = list( text = "<br>Percent<br>of Bills<br>")))

byPartyPlot <- plot_ly(data = AllOutput, type = "scatter", mode = "markers",
        x = ~LatestActionYear, 
        y = ~DayMonth, 
        color = ~SponsorParty, 
        hoverinfo = 'text',
        text = ~paste("Title:", Title, "<br>", "URL:", URL))


indBillsCongressionalWomen <- plot_ly(data = joinedData, type = "scatter", mode = "markers",
        x = ~Congress, 
        y = ~DayMonth, 
        color = ~TotalWomen,
        colors = c("slategray", "thistle3", "plum", "mediumpurple"),
        hoverinfo = 'text',
        text = ~paste("Title:", Title, "<br>", URL, "<br>Total Women: ", TotalWomen, "<br>Sponsor: ", Sponsor, 
                      "<br>Sponsor Party: ", SponsorParty))
indBillsCongressionalWomen <- indBillsCongressionalWomen%>%layout(
  legend = list(title = list(text = "Women<br>in Congress")),
  title = "Timeline of Bills about Women<br>and Number of Women in Congress",
  yaxis = list(title = "Day - Month"),
  xaxis = list(title = "Congress")
)

TermFrequencyPlot <- plot_ly(data = Frequency, 
        type = 'bar', 
        x = ~fct_reorder(Term, Frequency), 
        y = ~Frequency, 
        hoverinfo = 'text',
        text = ~paste("Term:", Term, "<br>Frequency", Frequency))
TermFrequencyPlot <- TermFrequencyPlot%>%layout(
  title = "Frequency of Term Usage",
  yaxis = list(title = "Number of Bills"),
  xaxis = list(title = "Term")
)

byTermPlot <- plot_ly(data = termDataJoined, type = "scatter", mode = "markers",
        x = ~LatestActionYear, 
        y = ~DayMonth, 
        color = ~fct_reorder(Term, Frequency, .desc=TRUE),
        colors = c("lightcoral", "seagreen3", 'cornflowerblue',"lightsalmon1", "palegreen","plum",  "steelblue1", "slategray2", "lightslateblue",
                   'mediumturquoise', "darkseagreen3", "cadetblue3", 'darksalmon', "aquamarine1", "darkolivegreen2", "gold","deepskyblue", "indianred1", 
                   "lightgoldenrod2", "lightpink", "orange1", "mediumaquamarine", "pink2",  "mediumpurple1", "lightskyblue1", "darkslategray1", "chocolate1"),
        hoverinfo = 'text',
        text = ~paste("Title:", Title, "<br>", URL, "<br>Total Women: ", TotalWomen, "<br>Sponsor: ", Sponsor, 
                      "<br>Sponsor Party: ", SponsorParty))
byTermPlot <- byTermPlot%>%layout(
  legend = list(title = list(text = "Terms")),
  title = "Timeline of Term Usage",
  yaxis = list(title = "Month - Day"),
  xaxis = list(title = "Year"))

#Make Plots:
billPercentPlot
billNumberPlot
numWomenPlot
byPartyPlot
indBillsCongressionalWomen
TermFrequencyPlot
byTermPlot
